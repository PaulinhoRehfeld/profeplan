# Checklist de Execução - Staging Environment

**Data de Execução**: _______________  
**Executor**: _______________  
**Horário Início**: _______________  
**Horário Fim**: _______________

---

## ✅ Fase 0: PRÉ-REQUISITOS

### Confirmações Iniciais
- [ ] **RLS_EXECUTION_ORDER.md** lido e compreendido
- [ ] **RLS_ROLLOUT_PLAN.md** revisado (Fase 2 - Staging)
- [ ] Acesso ao Supabase dashboard de staging confirmado
- [ ] Credenciais de administrador verificadas
- [ ] Horário de execução confirmado (baixo tráfego)
- [ ] Equipe notificada sobre manutenção programada

### Preparação do Ambiente
- [ ] Backup do banco de dados criado
  - **Timestamp do backup**: _______________
  - **Localização**: _______________
- [ ] Script de rollback preparado e testado
- [ ] Conexão VPN/SSH estável verificada
- [ ] Editor SQL aberto e conectado ao staging

---

## ✅ Fase 1: BACKUP E SNAPSHOT

### Backup Completo
- [ ] Executar backup via Supabase dashboard
  ```sql
  -- Documentar timestamp do último backup
  SELECT current_timestamp;
  ```
  - **Resultado**: _______________

### Snapshot do Estado Atual
- [ ] Contar registros nas tabelas críticas
  ```sql
  SELECT 
    'profiles' as table_name, COUNT(*) as count FROM profiles
  UNION ALL
  SELECT 'schools', COUNT(*) FROM schools
  UNION ALL
  SELECT 'pending_teacher_approvals', COUNT(*) FROM pending_teacher_approvals
  UNION ALL
  SELECT 'manager_school_assignments', COUNT(*) FROM manager_school_assignments;
  ```
  - **Profiles**: _______________
  - **Schools**: _______________
  - **Pending Teachers**: _______________
  - **Manager Assignments**: _______________

- [ ] Verificar políticas RLS atuais
  ```sql
  SELECT schemaname, tablename, policyname, permissive, roles, cmd 
  FROM pg_policies 
  WHERE schemaname = 'public'
  ORDER BY tablename, policyname;
  ```
  - **Total de políticas**: _______________
  - **Screenshot salvo**: [ ]

---

## ✅ Fase 2: EXECUÇÃO DOS SCRIPTS (Ordem Obrigatória)

### Script 1: fix_profiles_recursion_400.sql (WINNER)
- [ ] Abrir arquivo `fix_profiles_recursion_400.sql`
- [ ] Revisar conteúdo do script
- [ ] Executar script completo
  - **Horário execução**: _______________
  - **Duração**: _______________
  - **Resultado**: SUCCESS / ERRO
  - **Mensagens**: _______________

### Verificação Pós-Script 1
- [ ] Verificar políticas RLS criadas
  ```sql
  SELECT policyname FROM pg_policies 
  WHERE tablename = 'profiles' 
  ORDER BY policyname;
  ```
  - **Políticas encontradas**: _______________

- [ ] Testar query recursiva (não deve dar erro 400)
  ```sql
  -- Como admin
  SELECT id, email, role FROM profiles LIMIT 5;
  ```
  - **Resultado**: _______________

### Script 2: Outros Scripts (Se Aplicável)
Se houver outros scripts no RLS_EXECUTION_ORDER.md:

- [ ] Script: _______________
  - **Horário execução**: _______________
  - **Resultado**: SUCCESS / ERRO
  - **Verificação**: _______________

---

## ✅ Fase 3: SMOKE TESTS

### Teste 1: Autenticação Básica
- [ ] Login como ADMIN
  - Email: _______________
  - **Resultado**: _______________
- [ ] Login como TEACHER
  - Email: _______________
  - **Resultado**: _______________
- [ ] Login como MANAGER
  - Email: _______________
  - **Resultado**: _______________
- [ ] Login como STUDENT
  - Email: _______________
  - **Resultado**: _______________

### Teste 2: Leitura de Dados
- [ ] ADMIN: consultar todos os profiles
  ```sql
  SELECT COUNT(*) FROM profiles;
  ```
  - **Esperado**: total de profiles
  - **Obtido**: _______________
  - **Status**: PASS / FAIL

- [ ] TEACHER: consultar próprio profile
  ```sql
  SELECT * FROM profiles WHERE id = auth.uid();
  ```
  - **Esperado**: 1 registro
  - **Obtido**: _______________
  - **Status**: PASS / FAIL

- [ ] MANAGER: consultar profiles de escolas gerenciadas
  ```sql
  SELECT COUNT(*) FROM profiles p
  WHERE EXISTS (
    SELECT 1 FROM manager_school_assignments msa
    WHERE msa.manager_id = auth.uid()
    AND msa.school_id = p.school_id
  );
  ```
  - **Resultado**: _______________
  - **Status**: PASS / FAIL

### Teste 3: Escrita de Dados
- [ ] ADMIN: criar profile de teste
  ```sql
  INSERT INTO profiles (id, email, role, school_id)
  VALUES (gen_random_uuid(), 'admin_test@staging.com', 'ADMIN', NULL)
  RETURNING id;
  ```
  - **ID criado**: _______________
  - **Status**: PASS / FAIL

- [ ] TEACHER: tentar atualizar próprio profile
  ```sql
  UPDATE profiles 
  SET full_name = 'Teste Staging Updated'
  WHERE id = auth.uid()
  RETURNING full_name;
  ```
  - **Status**: PASS / FAIL

- [ ] TEACHER: tentar atualizar outro profile (deve falhar)
  ```sql
  -- Usar ID de outro usuário
  UPDATE profiles 
  SET full_name = 'Hack Attempt'
  WHERE id = '<outro_user_id>'
  RETURNING full_name;
  ```
  - **Esperado**: 0 rows affected ou erro de permissão
  - **Obtido**: _______________
  - **Status**: PASS / FAIL

### Teste 4: Pending Teacher Approvals
- [ ] ADMIN: listar pending approvals
  ```sql
  SELECT COUNT(*) FROM pending_teacher_approvals;
  ```
  - **Resultado**: _______________
  - **Status**: PASS / FAIL

- [ ] MANAGER: listar pending approvals de suas escolas
  ```sql
  SELECT COUNT(*) FROM pending_teacher_approvals pta
  WHERE EXISTS (
    SELECT 1 FROM manager_school_assignments msa
    WHERE msa.manager_id = auth.uid()
    AND msa.school_id = pta.school_id
  );
  ```
  - **Resultado**: _______________
  - **Status**: PASS / FAIL

- [ ] TEACHER: tentar acessar pending approvals (deve falhar)
  ```sql
  SELECT COUNT(*) FROM pending_teacher_approvals;
  ```
  - **Esperado**: 0 ou erro de permissão
  - **Obtido**: _______________
  - **Status**: PASS / FAIL

### Teste 5: Manager School Assignments
- [ ] MANAGER: listar próprias assignments
  ```sql
  SELECT * FROM manager_school_assignments 
  WHERE manager_id = auth.uid();
  ```
  - **Resultado**: _______________
  - **Status**: PASS / FAIL

- [ ] ADMIN: criar assignment de teste
  ```sql
  INSERT INTO manager_school_assignments (manager_id, school_id)
  VALUES ('<manager_id>', '<school_id>')
  RETURNING id;
  ```
  - **ID criado**: _______________
  - **Status**: PASS / FAIL

---

## ✅ Fase 4: TESTES DA APLICAÇÃO

### Interface Web
- [ ] Abrir aplicação web em staging
  - **URL**: _______________
- [ ] Login como ADMIN
  - **Dashboard carregado**: [ ]
  - **Lista de usuários visível**: [ ]
  - **Sem erros no console**: [ ]

- [ ] Login como TEACHER
  - **Dashboard carregado**: [ ]
  - **Planejamentos visíveis**: [ ]
  - **Sem erros no console**: [ ]

- [ ] Login como MANAGER
  - **Dashboard carregado**: [ ]
  - **Escolas gerenciadas visíveis**: [ ]
  - **Sem erros no console**: [ ]

- [ ] Login como STUDENT
  - **Dashboard carregado**: [ ]
  - **Conteúdo disponível**: [ ]
  - **Sem erros no console**: [ ]

### Funcionalidades Críticas
- [ ] ADMIN: aprovar pending teacher
  - **Status**: PASS / FAIL
- [ ] TEACHER: criar planejamento
  - **Status**: PASS / FAIL
- [ ] MANAGER: visualizar relatórios de escola
  - **Status**: PASS / FAIL
- [ ] STUDENT: visualizar material didático
  - **Status**: PASS / FAIL

---

## ✅ Fase 5: VALIDAÇÃO FINAL

### Verificação de Integridade
- [ ] Recontar registros (comparar com snapshot inicial)
  ```sql
  SELECT 
    'profiles' as table_name, COUNT(*) as count FROM profiles
  UNION ALL
  SELECT 'schools', COUNT(*) FROM schools
  UNION ALL
  SELECT 'pending_teacher_approvals', COUNT(*) FROM pending_teacher_approvals
  UNION ALL
  SELECT 'manager_school_assignments', COUNT(*) FROM manager_school_assignments;
  ```
  - **Profiles**: _______________ (era: _______________)
  - **Schools**: _______________ (era: _______________)
  - **Pending Teachers**: _______________ (era: _______________)
  - **Manager Assignments**: _______________ (era: _______________)
  - **Diferenças explicadas**: [ ]

### Performance
- [ ] Verificar tempo de resposta de queries
  ```sql
  EXPLAIN ANALYZE
  SELECT * FROM profiles WHERE role = 'TEACHER' LIMIT 100;
  ```
  - **Tempo de execução**: _______________
  - **Aceitável (<500ms)**: [ ]

### Logs e Erros
- [ ] Verificar logs do Supabase (últimos 15 minutos)
  - **Erros encontrados**: _______________
  - **Todos resolvidos**: [ ]

- [ ] Verificar logs da aplicação
  - **Erros 400**: _______________
  - **Erros 500**: _______________
  - **Todos resolvidos**: [ ]

---

## ✅ Fase 6: DOCUMENTAÇÃO

### Registro de Execução
- [ ] Atualizar este checklist com todos os resultados
- [ ] Tirar screenshots de evidências críticas
  - [ ] Políticas RLS ativas
  - [ ] Smoke tests com sucesso
  - [ ] Dashboard funcionando

### Comunicação
- [ ] Notificar equipe de QA: staging pronto para testes
- [ ] Atualizar ticket/issue no gerenciador de projetos
- [ ] Documentar quaisquer ajustes necessários

---

## ⚠️ PLANO DE ROLLBACK (Se Necessário)

### Critérios para Rollback
Se **qualquer** dos seguintes ocorrer, executar rollback imediatamente:
- [ ] Mais de 2 smoke tests falharam
- [ ] Erro 400 ainda ocorre em queries recursivas
- [ ] Aplicação não carrega para qualquer role
- [ ] Perda de dados detectada
- [ ] Performance degradada >50%

### Procedimento de Rollback
1. [ ] Parar aplicação em staging
2. [ ] Restaurar backup do banco de dados
   ```
   Timestamp do backup: _______________
   ```
3. [ ] Verificar restauração com smoke tests básicos
4. [ ] Reiniciar aplicação
5. [ ] Documentar causa do rollback
6. [ ] Agendar nova tentativa após correções

---

## 📋 CRITÉRIOS DE ACEITAÇÃO

### Deve Passar TODOS:
- [x] Nenhum erro 400 em queries recursivas
- [x] Todos os 4 roles (ADMIN, TEACHER, MANAGER, STUDENT) fazem login com sucesso
- [x] RLS bloqueia acessos não autorizados (TEACHER não acessa outros profiles)
- [x] RLS permite acessos autorizados (ADMIN acessa todos, MANAGER acessa suas escolas)
- [x] Aplicação web funciona sem erros de console
- [x] Nenhuma perda de dados (contagens iguais ao snapshot)
- [x] Performance aceitável (queries <500ms)

### Resultado Final
- [ ] **APROVADO** - Pronto para produção
- [ ] **REPROVADO** - Necessita correções

---

## 📝 NOTAS E OBSERVAÇÕES

**Problemas Encontrados:**
_______________________________________________________________________________
_______________________________________________________________________________
_______________________________________________________________________________

**Soluções Aplicadas:**
_______________________________________________________________________________
_______________________________________________________________________________
_______________________________________________________________________________

**Lições Aprendidas:**
_______________________________________________________________________________
_______________________________________________________________________________
_______________________________________________________________________________

**Próximos Passos:**
_______________________________________________________________________________
_______________________________________________________________________________
_______________________________________________________________________________

---

**Assinatura do Executor**: _______________  
**Data**: _______________
