-- Script de Diagnóstico Avançado (V2)
-- Retorna o resultado como tabela para você ver CLARAMENTE se deu erro ou não.

BEGIN;

-- 1. Verificar se o registro JÁ EXISTE (conflito de duplicidade)
SELECT 
    'CHECK_EXISTING' as check_type,
    id, 
    email_institucional, 
    status 
FROM pending_teachers 
WHERE email_institucional = 'paulo.rehfeld@educacao.mg.gov.br';

-- 2. Listar gatilhos (triggers) na tabela pending_teachers
-- (Para ver se tem algum "gatilho fantasma" causando erro)
SELECT 
    'TRIGGER_CHECK' as check_type,
    tgname as trigger_name,
    NULL as details,
    NULL as additional_info
FROM pg_trigger
WHERE tgrelid = 'public.pending_teachers'::regclass;

-- 3. Tentar inserir EXATAMENTE os dados que você mostrou no print
-- Usamos um bloco DO com tratamento de erro e tabela temporária para exibir o resultado
CREATE TEMP TABLE IF NOT EXISTS debug_results (
    step text,
    success boolean,
    message text
);

DO $$
DECLARE
    v_school_id TEXT;
    v_user_id UUID;
BEGIN
    -- Pegar seu ID e Escola
    SELECT school_id, id INTO v_school_id, v_user_id
    FROM profiles 
    WHERE email = 'prehfeld@hotmail.com';

    -- Tentar inserir
    INSERT INTO public.pending_teachers (
        school_id,
        email_institucional,
        masp,
        full_name,
        created_by
    ) VALUES (
        v_school_id,
        'paulo.rehfeld@educacao.mg.gov.br',
        '11093721',
        'PAULO ROBERTO REHFELD',
        v_user_id
    );

    INSERT INTO debug_results VALUES ('Insert Test', true, 'Inserção realizada com sucesso!');

EXCEPTION WHEN OTHERS THEN
    INSERT INTO debug_results VALUES ('Insert Test', false, 'FALHA: ' || SQLERRM || ' (Code: ' || SQLSTATE || ')');
END $$;

-- Mostrar resultado da tentativa
SELECT * FROM debug_results;

ROLLBACK; -- Desfaz tudo para não sujar o banco
