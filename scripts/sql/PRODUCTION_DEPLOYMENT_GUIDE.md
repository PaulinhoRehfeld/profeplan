# Production Deployment - RLS Fixes

**Data do Deployment**: _______________  
**Executor**: _______________  
**Ambiente**: PRODUCTION

---

## 📋 PRÉ-REQUISITOS

### Antes de Executar
- [ ] **Staging validado**: Todos os fixes testados e funcionando em staging
- [ ] **Backup criado**: Snapshot completo do banco de production
- [ ] **Janela de manutenção**: Agendada e comunicada aos stakeholders
- [ ] **Rollback preparado**: Scripts de reversão prontos e testados
- [ ] **Acesso verificado**: Credenciais admin do Supabase production confirmadas

### Validações de Staging
- [x] Error 400 (profiles recursion) eliminado
- [x] Error 403 (pdi_records) eliminado
- [x] Error 406 (school_students) eliminado
- [x] ENEM questions acessíveis (17,000 questões)
- [x] 12 políticas RLS criadas e validadas

---

## 🚀 EXECUÇÃO

### Passo 1: Backup
```sql
-- No Supabase Dashboard:
-- Settings → Database → Create Backup
-- Documentar timestamp: _______________
```

### Passo 2: Executar Script All-in-One
1. Abrir Supabase SQL Editor (production)
2. Copiar todo o conteúdo de `PRODUCTION_FULL_EXECUTION.sql`
3. Colar no editor
4. Executar (o script usa uma única transação)
5. Verificar output das queries de verificação

### Passo 3: Validar Deployment

#### 3.1 Verificar Contagem de Políticas
Deve retornar:
```
tablename         | policy_count
------------------|-------------
enem_questions    | 1
pdi_records       | 4
profiles          | 3
school_students   | 4
TOTAL: 12 policies
```

#### 3.2 Verificar Funções SECURITY DEFINER
Deve retornar 2 funções:
- `is_admin_safe()` - SECURITY DEFINER
- `get_my_school_id_safe()` - SECURITY DEFINER

#### 3.3 Smoke Tests no App
- [ ] Login como **admin**: visualizar todos os profiles
- [ ] Login como **manager**: visualizar apenas school members
- [ ] Login como **teacher**: visualizar apenas próprio profile
- [ ] Buscar questões ENEM: deve retornar múltiplos resultados
- [ ] Acessar PDI records: sem erro 403
- [ ] Acessar school students: sem erro 406

---

## ✅ CRITÉRIOS DE ACEITAÇÃO

- [ ] Nenhum erro 400, 403, 406 nos logs da aplicação
- [ ] RLS habilitado em 4 tabelas: profiles, pdi_records, school_students, enem_questions
- [ ] 12 políticas RLS criadas e ativas
- [ ] 2 funções SECURITY DEFINER operacionais
- [ ] App funcional para todos os tipos de usuários (admin, manager, teacher)
- [ ] ENEM questions acessíveis (17,000 questões disponíveis)

---

## 🔙 ROLLBACK (Se Necessário)

Se houver falhas críticas durante ou após o deployment:

### Opção 1: Restaurar Backup
```sql
-- No Supabase Dashboard:
-- Settings → Database → Restore from Backup
-- Selecionar o backup criado no Passo 1
```

### Opção 2: Rollback Manual
```sql
-- Remover políticas criadas
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "pdi_records_select_all" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_insert" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_update" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_delete" ON public.pdi_records;
DROP POLICY IF EXISTS "school_students_select" ON public.school_students;
DROP POLICY IF EXISTS "school_students_insert" ON public.school_students;
DROP POLICY IF EXISTS "school_students_update" ON public.school_students;
DROP POLICY IF EXISTS "school_students_delete" ON public.school_students;
DROP POLICY IF EXISTS "enem_questions_select_all" ON public.enem_questions;

-- Remover funções SECURITY DEFINER
DROP FUNCTION IF EXISTS public.is_admin_safe();
DROP FUNCTION IF EXISTS public.get_my_school_id_safe();
```

---

## 📊 LOG DE EXECUÇÃO

### Timestamp de Eventos
- **Backup iniciado**: _______________
- **Backup concluído**: _______________
- **Script iniciado**: _______________
- **Script concluído**: _______________
- **Validação iniciada**: _______________
- **Validação concluída**: _______________
- **Deployment finalizado**: _______________

### Resultados da Verificação
```
Copiar output das queries de verificação aqui:

[FUNCTIONS]


[PROFILES POLICIES]


[PDI_RECORDS POLICIES]


[SCHOOL_STUDENTS POLICIES]


[ENEM_QUESTIONS POLICIES]


[SUMMARY COUNT]

```

### Problemas Encontrados
```
Documentar qualquer erro ou comportamento inesperado:



```

### Resolução
```
Ações tomadas para resolver problemas:



```

---

## 📝 NOTAS FINAIS

### Mudanças Aplicadas
1. **Profiles Table**: Fix de recursão RLS (error 400) usando funções SECURITY DEFINER
2. **PDI Records**: Criação de 4 políticas RLS (SELECT, INSERT, UPDATE, DELETE)
3. **School Students**: Criação de 4 políticas RLS (SELECT, INSERT, UPDATE, DELETE)
4. **ENEM Questions**: Habilitação de acesso de leitura para 17,000 questões

### Próximos Passos
- [ ] Monitorar logs de produção por 24-48h
- [ ] Verificar métricas de performance (queries RLS)
- [ ] Coletar feedback dos usuários
- [ ] Documentar lessons learned

### Contatos de Emergência
- **DBA**: _______________
- **DevOps**: _______________
- **Product Owner**: _______________

---

**Deployment Status**: ⬜ Pending | ⬜ In Progress | ⬜ Completed | ⬜ Rolled Back
