---
feature: "Planejamento Trimestral"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-05"
status: "draft"
---

# Contrato de Comportamento – Planejamento Trimestral (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Gerar, revisar e salvar **planejamentos trimestrais completos** para uma disciplina/série/período, servindo como fonte de verdade para:

- Distribuição de conteúdos ao longo do trimestre.
- Geração posterior de **Planos de Aula**, Materiais, Avaliações e Adaptações PDI/DUA.
- Alinhamento ao currículo oficial (SEE/MG, BNCC, PNLD).

---

## 2. Entidades e Contexto Técnico

- **TermPlan** (planejamento trimestral estruturado)
  - `id`, `user_id`
  - `subject`, `grade`, `level`
  - `period` (1, 2, 3), `regime` ('Trimestre')
  - `workloadWeekly`, `totalClasses`
  - `reserves` (datas reservadas)
  - `gradingGrid`
  - `stateBase`, `educationSphere`
  - `generatedText` (Markdown com aulas) e `lessons[]` (estruturado)

- **Orquestração**
  - `PlanningAuthorityService`
  - `PlanningOrchestrator`
  - `AiPlanningService` (Azure OpenAI)
  - `CreditManager`, `PlanningDAL`, `EventBus`

---

## 3. Fluxo Principal – Criar/Atualizar Planejamento Trimestral

### 3.1 Entrada

- Origem: aba **Planejamento Trimestral** (`ToolMode.QUARTERLY_PLANNING`).
- Inputs:
  - Disciplina, Série/Ano, Nível.
  - Trimestre (1, 2, 3).
  - Carga horária semanal, reservas, grade de avaliação.
  - Opcional: livro PNLD, preferências pedagógicas.

### 3.2 Orquestração

1. UI coleta dados e monta a intenção de planejamento.
2. `PlanningAuthority` valida:
   - Escopo (Fundamental II / Médio).
   - Série/ano válidos.
   - Presença de currículo base.
3. `PlanningOrchestrator.executeTermPlanning`:
   - Passa pelo `CreditManager` (se aplicável).
   - Usa `PlanningDAL` para buscar currículo e PNLD.
   - Chama `AiPlanningService.generateTermPlan` com contexto consolidado.

### 3.3 Saída Esperada

- Planejamento trimestral em Markdown com:
  - Visão geral do trimestre.
  - Lista/Tabela de aulas: `Aula 1... Aula N` com título, descrição e carga horária.
- Registro persistido em:
  - `term_plans` (dados estruturados).
  - `generated_contents` com `type: 'trimestral'`.

---

## 4. Contratos Fortes (Invariantes)

1. **Modo Correto**
   - Solicitações de planejamento trimestral **devem** ocorrer apenas em `ToolMode.QUARTERLY_PLANNING`.
   - Em outros modos, nenhum fluxo pode chamar `executeTermPlanning` automaticamente.

2. **Disciplina e Série**
   - A disciplina usada no planejamento deve ser exatamente a informada pelo professor (ex.: Sociologia).
   - É proibido qualquer fallback silencioso para “História” ou outra disciplina.

3. **Período**
   - `period` ∈ {1, 2, 3} e `regime` = 'Trimestre'.
   - O texto gerado deve mencionar explicitamente o trimestre correspondente.

4. **Segurança de Dados**
   - Um planejamento salvo não pode ser sobrescrito por outro usuário.
   - Atualizações mantêm o vínculo com `user_id`, `subject`, `grade` e `period`.

---

## 5. Erros e Mensagens

- Falha de IA (Azure OpenAI):
  - Mensagem amigável para o professor, sem travar a UI.
- Falta de créditos:
  - Bloqueio claro com texto explicando como proceder.
- Falta de currículo base:
  - Professor informado de que aquele nível/disciplina ainda não possui cobertura total.

---

## 6. Checklist de Validação (para agentes/QA)

1. **Contexto**
   - [ ] Requisição vem da aba Planejamento Trimestral.
   - [ ] `subject`, `grade` e `period` estão preenchidos.
2. **Roteamento**
   - [ ] Fluxo passa por `PlanningAuthority` + `PlanningOrchestrator`.
3. **Persistência**
   - [ ] Registro criado/atualizado em `term_plans`.
   - [ ] Conteúdo salvo em `generated_contents` com `type: 'trimestral'`.
4. **Disciplina**
   - [ ] Texto gerado usa a disciplina correta (ex.: Sociologia).
5. **UX**
   - [ ] Em caso de erro, a tela não entra em loop nem recarrega automaticamente.

