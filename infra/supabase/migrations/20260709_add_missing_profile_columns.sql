-- ==============================================================================
-- MIGRATION: Adiciona colunas pedagógicas e de personalização em profiles
-- Date: 2026-07-09
-- Problema: A RPC update_my_profile e o updateUserProfile no frontend tentam
--   escrever colunas que não existiam na tabela profiles, causando falha
--   silenciosa no salvamento das Configurações (Perfil e Preferências).
--   O usuário preenchia todos os campos mas nada era persistido no banco.
--
-- Colunas adicionadas:
--   - favorite_methodology  : metodologia pedagógica preferida (Gamification, etc.)
--   - teaching_style        : estilo pedagógico (Tradicional, Construtivista, etc.)
--   - assessment_focus      : foco avaliativo (Somativa, Formativa, Diagnóstica)
--   - tone_of_voice         : tom de escrita para IA (Prático/Inspiracional, Técnico/Formal)
--   - header_text           : cabeçalho personalizado para exportação de documentos
--   - footer_text           : rodapé personalizado para exportação de documentos
--   - logo_base64           : logo da escola em base64 para documentos
-- ==============================================================================

BEGIN;

-- 1. Adicionar colunas pedagógicas (preferências de IA)
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS favorite_methodology TEXT;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS teaching_style TEXT;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS assessment_focus TEXT;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS tone_of_voice TEXT;

-- 2. Adicionar colunas de personalização de documentos (exportação)
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS header_text TEXT;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS footer_text TEXT;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS logo_base64 TEXT;

COMMIT;

-- ==============================================================================
-- VERIFICAÇÃO (execute após aplicar a migration):
--
-- SELECT column_name, data_type
--   FROM information_schema.columns
--  WHERE table_name = 'profiles'
--    AND column_name IN (
--      'favorite_methodology', 'teaching_style', 'assessment_focus',
--      'tone_of_voice', 'header_text', 'footer_text', 'logo_base64'
--    );
--
-- Deve retornar 7 linhas.
-- ==============================================================================
