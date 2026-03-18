---
title: 'Epic 3 - Planejamento Trimestral Alinhado à BNCC/PNLD'
type: 'feature'
created: '2026-03-17'
status: 'draft'
context:
  - 'docs/prd-planejamento-turmas-pdi.md'
  - 'docs/arquitetura-geral-profeplan.md'
  - 'docs/fluxos-criticos-e-guardrails.md'
---

# Epic 3 - Planejamento Trimestral Alinhado à BNCC/PNLD

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** O fluxo atual de planejamento trimestral ainda não está fechado ponta a ponta como núcleo confiável do PROFEPLAN: nem sempre garante que `TermPlan` seja criado com parâmetros completos (disciplina/série/período), que a geração de conteúdo use BNCC/PNLD reais via RAG (sem “prompt genérico”), e que as `lessons` geradas sejam persistidas de forma rastreável, ligadas ao planejamento e, quando aplicável, à turma.  

**Approach:** Consolidar um fluxo único de planejamento trimestral em que o professor define o contexto (disciplina, série, período, carga horária, PNLD), a IA gera o texto do plano e uma grade de `lessons` alinhadas à BNCC/PNLD via `AiPlanningService`, e o sistema persiste `TermPlan` + `lessons` vinculados ao usuário/turma, permitindo visualização e edição posteriores sem perder vínculos com currículo e avaliações futuras.

## Boundaries & Constraints

**Always:**
- Usar **BNCC/PNLD reais via RAG** para geração de planejamento (`AiPlanningService.generateTermPlan`), nunca inventando códigos de habilidades ou conteúdo curricular.  
- Manter a separação arquitetural entre **Azure OpenAI (geração de texto)** e **Gemini + Supabase (RAG de BNCC/PNLD)**, respeitando dimensão de embeddings `vector(768)` descrita na arquitetura.  
- Persistir `TermPlan` com parâmetros mínimos (disciplina, série, período, regime, carga horária, `totalClasses`, grade de pontos) e associar `lessons` ao `term_plan_id` e, quando houver, ao `class_id`.  
- Garantir que qualquer tela que consuma `lessons` (ex.: seleção de aula para PDI/Adaptação) leia os dados persistidos, não apenas o markdown gerado em memória.  

**Ask First:**
- Ajustar o schema de banco para `term_plans`/`lessons` além do que já está previsto no PRD (ex.: novos campos, índices específicos para relatórios).  
- Alterar o modelo de pontos/avaliação (grade de vistos, trabalhos, provas) além do configurável pelo usuário na UI.  
- Introduzir lógica de prevenção de duplicidade de `TermPlan` por disciplina/série/período que altere comportamento atual (bloquear vs permitir múltiplos).  

**Never:**
- Substituir a arquitetura multi-agentes de planejamento por um único prompt genérico sem RAG, quebrando os guardrails “BNCC/PNLD não podem ser alucinadas”.  
- Persistir `lessons` sem vínculo claro com o `TermPlan` de origem ou, quando aplicável, com a turma em que serão usadas.  
- Reduzir o planejamento a mero texto solto sem estrutura de aulas rastreáveis por BNCC/período.  

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| CREATE_TERMPLAN_HAPPY_PATH | Professor acessa Planejamento Trimestral e preenche disciplina, série, período, carga horária e parâmetros básicos | Ao clicar em “Criar planejamento”, o sistema cria um `TermPlan` persistido com esses metadados e estado inicial; a tela evolui para permitir geração via IA | Em falha de gravação, mostrar erro claro e manter dados do formulário na memória para nova tentativa |
| GENERATE_PLAN_WITH_BNCC | Professor com `TermPlan` criado aciona geração automática com BNCC/PNLD | `AiPlanningService` executa RAG, gera markdown com seções (dados gerais, competências/habilidades, cronograma, avaliação) e lista de aulas estruturadas; UI exibe o texto no editor | Em falha de IA/RAG, exibir mensagem amigável (“robô de currículo indisponível”) e não alterar estado salvo do `TermPlan` |
| SAVE_PLAN_AND_LESSONS | Professor revisa texto e salva | `TermPlanningService.saveTermPlan` persiste `TermPlan` com `generatedText` e cria/atualiza `lessons` derivadas (com título, objetivos, BNCC), vinculadas a `term_plan_id` (e opcionalmente `class_id`) | Em falha de persistência, informar erro sem perder conteúdo no editor; permitir nova tentativa |
| REOPEN_EXISTING_TERMPLAN | Professor abre um planejamento já criado para mesma disciplina/série/período | Tela carrega `TermPlan` existente com `generatedText` e `lessons` associadas, permitindo edição leve dos campos de texto e objetivos | Se não encontrar `TermPlan`, oferecer opção de criar um novo, evitando duplicidade silenciosa |

</frozen-after-approval>

## Code Map

- `apps/web/src/features/TermPlanning/TermPlanningManager.tsx` -- UI principal de planejamento trimestral (formulário de contexto, chamada para IA, editor de texto, salvar/exportar).  
- `apps/web/src/services/ai/AiPlanningService.ts` -- Serviço de IA responsável por gerar `generatedText` de planejamento usando BNCC/PNLD via RAG (`generateTermPlan`).  
- `apps/web/src/features/TermPlanning/TermPlanningService.ts` -- Funções de persistência `saveTermPlan`/carregamento de planos, conversão entre `TermPlan` em memória e schema de banco.  
- `apps/web/src/services/PlanningAuthorityService.ts` & `apps/web/src/services/orchestration/PlanningOrchestrator.ts` -- Camada de orquestração/guardrails em torno da IA de planejamento.  
- `apps/web/src/schemas/TermPlanSchema.ts` -- Definição de schema/validação de `TermPlan` no front.  
- `apps/web/src/contexts/GlobalPlanningContext.tsx` -- Contexto global para planos (`currentPlan`, lista de term plans, integração com outras features).  

## Tasks & Acceptance

**Execution:**
- [ ] `TermPlanningManager.tsx` -- Garantir que o formulário de contexto (disciplina, série, nível, período, carga horária, PNLD) preencha e envie corretamente todos os campos esperados por `PlanningAuthority.executePlanning` / `AiPlanningService.generateTermPlan`, incluindo `gradingGrid` e reservas de provas, alinhados ao PRD -- evita divergência entre UI e prompt de IA.  
- [ ] `AiPlanningService.ts` -- Revisar `generateTermPlan` para assegurar: (a) uso obrigatório de RAG BNCC/PNLD (ou currículo SEE/MG) antes da geração, (b) montagem do prompt com seções e cabeçalhos padronizados para facilitar parsing de `lessons`, e (c) manutenção dos guardrails de não-alucinação de códigos BNCC -- cumpre guardrails de currículo.  
- [ ] `TermPlanningService.ts` -- Confirmar/ajustar que `saveTermPlan` persiste `TermPlan` completo (incluindo `totalClasses`, `gradingGrid`, PNLD selecionado) e cria/atualiza `lessons` com vínculos a `term_plan_id` (e `class_id` quando informado), preenchendo campos de objetivos, bncc, descrição -- implementa Stories 3.2 e 3.3.  
- [ ] `GlobalPlanningContext.tsx` -- Garantir que a lista de planejamentos e o `currentPlan` sejam carregados a partir da base, permitindo reabertura/edição de `TermPlan` existentes e evitando múltiplos planos conflitantes para a mesma disciplina/série/período sem confirmação -- cobre Story 3.1 e parte de 3.4.  
- [ ] `TermPlanningManager.tsx` & utilitários (`parseMarkdownToLessons`) -- Assegurar que a visualização/edição de `lessons` geradas respeite a estrutura (número, título, objetivos, BNCC) e que alterações no editor sejam refletidas tanto no markdown quanto na estrutura de `lessons` persistida -- cobre Story 3.4.  
- [ ] Adicionar ou ajustar testes (ou roteiro manual) para os cenários de I/O (criar plano, gerar com BNCC, salvar e reabrir, editar lessons), confirmando que não há perda de vínculos com BNCC ou turmas.  

**Acceptance Criteria:**
- Dado que o professor preenche disciplina, série, período, carga horária e parâmetros básicos no Planejamento Trimestral, quando clicar em “Criar planejamento”, então um `TermPlan` deve ser criado e armazenado com esses metadados, ficando disponível na lista de planejamentos (Story 3.1).  
- Dado um `TermPlan` criado, quando o professor acionar “Gerar Planejamento” com BNCC/PNLD, então o sistema deve usar RAG/SEE/MG para montar `generatedText` estruturado (dados gerais, competências/habilidades, cronograma, avaliação) sem inventar códigos BNCC (Story 3.2).  
- Dado um planejamento gerado e revisado, quando o professor salvar, então as `lessons` correspondentes devem ser persistidas em `lessons` com `term_plan_id` (e `class_id` quando aplicável), contendo ao menos título, objetivos e BNCC válidos (Story 3.3).  
- Dado um `TermPlan` salvo com `lessons`, quando o professor reabrir o planejamento, então deverá ver tanto o texto de planejamento quanto a lista de `lessons` para visualizar/editar, e quaisquer alterações salvas devem refletir-se em fluxos que usam essas aulas (ex.: seleção de aula para PDI) (Story 3.4).  

## Spec Change Log

## Design Notes

- O planejamento trimestral é tratado como **fonte de verdade pedagógica** que alimenta aulas, PDI e avaliações; por isso, a estrutura de `TermPlan` + `lessons` deve permanecer consistente e rastreável, evitando duplicação de lógica fora desse núcleo.  
- A extração de `lessons` a partir do markdown gerado deve permanecer simples e robusta, baseada em cabeçalhos padronizados (`### Aula X: ...`), para facilitar manutenção futura.  

## Verification

**Commands:**
- `npm test -- --runTestsByPath apps/web/src/features/TermPlanning/TermPlanningManager.test.tsx` -- esperado: fluxo de criação/edição/salvamento de `TermPlan` e `lessons` funcionando (se teste existir ou for criado).  

**Manual checks (if no CLI):**
- Criar um novo planejamento trimestral (disciplina/série/período), gerar com BNCC/PNLD, salvar, reabrir, e em seguida verificar se as `lessons` aparecem corretamente tanto na tela de planejamento quanto como opções em fluxos dependentes (ex.: Adaptações PDI).  

