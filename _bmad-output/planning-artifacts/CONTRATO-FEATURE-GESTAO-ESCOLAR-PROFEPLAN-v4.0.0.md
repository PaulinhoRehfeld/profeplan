---
feature: "Gestão Escolar"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Gestão Escolar (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Oferecer ao **gestor escolar** (direção, coordenação, superadmin) um painel unificado para:

- Visualizar **professores, turmas e alunos** da escola.
- Navegar entre escolas (modo admin) de forma segura e rastreável.
- Servir como referência para decisões de PDI, planejamento, turmas e matrícula.

---

## 2. Entidades e Contexto Técnico

- **Escolas (`schools`)**
  - Acesso via `SchoolService`:
    - `getCities`, `getSchoolsByCity`, `resolveSchoolByIdOrInep`, `getAllSchools`.

- **Professores**
  - Associados à escola via:
    - `teacher_schools` (ativo/pending) em `teacherSchoolService` / `teacherService`.
    - `profiles` (para dados básicos).

- **Alunos**
  - Tabela `school_students` (Supabase).
  - Acesso agregado via `getStudentsBySchool`.

- **Turmas**
  - Tabela `classes` (Supabase).
  - Carregadas por escola via `getClassesBySchool`.
  - Geridas dentro da aba “Turmas” do SchoolDashboard com `ClassManagement`.

- **Componente principal**
  - `SchoolDashboard.tsx`:
    - Props: `userProfile`, `onOpenSettings`.
    - Gere:
      - `activeSchoolId`, `stats`, `teachers`, `students`, `classes`.
      - `isAdmin`, seleção de cidades/escolas (modo admin).
      - Tabs: `teachers`, `classes`, `students`.
    - Usa:
      - `TeacherManagement`, `ClassManagement`, `StudentManagement`.
      - `SchoolService`, `getStudentsBySchool`, `getClassesBySchool`, `getActiveTeachersBySchool`, `getPendingTeachersBySchool`.

---

## 3. Fluxos Principais

### 3.1 Seleção de Escola Ativa

**Regra básica:**

- Para gestores “normais” (não admin):
  - A escola ativa vem de `userProfile.school_id`.
- Para admins:
  - Não existe escola ativa por padrão; admin deve selecionar cidade e escola.

**Comportamento esperado:**

1. Ao montar:
   - Se `isAdmin`:
     - Chama `SchoolService.getCities()` para preencher lista de cidades.
   - Se `userProfile.school_id`:
     - Seta `activeSchoolId` com esse valor.
2. Admin, sem escola ativa:
   - Escolhe cidade → carrega escolas via `SchoolService.getSchoolsByCity`.
   - Escolhe escola → `handleAdminConnect` define `activeSchoolId` e atualiza `stats.schoolName`.

**Contrato:**

- O painel nunca deve tentar carregar dados de escola sem um `activeSchoolId` definido.
- Admins só podem inspecionar escolas listadas via `SchoolService` (sem IDs arbitrários injetados).

---

### 3.2 Carregamento de Dados da Escola

**Função central (`loadDashboardData`)**:

1. Resolve `schoolId`:
   - Usa `SchoolService.resolveSchoolByIdOrInep` para aceitar tanto UUID quanto código INEP.
2. Carrega:
   - Professores ativos via `getActiveTeachersBySchool(resolvedSchoolId)`.
   - Professores pendentes via `getPendingTeachersBySchool(resolvedSchoolId)`.
   - Alunos via `getStudentsBySchool(resolvedSchoolId)`.
   - Turmas via `getClassesBySchool(resolvedSchoolId)`.
3. Calcula:
   - `totalTeachers = ativos + pendentes`.
   - `totalStudents`, `totalClasses`.
   - `classesWithCounts`: turmas com `student_count` baseado em `studentsData`.

**Contrato forte:**

- Qualquer métrica mostrada (cards superiores) deve ser derivada **diretamente** desses dados.
- Se `resolveSchoolByIdOrInep` falhar, o painel deve registrar erro em log e não exibir dados inconsistentes.

---

### 3.3 Tabs: Professores, Turmas, Alunos

**Professores (`activeTab = 'teachers'`)**

- Componente `TeacherManagement`:
  - Lista professores ativos e pendentes.
  - Permite ações administrativas (aprovar convites, gerenciar vínculos, etc. – conforme implementação).

**Turmas (`activeTab = 'classes'`)**

- Componente `ClassManagement` (escolar):
  - Usa `classes` com `student_count`.
  - Permite:
    - Criar, atualizar, unificar, excluir turmas (ver contrato de Minhas Turmas/Gestão Escolar).
    - Gerenciar alunos dentro da escola (adicionar / editar / PDI).

**Alunos (`activeTab = 'students'`)**

- Componente `StudentManagement`:
  - Lista `students` da escola.
  - Provê filtros, ações de gestão e possíveis atalhos para PDI.

**Contrato:**

- Todas as ações de professores/turmas/alunos devem operar **dentro do escopo de `activeSchoolId`**.

---

### 3.4 Estados Especiais

- **Nenhuma escola vinculada (gestor não-admin)**
  - Exibir painel explicativo com orientações para vincular escola via Configurações (INEP).

- **Admin sem escola ativa**
  - Mostrar seletor de cidade/escola.

- **Carregando**
  - Exibir spinner centralizado.

---

## 4. Conexões com Outras Features

- **Minhas Turmas**
  - `ClassManagement` (painel escolar) e `ClassManager` (aba do professor) devem convergir para a mesma tabela `classes` e `school_students`.

- **PDI/DUA**
  - `StudentManagement` e `StudentPDIProfile` dependem de `school_students` e vínculos corretos com turmas.

- **Planejamento / Avaliações**
  - O contexto de escola/turmas deve estar alinhado com as turmas usadas nessas features.

---

## 5. Erros, Estados e Mensagens

- Falhas em qualquer serviço (`SchoolService`, `getStudentsBySchool`, `getClassesBySchool`, etc.):
  - Devem ser logadas no console.
  - O painel não deve exibir números enganadores (melhor mostrar 0 do que dados parciais sem aviso).

---

## 6. Checklist de Validação (para agentes/QA)

1. **Seleção de escola**
   - [ ] Gestor não-admin cai sempre na própria escola (`userProfile.school_id`).
   - [ ] Admin consegue trocar escola apenas pelas listas de cidade/escolas.

2. **Métricas**
   - [ ] Contadores (professores, turmas, alunos) batem com os dados carregados.

3. **Escopo**
   - [ ] Todas as consultas de professores/turmas/alunos usam `activeSchoolId` (resolvido).

