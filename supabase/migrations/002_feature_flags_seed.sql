-- ============================================================================
-- Pattu Petti — Feature Flags Seed
-- Migration: 002_feature_flags_seed.sql
-- ============================================================================

INSERT INTO public.feature_flags (feature_key, enabled, description) VALUES
    ('audio_editor_enabled', TRUE, 'Virtual clip creation and timestamp waveform editing'),
    ('audio_merger_enabled', TRUE, 'Multi-track audio merger with fade transitions'),
    ('voice_recorder_enabled', TRUE, 'In-app microphone recording system'),
    ('equalizer_enabled', TRUE, 'Hardware/software multi-band equalizer'),
    ('lyrics_enabled', TRUE, 'LRC synchronized lyrics viewer'),
    ('smart_playlists_enabled', TRUE, 'Auto-updating dynamic smart playlists'),
    ('sleep_timer_enabled', TRUE, 'Configurable playback sleep timer'),
    ('waveform_visualizer_enabled', TRUE, 'Real-time playback waveform visualizer'),
    ('lossless_flac_support', TRUE, 'FLAC and high-resolution local audio decoding'),
    ('cloud_backup_enabled', FALSE, 'Future cloud sync to Supabase/Drive (disabled initially)'),
    ('public_library_enabled', FALSE, 'Future public shared community library (disabled initially)')
ON CONFLICT (feature_key) DO UPDATE SET
    description = EXCLUDED.description;
