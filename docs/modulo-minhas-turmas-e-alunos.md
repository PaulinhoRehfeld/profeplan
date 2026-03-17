### Módulo Minhas Turmas & Gestão de Alunos

#### 1. Propósito do módulo

- **Objetivo principal**: Ser o **centro de verdade operacional** sobre:
  - quais **turmas** o professor/gestor tem sob responsabilidade;
  - quais **alunos** existem em cada turma;
  - quais dados escolares mínimos sustentam PDI, planejamento e avaliação.

- **O que este módulo resolve**:
  - **[IMPLEMENTADO]** Importação de turmas e alunos a partir de PDFs do **SIMADE** (via `ImportProcess` + `AiUtilityService.parseClassListFromText`).
  - **[IMPLEMENTADO]** Listagem de turmas do professor (via `ClassManager` + serviços Supabase).
  - **[IMPLEMENTADO]** Exclusão de turmas afetando banco + cache local (`deleteClass` em `supabaseService` + `deleteLocalClass`).
  - **[IMPLEMENTADO PARCIAL]** Visualização da lista de alunos (nome, número de chamada, código, com coluna extra em `ClassDetail`).
  - **[TODO]** Edição de dados de alunos (nome, observações) diretamente pela UI de turma.

- **O que este módulo NÃO faz**:
  - Não define diagnósticos ou laudos.
  - Não gerencia perfil do professor ou da escola (isso está em Configurações/Perfil, já desacoplado da tabela `schools`).
  - Não implementa lógica de PDI (usa apenas como fonte de dados para outros módulos).

---

#### 2. Escopo funcional

- **Funcionalidades centrais**:
  - **[IMPLEMENTADO]** Importar uma nova turma via PDF “padrão SIMADE”.
  - **[IMPLEMENTADO]** Listar todas as turmas do professor/gestor na tela “Minhas Turmas”.
  - **[IMPLEMENTADO]** Exibir detalhes de uma turma: lista de alunos, incluindo:
    - Nome,
    - Número de chamada,
    - Código do aluno (coluna adicionada em `ClassDetail`),
    - **[PARCIAL]** Observações (já existem no modelo de dados / parser, mas nem sempre expostas ou editáveis na UI).
  - **[IMPLEMENTADO]** Excluir turmas com chamada ao Supabase (`deleteClass`) + atualização de cache local.
  - **[TODO]** Fluxos de edição manual de alunos (ex.: corrigir nome, ajustar observações) com regras claras.

- **Principais usuários**:
  - Professores (visão de suas turmas).
  - Gestores (visão consolidada, conforme regras de permissão a definir/documentar com mais detalhes).

---

#### 3. Modelo de dados

##### 3.1. Tabelas de turmas e alunos

> **[PARCIAL]** A estrutura abaixo reflete a intenção arquitetural e o que já sabemos das migrations e serviços; sempre validar com as migrations reais.

- **Tabela de turmas** (ex.: `classes` ou equivalente):
  - **[IMPLEMENTADO]** `id UUID PRIMARY KEY`
  - **[IMPLEMENTADO]** `teacher_id UUID` (perfil/professor, usado indiretamente nas queries)
  - **[IMPLEMENTADO]** `name TEXT` / `class_name TEXT` (nome da turma)
  - **[IMPLEMENTADO]** `year INT` (ano letivo)
  - **[IMPLEMENTADO]** `shift TEXT` / `turno TEXT` (ex.: manhã, tarde, noite)
  - **[PARCIAL]** Outros campos como `grade` / `serie`, `discipline` — suportados/extraídos na importação, mas ainda não 100% padronizados em doc.
  - **[PARCIAL]** `school_name TEXT` pode existir e ser derivado do perfil, não mais da tabela `schools`.

- **Tabela `students`** (campos relevantes para este módulo):
  - **[IMPLEMENTADO]** `id UUID PRIMARY KEY`
  - **[IMPLEMENTADO]** `class_id UUID REFERENCES classes(id)` (há uma migration para a relação aluno ↔ turma; validar se tem `ON DELETE CASCADE`)
  - **[IMPLEMENTADO]** `name TEXT NOT NULL`
  - **[IMPLEMENTADO]** `student_code TEXT` (já previsto e agora preenchido pelo fluxo SIMADE)
  - **[IMPLEMENTADO]** `call_number INTEGER` (migration `20260317_add_call_number_to_students.sql`)
  - **[PARCIAL]** `observations TEXT` / `pedagogical_observations TEXT` (campos existentes e usados em snapshots e PDI, mas nem sempre expostos na UI de turma)
  - **[IMPLEMENTADO]** `needs_adaptation BOOLEAN`, `deficiencies TEXT[]` (migrations alinhadas com PDI)

##### 3.2. Tipos TypeScript principais

- **Aluno (`Student` ou equivalente)**:
  - **[PARCIAL]** Já existe um tipo consolidado, mas precisa ser checado contra o schema para garantir 1:1 em:
    - `student_code`,
    - `call_number`,
    - `observations`/`pedagogical_observations`,
    - campos de inclusão.
- **Aluno importado de SIMADE (`ParsedStudent`)**:
  - **[IMPLEMENTADO]** Já foi ajustado em `ImportProcess` / `AiUtilityService` para:
    - `{ name: string; student_code?: string; call_number?: number; observations?: string }`
  - **[TODO]** Garantir que não existam versões antigas baseadas apenas em `string`.
- **Turma (`Class` ou equivalente)**:
  - **[PARCIAL]** Estrutura está em uso em `ClassManager`, mas merece revisão para alinhar com migrations (ano, turno, disciplina, etc.).

---

#### 4. Serviços e componentes envolvidos

##### 4.1. Serviços de backend/frontend

- **`supabaseService`**:
  - **[IMPLEMENTADO]** Funções para:
    - listar turmas e alunos,
    - **deletar turma no banco** (`deleteClass`),
    - gravar dados vindos da importação.
  - **[TODO]** Centralizar em uma única função “oficial” a leitura de alunos por `class_id` para evitar duplicação.

- **`studentService`**:
  - **[IMPLEMENTADO PARCIAL]** Funções relacionadas a alunos (ex.: `getStudentInclusionSnapshot`).
  - **[TODO]** Consolidar aqui a função “listar alunos por turma”, se ainda não estiver centralizada.

- **`AiUtilityService.parseClassListFromText`**:
  - **[IMPLEMENTADO]** Parser com:
    - prompt orientando a IA a gerar objetos de alunos,
    - pós-processamento determinístico (`regex ^(\d+)\s+(\d+)\s+(.+)$`) para extrair `call_number` e `student_code` de linhas SIMADE.

##### 4.2. Componentes React

- **`ClassManager`**:
  - **[IMPLEMENTADO]** Tela principal:
    - lista turmas,
    - integra exclusão com Supabase (`deleteClass`) + local,
    - abre fluxo de importação.
- **`ClassManager/ImportProcess`**:
  - **[IMPLEMENTADO]** Fluxo:
    - upload de PDF,
    - invocação do parser de IA,
    - pré-visualização com novos tipos `ParsedClassData` / `ParsedStudent`,
    - gravação final.
- **`ClassManager/ClassDetail`**:
  - **[IMPLEMENTADO PARCIAL]**:
    - exibindo tabela de alunos com:
      - Nome,
      - Número de chamada,
      - **Código** (usando `student_code` ou `state_unique_id` com fallback),
    - ajuste de `colspan` para a nova coluna.
  - **[TODO]** Expor/editar observações diretamente nesta tela (quando for decisão de produto).

---

#### 5. Fluxos críticos

##### 5.1. Importar turma e alunos via PDF (SIMADE)

1. **[IMPLEMENTADO]** Usuário envia o PDF da listagem de turma.
2. **[IMPLEMENTADO]** Front extrai texto e chama `AiUtilityService.parseClassListFromText`.
3. **[IMPLEMENTADO]** Serviço:
   - usa IA + regex para extrair dados da turma e alunos:
     - `call_number`,
     - `student_code`,
     - `name`,
     - e, quando possível, `observations`.
4. **[IMPLEMENTADO]** `ImportProcess` mostra pré-visualização com types ricos (`ParsedClassData`, `ParsedStudent`).
5. **[IMPLEMENTADO PARCIAL]** Serviço de salvamento cria turma e insere alunos:
   - já grava os alunos em `students`,
   - precisa ser auditado para garantir que **nenhum campo importante** é descartado.

- **OBRIGATÓRIO**:
  - **[TODO – AUDITAR]** Verificar ponta a ponta se `student_code` e `call_number` estão chegando corretamente na tabela `students`.
  - **[TODO]** Logar casos em que a linha SIMADE contém padrão de código mas o objeto final está sem `student_code`.

##### 5.2. Listar e gerenciar turmas

1. **[IMPLEMENTADO]** `ClassManager` chama serviços Supabase para listar turmas.
2. Usuário:
   - visualiza turmas,
   - seleciona turma,
   - pode remover turma (delete).
3. **[IMPLEMENTADO]** Exclusão de turma chama:
   - `deleteClass(id)` (Supabase),
   - `deleteLocalClass(id)` (cache local),
   - recarrega lista de turmas.

- **OBRIGATÓRIO**:
  - **[TODO – DECISÃO]** Documentar/comprovar se a deleção de turma apaga alunos em cascata ou se há bloqueios (especialmente quando existir PDI vinculado).

##### 5.3. Exibir e manter a lista de alunos de uma turma

1. **[IMPLEMENTADO PARCIAL]** `ClassDetail` usa serviço para obter lista de alunos (nome, código, etc.).
2. Tabela exibe:
   - Nome,
   - Número de chamada (`call_number`),
   - Código do aluno (`student_code` ou `state_unique_id` com fallback),
   - **[PARCIAL]** Observações (a depender de implementação atual).

- **OBRIGATÓRIO**:
  - **[IMPLEMENTADO]** Manter a coluna de código visível (já existe).
  - **[TODO]** Centralizar a função de “listar alunos por turma” num único serviço.

---

#### 6. Guardrails (OBRIGATÓRIO / PROIBIDO)

- **OBRIGATÓRIO**:
  - **[PARCIAL]** Manter alinhamento 1:1 entre:
    - tabela `students`,
    - tipos TS de aluno (`Student`, `ParsedStudent`).
  - **[IMPLEMENTADO]** Deletar turma tanto no Supabase quanto no cache local.
  - **[PARCIAL]** Ao alterar schema de `students`, atualizar:
    - este documento,
    - doc do Módulo PDI,
    - serviços (`studentService`, `PdiDocumentService`, `AiPdiService`).

- **PROIBIDO**:
  - **[IMPLEMENTADO]** Voltar a acoplar Perfil/Configurações à tabela `schools` para nome da escola (já foi removido).
  - **[TODO/GUARDRAIL]** Apagar ou sobrescrever `student_code` e `call_number` de forma silenciosa.
  - Implementar lógica de PDI aqui dentro (deve permanecer separado, consumindo este módulo).

---

#### 7. Integração com outros módulos

- **Módulo PDI / Inclusão**:
  - **[IMPLEMENTADO PARCIAL]** Já consome:
    - `needs_adaptation`, `deficiencies`, `observations` via `getStudentInclusionSnapshot`.
  - **[OBRIGATÓRIO]** Qualquer alteração nesses campos em `students` precisa ser refletida também em:
    - `docs/modulo-pdi-inclusao.md`,
    - serviços de PDI e de IA.

- **Módulo Planejamento**:
  - **[TODO]** Especificar uso de dados de turma/aluno para organização de planos.

- **Módulo Avaliação / Relatórios**:
  - **[TODO]** Documentar integração futura baseada em turmas + alunos.

---

#### 8. Checklist rápido para agentes / devs

- [ ] Conferir schema de turmas e `students` nas migrations e alinhar com este documento.  
- [ ] Garantir que tipos TS de `Student` e `ParsedStudent` reflitam `student_code`, `call_number`, observações e campos de inclusão.  
- [ ] Auditar fluxo de importação SIMADE ponta a ponta para assegurar que `student_code` e `call_number` chegam na tabela `students`.  
- [ ] Verificar se `ClassManager` e `ClassDetail` usam funções de serviço centralizadas para listar turmas e alunos.  
- [ ] Atualizar este documento e o módulo PDI sempre que o schema de `students` mudar.

