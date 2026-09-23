-- ============================================================================
-- Pattu Petti — Auth RLS Fix (v2 — robust trigger with exception handling)
-- Migration: 004_fix_auth_rls.sql
-- Run this entire script in the Supabase SQL Editor.
-- ============================================================================

-- ─── 1. RLS: Allow authenticated users to insert their OWN profile row ───────
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- ─── 2. RLS: Allow authenticated users to insert their OWN normal role ────────
DROP POLICY IF EXISTS "roles_insert_own" ON public.user_roles;
CREATE POLICY "roles_insert_own" ON public.user_roles
  FOR INSERT
  WITH CHECK (auth.uid() = user_id AND role = 'normal');

-- ─── 3. Email uniqueness index on profiles ────────────────────────────────────
DROP INDEX IF EXISTS profiles_email_unique;
CREATE UNIQUE INDEX profiles_email_unique
  ON public.profiles (lower(email))
  WHERE email IS NOT NULL;

-- ─── 4. Robust handle_new_user trigger ───────────────────────────────────────
-- Wraps the profile insert in an EXCEPTION block so that ANY constraint
-- violation (duplicate username, duplicate email, etc.) does NOT crash the
-- trigger and does NOT block the Supabase auth.signUp() call.
-- The Flutter app's explicit upsert call acts as a fallback.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    v_username       TEXT;
    v_username_norm  TEXT;
    v_display_name   TEXT;
    v_counter        INT := 0;
    v_max_attempts   INT := 10;
BEGIN
    -- Derive username: prefer metadata, fall back to email prefix
    v_username := COALESCE(
        NULLIF(TRIM(NEW.raw_user_meta_data->>'username'), ''),
        split_part(NEW.email, '@', 1)
    );
    v_username_norm  := lower(v_username);
    v_display_name   := COALESCE(
        NULLIF(TRIM(NEW.raw_user_meta_data->>'display_name'), ''),
        v_username
    );

    -- ── Profile insert with duplicate-username resolution ──────────────────
    LOOP
        BEGIN
            INSERT INTO public.profiles (
                id, username, username_normalized, display_name, email
            ) VALUES (
                NEW.id,
                CASE WHEN v_counter = 0 THEN v_username
                     ELSE v_username || v_counter::TEXT END,
                CASE WHEN v_counter = 0 THEN v_username_norm
                     ELSE v_username_norm || v_counter::TEXT END,
                v_display_name,
                lower(NEW.email)
            )
            ON CONFLICT (id) DO UPDATE SET
                username            = EXCLUDED.username,
                username_normalized = EXCLUDED.username_normalized,
                display_name        = EXCLUDED.display_name,
                email               = EXCLUDED.email,
                updated_at          = NOW();

            -- Insert succeeded — exit loop
            EXIT;

        EXCEPTION
            WHEN unique_violation THEN
                -- Username or email is already taken by another user.
                -- Increment counter and retry with a suffixed username.
                v_counter := v_counter + 1;
                IF v_counter > v_max_attempts THEN
                    -- Give up — don't crash the auth signup.
                    EXIT;
                END IF;
            WHEN OTHERS THEN
                -- Any other DB error: log and continue without crashing signup.
                RAISE WARNING 'handle_new_user: unexpected error for user %: %', NEW.id, SQLERRM;
                EXIT;
        END;
    END LOOP;

    -- ── User role insert ───────────────────────────────────────────────────
    BEGIN
        INSERT INTO public.user_roles (user_id, role)
        VALUES (NEW.id, 'normal')
        ON CONFLICT (user_id) DO NOTHING;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'handle_new_user: could not insert role for user %: %', NEW.id, SQLERRM;
    END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-attach trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ─── 5. Public read policies (allow anon & authenticated to view profiles & lookup) ──
DROP POLICY IF EXISTS "profiles_select" ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "profiles_select" ON public.profiles
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "roles_select" ON public.user_roles;
DROP POLICY IF EXISTS "Users can view own role" ON public.user_roles;
CREATE POLICY "roles_select" ON public.user_roles
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "restrictions_select" ON public.user_restrictions;
DROP POLICY IF EXISTS "Users view own restrictions" ON public.user_restrictions;
CREATE POLICY "restrictions_select" ON public.user_restrictions
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "premium_select" ON public.premium_access;
DROP POLICY IF EXISTS "Users view own premium status" ON public.premium_access;
CREATE POLICY "premium_select" ON public.premium_access
  FOR SELECT USING (true);

