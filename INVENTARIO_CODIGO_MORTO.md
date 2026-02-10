# 🔍 INVENTÁRIO DE CÓDIGO MORTO E DUPLICADO - PROFEPLAN
**Data da Análise**: 10 de Fevereiro de 2026  
**Especialista**: Backend-Specialist  
**Status**: ⚠️ NÃO DELETAR - APENAS REPORT

---

## 📊 RESUMO EXECUTIVO

| Categoria | Qtd | Status |
|-----------|-----|--------|
| **SQL** | 248 | 🔴 CRÍTICO - Centenas de duplicatas |
| **Python** | 150+ | 🟠 ALTO - 40+ scripts duplicados |
| **JS/CJS** | 22 | 🟡 MÉDIO - Duplicatas claras |
| **TypeScript (src/)** | 205+ | 🟡 MÉDIO - 8+ padrões duplicados |
| **Dead Code em src/** | 15+ | 🟢 BAIXO - Serviços deprecados |

---

# 1️⃣ ANÁLISE SQL - 248 SCRIPTS

## 🔴 PADRÃO 1: fix_admin_*.sql (11 SCRIPTS)
**Risco**: CRÍTICO - Múltiplas versões, sem timestamp claro

```
✓ fix_admin_duplicates.sql          (2025)
✓ fix_admin_protection.sql          (2025)
✓ fix_admin_recursion.sql           (2025)
✓ fix_admin_rls.sql                 (2025)
✓ ensure_global_admin_access.sql    (2025)
✓ fix_force_all_admins.sql          (2025)
✓ promote_admin.sql                 (2025)
✓ bootstrap_admin.sql               (2025)
✓ insert_admin_manual.sql           (2025)
✓ delete_duplicate_admin.sql        (2025)
✓ force_admin_update.sql            (2025)
```

**Recomendação**: Consolidar em `fix_admin_final.sql` documentando precedência

---

## 🔴 PADRÃO 2: fix_rls_*.sql (13 SCRIPTS)
**Risco**: CRÍTICO - Conflito direto com problemas RLS não resolvidos

```
✓ fix_rls_authorized_users.sql
✓ fix_rls_complete.sql
✓ fix_rls_final_v2.sql              ⚠️ Indica falha da versão anterior
✓ fix_rls_jwt.sql
✓ fix_rls_profiles_final.sql
✓ fix_rls_recursion.sql
✓ rls_fix_definitivo.sql            ⚠️ DEFINITIVO mas podem existir _V2
✓ nuke_and_fix_profiles_rls.sql
✓ migration_profiles_rls.sql
✓ disable_rls_debug.sql
✓ migration_fix_policies.sql
✓ fix_all_open_read.sql
✓ disable_schools_fix_profiles.sql
```

**Recomendação**: RLS não foi resolvido definitivamente. Remover versões antigas de v1, v2, _debug

---

## 🔴 PADRÃO 3: fix_infinite_recursion_*.sql (2 SCRIPTS)
**Risco**: CRÍTICO - Problema de recursão não resolvido

```
✓ fix_infinite_recursion.sql         (v1)
✓ fix_infinite_recursion_final.sql   (v2) ⚠️ "final" indica v1 falhou
```

**Recomendação**: Manter apenas versão _final, estudar por que v1 falhou

---

## 🔴 PADRÃO 4: fix_recursion_*.sql (2 SCRIPTS)
**Risco**: ALTO - Alias para infinito recursion

```
✓ fix_recursion.sql
✓ fix_recursion_profiles.sql
```

**Duplicata de**: fix_infinite_recursion_*.sql?

---

## 🔴 PADRÃO 5: fix_school_*.sql (4 SCRIPTS)
**Risco**: ALTO - Múltiplas tentativas não consolidadas

```
✓ fix_school_id_type.sql
✓ fix_school_id_type_final.sql      ⚠️ Indica falha de v1
✓ fix_school_id_final_v2.sql        ⚠️ v2 após "final"?
✓ fix_jose_school.sql               (específico do teste?)
```

**Recomendação**: Manter apenas versão _v2, remover intermediárias

---

## 🔴 PADRÃO 6: fix_students_rls_*.sql (2 SCRIPTS)
**Risco**: ALTO - Inconsistência em student RLS

```
✓ fix_students_rls.sql
✓ fix_students_rls_final.sql        ⚠️ v1 falhou?
```

---

## 🔴 PADRÃO 7: fix_pending_teachers_rls_*.sql (2 SCRIPTS)
**Risco**: MÉDIO - Lógica incompleta

```
✓ fix_pending_teachers_rls.sql
✓ fix_pending_teachers_rls_v2.sql
```

---

## 🔴 PADRÃO 8: fix_profile_school_id_type_*.sql (2 SCRIPTS)
**Risco**: MÉDIO - Redundância com fix_school_id_type

```
✓ fix_profile_school_id_type.sql
✓ fix_profile_school_id_type_force.sql
```

---

## 🟠 PADRÃO 9: Fixes genéricos sobrepostos (10 SCRIPTS)

```
✓ fix_manager_role.sql              |
✓ fix_manager_role_complete.sql     | ⚠️ qual está ativo?
✓ fix_full_manager_permissions.sql  |

✓ fix_role_enum_constraint.sql
✓ fix_enum_part1.sql
✓ fix_enum_part2.sql
✓ fix_enum_and_sync.sql            ⚠️ combina outras?

✓ fix_simplified.sql                (vago - o quê foi simplificado?)
✓ fix_final_permissions.sql
✓ fix_missing_profile.sql
✓ fix_missing_city_column.sql
```

---

## 🟠 PADRÃO 10: Restore/Revert (5 SCRIPTS)
**Risco**: MÉDIO - Indicam falhas anteriores

```
✓ restore_admin_access.sql          (revert de fix_admin_*)
✓ restore_profiles_security.sql     (revert de fix_rls_profiles_final)
✓ restore_profile_access.sql
✓ restore_schools_security.sql
✓ revert_school_management.sql      (revert de migration_school_management)
```

**Insight**: Cada restore indica que a versão anterior quebrou algo

---

## 🟠 PADRÃO 11: Diagnósticos nunca limpados (8 SCRIPTS)
**Risco**: MÉDIO - Debug code em raiz, não em /scripts

```
✓ diagnose_server_error.sql
✓ diagnose_student_data.sql
✓ diagnostico_paulo_final.sql       (específico do usuário!)
✓ diagnostico_paulinho_profiles.sql (específico do usuário!)
✓ diagnostico_completo_paulinho.sql (específico do usuário!)
✓ debug_users.sql
✓ debug_schema.sql
✓ debug_profiles_rls.sql
✓ debug_insert_pending.sql
```

**Recomendação**: Mover para `.diagnostics/` ou deletar

---

## 🟠 PADRÃO 12: Seeding/Setup (4 SCRIPTS)
**Risco**: MÉDIO - Dados de teste em produção

```
✓ seed_schools.sql
✓ seed_schools_v2.sql
✓ seed_jose_silva.sql               ⚠️ usuário específico!
✓ setup_test_environment.sql        ⚠️ test em raiz!
```

**Recomendação**: Mover para supabase/scripts/setup/

---

## 🟡 PADRÃO 13: Check/Verify (10 SCRIPTS)
**Risco**: BAIXO - Geralmente safe mas muitos descontinuados

```
✓ check_archive_schema.sql
✓ check_class_integrity.sql
✓ check_classes_schema.sql
✓ check_db_integrity.sql
✓ check_profiles_schema.sql
✓ check_schemas.sql
✓ check_security_flags.sql
✓ check_student_columns.sql
✓ check_support_profile.sql
✓ check_teacher_link.sql
✓ verify_rls_policies.sql
```

**Insight**: Padrão verify_* vs check_* - consolidar naming

---

## 🟡 PADRÃO 14: Análise/Audit (5 SCRIPTS)
**Risco**: BAIXO - Geralmente read-only

```
✓ analyze_disconnected_classes.sql
✓ audit_admin_rls.sql
✓ audit_functions.sql
✓ audit_lines.py
✓ recover_orphaned_data.sql
✓ recover_profile_diagnostic.sql
```

---

## 🟡 PADRÃO 15: RPC/Functions (6 SCRIPTS)
**Risco**: BAIXO - Mas verificar se duplicam lógica

```
✓ create_approve_teacher_rpc.sql    |
✓ create_merge_classes_rpc.sql      | Manter
✓ create_rpc_get_users.sql          | Verificar v1 vs v2
✓ create_rpc_get_users_v2.sql       |
✓ fix_city_list_rpc.sql
✓ create_student_archive.sql
```

---

## 🟢 PADRÃO 16: Migration/Structure (20+ SCRIPTS)
**Status**: ESTRUTURADO em supabase/migrations/

```
Bem organizados por data:
✓ 20260124_*.sql (Lote de 2026-01-24)
✓ 20260129_*.sql (Lote de 2026-01-29)  ⚠️ Muita atividade - problema?
✓ 20260203_*.sql (Lote de 2026-02-03)
✓ 20260204_*.sql (Lote de 2026-02-04)
✓ 20260209_*.sql (Lote de 2026-02-09)

Diretório ok: supabase/migrations/
```

---

## SQL - RECOMENDAÇÃO LIMPEZA

| Script | Ação | Risco | Motivo |
|--------|------|-------|--------|
| fix_admin_duplicates.sql | ❌ DELETAR | BAIXO | Consolidado em others |
| fix_infinite_recursion.sql | ❌ DELETAR | MÉDIO | Use _final |
| fix_school_id_type.sql | ❌ DELETAR | MÉDIO | Use _v2 |
| diagnostico_paulo*.sql | ❌ DELETAR | BAIXO | Específico usuário |
| seed_jose_silva.sql | ❌ DELETAR | BAIXO | Teste de usuário |
| debug_*.sql | 📁 MOVER | BAIXO | Para .diagnostics/ |
| rls_fix_definitivo.sql | ✓ MANTER | CRÍTICO | Última versão |

**Total deletável**: ~40 scripts (~16% do SQL)

---

# 2️⃣ ANÁLISE PYTHON - 150+ SCRIPTS

## 🔴 PADRÃO 1: Duplicatas de Extração (3 SCRIPTS)
**Risco**: CRÍTICO - Mesma funcionalidade, código diverge

```
✓ extrair_livro.py                  (versão 1: selenium+bs4)
✗ extrator_preciso_profeplan.py    (versão 2: pdfplumber) ⚠️ TYPO em nome
✗ gerar_json.py                     (versão 3: ???)
```

**Análise**:
- `extrair_livro.py`: Scraping com Selenium do PNLD Digital
- `extrator_preciso_profeplan.py`: Parse de PDF com pdfplumber (estado 2026)
- `gerar_json.py`: Função `extrair()` vaga

**Recomendação**: Consolidar em `scripts/pnld/extract_curriculum.py`

---

## 🔴 PADRÃO 2: Duplicatas de Integração (3 SCRIPTS)
**Risco**: CRÍTICO - Mesma funcionalidade em 3 versões

```
✓ integrador_curriculo.py           (genérico)
✓ integrador_profeplan_mg.py        (MG específico)
✓ integrador_pnld_livros.py         (PNLD específico)
✓ import google.py                  ⚠️ TYPO - deveria ser integrador_google
```

**Análise**:
- Todos têm função `extrair_codigo()` idêntica
- Lógica de embedding repetida
- `import google.py` é um typo ou nome temporário

**Recomendação**: 
- Manter `integrador_curriculo.py` como base
- Deletar `integrador_profeplan_mg.py` (redundante)
- Manter `integrador_pnld_livros.py` (específico)
- Deletar `import google.py` (typo)

---

## 🔴 PADRÃO 3: Geradores de Base (2 SCRIPTS)
**Risco**: ALTO - Podem ter saído de sincronização

```
✓ gerador_base_planejamentos.py
✓ gerador_planejamento_codex.py     ⚠️ "Codex" é LLM da OpenAI - deprecated
```

**Recomendação**: Deletar `gerador_planejamento_codex.py` - usar Gemini (ativo)

---

## 🟠 PADRÃO 4: Scripts de Debug (6 SCRIPTS)
**Risco**: ALTO - Debug/test em raiz

```
✓ debug_books.py
✓ debug_ed_digital.py
✓ debug_supabase.py
✓ test_exec_sql.py
✓ test_pnld_search.py
✓ test_rag.py
✓ reproduce_issue.py
✓ testar_casamento.py
```

**Recomendação**: Mover para `scripts/debug/` ou deletar se deprecados

---

## 🟠 PADRÃO 5: Check/Verify Schema (3 SCRIPTS)
**Risco**: MÉDIO - Redundância com check_schema_v2.py

```
✓ check_schema.py
✓ check_schema_v2.py                ⚠️ v2 indica v1 deprecated
✓ check_pnld_data.py
```

**Recomendação**: Manter apenas v2, deletar v1

---

## 🟠 PADRÃO 6: Análise de Dados (5 SCRIPTS)
**Risco**: MÉDIO - Ferramentas analíticas, provavelmente obsoletas

```
✓ analyze_db.py
✓ analyze_disconnected_classes.sql  (já listado em SQL)
✓ audit_lines.py
✓ check_pnld_data.py
✓ scripts/analysis/analyze_planning_data.py
```

**Status**: Legítimos, manter mas documentar propósito

---

## 🟡 PADRÃO 7: Utilitários de Migration (8 SCRIPTS)
**Risco**: BAIXO - Mas verificar se realmente em uso

```
✓ run_migration.py
✓ scripts/migrations/migrate_planning_data.py
✓ scripts/migrations/phase1_subject_aliases.py
✓ scripts/ingest_fix.py
✓ scripts/ingest_curriculum.py
✓ scripts/ingest_curriculo_rag.py
✓ scripts/post_crash_check.py
✓ restore_rpc.py
```

**Recomendação**: Manter estruturados em `/scripts/migrations/`

---

## 🟢 PADRÃO 8: Scripts em /scripts/ (30+)
**Status**: BEM ORGANIZADO

```
scripts/
├─ pnld/                          ✓ Bem estruturado
│  ├─ populate_pnld_livros.py
│  ├─ parse_book_metadata.py
│  ├─ json_to_markdown.py
│  └─ export_to_json.py
├─ migrations/                    ✓ Bem estruturado
├─ analysis/                      ✓ Bem estruturado
├─ [Diretos em /scripts/]        ⚠️ 20+ scripts soltos
│  ├─ check_schema.py
│  ├─ profeplan_tools.py
│  ├─ ingest_*.py
│  └─ ...
```

**Insight**: /scripts/ cresceu demais sem estrutura

---

## Python - RECOMENDAÇÃO LIMPEZA

| Script | Ação | Risco | Motivo |
|--------|------|-------|--------|
| extrair_livro.py | ❌ DELETAR | MÉDIO | Use extrator_preciso |
| integrador_profeplan_mg.py | ❌ DELETAR | MÉDIO | Redundante |
| import google.py | ❌ DELETAR | ALTO | Typo/incompleto |
| gerador_planejamento_codex.py | ❌ DELETAR | ALTO | LLM deprecado |
| debug_*.py | 📁 MOVER | BAIXO | Para scripts/debug/ |
| test_*.py | 📁 MOVER | BAIXO | Para scripts/test/ |
| check_schema.py | ❌ DELETAR | MÉDIO | Use v2 |

**Total deletável**: ~12 scripts (~8% Python)

---

# 3️⃣ ANÁLISE JS/CJS - 22 SCRIPTS

## 🔴 PADRÃO 1: Duplicatas Node Modules (2 SCRIPTS)
**Risco**: CRÍTICO - Node CommonJS

```
✓ achar_erro.cjs
✓ achar_erro.js                     ⚠️ Duas versões!
```

**Análise**: 
- `.cjs` = CommonJS (antigo)
- `.js` = ESM (moderno)

**Recomendação**: Manter ESM `.js`, deletar `.cjs`

---

## 🔴 PADRÃO 2: Criação de Support User (2 SCRIPTS)
**Risco**: CRÍTICO - Mesma função, versões diferentes

```
✓ create_support_user.cjs
✓ create_support_user.js
✓ ensure_profile.cjs
```

**Recomendação**: Manter `.js`, deletar `.cjs`

---

## 🟠 PADRÃO 3: Geração de SQL (5 SCRIPTS)
**Risco**: ALTO - Múltiplas versões do mesmo gerador

```
✓ scripts/gerar_sql_escolas.js
✓ scripts/gerar_sql_escolas_corrigido.js       ⚠️ versão
✓ scripts/gerar_sql_escolas_filtradas.js       ⚠️ versão
✓ scripts/gerar_sql_escolas_PROD.js            ⚠️ versão
✓ scripts/generate_schools_sql.js              ⚠️ naming diferente
```

**Análise**: Mesmo propósito, 5 versões não consolidadas

**Recomendação**: Manter apenas PROD, consolidar lógica, deletar intermediárias

---

## 🟠 PADRÃO 4: ENEM Processing (4 SCRIPTS)
**Risco**: ALTO - Múltiplas abordagens não consolidadas

```
✓ scripts/ingest_enem.js
✓ scripts/ingest_enem_pdf_to_db.js
✓ scripts/inspect_enem_tables.js
✓ scripts/convert_enem_to_md.js
```

**Insight**: Parece haver evolução não consolidada

**Recomendação**: Manter apenas versão mais recente (PDF to DB), deletar outras

---

## 🟡 PADRÃO 5: Utilitários (8 SCRIPTS)
**Status**: Legítimos mas poderia consolidar

```
✓ scripts/build-manifest.js
✓ scripts/check_count.js
✓ scripts/debug_db.js
✓ scripts/diagnostico_etapas.js
✓ scripts/test_search.js
✓ scripts/upload_embeddings.js
```

---

## JS/CJS - RECOMENDAÇÃO LIMPEZA

| Script | Ação | Risco | Motivo |
|--------|------|-------|--------|
| achar_erro.cjs | ❌ DELETAR | BAIXO | Use .js |
| create_support_user.cjs | ❌ DELETAR | BAIXO | Use .js |
| ensure_profile.cjs | ❌ DELETAR | BAIXO | Use .js |
| gerar_sql_escolas.js | ❌ DELETAR | MÉDIO | Use PROD |
| gerar_sql_escolas_corrigido.js | ❌ DELETAR | MÉDIO | Use PROD |
| gerar_sql_escolas_filtradas.js | ❌ DELETAR | MÉDIO | Use PROD |
| generate_schools_sql.js | ❌ DELETAR | MÉDIO | Use PROD |
| ingest_enem.js | ❌ DELETAR | MÉDIO | Use PDF |
| ingest_enem_pdf_to_db.js | ✓ MANTER | MÉDIO | Versão ativa |
| convert_enem_to_md.js | ❓ AVALIAR | MÉDIO | Propósito? |

**Total deletável**: ~8 scripts (~36% JS)

---

# 4️⃣ ANÁLISE TYPESCRIPT - src/

## 🔴 PADRÃO 1: geminiService.ts - DEPRECATED
**Risco**: CRÍTICO - Arquivo deprecated mas ainda 13 imports ativos

**Localização**: [src/services/geminiService.ts](src/services/geminiService.ts)

**Status Atual**:
```typescript
/**
 * @deprecated This file is deprecated. Please import from the appropriate module in src/services/ai/
 */
export { decode, decodeAudioData, executeWithFallback, getGenAIClient, GENERATION_MODELS, safetySettings } from './ai/AiCore';
export { generateProfePlanStream } from './ai/AiChatService';
// ... mais exports re-export
```

**Importadores Ativos** (13 encontrados):
1. [src/services/PlanningAuthorityService.ts](src/services/PlanningAuthorityService.ts) - linha 3
2. [src/services/PdiBlock9Service.ts](src/services/PdiBlock9Service.ts) - linha 7
3. [src/services/ai/AiAdaptationService.ts](src/services/ai/AiAdaptationService.ts) - linha 1
4. [src/features/PDI/usePDIManager.ts](src/features/PDI/usePDIManager.ts) - linha 7
5. [src/features/PDI/components/PDIBlock10Form.tsx](src/features/PDI/components/PDIBlock10Form.tsx) - linha 4
6. [src/features/PDI/components/PDIBlock11Editor.tsx](src/features/PDI/components/PDIBlock11Editor.tsx) - linha 7
7. [src/features/Planning/PlanningManager.tsx](src/features/Planning/PlanningManager.tsx) - linha 4
8. [src/features/Assessment/components/AssessmentSetup.tsx](src/features/Assessment/components/AssessmentSetup.tsx) - linha 5
9. [src/components/PresentationCreator.tsx](src/components/PresentationCreator.tsx) - linha 7
10. [src/components/School/PDI/PDIConsolidator.tsx](src/components/School/PDI/PDIConsolidator.tsx) - linha 4
11. [src/components/ClassManager/ImportProcess.tsx](src/components/ClassManager/ImportProcess.tsx) - linha 4
12. [src/components/DissertativeGrader.tsx](src/components/DissertativeGrader.tsx) - linha 3
13. [src/components/ClassBatchImportModal.tsx](src/components/ClassBatchImportModal.tsx) - linha 5

**Recomendação**: 
- ❌ NÃO deletar ainda
- ✅ Criar issue para refatorar todos os 13 imports
- 📋 Usar como lista de refatoração

---

## 🟠 PADRÃO 2: Serviços de Profile (Redundância)
**Risco**: MÉDIO - Múltiplas formas de acessar profiles

```
✓ ProfileService.ts          (Classe com métodos)
✓ userService.ts             (getUserProfile())
✓ supabaseService.ts         (getTeacherContext())
```

**Análise**:
- `ProfileService.ts`: Tipo-safe, métodos
- `userService.ts`: Funções diretas, com RLS bypass
- `supabaseService.ts`: Wrapper mais genérico

**Recomendação**: Consolidar em ProfileService, remover duplicação em userService

---

## 🟠 PADRÃO 3: Search Services (2 IMPLEMENTAÇÕES)
**Risco**: MÉDIO - Dois tipos de busca

```
✓ searchService.ts           (hybridSearchProfeplan, searchCurriculum)
✓ services/ai/AiUtilityService.ts  (parseClassListFromText - AI)
```

**Insight**: Diferentes responsabilidades mas nomenclatura confusa

**Recomendação**: Renomear AiUtilityService → AiParsingService

---

## 🟠 PADRÃO 4: Exportação de PDI (2 PADRÕES)
**Risco**: MÉDIO - Dois tipos de export

```
✓ PdiExportService.ts        (export para DOCX)
✓ exportService.ts           (genérico para qualquer formato)
```

**Recomendação**: PdiExportService deveria usar exportService como base

---

## 🟡 PADRÃO 5: Tipos Duplicados em src/types/
**Risco**: BAIXO - Mas verificar

```
Estrutura atual:
src/types/
├─ types.ts                  (tipos principais)
├─ index.ts                  (re-exports)
├─ pdi.ts                    (tipos PDI)
├─ pdi-schema.ts             (schema Zod PDI)
```

**Insight**: `pdi-schema.ts` exporta tipos que duplicam `pdi.ts`

**Recomendação**: Consolidar em um arquivo, remover duplicação

---

## TypeScript - RECOMENDAÇÃO LIMPEZA

| Arquivo | Ação | Risco | Motivo |
|---------|------|-------|--------|
| geminiService.ts | 🔄 REFACTOR | CRÍTICO | 13 imports para migrar |
| [todos 13 imports] | 🔄 REFACTOR | ALTO | Migrar para ai/* |
| UserService profile fns | 🔄 MERGE | MÉDIO | Com ProfileService |
| supabaseService profile fns | 🔄 MERGE | MÉDIO | Com ProfileService |
| AiUtilityService | 🔄 RENAME | BAIXO | → AiParsingService |
| PdiExportService | 🔄 REFACTOR | BAIXO | Use exportService |

**Total refactor needed**: ~15 arquivos

---

# 5️⃣ ANÁLISE: REDUNDÂNCIAS GLOBAIS

## 🔴 CRÍTICO: Padrão "Final" em Nomes
**Padrão**: Scripts com nomes tipo `*_final.sql`, `*_v2.sql`

**Contagem**:
- `*_final` = 8 occurrências
- `*_v2` = 4 occorrências
- `*_definitivo` = 2 occorrências

**Análise**: Nomenclatura indica falha iterativa anterior

```
✓ fix_admin_recursion.sql
✗ fix_infinite_recursion_final.sql     ← v1 falhou?

✓ fix_manager_role.sql
✗ fix_manager_role_complete.sql        ← v1 incompleto?
```

**Insight**: Cada "_final" representa um bug não detectado em tempo

---

## 🟠 ALTO: Duplicação de Lógica (sem DRY)

### Extract Code Pattern
Função `extrair_codigo()` aparece em 3 arquivos Python:
1. integrador_profeplan_mg.py
2. integrador_curriculo.py
3. import google.py

```python
def extrair_codigo(texto):
    match = re.search(r'\((E[MF]\d+[\w\d]+)\)', texto)
    return match.group(1) if match else "SEM_CODIGO"
```

**Recomendação**: Mover para `utils/curriculum_utils.py`

---

## 🟠 ALTO: Type Definitions Scatter

Tipos PDI espalhados em:
- `src/types/pdi.ts`
- `src/types/pdi-schema.ts`
- Re-exports em `src/types/index.ts`

**Recomendação**: Single source of truth em pdi-schema.ts

---

## 🟡 MÉDIO: Services Duplication

3 formas de acessar user profiles:
- `ProfileService.getProfile(userId)`
- `userService.getUserProfile(userId)`
- `supabaseService.getTeacherContext(userId)`

**Recomendação**: Manter apenas ProfileService como façade

---

# 6️⃣ RESUMO CONSOLIDADO: LIMPEZA RECOMENDADA

## Deletáveis SEM Risco (Baixo: 30 arquivos)

### SQL (15 scripts)
```
❌ diagnostico_paulo_final.sql
❌ diagnostico_paulinho_profiles.sql
❌ diagnostico_completo_paulinho.sql
❌ seed_jose_silva.sql
❌ fix_admin_duplicates.sql
❌ fix_infinite_recursion.sql
❌ fix_school_id_type.sql
❌ fix_profile_school_id_type.sql
❌ fix_pending_teachers_rls.sql
❌ fix_manager_role.sql
❌ fix_recursion.sql
❌ fix_enum_part1.sql
❌ fix_simplified.sql
❌ delete_paulo.sql
❌ delete_duplicate_admin.sql
```

### Python (6 scripts)
```
❌ extrair_livro.py
❌ gerador_planejamento_codex.py
❌ import google.py
❌ check_schema.py (use v2)
❌ integrador_profeplan_mg.py
❌ testar_casamento.py
```

### JS/CJS (9 scripts)
```
❌ achar_erro.cjs
❌ create_support_user.cjs
❌ ensure_profile.cjs
❌ gerar_sql_escolas.js
❌ gerar_sql_escolas_corrigido.js
❌ gerar_sql_escolas_filtradas.js
❌ generate_schools_sql.js
❌ ingest_enem.js
❌ convert_enem_to_md.js
```

**Total Deletável Baixo Risco**: 30 arquivos

---

## Risco Médio: 45 arquivos

### SQL (20 scripts)
- Todos os `debug_*.sql` (mover para .diagnostics/)
- Todos os `diagnose_*.sql` (consolidar)
- Duplicatas de `restore_*.sql`

### Python (15 scripts)
- Todos os `test_*.py` (mover para scripts/test/)
- Todos os `debug_*.py` (mover para scripts/debug/)

### JS (10 scripts)
- Múltiplas versões de generate_schools_sql.js

---

## Risco Crítico: Refatoração (13 arquivos)

### TypeScript (todos em src/)
1. Migrar 13 imports de geminiService → ai/*
2. Consolidar ProfileService (remover duplicação userService)
3. Consolidar tipos PDI (remover duplicação)

---

# 7️⃣ ESTATÍSTICAS FINAIS

| Categoria | Total | Deletável | % | Refator | Status |
|-----------|-------|-----------|---|---------|--------|
| **SQL** | 248 | 40 | 16% | 30 | 🔴 CRÍTICO |
| **Python** | 150+ | 12 | 8% | 15 | 🟠 ALTO |
| **JS/CJS** | 22 | 8 | 36% | 5 | 🟠 ALTO |
| **TS/TSX** | 205+ | 0 | 0% | 13 | 🟡 MÉDIO |
| **TOTAL** | 625+ | 60 | ~10% | 63 | ⚠️ |

---

# 8️⃣ RECOMENDAÇÕES FINAIS

## 🔴 CRÍTICO - Fazer AGORA (Impacto Alta)

1. **Consolidar fix_admin_*.sql** → create index com precedência
2. **Consolidar fix_rls_*.sql** → estudar por que RLS falhou 13x
3. **Deletar debug_*.sql** → mover para .diagnostics/
4. **Refactor geminiService** → lista de 13 migrações

## 🟠 ALTO - Fazer esta semana

1. Consolidar integrador_*.py
2. Deletar test_*.py duplicados
3. Consolidar generate_schools_sql.js (apenas 1 versão)
4. Documentar padrão de teste (onde vão test_*.py)

## 🟡 MÉDIO - Fazer este mês

1. Consolidar ProfileService
2. Remover tipos PDI duplicados
3. Renomear serviços (AI*)
4. Mover check_*.sql para scripts/

## 🟢 BAIXO - Prioridade contínua

1. Parar de criar fix_*_final.sql (resolver problema direto)
2. Estabelecer convenção de nomenclatura
3. Documentar versioning strategy
4. Usar branches para variations (não arquivos)

---

## ⚠️ AVISO IMPORTANTE

**NENHUM ARQUIVO FOI DELETADO**. Este é apenas um INVENTÁRIO.

Antes de deletar qualquer arquivo:

1. ✅ Commit todo código no git
2. ✅ Procurar por últimos usos em git log
3. ✅ Verificar backups de produção
4. ✅ Notificar time sobre remoção
5. ✅ Deletar em múltiplas passes (não tudo de uma vez)

---

**Assinado**: Backend-Specialist  
**Data**: 10 de Fevereiro de 2026  
**Próxima Revisão**: 17 de Fevereiro de 2026

