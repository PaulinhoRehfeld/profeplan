### Módulo Planejamento (Trimestral, Aulas Semanais e Diárias)

#### 1. Propósito do módulo

- **Objetivo principal**: organizar o ciclo completo de planejamento pedagógico, ligando:
  - **[IMPLEMENTADO PARCIAL]** Planejamento Trimestral (TermPlan),
  - **[IMPLEMENTADO PARCIAL]** Planos de Aula Semanais/Diários,
  - **[IMPLEMENTADO PARCIAL]** BNCC/PNLD via serviços de IA,
  - **[IMPLEMENTADO]** Turmas e Alunos (Módulo Minhas Turmas),
  - **[IMPLEMENTADO PARCIAL]** PDI/Inclusão (adaptações derivadas dos planos).

- **O que este módulo resolve**:
  - **[IMPLEMENTADO PARCIAL]** Criação guiada de planejamento Trimestral com apoio da IA (TermPlanningManager + AiPlanningService).
  - **[IMPLEMENTADO PARCIAL]** Geração de aulas sequenciais a partir do trimestre (Lesson[]).
  - **[IMPLEMENTADO PARCIAL]** Visualização/edição dos planos gerados em telas de planejamento.
  - **[TODO]** Exposição totalmente padronizada desse planejamento para avaliações e relatórios.

---

#### 2. Escopo funcional

- **Planejamento Trimestral**:
  - **[IMPLEMENTADO PARCIAL]** Definir período (`period`), série (`grade`), disciplina (`subject`), regime, etc.
  - **[IMPLEMENTADO PARCIAL]** Gerar `lessons` com título, objetivos, habilidades BNCC, descrição.
  - **[TODO]** Garantir persistência estruturada de todas as `lessons` ligadas ao TermPlan (não só texto solto).

- **Planos de Aula Semanais / Diários**:
  - **[IMPLEMENTADO PARCIAL]** Detalhar aula a aula a partir do TermPlan (PlanningManager e derivados).
  - **[TODO]** Padrão único de campos por aula (objetivos, conteúdos, atividades, avaliação) documentado em types + DB.

- **Integrações**:
  - **[IMPLEMENTADO PARCIAL]** BNCC/PNLD via RAG/IA (ver `fluxos-criticos-e-guardrails.md` – Módulo 3 e 4).
  - **[IMPLEMENTADO]** Turmas (ligação a `classes` e `lessons` pela `class_id`).
  - **[TODO]** Integração formalizada com PDI (chamada sistemática para gerar Bloco 9 a partir das aulas).

---

#### 3. Modelo de dados

##### 3.1. Planejamento Trimestral (`TermPlan` e tabela correspondente)

- **Tipo `TermPlan` (`types.ts`)**:
  - **[IMPLEMENTADO]** Estrutura TS com:
    - `id`, `period`, `regime`, `subject`, `grade`, `level`,
    - `workloadWeekly`, `reserves`, `totalClasses`, `gradingGrid`,
    - `stateBase`, `educationSphere`,
    - `generatedText`, `lessons?`, `created_at`, `pnld_book_id?`.

- **Tabela de apoio (ex.: `term_plans`)**:
  - **[PARCIAL]** Existe suporte para salvar planejamentos (via serviços/IA), mas o mapeamento 100% 1:1 `TermPlan ↔ tabela` ainda merece revisão e documentação detalhada.

##### 3.2. Aulas (`Lesson` e tabela `lessons`)

- **Tipo `Lesson` (`types.ts`)**:
  - **[IMPLEMENTADO]** `number`, `title`, `description`, `objectives[]`, `bncc[]`, `content?`.

- **Tabela `lessons` (via `supabaseService`)**:
  - **[IMPLEMENTADO PARCIAL]** Campos básicos (`user_id`, `topic`, `content`, `class_id`, `canva_json`, etc.).
  - **[TODO]** Garantir ligação explícita com `TermPlan` (ex.: `term_plan_id`) e com BNCC/period, e documentar isso aqui.

---

#### 4. Serviços e componentes envolvidos

##### 4.1. Serviços de planejamento

- **`AiPlanningService`**:
  - **[IMPLEMENTADO PARCIAL]** Usa `subject`, `grade`, `period` e contexto BNCC para gerar planejamento (inclusive com mensagens de log).
  - **[TODO]** Documentar formalmente as entradas/saídas (especialmente o formato de `lessons`) e garantir que não haja alucinação de códigos BNCC/PNLD.

- **`PlanningOrchestrator`**:
  - **[IMPLEMENTADO PARCIAL]** Orquestra geração de planejamento trimestral com IA.
  - **[TODO]** Garantir que todo fluxo passe por aqui (e não por chamadas soltas de IA em componentes).

- **`supabaseService`**:
  - **[IMPLEMENTADO PARCIAL]** Salva aulas em `lessons` (`saveLessonToMemory`, `getLessons`).
  - **[TODO]** Completar a ligação entre TermPlan ↔ lessons na camada de dados.

##### 4.2. Componentes React

- **`TermPlanningManager`**:
  - **[IMPLEMENTADO]** UI para criar/editar TermPlan, selecionar período/série/disciplina, disparar IA.

- **`PlanningManager` / `PlanningCockpit`**:
  - **[IMPLEMENTADO PARCIAL]** UI para visualizar/refinar planejamento e aulas.
  - **[TODO]** Padronizar a forma de edição de aulas para refletir o modelo de dados (`Lesson`).

- **Outros**:
  - **[PARCIAL]** `SimulationWorkspace`, `CleanChat` etc. interagem com o planejamento, mas ainda não estão 100% documentados como parte oficial do fluxo.

---

#### 5. Fluxos críticos

##### 5.1. Criar Planejamento Trimestral

- **Estado atual**:
  - **[IMPLEMENTADO PARCIAL]** Seleção de `grade`, `subject`, `period` e disparo de IA funcionam.
  - **[TODO]** Checklist formal (Given/When/Then) para garantir:
    - uso explícito de BNCC/PNLD do estado/esfera,
    - salvamento consistente de TermPlan + lessons.

##### 5.2. Gerar Planos de Aula a partir do Trimestre

- **Estado atual**:
  - **[IMPLEMENTADO PARCIAL]** Geração de `lessons` e visualização/edição por UI.
  - **[TODO]** Garantir que todas as lições geradas sejam persistidas de forma estruturada (não só texto), com BNCC/periodo associados.

##### 5.3. Integração com PDI (Adaptações a partir do Planejamento)

- **Estado atual**:
  - **[IMPLEMENTADO PARCIAL]** Já existe integração conceitual (Bloco 9 do PDI usa conteúdo de aula + contexto do aluno).
  - **[TODO]** Amarrar este fluxo explicitamente ao Módulo Planejamento (por exemplo, sempre que aula é salva/atualizada, oferecer gatilho para adaptações).

---

#### 6. Guardrails (OBRIGATÓRIO / PROIBIDO)

- **OBRIGATÓRIO**:
  - **[IMPLEMENTADO PARCIAL]** Utilizar BNCC/PNLD reais para habilidades (já descrito em `fluxos-criticos-e-guardrails.md` – Módulo 3/4).
  - **[PARCIAL]** Manter vínculo forte entre TermPlan ↔ lessons ↔ turmas ↔ PDI/avaliações (já existe, mas precisa ser consolidado em doc e tipos).

- **PROIBIDO**:
  - **[IMPLEMENTADO EM DOC, A VERIFICAR EM CÓDIGO]** Substituir arquitetura multi-agentes + RAG por um único prompt genérico para planejamento.
  - **[TODO]** Garantir via testes/lógicas de serviço que nenhuma rota “atalho” faça isso.

---

#### 7. Checklist rápido para agentes / devs

- [ ] Confirmar se a tabela de planejamentos (`term_plans` ou equivalente) está 1:1 com `TermPlan` (TS).  
- [ ] Garantir que `AiPlanningService` sempre usa BNCC/PNLD reais e registra período/ano/serie corretamente.  
- [ ] Verificar se todas as `lessons` geradas estão sendo persistidas com vínculo claro ao planejamento e à turma.  
- [ ] Garantir que o PDI (Bloco 9) sempre consome aula original + contexto do aluno (nunca um texto “solto”).  
- [ ] Atualizar este documento e `fluxos-criticos-e-guardrails.md` a cada mudança estrutural em TermPlan/lessons.

