-- ============================================================================
-- Pattu Petti — Premium Requests Enhancement
-- Migration: 005_premium_fields.sql
-- Description:
--   1. Adds requested_days (INT) and phone_number (TEXT) to public.premium_requests
--   2. Ensures RLS policies allow authenticated users to submit requests
--      with phone_number and requested_days
-- ============================================================================

-- ─── 1. Add columns to premium_requests ─────────────────────────────────────
ALTER TABLE public.premium_requests 
  ADD COLUMN IF NOT EXISTS requested_days INT DEFAULT 30,
  ADD COLUMN IF NOT EXISTS phone_number TEXT;

-- ─── 2. Refresh RLS Policies for premium_requests ──────────────────────────
-- Drop existing policy if present
DROP POLICY IF EXISTS "premium_user_all" ON public.premium_requests;
DROP POLICY IF EXISTS "premium_user_insert" ON public.premium_requests;
DROP POLICY IF EXISTS "premium_user_select" ON public.premium_requests;
DROP POLICY IF EXISTS "premium_admin_all" ON public.premium_requests;

-- Allow users to view their own requests, and admins to view all
CREATE POLICY "premium_user_select" ON public.premium_requests
  FOR SELECT
  USING (auth.uid() = user_id OR public.is_admin());

-- Allow users to insert their own requests
CREATE POLICY "premium_user_insert" ON public.premium_requests
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Allow admins full control to review/update requests
CREATE POLICY "premium_admin_all" ON public.premium_requests
  FOR ALL
  USING (public.is_admin());

-- ─── 3. Ensure premium_access RLS is properly set ──────────────────────────
DROP POLICY IF EXISTS "premium_access_select" ON public.premium_access;
DROP POLICY IF EXISTS "premium_access_admin_all" ON public.premium_access;

CREATE POLICY "premium_access_select" ON public.premium_access
  FOR SELECT
  USING (auth.uid() = user_id OR public.is_admin());

CREATE POLICY "premium_access_admin_all" ON public.premium_access
  FOR ALL
  USING (public.is_admin());
