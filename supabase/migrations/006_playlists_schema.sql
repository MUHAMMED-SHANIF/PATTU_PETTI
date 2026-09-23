-- ─── 006_playlists_schema.sql ──────────────────────────────────────────────
-- Production-Ready Playlist System Schema for Pattu Petti
-- Backed by Supabase PostgreSQL with strict Row Level Security (RLS).
-- Supports playlists, ordered item references, smart playlists, and sharing.

-- 1. Playlists Table
CREATE TABLE IF NOT EXISTS public.playlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    artwork_path TEXT,
    playlist_type VARCHAR(20) NOT NULL DEFAULT 'standard', -- 'standard' | 'smart' | 'collaborative'
    is_liked BOOLEAN NOT NULL DEFAULT FALSE,
    is_smart BOOLEAN NOT NULL DEFAULT FALSE,
    smart_criteria JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- Indexes for Playlists
CREATE INDEX IF NOT EXISTS idx_playlists_user_id ON public.playlists(user_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_playlists_name ON public.playlists(name);
CREATE INDEX IF NOT EXISTS idx_playlists_is_liked ON public.playlists(user_id, is_liked) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_playlists_created_at ON public.playlists(created_at DESC);

-- Trigger for playlists updated_at
CREATE OR REPLACE FUNCTION update_playlists_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_playlists_updated_at ON public.playlists;
CREATE TRIGGER trg_playlists_updated_at
    BEFORE UPDATE ON public.playlists
    FOR EACH ROW
    EXECUTE FUNCTION update_playlists_updated_at();

-- 2. Playlist Items Table
-- Stores references and integer position ordering for manually curated playlists.
-- Audio files are never duplicated; references the central audio item entity.
CREATE TABLE IF NOT EXISTS public.playlist_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    playlist_id UUID NOT NULL REFERENCES public.playlists(id) ON DELETE CASCADE,
    audio_item_id UUID NOT NULL, -- Logical reference to audio item
    position INTEGER NOT NULL DEFAULT 0,
    added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(playlist_id, audio_item_id) -- Prevent duplicate item references within same playlist
);

-- Indexes for Playlist Items
CREATE INDEX IF NOT EXISTS idx_playlist_items_playlist_pos ON public.playlist_items(playlist_id, position ASC);
CREATE INDEX IF NOT EXISTS idx_playlist_items_audio_item ON public.playlist_items(audio_item_id);

-- 3. Smart Playlists Configuration Table
-- Dynamic playlists generated from library conditions without permanent item rows.
CREATE TABLE IF NOT EXISTS public.smart_playlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    rules JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_smart_playlists_user ON public.smart_playlists(user_id);

-- 4. Playlist Shares Table
-- Enables secure playlist sharing, deep-link access, and collaborator permissions.
CREATE TABLE IF NOT EXISTS public.playlist_shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    playlist_id UUID NOT NULL REFERENCES public.playlists(id) ON DELETE CASCADE,
    owner_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    recipient_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    share_token VARCHAR(64) UNIQUE NOT NULL,
    permission VARCHAR(20) NOT NULL DEFAULT 'view', -- 'view' | 'edit'
    status VARCHAR(20) NOT NULL DEFAULT 'active', -- 'active' | 'revoked' | 'expired'
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_playlist_shares_token ON public.playlist_shares(share_token);
CREATE INDEX IF NOT EXISTS idx_playlist_shares_playlist ON public.playlist_shares(playlist_id);
CREATE INDEX IF NOT EXISTS idx_playlist_shares_recipient ON public.playlist_shares(recipient_user_id);

-- ─── ROW LEVEL SECURITY (RLS) POLICIES ───────────────────────────────────────

-- Enable RLS on all playlist tables
ALTER TABLE public.playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playlist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.smart_playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playlist_shares ENABLE ROW LEVEL SECURITY;

-- 1. Playlists Policies
-- Owner has full CRUD access
DROP POLICY IF EXISTS "Users own their playlists" ON public.playlists;
CREATE POLICY "Users own their playlists" ON public.playlists
    FOR ALL
    USING (auth.uid() = user_id AND deleted_at IS NULL)
    WITH CHECK (auth.uid() = user_id);

-- Shared playlists: read access for recipients with an active share
DROP POLICY IF EXISTS "Recipients can view shared playlists" ON public.playlists;
CREATE POLICY "Recipients can view shared playlists" ON public.playlists
    FOR SELECT
    USING (
        id IN (
            SELECT playlist_id FROM public.playlist_shares
            WHERE (recipient_user_id = auth.uid() OR recipient_user_id IS NULL)
              AND status = 'active'
        )
        AND deleted_at IS NULL
    );

-- 2. Playlist Items Policies
-- Owners can view, insert, update, and delete items from their playlists
DROP POLICY IF EXISTS "Users can manage items of their playlists" ON public.playlist_items;
CREATE POLICY "Users can manage items of their playlists" ON public.playlist_items
    FOR ALL
    USING (
        playlist_id IN (
            SELECT id FROM public.playlists
            WHERE user_id = auth.uid() AND deleted_at IS NULL
        )
    )
    WITH CHECK (
        playlist_id IN (
            SELECT id FROM public.playlists
            WHERE user_id = auth.uid() AND deleted_at IS NULL
        )
    );

-- Recipients can view items of shared playlists
DROP POLICY IF EXISTS "Recipients can view items of shared playlists" ON public.playlist_items;
CREATE POLICY "Recipients can view items of shared playlists" ON public.playlist_items
    FOR SELECT
    USING (
        playlist_id IN (
            SELECT playlist_id FROM public.playlist_shares
            WHERE (recipient_user_id = auth.uid() OR recipient_user_id IS NULL)
              AND status = 'active'
        )
    );

-- 3. Smart Playlists Policies
DROP POLICY IF EXISTS "Users own their smart playlists" ON public.smart_playlists;
CREATE POLICY "Users own their smart playlists" ON public.smart_playlists
    FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 4. Playlist Shares Policies
-- Owners can create, view, update and revoke shares
DROP POLICY IF EXISTS "Owners manage shares of their playlists" ON public.playlist_shares;
CREATE POLICY "Owners manage shares of their playlists" ON public.playlist_shares
    FOR ALL
    USING (owner_user_id = auth.uid())
    WITH CHECK (owner_user_id = auth.uid());

-- Recipients can read shares addressed to them
DROP POLICY IF EXISTS "Recipients can read their received shares" ON public.playlist_shares;
CREATE POLICY "Recipients can read their received shares" ON public.playlist_shares
    FOR SELECT
    USING (recipient_user_id = auth.uid() OR share_token IS NOT NULL);
