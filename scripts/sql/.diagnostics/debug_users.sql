-- LISTAR TODOS OS USUÁRIOS (Limitado a 20 para visualização rápida)
-- Use isso para encontrar o SEU email exato e o SEU ID.

SELECT 
    id, 
    email, 
    role, 
    is_admin, 
    tier
FROM 
    public.profiles
ORDER BY 
    updated_at DESC
LIMIT 20;

-- DEPOIS DE ENCONTRAR SEU USUÁRIO NA LISTA:
-- Copie o ID dele e rode o comando abaixo (substitua o ID):
-- UPDATE public.profiles SET role = 'admin', is_admin = true, tier = 'GOLD' WHERE id = 'COLE_SEU_ID_AQUI';
