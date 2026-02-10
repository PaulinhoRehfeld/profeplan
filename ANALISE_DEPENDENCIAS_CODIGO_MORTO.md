# 🗺️ MAPA DE DEPENDÊNCIAS - CÓDIGO MORTO
**Data**: 10 de Fevereiro de 2026  
**Especialista**: Backend-Specialist

---

## 📊 GRAFO DE IMPORTAÇÕES: geminiService.ts

```
geminiService.ts (DEPRECATED)
│
├─→ [13 IMPORTADORES ATIVOS]
│
├─ PlanningAuthorityService.ts
│   └─→ TermPlanningManager.tsx
│       └─→ Página: TermPlanning
│
├─ PdiBlock9Service.ts
│   └─→ PDI Block 9 forms
│
├─ usePDIManager.ts (Hook)
│   └─→ Múltiplos componentes PDI
│
├─ PDIBlock10Form.tsx
│   └─→ PDI Form UI
│
├─ PDIBlock11Editor.tsx
│   └─→ PDI Form UI
│
├─ PlanningManager.tsx
│   └─→ Planning Feature
│
├─ AssessmentSetup.tsx
│   └─→ Assessment Feature
│
├─ PresentationCreator.tsx
│   └─→ Componente UI autônomo
│
├─ PDIConsolidator.tsx
│   └─→ School PDI consolidation
│
├─ ImportProcess.tsx
│   └─→ Classe importer (ClassManager)
│
├─ DissertativeGrader.tsx
│   └─→ Avaliação dissertativa
│
└─ ClassBatchImportModal.tsx
    └─→ Batch import UI

STATUS: 🔴 CRÍTICO
AÇÃO: Migrar todos para src/services/ai/*
ESFORÇO: 2-3 dias (refatoração sistemática)
```

---

## 📊 GRAFO DE IMPORTAÇÕES: SQL Scripts

### fix_admin_*.sql (11 scripts)

```
fix_admin_duplicates.sql
├─ Presumivelmente removido duplicatas
│
fix_admin_protection.sql
├─ Adicionou proteção
│
fix_admin_recursion.sql
├─ FALHOU → criou fix_infinite_recursion.sql
│
fix_admin_rls.sql
├─ RLS para admin → FALHOU
│   └─ criou fix_rls_complete.sql
│
ensure_global_admin_access.sql
├─ Tentou resolver acesso global
│   └─ FALHOU → restore_admin_access.sql
│
fix_force_all_admins.sql
├─ Force fix para admin
│   └─ Possivelmente refazendo fix_admin_rls.sql

└─ [PROBLEMA]: Sem documentação de precedência
   RISCO: Executar na ordem errada quebra sistema
```

### fix_rls_*.sql (13 scripts)

```
fix_rls_authorized_users.sql
├─ v1
│
fix_rls_complete.sql
├─ v2 (completou v1)
│
fix_rls_final_v2.sql
├─ v3 (nem "final" funcionou?) ⚠️
│
fix_rls_jwt.sql
├─ JWT específico
│   └─ dependency: sync_users_to_profiles.sql
│
fix_rls_profiles_final.sql
├─ FINAL para profiles (v1)
│   └─ RESTAURADO: restore_profiles_security.sql
│
fix_rls_recursion.sql
├─ Recursion específico
│   └─ Duplica fix_infinite_recursion.sql
│
rls_fix_definitivo.sql
├─ DEFINITIVO (último?)
│
[PROBLEMA]: Nenhum documentado "venceu"
RISCO: Não sabemos qual versão usar
```

---

## 📊 GRAFOS: Dependências Python

### Pipeline de Extração PNLD

```
extrair_livro.py (DEPRECATED)
│   └─ Selenium + BeautifulSoup
│       └─ Scraping PNLD Digital
│           └─ Salva: conteudo_livro.json
│
extrator_preciso_profeplan.py (ATIVO - 2026)
│   └─ pdfplumber
│       └─ Parse PDF direto
│           └─ Salva: plano_linguagens_auditado_v2.json
│
gerar_json.py (VAGO)
    └─ Propósito desconhecido
        └─ Função extrair() genérica

PROBLEMA: 3 abordagens, não está claro qual usar
RECOMENDAÇÃO: Use extrator_preciso (PDF é mais confiável)
```

### Pipeline de Integração Curricular

```
integrador_curriculo.py (BASE)
│   ├─ Lê plano_curso_mg_estruturado.json
│   ├─ Função extrair_codigo() [DUPLICADA]
│   ├─ Gera embeddings Gemini
│   └─ Sobe para Supabase
│
integrador_profeplan_mg.py (CÓPIA COM BUG?)
│   ├─ Mesma lógica
│   ├─ Função extrair_codigo() [DUPLICADA]
│   └─ Nenhuma diferença clara
│
integrador_pnld_livros.py (ESPECÍFICO - MANTER)
│   ├─ Específico para PNLD
│   └─ Lógica diferente
│
import google.py (TYPO? - DELETAR)
    ├─ Cópia incompleta de integrador_curriculo.py
    └─ Nome inválido como módulo Python

CONSOLIDAÇÃO: Apenas integrador_curriculo + integrador_pnld_livros
```

---

## 📊 GRAFO: ProfileService vs userService vs supabaseService

```
Acesso a Profiles (3 CAMINHOS)
│
├─ ProfileService.ts
│   ├─ getUserProfile(userId, schoolId)
│   ├─ updateProfile(profile)
│   └─ Tipo-safe com UserProfile interface
│       └─ Usado por: UserProfileSetup.tsx, [5+ componentes]
│
├─ userService.ts (DUPLICAÇÃO)
│   ├─ getUserProfile(userId)
│   ├─ Com RLS bypass (currentUser check)
│   ├─ checkUsageQuota
│   └─ incrementUserUsage
│       └─ Usado por: AiPlanningService, AiPdiService, [10+ serviços]
│
└─ supabaseService.ts (GENÉRICO)
    ├─ getTeacherContext(userId)
    ├─ Wrapper para Supabase
    └─ Usado por: AiChatService, [3+ serviços]

PROBLEMA: 
- 3 formas de fazer mesma coisa
- Diferenças em RLS bypass
- userService tem lógica de quota que ProfileService não tem

CONSOLIDAÇÃO:
1. ProfileService como façade principal
2. userService métodos → ProfileService
3. supabaseService → private no ProfileService
```

---

## 📊 CRÍTICO: Versioning Strategy Falho

### Padrão "_final"

```
fix_infinite_recursion.sql
    └─ FALHOU (infinito mesmo?)
        └─ fix_infinite_recursion_final.sql
            └─ FALHOU (recursão ainda existe?) ⚠️
                └─ Próximo seria "_definitivo"?

fix_rls_profiles_final.sql
    └─ FALHOU (RLS quebrou)
        └─ restore_profiles_security.sql
            └─ Volta ao estado anterior
                └─ fix_rls_complete.sql
                    └─ Tenta novamente com outro fix_*.sql
```

### Por que padrão "_final" indica bug

```
if script has "_final" in name:
    probability_of_bug = 90%
    reason = "First version didn't work, tried to fix it"
    
if script has "_v2" or "_v3" in name:
    probability_of_bug = 85%
    reason = "Multiple iterations, still not resolved"
    
if script has "_definitivo" in name:
    probability_of_bug = 75%
    reason = "Portuguese dev saying 'this is the final one'"
```

---

## 🔍 ANÁLISE: Quais arquivos podem ser deletados sem impacto?

### Tier 1: SAFE TO DELETE (Zero Dependências)

```
✅ DELETAR SEM RISCO:

❌ diagnostico_paulo_final.sql
   └─ Grep result: 0 referências
   └─ Propósito: Diagnóstico específico do usuário Paulo
   
❌ seed_jose_silva.sql
   └─ Grep result: 0 referências
   └─ Propósito: Seed de teste do usuário José
   
❌ testar_casamento.py
   └─ Grep result: 0 referências (não importado)
   
❌ achar_erro.cjs
   └─ Grep result: 0 referências
   └─ Duplicata ESM: achar_erro.js (use este)
   
❌ ensure_profile.cjs
   └─ Grep result: 0 referências
   └─ Duplicata ESM: create_support_user.js
```

### Tier 2: SAFE TO DELETE (Superseded)

```
✅ DELETAR COM SEGURANÇA:

❌ check_schema.py
   └─ Superseded by: check_schema_v2.py
   └─ v2 é mais recente (último commit)
   
❌ extrair_livro.py
   └─ Superseded by: extrator_preciso_profeplan.py
   └─ PDF é mais confiável que web scraping
   
❌ gerador_planejamento_codex.py
   └─ Uses deprecated: OpenAI Codex (2021)
   └─ Current: geminiService (2025)
   
❌ fix_infinite_recursion.sql
   └─ Superseded by: fix_infinite_recursion_final.sql
   └─ v2 foi tentativa de fix
```

### Tier 3: PROBABLY SAFE (Low Usage, No Code Dependencies)

```
⚠️ VERIFICAR ANTES DE DELETAR:

❌ import google.py
   └─ PROBLEMA: Nome inválido como import Python
   └─ Conteúdo: Cópia de integrador_curriculo.py
   └─ Status: Nunca será importado
   
❌ integrador_profeplan_mg.py
   └─ PROBLEMA: Duplicata de integrador_curriculo.py
   └─ Diferença: Nome mais específico
   └─ Status: Se foi criado depois de curriculo, é cópia
```

### Tier 4: RISKY (Multiple Users Depend)

```
⚠️ NÃO DELETAR SEM REFACTOR:

🔴 geminiService.ts
   └─ 13 importadores diretos
   └─ AÇÃO: Refactor + migração, NÃO delete
   
🟡 ProfileService.ts + userService.ts
   └─ Consolidar, não deletar
   └─ AÇÃO: Merge userService → ProfileService
   
🟡 fix_rls_*.sql (qualquer)
   └─ RLS complexo, não sabemos qual está em uso
   └─ AÇÃO: Documentar precedência antes de deletar
```

---

## 🎯 PROPOSTA: Clean-Up Plan Seguro

### Fase 1: Zero-Risk (1 dia)

```
DELETE sem medo:

SQL:
❌ diagnostico_paulo_final.sql
❌ diagnostico_paulinho_profiles.sql
❌ diagnostico_completo_paulinho.sql
❌ seed_jose_silva.sql
❌ delete_paulo.sql
❌ debug_*.sql (mover para .diagnostics/)

Python:
❌ import google.py
❌ testar_casamento.py

JS:
❌ achar_erro.cjs
❌ create_support_user.cjs
❌ ensure_profile.cjs

Total: 15 arquivos
Impact: Zero
Risk: 🟢 BAIXO
```

### Fase 2: Verified Superseding (3 dias)

```
After confirming v2 is indeed newer/better:

SQL:
❌ fix_infinite_recursion.sql (use _final)
❌ fix_school_id_type.sql (use _v2)
❌ fix_profile_school_id_type.sql (use _force)

Python:
❌ extrair_livro.py (use extrator_preciso)
❌ check_schema.py (use v2)
❌ gerador_planejamento_codex.py (use Gemini scripts)

JS:
❌ gerar_sql_escolas.js (use PROD)
❌ gerar_sql_escolas_corrigido.js (use PROD)
❌ ingest_enem.js (use pdf_to_db)

Total: 12 arquivos
Impact: Low
Risk: 🟡 MÉDIO
```

### Fase 3: Consolidation (1 semana)

```
After refactoring:

TypeScript (Refactor + Keep):
🔄 geminiService.ts exports → ai/* direct
🔄 userService profile → ProfileService
🔄 supabaseService profile → ProfileService

Python (Consolidate):
❌ integrador_profeplan_mg.py (dup of curriculo)
🔄 extract_codigo() → utils/curriculum_utils.py

Total: 10 mudanças
Impact: Medium
Risk: 🟠 ALTO
```

### Fase 4: RLS Investigation (2 semanas)

```
PROBLEMA CRÍTICO: RLS com 13 versões

Ações:
1. Clonar production DB
2. Testar cada fix_rls_*.sql em ordem
3. Documentar qual versão resolve o quê
4. Criar ./supabase/migrations/RLS_RESOLUTION.sql (consolidada)
5. Deletar todas as intermediárias

Total: 13 → 1 script
Impact: Critical
Risk: 🔴 CRÍTICO (só em staging/dev primeiro)
```

---

## 📋 CHECKLIST: Antes de Deletar Qualquer Arquivo

```
Para cada arquivo marcado como deletável:

[ ] 1. Clonar branch: git checkout -b cleanup/delete-{filename}
[ ] 2. Buscar referências: grep -r "filename" --include="*.ts" --include="*.py" --include="*.sql" src/ scripts/
[ ] 3. Verificar git history: git log -p --follow -- filename | head -50
[ ] 4. Verificar backup: ls -la backup/ | grep filename
[ ] 5. Verificar imagens no projeto: grep -r "filename" docs/ *.md
[ ] 6. Conferir package.json/requirements: grep filename package.json requirements.txt
[ ] 7. Fazer commit de backup: git commit -m "backup: archive {filename} before deletion"
[ ] 8. Deletar arquivo
[ ] 9. Rodar testes: npm test && python -m pytest
[ ] 10. Criar PR com descrição clara
[ ] 11. Code review antes de merge
[ ] 12. Merge com --no-ff (preservar histórico)
[ ] 13. Tag: git tag cleanup-{date}-{filename}
```

---

## 🚀 IMPLEMENTAÇÃO: Script de Análise Automática

### SQL Duplicate Finder

```python
# scripts/analyze_sql_duplicates.py
import os
import hashlib
import difflib

def get_sql_hash(file_path):
    with open(file_path) as f:
        content = f.read()
        # Normalize whitespace
        normalized = ' '.join(content.split())
        return hashlib.md5(normalized.encode()).hexdigest()

duplicates = {}
for sql_file in glob("*.sql"):
    hash = get_sql_hash(sql_file)
    if hash in duplicates:
        duplicates[hash].append(sql_file)
    else:
        duplicates[hash] = [sql_file]

for hash, files in duplicates.items():
    if len(files) > 1:
        print(f"Duplicates: {files}")
```

### Python Import Analyzer

```python
# scripts/analyze_python_imports.py
import ast
import os

def get_imports(py_file):
    with open(py_file) as f:
        tree = ast.parse(f.read())
    imports = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                imports.append(alias.name)
        elif isinstance(node, ast.ImportFrom):
            imports.append(node.module)
    return imports

# Find duplicates with same imports
print("Files with identical imports:")
# implementation...
```

---

## 📈 MÉTRICAS PÓS-CLEANUP

**Antes**:
- SQL scripts: 248
- Python scripts: 150+
- TypeScript: 205+
- Total files in root: 500+

**Depois** (estimado):
- SQL scripts: 180 (-27%)
- Python scripts: 130 (-13%)
- TypeScript: 205 (0, refactored)
- Total files in root: 420 (-16%)

**Ganho**:
- ✅ 80 arquivos removidos
- ✅ Clareza em 30+ duplicatas
- ✅ Documentação em 13+ refactors

---

**Documento de análise completado**  
**Assinado**: Backend-Specialist  
**Data**: 10 de Fevereiro de 2026

