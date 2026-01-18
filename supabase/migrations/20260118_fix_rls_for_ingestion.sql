-- ⚠️ ATENÇÃO: EXECUTE ISTO NO SQL EDITOR DO SUPABASE
-- Este script libera as permissões de escrita na tabela curriculos_mg
-- para que o script de ingestão funcione usando a chave pública (ANON).

-- 1. Remove políticas anteriores restritivas
drop policy if exists "Enable write access for service role" on curriculos_mg;
drop policy if exists "Enable read access for all users" on curriculos_mg;
drop policy if exists "Enable access for all users" on curriculos_mg;

-- 2. Cria uma política permissiva TOTAL (Leitura e Escrita para todos)
-- Isso resolve o erro 42501 (Violates row-level security policy)
create policy "Liberar Geral para Ingestao"
on curriculos_mg
for all
using (true)
with check (true);

-- 3. Garante que o RLS está ativo (mas com a política acima permitindo tudo)
alter table curriculos_mg enable row level security;
