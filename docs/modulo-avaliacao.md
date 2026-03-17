### Módulo Avaliação (Avaliações Contextualizadas + Simulados)

#### 1. Propósito do módulo

- **Objetivo principal**: gerar e organizar **avaliações alinhadas ao planejamento** e ao perfil dos alunos, garantindo:
  - coerência com o **Planejamento Trimestral / aulas**,
  - uso ético e controlado de **BNCC/PNLD**,
  - possibilidade de usar o banco de questões (ENEM/Saeb) sem alucinar conteúdo.

- **O que este módulo resolve**:
  - **[IMPLEMENTADO PARCIAL]** Simulados ENEM/Saeb baseados em banco estático de questões.
  - **[IMPLEMENTADO PARCIAL]** Avaliações inéditas contextualizadas (a partir do planejamento).
  - **[TODO]** Consolidação de relatórios de desempenho ligados a turmas, alunos e PDIs.

---

#### 2. Escopo funcional

- **Simulados ENEM/Saeb**:
  - Buscar questões por:
    - ano, disciplina, código BNCC, tags.
  - Montar provas/simulados com:
    - número de questões,
    - distribuição por dificuldade.

- **Avaliações Contextualizadas (internas)**:
  - Gerar provas e atividades avaliativas:
    - baseadas no planejamento trimestral,
    - respeitando número de questões por dificuldade,
    - com balanceamento de gabarito.

- **Relatórios**:
  - Mostrar resultados por aluno, turma, disciplina, período (futuro).

---

#### 3. Modelo de dados

##### 3.1. Banco de questões ENEM/Saeb

- **Tipo `EnemQuestion` (`types.ts`)** – **[IMPLEMENTADO]**:
  - `id: number`, `similarity?: number` (para busca vetorial).
  - `metadata`:
    - `id_original`, `year`, `discipline`/`disciplina`,
    - `context`, `alternativesIntroduction`,
    - `alternatives[]` com `letter`, `text`, `isCorrect`,
    - `bncc: string[]`, `tags: string[]`.

- **Base de dados**:
  - **[IMPLEMENTADO PARCIAL]** Índices e estruturas de embeddings já existentes (dimensão 768) para buscas.
  - Guardrail: **questões não podem ser alteradas** (ver `fluxos-criticos-e-guardrails.md` – Módulo 6).

##### 3.2. Avaliações internas

- **Tipo `Assessment` (`types.ts`)** – **[IMPLEMENTADO]**:
  - `id`, `title`, `classId?`, `className?`, `subject`,
  - `questions: AssessmentQuestion[]` (tipo também definido),
  - `createdAt`, `totalPoints`, `academicPeriod?`, `difficulty?`, `numEnem?`.

- **Banco**:
  - **[PARCIAL]** Tabelas para armazenar avaliações e respostas existem, mas precisam ser consolidadas neste doc (nomes e colunas exatos).

---

#### 4. Serviços e componentes envolvidos

- **Features de Avaliação**:
  - `features/Assessment/AssessmentManager.tsx` – **[IMPLEMENTADO PARCIAL]**:
    - gerencia criação/edição/listagem de avaliações.

- **Serviços de busca ENEM**:
  - `services/searchService.ts` – **[IMPLEMENTADO PARCIAL]**:
    - filtros por disciplina, ano, período,
    - uso de RAG/embeddings para achar questões adequadas.

- **Outros pontos**:
  - **[PARCIAL]** Integração com Planejamento (para gerar avaliações com base em planos de aula/trimestre).
  - **[TODO]** Integração direta com PDI (ex.: adaptações de itens avaliativos para alunos com PDI).

---

#### 5. Fluxos críticos

##### 5.1. Simulado ENEM/Saeb

1. Usuário seleciona:
   - disciplina, ano, tema/BNCC, número de questões.
2. Sistema:
   - busca no **banco estático de 17.000 questões**,
   - monta prova com critérios de dificuldade e cobertura de habilidades.
3. Avaliação é salva como `Assessment` (com `numEnem` e metadados).

- **OBRIGATÓRIO**:
  - **[IMPLEMENTADO EM GUARDRAIL]** Não inventar nem alterar enunciados ou alternativas.
  - **[TODO]** Garantir via código/teste que textos sempre vêm de `metadata`/banco e nunca da IA “livre”.

##### 5.2. Avaliação Contextualizada (internas)

1. A partir de um planejamento (TermPlan/lessons), o usuário aciona geração de avaliação.
2. Sistema:
   - usa conteúdo já planejado (não currículo genérico),
   - gera questões compatíveis com objetivos e BNCC daquele período.
3. Avaliação é salva como `Assessment` e ligada à turma.

- **OBRIGATÓRIO**:
  - **[PARCIAL]** Sempre usar planejamento/BNCC real como base (regra descrita nos guardrails).
  - **[TODO]** Formalizar o pipeline (planejamento → orquestrador de avaliação → `Assessment`) e documentar funções responsáveis.

##### 5.3. Relatórios de desempenho

- **Estado atual**:
  - **[PARCIAL]** Há tipos (`GradingResult`) e estruturas para correção/feedback por questão.
  - **[TODO]** Consolidar telas e serviços de relatórios (por aluno, turma, competência BNCC).

---

#### 6. Guardrails (OBRIGATÓRIO / PROIBIDO)

- **OBRIGATÓRIO**:
  - Usar **sempre** o banco oficial de questões para ENEM/Saeb (nunca IA livre para gerar ou editar enunciados).
  - Basear avaliações inéditas **no planejamento existente** (não em conhecimento genérico solto).
  - Manter balanceamento de gabarito (Regra do 2) nas provas geradas automaticamente.

- **PROIBIDO**:
  - Permitir edição automática de enunciados do banco oficial.
  - Gerar questões de alta-stakes puramente por IA sem vínculo com BNCC/planejamento.

---

#### 7. Checklist rápido para agentes / devs

- [ ] Confirmar que o pipeline de busca ENEM/Saeb **nunca** altera enunciados/alternativas.  
- [ ] Verificar que as avaliações internas são geradas **a partir** do planejamento trimestral/aulas (não de prompts genéricos).  
- [ ] Garantir que `Assessment` e `AssessmentQuestion` estão 1:1 com o schema de banco.  
- [ ] Implementar ou revisar relatórios que cruzem avaliações com turmas, alunos e períodos.  
- [ ] Atualizar este doc e `fluxos-criticos-e-guardrails.md` a cada mudança em avaliação/simulados.

