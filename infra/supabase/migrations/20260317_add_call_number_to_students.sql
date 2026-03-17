-- ==============================================================================
-- MIGRATION: Add call_number column to students
-- Date: 2026-03-17
-- Goal: armazenar o número de chamada importado do PDF SIMADE
-- ==============================================================================

ALTER TABLE public.students
ADD COLUMN IF NOT EXISTS call_number INTEGER;

