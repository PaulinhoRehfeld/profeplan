### PRD – Núcleo Planejamento + Minhas Turmas + PDI (`planejamento-turmas-pdi`)

#### 1. Visão geral

- **Produto**: PROFEPLAN – plataforma de planejamento pedagógico com foco em inclusão.
- **Núcleo desta feature**:
  - **Minhas Turmas & Gestão de Alunos**
  - **PDI / Inclusão**
  - **Planejamento (Trimestral + Aulas)**
- **Objetivo**: garantir um fluxo consistente onde:
  1. O professor/gestor tem turmas e alunos corretamente cadastrados (com códigos oficiais).
  2. Planejamentos trimestrais e aulas são gerados a partir de BNCC/PNLD reais.
  3. O PDI utiliza dados fiéis dos alunos e das aulas para gerar e registrar adaptações.

---

#### 2. Problema e oportunidades

- **Problema atual**:
  - Dados de turmas/alunos podem ser inconsistentes se o parser SIMADE ou a persistência não respeitarem `student_code` e `call_number`.
  - Planejamento pode ficar “descolado” da realidade se não estiver sempre baseado em BNCC/PNLD + contexto de turma.
  - PDI depende fortemente da qualidade desses dados; qualquer quebra na cadeia Turma → Aluno → Planejamento → PDI gera risco pedagógico e de confiança no produto.

- **Oportunidade**:
  - Consolidar este núcleo como **backbone pedagógico** da plataforma, com:
    - fluxo robusto de importação de dados,
    - planejamento rigoroso,
    - PDI eticamente controlado e rastreável.

---

#### 3. Escopo (IN / OUT)

- **IN (escopo desta feature)**:
  - Importação de turmas e alunos via PDF SIMADE (incluindo número de chamada e código oficial do aluno).
  - CRUD básico de turmas e exibição consolidada de alunos.
  - Planejamento trimestral (TermPlan) + geração/edição de aulas (Lesson).
  - Geração e manutenção de documentos PDI por aluno e ano letivo.
  - Integração lógica entre:
    - `classes` ↔ `students` ↔ `pdi_documents` ↔ `lessons`.

- **OUT (fora de escopo imediato)**:
  - Relatórios avançados de avaliação.
  - Gestão de arquivos gerais (Meus Arquivos).
  - Simulados ENEM/Saeb (tratados em outro módulo).
  - Qualquer refatoração de FREEDAY / assistente global.

---

#### 4. Usuários e personas

- **Professor Regente**:
  - Importa turmas e alunos.
  - Planeja trimestre e aulas.
  - Gera e usa PDIs para alunos com necessidades específicas.

- **Professor de Apoio / Inclusão**:
  - Consulta PDIs, acompanha adaptações e logs.
  - Colabora em ajustes de planejamento e relatórios.

- **Gestor Escolar**:
  - Visualiza panorama de turmas, alunos com PDI, planejamento em andamento.

---

#### 5. Modelo de dados (resumo)

- **`classes`**:
  - `id`, `user_id`/`teacher_id`, `name`, `year`, `shift`, `grade`, `subject`, `school_id?`.
- **`students`**:
  - `id`, `class_id`, `name`,
  - `student_code` (código oficial, ex. SIMADE),
  - `call_number` (número de chamada),
  - `current_school_id`,
  - `needs_adaptation`, `deficiencies[]`,
  - `pedagogical_observations` / `observations`.
- **`pdi_documents`**:
  - `id`, `student_id → students(id) ON DELETE CASCADE`,
  - `year INT`, `status` (`em_andamento`, `finalizado`, `arquivado`),
  - `content_data JSONB` (blocos 1–8 etc.), `block_9_content`, `block_10_entries`, `final_report`.
- **`term_plans`** (conceito `TermPlan`):
  - `id`, `period`, `regime`, `subject`, `grade`, `level`,
  - `workloadWeekly`, `totalClasses`, `gradingGrid`,
  - `stateBase`, `educationSphere`,
  - `generatedText`, `lessons?`.
- **`lessons`**:
  - `id`, `user_id`, `class_id?`, `term_plan_id?`,
  - `topic/title`, `content`, `bncc[]`, `canva_json`, `created_at`.

---

#### 6. Principais fluxos

##### 6.1. Importação de Turmas & Alunos (SIMADE)

- **Entrada**: PDF SIMADE.
- **Processo**:
  1. Extração de texto do PDF.
  2. `parseClassListFromText`:
     - regex para linhas `"N CODIGO NOME..."` → `{ call_number, student_code, name }`.
     - fallback via IA com pós-processamento determinístico.
  3. `ImportProcess` exibe `ParsedClassData` para confirmação.
  4. `saveClassStructure`:
     - cria registro em `classes`,
     - insere alunos em `students` com:
       - `class_id`, `name`, `student_code`, `call_number`, `current_school_id`, `pedagogical_observations`, `needs_adaptation`.

- **Saída**:
  - Turma cadastrada em `classes`.
  - Alunos cadastrados em `students` com códigos e números de chamada corretos.

##### 6.2. Planejamento Trimestral + Aulas

- **Entrada**:
  - Disciplina, série, período, BNCC/PNLD, contexto de rede (`stateBase`, `educationSphere`).

- **Processo**:
  1. `TermPlanningManager` cria/edita `TermPlan`.
  2. `AiPlanningService` usa BNCC/PNLD + parâmetros para gerar:
     - texto de planejamento (`generatedText`),
     - `lessons` sugeridas com objetivos e BNCC.
  3. Usuário revisa/edita `lessons` em UI de planejamento.
  4. `lessons` são persistidas em `lessons` (ligadas ao `TermPlan` e, quando aplicável, a `classes`.

- **Saída**:
  - Trimestre planejado com conjunto coerente de aulas, rastreáveis por BNCC e período.

##### 6.3. PDI / Inclusão

- **Entrada**:
  - Aluno com `needs_adaptation = true` ou `observations` relevantes em `students`.
  - Planejamento de aula/ trimestre.

- **Processo**:
  1. `getStudentInclusionSnapshot` monta:
     - `needsAdaptation`, `deficiencies`, `observations` a partir de `students`.
  2. `PdiDocumentService.getOrCreatePdi(studentId, year)`:
     - busca ou cria `pdi_documents` (`student_id`, `year`, `status='em_andamento'`).
  3. `AiPdiService.generateStudentAdaptation` usa:
     - aula original (texto),
     - snapshot de inclusão,
     - contexto BNCC, estado/esfera.
  4. Adaptações são salvas em `pdi_documents` (Bloco 9, registros, logs).

- **Saída**:
  - PDI estruturado por aluno/ano, com adaptações de aula rastreáveis.

---

#### 7. Requisitos funcionais (principais)

- **RF1 – Importação SIMADE confiável**
  - Deve extrair e persistir `student_code` e `call_number` para todos os alunos onde o PDF fornecer essas informações.

- **RF2 – Gestão de Turmas & Alunos**
  - Listar turmas do usuário, com contadores de alunos.
  - Exibir alunos por turma com:
    - nome,
    - número de chamada,
    - código do aluno,
    - indicadores de inclusão (badge, `needs_adaptation`).

- **RF3 – Planejamento Trimestral**
  - Criar e editar `TermPlan` por disciplina/série/período.
  - Gerar `lessons` estruturadas a partir das decisões de planejamento.

- **RF4 – PDI por aluno/ano**
  - Criar/obter PDI único por (`student_id`, `year`, `status='em_andamento'`).
  - Permitir registrar adaptações de aula (Bloco 9) e avaliações (Bloco 10) com histórico.

- **RF5 – Integração Planejamento ↔ PDI**
  - Para alunos com PDI ativo, oferecer caminho para gerar adaptação de aula imediatamente após salvar planejamento.

---

#### 8. Requisitos não-funcionais / guardrails

- **RNF1 – Anti-alucinação BNCC/PNLD**
  - Planejamento e PDI **não podem inventar** códigos de habilidades; devem usar RAG + base oficial.

- **RNF2 – Ética e privacidade no PDI**
  - IA não pode inventar diagnósticos; apenas usar textos/necessidades já descritos por profissionais.

- **RNF3 – Rastreabilidade**
  - Toda adaptação de aula deve apontar:
    - aluno (`student_id`),
    - PDI (`pdi_document_id`),
    - aula ou planejamento de origem (`lesson_id` ou equivalente).

- **RNF4 – Integridade de dados**
  - `student_code` e `call_number` nunca devem ser sobrescritos silenciosamente por valores vazios.

---

#### 9. Critérios de aceite (alto nível)

- **CA1 – Importação SIMADE**
  - Dado um PDF válido do SIMADE,
    quando o professor importar a turma,
    então todos os alunos devem aparecer em `ClassDetail` com:
    - nome correto,
    - número de chamada correto,
    - código de aluno igual ao do PDF.

- **CA2 – Planejamento Trimestral**
  - Dado um TermPlan criado para uma disciplina/série/período,
    quando o professor abrir o planejamento,
    então ele deve ver uma sequência de `lessons` com:
    - títulos coerentes,
    - objetivos claros,
    - códigos BNCC válidos.

- **CA3 – PDI / Adaptação de Aula**
  - Dado um aluno com `needs_adaptation = true` e planejamento de aula gerado,
    quando o professor solicitar adaptação PDI para aquela aula,
    então o sistema deve gerar um texto de adaptação:
    - utilizando `deficiencies` e `observations` do aluno,
    - referenciando o conteúdo da aula,
    - sem criar diagnósticos clínicos.

