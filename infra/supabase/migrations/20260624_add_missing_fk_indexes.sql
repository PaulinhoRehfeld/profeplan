-- Migration: Adicionar índices faltantes em colunas FK
-- Date: 2026-06-24
-- Problema: pending_teachers.matched_profile_id, pending_teachers.created_by e
--           referrals.referrer_id são FKs sem índice — causam sequential scans
--           em queries de match automático e consultas de referrals.

CREATE INDEX IF NOT EXISTS idx_pending_teachers_matched_profile_id
    ON public.pending_teachers(matched_profile_id);

CREATE INDEX IF NOT EXISTS idx_pending_teachers_created_by
    ON public.pending_teachers(created_by);

CREATE INDEX IF NOT EXISTS idx_referrals_referrer_id
    ON public.referrals(referrer_id);
