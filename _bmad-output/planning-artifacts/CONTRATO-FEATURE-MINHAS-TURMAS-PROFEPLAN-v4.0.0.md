---
feature: "Minhas Turmas"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Minhas Turmas (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Ser o **painel principal de turmas do professor**, onde ele:

- Cadastra, importa e gerencia suas turmas e listas de alunos.
- Mantém a ligação entre **turma ↔ alunos ↔ PDI ↔ Planejamento ↔ Avaliações**.
- Garante que os dados de alunos sobrevivam a falhas de rede (Supabase) via backup local.

---

## 2. Entidades e Contexto Técnico

- **Tabela `classes` (Supabase)**
  - Gerenciada principalmente via `supabaseService` e `classService`:
    - `getClasses(userId, schoolId?)`
    - `getClassDetails(classId)`
    - `saveClassStructure(userId, { className, subject, students })`
    - `createClass`, `updateClass`, `mergeClasses`, `deleteClass`
  - Campos típicos:
    - `id`, `name`, `subject`, `grade?`, `shift?`, `room?`, `year?`, `school_id?`, `user_id?`.

- **Tabela `school_students` (Supabase)**
  - Base de alunos da escola (ligada a PDI, PDI logs etc.).

- **Modelo de turma no frontend**
  - Tipo `Class` em `types.ts`:
    - `id`, `name`, `subject`, `grade?`, `shift?`, `year?`, `room?`, `school_id?`, `user_id?`, `students?`.
  - Extensões locais (`LocalClass`) em `ClassManagement.tsx`:
    - `student_count`, `students[]`.

- **Armazenamento Local (offline/backup)**
  - `localStorageService`:
    - `saveClassToLocal`, `getLocalClasses`, `getLocalClassDetails`, `deleteLocalClass`, `updateLocalClass`, `exportClassesToJSON`.

- **Componentes**
  - `ClassManager.tsx` (aba “Minhas Turmas” – professor):
    - Lista, criação, importação via PDF, exportação JSON e edição básica de turmas/alunos (focada no professor).
  - `School/ClassManagement.tsx` (Gestão Escolar – direção/coordenador):
    - Cria/edita/mescla/exclui turmas por escola, gerencia alunos vinculados à escola, integra diretamente com PDI (`StudentPDIProfile`).

---

## 3. Fluxo – Minhas Turmas (Professor)

### 3.1 Carregamento de turmas

**Comportamento esperado (`ClassManager.fetchClasses`)**:

1. Tenta buscar primeiro no Supabase:
   - `getClasses(userId, schoolId)` (filtra por escola ativa se houver `userProfile.active_school_id`).
2. Se houver erro:
   - Faz fallback para local:
     - `getLocalClasses(userId)` convertendo estrutura para `Class`.
3. Preenche `classes` com lista de turmas contendo:
   - `id`, `name`, `subject`, `created_at`, `students` (se disponível).

**Contrato:**

- Supabase é fonte primária; localStorage é backup e cache offline.
- A lista exibida deve refletir a escola ativa do professor, quando aplicável.

---

### 3.2 Criação e Importação de Turmas

**Criação manual (`handleSaveNewClass`)**:

1. Usa `saveClassStructure(userId, { className, subject, students })` para gravar no Supabase.
2. Grava cópia local para backup:
   - `saveClassToLocal(userId, { className, subject, students })`.
3. Recarrega lista (`fetchClasses`).

**Importação via PDF (`ImportProcess`)**:

1. Usuário escolhe arquivo PDF de lista de chamada.
2. `ImportProcess` extrai `className`, `subject`, `students[]`.
3. `handleImportComplete` grava:
   - No Supabase, via `saveClassStructure`.
   - Localmente, via `saveClassToLocal`.

**Contrato:**

- Nenhuma turma criada/importada pode ficar **apenas** em localStorage se a rede estiver disponível – deve sempre tentar sincronizar com Supabase.

---

### 3.3 Visualização de Turma e Alunos

**Seleção de turma (`handleViewClass`)**:

1. Tenta carregar detalhes da turma do Supabase:
   - `getClassDetails(id)` (incluindo `students`).
2. Se falhar, recorre ao local:
   - `getLocalClassDetails(id)`.
3. Preenche `selectedClass` com:
   - `id`, `name`, `subject`, `created_at`, `students[]`.

**Detalhe da turma (lista de alunos) em `ClassManager`**:

- Lista alunos com:
  - `name`, `student_code`, marcadores de PDI (`needs_adaptation`, `deficiencies` etc.) quando disponíveis.
- Permite:
  - Atualizar atributos de PDI/observações locais e sincronizar com Supabase (`updateStudent`).

**Contrato:**

- A visão de turma usada por **Avaliações**, **PDI**, **Planejamento** e outras features deve ser consistente (mesmo `class.id`).

---

## 4. Fluxo – Gestão Escolar de Turmas (ClassManagement em SchoolDashboard)

**Escopo:**

- Painel de turmas ao nível da escola:
  - Criação, edição, unificação (merge) e exclusão de turmas ligadas a `school_id`.

**Ações principais:**

- Criar turma (`createClass` via `classService`).
- Atualizar turma (`updateClass`).
- Unificar turmas (`mergeClasses`):
  - Move alunos da turma origem para a turma destino.
  - Exclui turma origem.
- Excluir turma (`deleteClass`), com salvaguarda:
  - Não permite excluir turma com alunos (`student_count > 0`).

**Integração PDI:**

- Exibe link/entrada para `StudentPDIProfile` de cada aluno.
- Permite marcar/alterar `deficiencies` do aluno, atualizando Supabase (`updateStudent`).

**Contrato:**

- Operações de merge/delete devem preservar integridade dos vínculos PDI/avaliações, respeitando as regras do backend (chaves estrangeiras e cascatas).

---

## 5. Conexões com Outras Abas

- **PDI/DUA**
  - Turmas e alunos são base para:
    - PDIs individuais (`pdi_documents`),
    - Registros PDI (`pdi_records`),
    - Geração de adaptações em lote por turma (Bloco 9).

- **Planejamento**
  - Turma selecionada pode ser usada como filtro/contexto para:
    - Selecionar planos/aulas que se aplicam àquela turma.

- **Avaliações**
  - `AssessmentSetup` carrega turmas via `getClasses(userId)` e filtra aulas por turma/série/disciplinas.

**Contrato:**

- O identificador de turma (`Class.id`) deve ser estável e usado como chave em:
  - Planejamentos, Avaliações, PDI logs e relatórios, sempre que houver relação com turma.

---

## 6. Erros, Estados e Mensagens

- **Falha Supabase ao listar turmas**
  - `ClassManager` deve fazer fallback para localStorage com aviso em console, sem travar a UX.

- **Falha ao salvar/atualizar turma/aluno**
  - Mensagens claras via `alert()` ou banners, sem inconsistência silenciosa.

- **Merge e exclusão em Gestão Escolar**
  - Deve haver confirmações explícitas, principalmente ao unificar turmas (ação irreversível).

---

## 7. Checklist de Validação (para agentes/QA)

1. **Sincronização Supabase/Local**
   - [ ] `fetchClasses` tenta Supabase e faz fallback para localStorage corretamente.
   - [ ] Criação/importação de turmas grava em Supabase e localStorage.

2. **Integridade de Turma/Aluno**
   - [ ] IDs de turmas e alunos são consistentes entre Minhas Turmas, PDI e Avaliações.

3. **Gestão Escolar**
   - [ ] `ClassManagement` respeita `school_id` e não permite apagar turmas com alunos sem merge prévio.

4. **UX**
   - [ ] Estados de carregamento, vazio e erro são claros para o professor.

