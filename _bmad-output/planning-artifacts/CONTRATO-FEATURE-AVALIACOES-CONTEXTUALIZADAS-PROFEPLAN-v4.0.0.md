---
feature: "Avaliações Contextualizadas"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Avaliações Contextualizadas (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Permitir que o professor crie **avaliações oficiais contextualizadas** que:

- Reflitam o que foi **efetivamente trabalhado** em:
  - Planejamentos Trimestrais (TermPlans),
  - Planos de Aula / Aulas registradas,
  - Simulados e Banco ENEM/SAEB (~17.000 questões reais).
- Combinar **questões inéditas** (IA) com **questões reais ENEM/SAEB**.
- Mantenham rastreabilidade entre **avaliação ↔ turma ↔ aulas ↔ simulados**.

---

## 2. Entidades e Contexto Técnico

- **Turmas**
  - Obtidas em `AssessmentSetup` via:
    - Supabase (`getClasses(userId)` em `supabaseService`),
    - Fallback: `getLocalClasses(userId)` (localStorage).
  - Campos relevantes:
    - `id`, `name`, `subject`, `students[]`.

- **Aulas / Planos de Aula**
  - Obtidas em `AssessmentSetup` via:
    - `getLessons(userId)` (Supabase),
    - Fallback: `getLocalLessons(userId)`.
  - Campos relevantes:
    - `id`, `class_id`, `topic`, `content`, `created_at`.
  - **Smart Filter**:
    - Filtra aulas por:
      - `class_id` da turma selecionada,
      - Série/ano inferidos do nome da turma,
      - Disciplina (`subject`) no texto da aula.

- **Planejamento Trimestral (TermPlan) – alvo do contrato**
  - Embora o código atual de `AssessmentSetup` ainda não consuma diretamente `TermPlan`, o contrato prevê:
    - Possibilidade de recuperar aulas a partir:
      - De um TermPlan selecionado (via `PlanningContext` / `PlanningDAL`),
      - Ou da ligação entre aulas e termos (futuro vínculo mais forte).

- **Simulados / Banco ENEM/SAEB**
  - Banco:
    - Tabela `enem_questions` com ~17.000 questões.
  - Serviços:
    - `searchQuestions(query)` em `questionService.ts`.
    - `questionBank.search` e SimulationFactory (para outras telas).
  - Uso em avaliações:
    - `AssessmentSetup` integra questões ENEM reais via `searchQuestions` (modo atual).

- **Avaliação (Assessment)**
  - Tipo `Assessment` (`apps/web/src/types.ts`):
    - `id`, `title`, `questions[]`, `classId`, `className`, `subject`,
    - `createdAt`, `totalPoints`, `academicPeriod`, `difficulty`, `numEnem`.

- **Serviços de IA**
  - `AiAssessmentService.generateAssessmentWithContext`
    - Usa `getGenAIClient` (Azure OpenAI).
    - Gera JSON com título + lista de questões (objetivas/dissertativas).
  - `AiAssessmentService.gradeWrittenAnswer`
    - Corrige questões dissertativas a partir de imagem (OCR + rubrica).

---

## 3. Fluxo Principal – Criar Avaliação Contextualizada

### 3.1 Seleção de Turma e Período

**Entrada:**

- Professor escolhe:
  - Turma (`selectedClassId`),
  - Período letivo (`academicPeriod` – ex.: "1º Trimestre (P1)").

**Comportamento esperado:**

1. `AssessmentSetup`:
   - Carrega turmas do Supabase (prioridade) ou localStorage (fallback).
   - Exibe aviso se não houver turmas.
2. Selecionar turma é pré-requisito para:
   - Ver aulas disponíveis.
   - Habilitar botão "Montar Prova Contextualizada".

**Contrato:**

- Sem turma selecionada:
  - A geração deve ser bloqueada com mensagem clara: “Selecione uma turma primeiro.”.

---

### 3.2 Seleção de Aulas (Conexão com Planos de Aula)

**Entrada:**

- Professor seleciona aulas dentro da turma, que servirão de base para as questões.

**Comportamento esperado:**

1. `AssessmentSetup` chama `getLessons(userId)` (Supabase) ou `getLocalLessons(userId)`.
2. Aplica **Smart Filter**:
   - Inclui aulas:
     - Da mesma turma (`lesson.class_id === selectedClassId`),
     - Ou que contenham sinais da mesma série/ano e disciplina da turma.
3. UI permite múltipla seleção de aulas.

**Contrato:**

- As aulas usadas para gerar questões devem representar:
  - O conteúdo realmente trabalhado com aquela turma.
  - Idealmente, estarem vinculadas a um plano de aula/TermPlan (futuro fortalecimento de vínculo).

---

### 3.3 Geração de Questões Contextuais (IA)

**Entrada:**

- Lista de aulas selecionadas (`selectedLessons`),
- Parâmetros:
  - `objectiveCount`, `dissertativeCount`, `numEnem`,
  - `additionalTopics`, `academicPeriod`, `difficulty`.

**Comportamento esperado:**

1. `AssessmentSetup.handleGenerate` monta `selectedLessons` com `topic` e `content`.
2. Chama `generateAssessmentWithContext` com:
   - `className`, `subject` (da turma),
   - `lessonsContext: [{ topic, content }]`,
   - contagens e parâmetros de dificuldade/período.
3. `AiAssessmentService.generateAssessmentWithContext`:
   - Constrói `lessonsToReference` concatenando:
     - `Aula N: {topic}\nConteúdo: {content.slice(0, 500)}...`.
   - Aplica **guardrails** (`UserSettings`) se fornecidos.
   - Define instruções claras:
     - Estrutura de avaliação (objetivas/dissertativas/ENEM),
     - Formato JSON,
     - Regras técnicas (5 alternativas, gabarito, rubrica).
   - Usa Azure OpenAI para gerar o JSON.

**Contrato forte:**

- A IA deve:
  - Utilizar explicitamente o conteúdo das aulas (`lessonsContext`) como base principal.
  - Não inventar temas completamente alheios ao que foi trabalhado.
- O retorno deve ser **JSON puro** (parseável), com:
  - `title` coerente com `subject` + `academicPeriod`,
  - `questions[]` seguindo a estrutura especificada (objetivas e dissertativas).

---

### 3.4 Integração com Banco ENEM/SAEB e Simulados

**Entrada:**

- Número de questões ENEM desejadas (`numEnem` > 0).

**Comportamento esperado (estado atual):**

1. Após gerar as questões contextuais:
   - `AssessmentSetup` monta uma busca textual para ENEM:
     - `searchQuery = "{subject} {additionalTopics} {topics das aulas}"`.
2. Chama `searchQuestions(searchQuery)`:
   - Que utiliza `enem_questions` como fonte.
3. Seleciona as `numEnem` primeiras questões e mapeia para `Assessment.questions`:
   - Prefixando o enunciado com `[Questão ENEM {meta.year}]`.
   - Construindo alternativas com base em `meta.alternatives`.
   - Gabarito a partir da alternativa `isCorrect`.

**Contrato alvo (conexão com Simulados):**

- Avaliações devem poder:
  - Reusar **questões já selecionadas** em Simulados (futuro):
    - Ex.: selecionar um simulado existente como fonte adicional.
  - Ou, no mínimo, manter compatibilidade de tipos (`SimulationQuestion` ↔ questões ENEM da avaliação).

**Contrato forte:**

- Questões ENEM incluídas na avaliação **devem** vir do banco real:
  - É proibido gerar “questões estilo ENEM” via IA e rotular como ENEM verdadeiro.
- O número de questões ENEM efetivamente incluídas deve respeitar `numEnem` (ou avisar se não houver questões suficientes).

---

### 3.5 Montagem do Objeto Avaliação

**Saída:**

- Objeto `Assessment` consolidado, retornado via `onAssessmentGenerated(assessment)`.

**Campos esperados:**

- `id`: identificador único (`assessment_${Date.now()}` ou similar).
- `title`: vindo de `result.title`.
- `questions`: combinação de:
  - Questões contextuais (IA),
  - Questões ENEM reais (mapeadas).
- `classId`, `className`, `subject`: herdados da turma.
- `createdAt`: timestamp ISO.
- `totalPoints`: valor total definido pelo professor.
- `academicPeriod`, `difficulty`, `numEnem`.

**Contrato:**

- As questões devem ser coerentes com:
  - A **turma** (série, disciplina),
  - As **aulas selecionadas**,
  - O **período** informado.

---

## 4. Contratos Fortes (Invariantes)

1. **Base na prática real**
   - Avaliações **não podem** ser geradas “no vazio”:
     - Devem se basear em aulas registradas, planejamentos e/ou simulados.

2. **Disciplina e Turma**
   - A disciplina das questões deve ser coerente com `selectedClass.subject`.
   - É proibido cair em disciplinas genéricas ou erradas (ex.: História no lugar de Sociologia) por padrão.

3. **Integração com o Banco ENEM**
   - Qualquer menção a “Questão ENEM” deve corresponder a uma entrada real em `enem_questions`.

4. **Formato Estrutural**
   - O JSON retornado pela IA deve ser sempre parseável e seguir a estrutura acordada:
     - Título + lista de questões + campos obrigatórios (`options`, `correctAnswer`, `rubric` etc.).

5. **Resiliência**
   - Erros na busca ENEM não podem impedir a geração da parte contextual:
     - Devem gerar apenas um aviso: “prova gerada sem questões ENEM”.

---

## 5. Erros, Estados e Mensagens

- **Sem turma selecionada**
  - Deve exibir erro claro e não chamar `generateAssessmentWithContext`.

- **Sem aulas disponíveis**
  - Pode:
    - Permitir gerar avaliação com base apenas em `additionalTopics` (mas sinalizar claramente),
    - Ou incentivar que o professor registre aulas antes.

- **Erro da IA (Azure OpenAI)**
  - Mensagem amigável: “Não foi possível gerar a avaliação. Tente novamente.”.
  - Logar o texto bruto retornado para análise (sem quebrar UX).

- **Erro na busca ENEM**
  - Mensagem: “Aviso: Não foi possível buscar questões do banco ENEM. A prova foi gerada apenas com as questões contextuais.”.

---

## 6. Checklist de Validação (para agentes/QA)

Quando o Guardião de Avaliações ou QA revisar essa aba, deve checar:

1. **Origem dos dados**
   - [ ] Aulas usadas vêm da turma correta e representam o conteúdo trabalhado.
   - [ ] (Futuro) Vínculos com TermPlans e Planos de Aula são coerentes.

2. **Prompt de IA**
   - [ ] `generateAssessmentWithContext` inclui claramente o contexto das aulas.
   - [ ] Há instruções explícitas sobre formato JSON, número de questões e gabarito.

3. **Disciplina/Turma**
   - [ ] A avaliação gerada é coerente com a disciplina e ano da turma.

4. **Questões ENEM**
   - [ ] Toda questão marcada como ENEM vem de `enem_questions`.
   - [ ] O mapeamento para `Assessment.questions` preserva alternativas e gabarito.

5. **Resiliência**
   - [ ] Erros de IA ou ENEM não quebram a tela e produzem mensagens adequadas.

