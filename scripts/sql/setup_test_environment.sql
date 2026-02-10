-- ==============================================================================
-- SCRIPT DE CONFIGURAÇÃO DE AMBIENTE DE TESTE
-- OBJETIVO: Criar Escola Antônio Lago e Definir Supervisor Fictício
-- ==============================================================================

-- 1. Garantir que a Escola Existe (Upsert)
INSERT INTO schools (id, name)
VALUES (
    '31023299', -- Usando o código INEP como ID para facilitar
    'EE PROJ ANTONIO LAGO'
)
ON CONFLICT (id) DO UPDATE 
SET name = 'EE PROJ ANTONIO LAGO';

-- 2. Configurar o Usuário de Teste (Supervisor)
-- Este script assume que o usuário JÁ SE CADASTROU no Supabase Auth.
-- Se ele se cadastrar com o e-mail abaixo, ele receberá as permissões.

-- Usaremos uma FUNCTION + TRIGGER para automatizar isso no momento do cadastro (futuro),
-- mas para o teste imediato, vamos tentar atualizar se o perfil já existir.

UPDATE profiles
SET 
    role = 'school_admin',
    school_id = '31023299'
WHERE email = 'supervisaoescola31023299@educacao.mg.gov.br';

-- 3. [EXTRA] Trigger para Auto-Assign de Admin (Caso o usuário se cadastre DEPOIS de rodar este script)
-- Se você rodar este bloco, qualquer usuario que se cadastrar com esse email vira admin automaticamente.

CREATE OR REPLACE FUNCTION promote_specific_school_admin()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email = 'supervisaoescola31023299@educacao.mg.gov.br' THEN
        NEW.role := 'school_admin';
        NEW.school_id := '31023299';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger Seguro (se já existir user, o update acima resolveu)
DROP TRIGGER IF EXISTS trg_promote_admin ON profiles;
-- Nota: Supabase cria profiles via trigger no auth.users geralmente.
-- Se o seu sistema cria profiles manualmente, verifique onde ajustar.
-- Se for via trigger 'on_auth_user_created', a lógica deve estar lá.
-- Mas podemos fazer um update posterior.

-- MENSAGEM: Execute este script no SQL Editor do Supabase para preparar o ambiente.
