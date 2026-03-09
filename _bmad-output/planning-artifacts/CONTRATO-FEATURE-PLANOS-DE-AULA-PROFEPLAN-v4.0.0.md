---
feature: "Planos de Aula"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-05"
status: "draft"
---

# Contrato de Comportamento – Planos de Aula (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Gerar, ajustar e salvar **planos de aula individuais** alinhados a um **planejamento trimestral** previamente selecionado, garantindo:

- Disciplina correta (ex.: Sociologia, Matemática) – nunca cair em História por default.
- Vínculo explícito com:
  - Trimestre (período),
  - Série/ano,
  - Aula específica (\# da aula dentro do trimestre).
- Conteúdo pedagogicamente estruturado em Markdown, pronto para salvar, exportar e reutilizar.

---

## 2. Entidades e Contexto Técnico

- **TermPlan (planejamento trimestral)** – vindo de `GlobalPlanningContext` / Supabase:
  - Campos relevantes: `id`, `subject`, `grade`, `period`, `regime`, `lessons[]`, `pnld_book_id`.
- **Lesson (aula)** – derivada de `TermPlan.generatedText` via `parseMarkdownToLessons`:
  - `number`, `title`, `description`, `objectives`, `bncc`, `content?`.
- **GeneratedPlan (armazenamento)** – definido em `PlanningService.ts`:
  - `type` ∈ {`plano`, `material`, `exercicio`, `trimestral`, ...}
  - `folder` ∈ `PlanFolder.PLANO_AULA`, etc.
  - Salvo em `generated_contents` e opcionalmente em `lessons`.
- **Serviços chave**:
  - `PlanningCockpit` – UI e prompts para IA.
  - `PlanningManager` – roteamento, contexto e chamada de IA.
  - `AiPlanningService.generateGeminiContent` – wrapper de IA via Azure OpenAI.

---

## 3. Fluxos de Usuário – Planos de Aula

### 3.1 Selecionar Plano Trimestral

**Pré-condições:**
- Usuário autenticado (`session.userId`).
- Pelo menos um `TermPlan` existente para o usuário.

**Fluxo:**
1. Usuário abre `Planos de Aula`.
2. Seleciona um planejamento trimestral na lista (`selectedTermPlanId`).
3. O sistema:
   - Carrega `TermPlan` do contexto global.
   - Popula `parsedLessons` com as aulas desse plano.

**Contrato:**
- Sem `selectedTermPlanId`, a UI **não deve permitir** gerar Plano de Aula (deve bloquear ou exibir aviso claro).

### 3.2 Selecionar Aula

**Fluxo:**
1. Ao clicar em uma aula na lista, `selectedLesson` é definido.
2. O estado `lessonTracking` indica se já existe plano salvo para aquela aula.

**Contrato:**
- Sem `selectedLesson`, o botão **“PLANO DE AULA”** deve exibir alerta: `"Selecione uma aula primeiro!"` (já implementado em `PlanningCockpit.handleActionClick`).

### 3.3 Gerar Plano de Aula (ação principal)

**Fonte de verdade – Prompt:**
- Em `PlanningCockpit.handleActionClick('plan')`:

  - Base:
    - `[AÇÃO: PLANO DE AULA DETALHADO]`
    - `Crie um plano de aula completo para a Aula ${selectedLesson.number}: ${selectedLesson.title}.`
    - `Descrição Original: ${selectedLesson.description}`

  - Disciplina obrigatória:
    - Se `selectedPlan.subject` existir:
      - `"[DISCIPLINA OBRIGATÓRIA: ${subject.toUpperCase()}]"`
      - `O plano DEVE ser de ${subject}. O cabeçalho deve ser "PLANEJAMENTO DE ENSINO - ${subject.toUpperCase()}". NÃO use História, Geografia ou outra disciplina.`

  - Contexto de planejamento:
    - `[Planejamento: ${grade} - ${subject || 'N/A'}]`

  - PNLD (opcional):
    - `[LIVRO PNLD SELECIONADO]: ${bookTitle}`

  - Observações do professor (opcional):
    - `[OBSERVAÇÕES DO PROFESSOR]: ...`

**Roteamento:**
- `triggerSend(prompt)` → `PlanningManager.handleSendMessage(overrideInput = prompt)`:
  - **Modo `ToolMode.PLANNING`**:
    - NÃO deve ser roteado para `PlanningAuthority`/planejamento trimestral.
    - Deve chamar diretamente `generateGeminiContent(activeInput, [], context, userId, dynamicTemp)`.

**Contrato forte – o que o código NÃO pode fazer:**

- **NUNCA**:
  - Gerar um *planejamento trimestral completo* quando o fluxo é de **Plano de Aula**.
  - Substituir a disciplina de `TermPlan.subject` por um fallback genérico (“História”) ao montar o contexto da IA.
  - Rotalinear qualquer comando que contenha `"plano"`/`"aula"` em modo `ToolMode.PLANNING` para o fluxo de `PlanningAuthority.executePlanning` (isso é exclusivo de `ToolMode.QUARTERLY_PLANNING` + pedido explícito de planejamento trimestral).

**Saída esperada:**
- Resposta em Markdown contendo:
  - Cabeçalho coerente com a disciplina: `PLANEJAMENTO DE ENSINO – {DISCIPLINA}`.
  - Estrutura de plano de aula (Dados Gerais, Objetivos, Conteúdos, Metodologia, Avaliação, etc.).
- Conteúdo salvo via `savePlan` com:
  - `type: 'plano'`
  - `folder: PlanFolder.PLANO_AULA`
  - Título recomendável: `Plano – Aula ${lesson.number}`.

---

## 4. Fluxos Auxiliares da Aba

### 4.1 Material do Aluno

- Usa `handleMaterialGenerate`:
  - `[AÇÃO: MATERIAL DIDÁTICO - {RESUMO/TEXTO/EXERCÍCIOS}]`
  - `[TYPE: MATERIAL]`
  - Gera materiais vinculados à aula atual.
- Deve:
  - Não mexer em `TermPlan`.
  - Salvar como `type: 'material'`, `folder: PlanFolder.MATERIAL_ALUNO`.

### 4.2 Lista de Exercícios

- Usa `handleAssessmentGenerate`:
  - `[AÇÃO: LISTA DE EXERCÍCIOS]`
  - `[TYPE: EXERCISES]`
  - Configura ENEM, número de questões, etc.
- Salvo como:
  - `type: 'exercicio'`, `folder: PlanFolder.ATIVIDADES`.

---

## 5. Erros, Estados e Mensagens

- **Sem créditos suficientes**:
  - `savePlan` chama `checkUsageQuota(userId)`; erro deve resultar em mensagem clara ao professor e **NÃO** pode derrubar a app.
- **Erro de IA (Azure/OpenAI)**:
  - Deve ser tratado em `PlanningManager.handleSendMessage` com mensagem amigável: “Erro ao processar. Tente novamente.”
- **Falta de plano trimestral ou aula**:
  - Botões não devem disparar IA silenciosamente; devem bloquear com alerta ou desabilitar.

---

## 6. Checklist de Validação (para agentes e revisões)

Quando um agente/QA/Dev revisar o fluxo de **Planos de Aula**, deve checar:

1. **Prompt**:
   - [ ] Contém `[AÇÃO: PLANO DE AULA DETALHADO]`.
   - [ ] Se houver `TermPlan.subject`, contém `DISCIPLINA OBRIGATÓRIA` com a disciplina correta.
   - [ ] Não há nenhuma referência a planejamento trimestral amplo quando o usuário acionou apenas plano de aula.
2. **Roteamento**:
   - [ ] Em modo `ToolMode.PLANNING`, nenhum caminho dispara `PlanningAuthority.executePlanning`.
3. **Disciplina**:
   - [ ] A disciplina usada pelo modelo é a do `TermPlan` selecionado (Sociologia, etc.), nunca o fallback “História”.
4. **Persistência**:
   - [ ] O conteúdo gerado é salvo com `type: 'plano'` e `folder: PlanFolder.PLANO_AULA`.
   - [ ] A tabela `lessons` recebe somente planos de aula/trimestrais (conforme regra).
5. **UX de erro**:
   - [ ] Erros de IA e de créditos mostram mensagens claras sem recarregar a página ou entrar em loop.

