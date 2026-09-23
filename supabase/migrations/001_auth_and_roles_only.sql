-- ============================================================================
-- Pattu Petti — Clean Auth, Roles, Powers & Admin Schema
-- Migration: 001_auth_and_roles_only.sql
-- Description:
--   Deletes all audio/playlist tables.
--   Keeps Supabase strictly for:
--     1. User Authentication (login / signup)
--     2. Profiles & Details
--     3. Roles & Powers ('admin', 'privileged', 'normal')
--     4. Account Restrictions & Bans
--     5. Feature Flags & User Overrides
--     6. Premium / Power Requests
--     7. Admin Audit Logs & System Settings
--   (All songs, clips, audio edits, and playlists remain 100% local on device)
-- ============================================================================

-- ─── 1. Clean Slate: Drop old unused audio & playlist tables ─────────────────
DROP TABLE IF EXISTS public.merge_items CASCADE;
DROP TABLE IF EXISTS public.merged_tracks CASCADE;
DROP TABLE IF EXISTS public.clips CASCADE;
DROP TABLE IF EXISTS public.audio_files CASCADE;
DROP TABLE IF EXISTS public.playlist_items CASCADE;
DROP TABLE IF EXISTS public.playlists CASCADE;
DROP TABLE IF EXISTS public.play_history CASCADE;
DROP TABLE IF EXISTS public.queue_snapshots CASCADE;
DROP TABLE IF EXISTS public.public_audio_items CASCADE;
DROP TABLE IF EXISTS public.folder_sources CASCADE;
DROP TABLE IF EXISTS public.audio_items CASCADE;
DROP TABLE IF EXISTS public.reports CASCADE;

-- Drop existing auth/admin tables for a fresh start
DROP TABLE IF EXISTS public.admin_audit_logs CASCADE;
DROP TABLE IF EXISTS public.user_restrictions CASCADE;
DROP TABLE IF EXISTS public.user_feature_overrides CASCADE;
DROP TABLE IF EXISTS public.feature_flags CASCADE;
DROP TABLE IF EXISTS public.premium_requests CASCADE;
DROP TABLE IF EXISTS public.premium_access CASCADE;
DROP TABLE IF EXISTS public.user_roles CASCADE;
DROP TABLE IF EXISTS public.system_settings CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

-- ─── 2. Extensions ──────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ─── 3. User Profiles ───────────────────────────────────────────────────────
CREATE TABLE public.profiles (
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

-- ─── 4. User Roles & Powers ─────────────────────────────────────────────────
-- Roles:
--   'admin'      -> Full portal & platform administrative powers
--   'privileged' -> Advanced powers (unlimited stems, merges, priority badges)
--   'normal'     -> Standard listener & editor
CREATE TABLE public.user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'normal' CHECK (role IN ('admin', 'normal', 'privileged')),
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Fast helper function: check if caller has admin role
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.user_roles
        WHERE user_id = auth.uid() AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- ─── 5. Account Restrictions, Bans & Power Revocations ──────────────────────
CREATE TABLE public.user_restrictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    is_banned BOOLEAN NOT NULL DEFAULT FALSE,
    ban_reason TEXT,
    restricted_powers TEXT[] DEFAULT '{}', -- e.g. ARRAY['recording', 'export', 'comments']
    restricted_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- ─── 6. Global Feature Flags & Per-User Overrides ───────────────────────────
CREATE TABLE public.feature_flags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feature_key TEXT UNIQUE NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE public.user_feature_overrides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    feature_key TEXT NOT NULL,
    enabled BOOLEAN NOT NULL,
    reason TEXT,
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(user_id, feature_key)
);

-- ─── 7. Privileged / Premium Requests ───────────────────────────────────────
CREATE TABLE public.premium_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    reason TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    admin_message TEXT,
    reviewed_by UUID REFERENCES public.profiles(id),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE public.premium_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    granted_by UUID REFERENCES public.profiles(id),
    expires_at TIMESTAMPTZ, -- NULL = permanent / unlimited
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- ─── 8. Admin Audit Trail & System Controls ─────────────────────────────────
CREATE TABLE public.admin_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    target_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    target_table TEXT,
    details TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE public.system_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_by UUID REFERENCES public.profiles(id),
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'info',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- ─── 9. Automatic Profile & Role Creation on Signup ─────────────────────────
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

-- ─── 10. Seed Default Platform Flags & Settings ──────────────────────────────
INSERT INTO public.feature_flags (feature_key, enabled, description) VALUES
    ('audio_editor_enabled', TRUE, 'Virtual clip creation and timestamp waveform editing'),
    ('audio_merger_enabled', TRUE, 'Multi-track audio merger with fade transitions'),
    ('voice_recorder_enabled', TRUE, 'In-app microphone recording system'),
    ('equalizer_enabled', TRUE, 'Hardware/software multi-band equalizer'),
    ('lyrics_enabled', TRUE, 'LRC synchronized lyrics viewer'),
    ('smart_playlists_enabled', TRUE, 'Auto-updating dynamic smart playlists'),
    ('sleep_timer_enabled', TRUE, 'Configurable playback sleep timer')
ON CONFLICT (feature_key) DO NOTHING;

INSERT INTO public.system_settings (key, value) VALUES
    ('allow_registration', '{"enabled": true}'::jsonb),
    ('maintenance_mode', '{"enabled": false}'::jsonb),
    ('active_announcement', '{"title": "Welcome to Pattu Petti", "body": "Experience local-first audio playback with virtual clips!", "show": true}'::jsonb)
ON CONFLICT (key) DO NOTHING;

-- ─── 11. Row Level Security (RLS) Policies ──────────────────────────────────
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_restrictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feature_flags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_feature_overrides ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.premium_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.premium_access ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Profiles: Public read, Admin manage all, User update own
CREATE POLICY "profiles_select" ON public.profiles
    FOR SELECT USING (TRUE);
CREATE POLICY "profiles_update" ON public.profiles
    FOR UPDATE USING (auth.uid() = id OR public.is_admin());
CREATE POLICY "profiles_delete" ON public.profiles
    FOR DELETE USING (public.is_admin());

-- Roles: Public read, Admin full control
CREATE POLICY "roles_select" ON public.user_roles
    FOR SELECT USING (TRUE);
CREATE POLICY "roles_admin_all" ON public.user_roles
    FOR ALL USING (public.is_admin());

-- Restrictions & Bans: Public read, Admin manages
CREATE POLICY "restrictions_select" ON public.user_restrictions
    FOR SELECT USING (TRUE);
CREATE POLICY "restrictions_admin_all" ON public.user_restrictions
    FOR ALL USING (public.is_admin());

-- Feature Flags: Public read, Admin manages
CREATE POLICY "flags_select" ON public.feature_flags
    FOR SELECT USING (TRUE);
CREATE POLICY "flags_admin_all" ON public.feature_flags
    FOR ALL USING (public.is_admin());

-- Feature Overrides: Users read own, Admin manages
CREATE POLICY "overrides_select" ON public.user_feature_overrides
    FOR SELECT USING (auth.uid() = user_id OR public.is_admin());
CREATE POLICY "overrides_admin_all" ON public.user_feature_overrides
    FOR ALL USING (public.is_admin());

-- Premium Requests: Users manage own, Admin manages all
CREATE POLICY "premium_user_all" ON public.premium_requests
    FOR ALL USING (auth.uid() = user_id OR public.is_admin());

-- Premium Access: Users read own, Admin manages
CREATE POLICY "premium_access_select" ON public.premium_access
    FOR SELECT USING (auth.uid() = user_id OR public.is_admin());
CREATE POLICY "premium_access_admin_all" ON public.premium_access
    FOR ALL USING (public.is_admin());

-- Audit Logs: Admin only
CREATE POLICY "audit_admin_all" ON public.admin_audit_logs
    FOR ALL USING (public.is_admin());

-- System Settings: Public read, Admin manages
CREATE POLICY "settings_select" ON public.system_settings
    FOR SELECT USING (TRUE);
CREATE POLICY "settings_admin_all" ON public.system_settings
    FOR ALL USING (public.is_admin());

-- Notifications: Users read/update own, Admin writes
CREATE POLICY "notifications_select" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "notifications_update" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "notifications_insert" ON public.notifications
    FOR INSERT WITH CHECK (public.is_admin() OR auth.uid() = user_id);
