-- ============================================================================
-- Pattu Petti — System Settings Seed
-- Migration: 003_system_settings_seed.sql
-- ============================================================================

INSERT INTO public.system_settings (key, value) VALUES
    ('allow_registration', '{"enabled": true, "message": "Registrations open"}'::jsonb),
    ('maintenance_mode', '{"enabled": false, "message": "System operational"}'::jsonb),
    ('max_clip_duration_seconds', '{"value": 600}'::jsonb),
    ('max_merge_items', '{"value": 20}'::jsonb),
    ('supported_audio_extensions', '{"extensions": ["mp3", "m4a", "wav", "flac", "ogg", "aac", "opus"]}'::jsonb),
    ('active_announcement', '{"title": "Welcome to Pattu Petti", "body": "Experience local-first audio playback with virtual clips and multi-track merging!", "show": true}'::jsonb)
ON CONFLICT (key) DO UPDATE SET
    value = EXCLUDED.value;
