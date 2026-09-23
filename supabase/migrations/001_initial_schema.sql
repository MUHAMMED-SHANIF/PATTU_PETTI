-- ============================================================================
-- Pattu Petti — Supabase PostgreSQL Database Schema
-- Migration: 001_initial_schema.sql
-- Description: Complete schema with RLS policies, triggers, and helper functions
-- ============================================================================

-- ─── Extensions ─────────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ─── 1. Profiles & Roles ────────────────────────────────────────────────────
-- Extends auth.users with app-specific metadata
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    username_normalized TEXT UNIQUE NOT NULL,
    display_name TEXT,
    email TEXT,
    phone TEXT,
    bio TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- User roles: 'admin', 'normal', 'privileged'
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'normal' CHECK (role IN ('admin', 'normal', 'privileged')),
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Helper function: check if caller has admin role
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.user_roles
        WHERE user_id = auth.uid() AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- Premium access tracking (granted by admin)
CREATE TABLE IF NOT EXISTS public.premium_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    granted_by UUID REFERENCES public.profiles(id),
    expires_at TIMESTAMPTZ, -- NULL = permanent / unlimited
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Premium requests submitted by normal users
CREATE TABLE IF NOT EXISTS public.premium_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    reason TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    admin_message TEXT,
    reviewed_by UUID REFERENCES public.profiles(id),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- ─── 2. Feature Flags & Restrictions ────────────────────────────────────────
-- Global feature flags toggled by admins
CREATE TABLE IF NOT EXISTS public.feature_flags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feature_key TEXT UNIQUE NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Per-user overrides for specific feature flags
CREATE TABLE IF NOT EXISTS public.user_feature_overrides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    feature_key TEXT NOT NULL,
    enabled BOOLEAN NOT NULL,
    reason TEXT,
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(user_id, feature_key)
);

-- User account restrictions (bans or partial feature blocks)
CREATE TABLE IF NOT EXISTS public.user_restrictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    is_banned BOOLEAN NOT NULL DEFAULT FALSE,
    ban_reason TEXT,
    restricted_features TEXT[] DEFAULT '{}',
    restricted_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- ─── 3. Audio Items & Files ─────────────────────────────────────────────────
-- Polymorphic table for songs, clips, merged tracks, and recordings
CREATE TABLE IF NOT EXISTS public.audio_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    item_type TEXT NOT NULL CHECK (item_type IN ('song', 'clip', 'merged', 'recording')),
    title TEXT NOT NULL,
    artist TEXT,
    album TEXT,
    album_artist TEXT,
    genre TEXT,
    year INTEGER,
    track_number INTEGER,
    composer TEXT,
    duration_ms BIGINT,
    artwork_path TEXT,
    is_liked BOOLEAN NOT NULL DEFAULT FALSE,
    star_number INTEGER, -- NULL = unstarred; 1..N = order
    play_count INTEGER NOT NULL DEFAULT 0,
    last_played_at TIMESTAMPTZ,
    resume_position_ms BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Physical file references for local songs and rendered clips
CREATE TABLE IF NOT EXISTS public.audio_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    audio_item_id UUID UNIQUE NOT NULL REFERENCES public.audio_items(id) ON DELETE CASCADE,
    file_path TEXT NOT NULL,
    file_hash TEXT,
    file_size_bytes BIGINT,
    mime_type TEXT,
    bit_rate INTEGER,
    sample_rate INTEGER,
    channels INTEGER,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    last_verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Virtual clips with timestamp intervals and optional nesting
CREATE TABLE IF NOT EXISTS public.clips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    audio_item_id UUID UNIQUE NOT NULL REFERENCES public.audio_items(id) ON DELETE CASCADE,
    source_audio_item_id UUID NOT NULL REFERENCES public.audio_items(id),
    parent_clip_id UUID REFERENCES public.clips(id) ON DELETE SET NULL,
    start_ms BIGINT NOT NULL,
    end_ms BIGINT NOT NULL,
    is_physical BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT chk_clip_duration CHECK (end_ms > start_ms)
);

-- Merged tracks (virtual compositions)
CREATE TABLE IF NOT EXISTS public.merged_tracks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    audio_item_id UUID UNIQUE NOT NULL REFERENCES public.audio_items(id) ON DELETE CASCADE,
    is_physical BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Ordered items inside a merged track
CREATE TABLE IF NOT EXISTS public.merge_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merged_track_id UUID NOT NULL REFERENCES public.merged_tracks(id) ON DELETE CASCADE,
    audio_item_id UUID NOT NULL REFERENCES public.audio_items(id),
    position INTEGER NOT NULL,
    fade_in_ms INTEGER NOT NULL DEFAULT 500,
    fade_out_ms INTEGER NOT NULL DEFAULT 500,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(merged_track_id, position)
);

-- Registered local folder sources
CREATE TABLE IF NOT EXISTS public.folder_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    folder_path TEXT NOT NULL,
    display_name TEXT,
    last_scanned_at TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(user_id, folder_path)
);

-- ─── 4. Playlists & Social ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.playlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    artwork_path TEXT,
    is_smart BOOLEAN NOT NULL DEFAULT FALSE,
    smart_criteria JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.playlist_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    playlist_id UUID NOT NULL REFERENCES public.playlists(id) ON DELETE CASCADE,
    audio_item_id UUID NOT NULL REFERENCES public.audio_items(id) ON DELETE CASCADE,
    position INTEGER NOT NULL,
    added_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(playlist_id, position)
);

CREATE TABLE IF NOT EXISTS public.play_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    audio_item_id UUID NOT NULL REFERENCES public.audio_items(id) ON DELETE CASCADE,
    played_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    duration_played_ms BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.queue_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    items JSONB NOT NULL DEFAULT '[]'::jsonb,
    current_index INTEGER NOT NULL DEFAULT 0,
    current_position_ms BIGINT NOT NULL DEFAULT 0,
    shuffle_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    repeat_mode TEXT NOT NULL DEFAULT 'off' CHECK (repeat_mode IN ('off', 'one', 'all')),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- ─── 5. Notifications & Administration ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'info',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.admin_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id UUID NOT NULL REFERENCES public.profiles(id),
    action TEXT NOT NULL,
    target_user_id UUID REFERENCES public.profiles(id),
    target_table TEXT,
    target_id TEXT,
    previous_value JSONB,
    new_value JSONB,
    reason TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.system_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.public_audio_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    audio_item_id UUID NOT NULL REFERENCES public.audio_items(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID NOT NULL REFERENCES public.profiles(id),
    target_id UUID NOT NULL,
    target_type TEXT NOT NULL,
    reason TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'in_review', 'resolved', 'dismissed')),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- ─── 6. Automatic updated_at Trigger ────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_profiles_updated_at ON public.profiles;
CREATE TRIGGER trg_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trg_audio_items_updated_at ON public.audio_items;
CREATE TRIGGER trg_audio_items_updated_at
    BEFORE UPDATE ON public.audio_items
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trg_playlists_updated_at ON public.playlists;
CREATE TRIGGER trg_playlists_updated_at
    BEFORE UPDATE ON public.playlists
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ─── 7. Auth User Created Trigger ───────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    v_username TEXT;
BEGIN
    v_username := COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1));
    
    INSERT INTO public.profiles (id, username, username_normalized, display_name, email)
    VALUES (
        NEW.id,
        v_username,
        lower(v_username),
        COALESCE(NEW.raw_user_meta_data->>'display_name', v_username),
        NEW.email
    )
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'normal')
    ON CONFLICT (user_id) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ─── 8. Row Level Security (RLS) ────────────────────────────────────────────
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.premium_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.premium_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feature_flags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_feature_overrides ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_restrictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audio_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audio_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clips ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merged_tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merge_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.folder_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playlist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.play_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.queue_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.public_audio_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

-- Profiles: Own profile or admin
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id OR public.is_admin());

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- User roles: Own role or admin
DROP POLICY IF EXISTS "Users can view own role" ON public.user_roles;
CREATE POLICY "Users can view own role" ON public.user_roles
    FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

DROP POLICY IF EXISTS "Only admin can modify roles" ON public.user_roles;
CREATE POLICY "Only admin can modify roles" ON public.user_roles
    FOR ALL USING (public.is_admin());

-- Premium access: Own or admin
DROP POLICY IF EXISTS "Users view own premium status" ON public.premium_access;
CREATE POLICY "Users view own premium status" ON public.premium_access
    FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

DROP POLICY IF EXISTS "Only admin can manage premium access" ON public.premium_access;
CREATE POLICY "Only admin can manage premium access" ON public.premium_access
    FOR ALL USING (public.is_admin());

-- Premium requests: Own or admin
DROP POLICY IF EXISTS "Users manage own premium requests" ON public.premium_requests;
CREATE POLICY "Users manage own premium requests" ON public.premium_requests
    FOR ALL USING (auth.uid() = user_id OR public.is_admin());

-- Feature flags: Authenticated can read, admin can write
DROP POLICY IF EXISTS "All authenticated can view feature flags" ON public.feature_flags;
CREATE POLICY "All authenticated can view feature flags" ON public.feature_flags
    FOR SELECT TO authenticated USING (TRUE);

DROP POLICY IF EXISTS "Admin manages feature flags" ON public.feature_flags;
CREATE POLICY "Admin manages feature flags" ON public.feature_flags
    FOR ALL USING (public.is_admin());

-- Feature overrides: Own or admin
DROP POLICY IF EXISTS "Users view own feature overrides" ON public.user_feature_overrides;
CREATE POLICY "Users view own feature overrides" ON public.user_feature_overrides
    FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

DROP POLICY IF EXISTS "Admin manages feature overrides" ON public.user_feature_overrides;
CREATE POLICY "Admin manages feature overrides" ON public.user_feature_overrides
    FOR ALL USING (public.is_admin());

-- User restrictions: Own read, admin full
DROP POLICY IF EXISTS "Users view own restrictions" ON public.user_restrictions;
CREATE POLICY "Users view own restrictions" ON public.user_restrictions
    FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

DROP POLICY IF EXISTS "Admin manages restrictions" ON public.user_restrictions;
CREATE POLICY "Admin manages restrictions" ON public.user_restrictions
    FOR ALL USING (public.is_admin());

-- Audio items: Own only
DROP POLICY IF EXISTS "Users own their audio items" ON public.audio_items;
CREATE POLICY "Users own their audio items" ON public.audio_items
    FOR ALL USING (auth.uid() = user_id);

-- Audio files: Own only
DROP POLICY IF EXISTS "Users own their audio files" ON public.audio_files;
CREATE POLICY "Users own their audio files" ON public.audio_files
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.audio_items
            WHERE audio_items.id = audio_files.audio_item_id
              AND audio_items.user_id = auth.uid()
        )
    );

-- Clips: Own only
DROP POLICY IF EXISTS "Users own their clips" ON public.clips;
CREATE POLICY "Users own their clips" ON public.clips
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.audio_items
            WHERE audio_items.id = clips.audio_item_id
              AND audio_items.user_id = auth.uid()
        )
    );

-- Merged tracks: Own only
DROP POLICY IF EXISTS "Users own their merged tracks" ON public.merged_tracks;
CREATE POLICY "Users own their merged tracks" ON public.merged_tracks
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.audio_items
            WHERE audio_items.id = merged_tracks.audio_item_id
              AND audio_items.user_id = auth.uid()
        )
    );

-- Merge items: Own only
DROP POLICY IF EXISTS "Users own their merge items" ON public.merge_items;
CREATE POLICY "Users own their merge items" ON public.merge_items
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.merged_tracks
            JOIN public.audio_items ON audio_items.id = merged_tracks.audio_item_id
            WHERE merged_tracks.id = merge_items.merged_track_id
              AND audio_items.user_id = auth.uid()
        )
    );

-- Folder sources: Own only
DROP POLICY IF EXISTS "Users own their folder sources" ON public.folder_sources;
CREATE POLICY "Users own their folder sources" ON public.folder_sources
    FOR ALL USING (auth.uid() = user_id);

-- Playlists: Own only
DROP POLICY IF EXISTS "Users own their playlists" ON public.playlists;
CREATE POLICY "Users own their playlists" ON public.playlists
    FOR ALL USING (auth.uid() = user_id);

-- Playlist items: Own only
DROP POLICY IF EXISTS "Users own their playlist items" ON public.playlist_items;
CREATE POLICY "Users own their playlist items" ON public.playlist_items
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.playlists
            WHERE playlists.id = playlist_items.playlist_id
              AND playlists.user_id = auth.uid()
        )
    );

-- Play history: Own only
DROP POLICY IF EXISTS "Users own their play history" ON public.play_history;
CREATE POLICY "Users own their play history" ON public.play_history
    FOR ALL USING (auth.uid() = user_id);

-- Queue snapshots: Own only
DROP POLICY IF EXISTS "Users own their queue snapshot" ON public.queue_snapshots;
CREATE POLICY "Users own their queue snapshot" ON public.queue_snapshots
    FOR ALL USING (auth.uid() = user_id);

-- Notifications: Own only
DROP POLICY IF EXISTS "Users view own notifications" ON public.notifications;
CREATE POLICY "Users view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users update own notifications" ON public.notifications;
CREATE POLICY "Users update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admin can insert notifications" ON public.notifications;
CREATE POLICY "Admin can insert notifications" ON public.notifications
    FOR INSERT WITH CHECK (public.is_admin() OR auth.uid() = user_id);

-- Admin audit logs: Admin only
DROP POLICY IF EXISTS "Admin views audit logs" ON public.admin_audit_logs;
CREATE POLICY "Admin views audit logs" ON public.admin_audit_logs
    FOR SELECT USING (public.is_admin());

DROP POLICY IF EXISTS "Admin creates audit logs" ON public.admin_audit_logs;
CREATE POLICY "Admin creates audit logs" ON public.admin_audit_logs
    FOR INSERT WITH CHECK (public.is_admin());

-- System settings: Read all, write admin
DROP POLICY IF EXISTS "Authenticated read system settings" ON public.system_settings;
CREATE POLICY "Authenticated read system settings" ON public.system_settings
    FOR SELECT TO authenticated USING (TRUE);

DROP POLICY IF EXISTS "Admin writes system settings" ON public.system_settings;
CREATE POLICY "Admin writes system settings" ON public.system_settings
    FOR ALL USING (public.is_admin());

-- Reports: Users insert own, admin views all
DROP POLICY IF EXISTS "Users insert reports" ON public.reports;
CREATE POLICY "Users insert reports" ON public.reports
    FOR INSERT WITH CHECK (auth.uid() = reporter_id);

DROP POLICY IF EXISTS "Admin views and updates reports" ON public.reports;
CREATE POLICY "Admin views and updates reports" ON public.reports
    FOR ALL USING (public.is_admin());
