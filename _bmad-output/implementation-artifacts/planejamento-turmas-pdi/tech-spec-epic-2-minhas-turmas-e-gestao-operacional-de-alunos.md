---
title: 'Epic 2 - Minhas Turmas & Gestão Operacional de Alunos'
type: 'feature'
created: '2026-03-17'
status: 'draft'
context:
  - 'docs/prd-planejamento-turmas-pdi.md'
  - 'docs/modulo-alunos-turmas-pdi.md'
  - 'docs/fluxos-criticos-e-guardrails.md'
---

# Epic 2 - Minhas Turmas & Gestão Operacional de Alunos

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** O módulo “Minhas Turmas” ainda não é um verdadeiro centro de verdade: a listagem de turmas e alunos não expõe de forma consistente número de chamada, código oficial do aluno e indicadores de inclusão, nem garante portabilidade de histórico ao mover alunos entre turmas/anos, o que fragiliza o núcleo Turma → Aluno → PDI descrito no PRD.  

**Approach:** Consolidar “Minhas Turmas” como painel operacional único, garantindo (a) listagem de turmas por usuário/escola com contagem de alunos, (b) lista de alunos por turma com `name`, `call_number`, `student_code` e badges de inclusão, (c) edição segura de observações/dados básicos que alimentam PDI e (d) fluxo de portabilidade que move o aluno entre turmas preservando código, observações, perfil inclusivo e histórico de PDIs.

## Boundaries & Constraints

**Always:**
- Preservar a cadeia relacional `Escola → Professor → Turma → Aluno → PDI`, conforme `modulo-alunos-turmas-pdi.md` e `fluxos-criticos-e-guardrails.md`.  
- Tratar `student_code`, `call_number`, `needs_adaptation` e `pedagogical_observations` como dados de negócio críticos – nunca apagar ou sobrescrever silenciosamente durante edições ou transferências de turma.  
- Exibir, na UI de alunos da turma, indicadores visuais claros para alunos com observações/perfil inclusivo, alinhados ao papel de gatilho de PDI.  
- Garantir que qualquer atualização de observações do aluno continue sendo consumida pelos fluxos de PDI (snapshot de inclusão), sem criar caminhos paralelos de dados.  

**Ask First:**
- Alterar schemas centrais (`students`, `classes`, `pdi_documents`) para modelar explicitamente portabilidade/histórico (ex.: tabela de histórico de matrícula) – envolve decisão de arquitetura e possível migração.  
- Introduzir filtros ou visões agregadas adicionais (por exemplo, dashboards de contagem de alunos com PDI por escola) além do que o Epic 2 exige.  
- Modificar regras de quem pode mover alunos entre turmas (restrições por papel/perfil) – isso impacta autorização e deve ser combinado com produto.  

**Never:**
- Remover ou ocultar da UI o campo de observações do aluno em nome de “simplificar tela”, quebrando o guardrail que usa esse campo como gatilho de PDI.  
- Simplificar o modelo de alunos para apenas `id + name`, descartando informações de inclusão/observações exigidas pela documentação de módulo.  
- Quebrar a filtragem por escola ativa do usuário (professores com múltiplas escolas) ao listar turmas e alunos.  
- Apagar ou “zerar” histórico de PDIs quando um aluno é movido de turma/ano.  

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| LIST_CLASSES_HAPPY_PATH | Professor/gestor autenticado com escola ativa selecionada e turmas existentes | Tela “Minhas Turmas” lista turmas associadas ao usuário (e opcionalmente filtradas por escola), exibindo nome, ano, turno, disciplina e contagem de alunos | Em caso de erro de Supabase, exibir mensagem amigável e, se possível, fallback para dados locais, sem travar a UI |
| LIST_STUDENTS_WITH_INCLUSION | Turma selecionada com alunos cadastrados, alguns com `needs_adaptation`/observações | Tela de detalhes da turma lista todos os alunos, mostrando `name`, `call_number`, `student_code` (quando disponível) e badge/ícone de inclusão para alunos com PDI/observações | Se algum aluno tiver dados parciais (sem código/número), ainda deve ser listado, com campos em branco/indicadores de dado ausente, nunca inventando valores |
| EDIT_OBSERVATIONS | Professor edita observações de um aluno na tela da turma | Campo de observações é atualizado em `students`, `needs_adaptation` é recalculado (por ex. true quando há observações relevantes), e alterações se refletem em fluxos de PDI | Em caso de falha ao salvar, manter valor anterior e exibir erro claro, sem corromper estado local; permitir tentar novamente |
| TRANSFER_STUDENT_BETWEEN_CLASSES | Professor/gestor aciona fluxo de transferência de aluno para outra turma/ano | Sistema associa aluno à nova turma preservando `student_code`, observações, perfil inclusivo e histórico de PDIs; a antiga associação não apaga PDIs antigos | Se a turma de destino não existir ou não pertencer à mesma escola/usuário, bloquear operação com mensagem clara; nenhuma perda de dados parcial |

</frozen-after-approval>

## Code Map

- `apps/web/src/components/ClassManager.tsx` -- Container principal de “Minhas Turmas”: busca turmas (Supabase/local), renderiza `ClassList`, abre detalhes de turma, integra importação e criação manual.  
- `apps/web/src/components/ClassManager/ClassList.tsx` -- Lista visual de turmas com contagem de alunos e ações (ver/excluir).  
- `apps/web/src/components/ClassManager/ClassDetail.tsx` -- Tela de detalhes da turma, responsável por listar alunos, exibir indicadores de inclusão e permitir edição de observações/dados básicos via `onUpdateStudent`.  
- `apps/web/src/services/supabaseService.ts` -- Funções `getClasses`, `getClassDetails`, `updateStudent`, `saveClassStructure` e possíveis novas funções para transferência de alunos.  
- `apps/web/src/types.ts` e `apps/web/src/types/index.ts` -- Tipos `Class`, `Student` e correlatos, usados para tipar dados vindos do Supabase e mantidos na UI.  
- `apps/web/src/services/localStorageService.ts` -- Fallback local para turmas/alunos quando Supabase falha; deve permanecer consistente com o modelo de dados principal.  

## Tasks & Acceptance

**Execution:**
- [ ] `apps/web/src/components/ClassManager.tsx` -- Revisar `fetchClasses` e `handleViewClass` para garantir que turmas e alunos sejam carregados com `student_code`, `call_number`, `needs_adaptation` e observações (quando existirem), normalizando apenas o campo de nome quando vier em formatos anômalos -- assegura que a listagem de turmas/alunos reflita o modelo completo do PRD.  
- [ ] `apps/web/src/components/ClassManager/ClassDetail.tsx` -- Ajustar a tabela de alunos para exibir explicitamente colunas de número de chamada (`call_number`), código do aluno (`student_code`) e badge/ícone de inclusão quando `needs_adaptation` ou observações estiverem presentes -- implementa Story 2.2 visualmente.  
- [ ] `apps/web/src/components/ClassManager/ClassDetail.tsx` & `apps/web/src/components/ClassManager.tsx` -- Garantir fluxo de edição de observações/dados básicos do aluno (usando `updateStudent`) que atualize `pedagogical_observations` e derive `needs_adaptation` conforme regras do módulo de PDI -- cobre Story 2.3 e mantém alinhamento com “campo Observações como gatilho de PDI”.  
- [ ] `apps/web/src/services/supabaseService.ts` -- Rever `getClasses`, `getClassDetails`, `updateStudent` e `saveClassStructure` para alinhar tipos e payloads a `student_code`, `call_number`, `needs_adaptation`, `pedagogical_observations` e `current_school_id`, evitando perda de dados em updates -- garante integridade e compatibilidade com o Epic 1.  
- [ ] (Opcional, se viável no escopo) `apps/web/src/services/supabaseService.ts` & UI associada -- Introduzir função/helper de transferência de aluno entre turmas (ex.: `transferStudentToClass(studentId, fromClassId, toClassId, year)`), atualizando apenas vínculos de turma/ano sem apagar histórico de PDIs; expor esse fluxo na UI de `ClassDetail` ou em modal dedicado -- cobre Story 2.4 com portabilidade segura.  
- [ ] `apps/web/src/services/localStorageService.ts` -- Verificar se a representação local de turmas/alunos inclui `needs_adaptation` e observações e se mantém sem divergir dos dados de Supabase; ajustar se necessário -- evita inconsistências entre modo online/offline.  
- [ ] Criar/ajustar testes (ou roteiro manual) cobrindo os cenários da matriz de I/O (lista de turmas, lista de alunos com inclusão, edição de observações, transferência de aluno) -- garante aderência às Stories 2.1–2.4.  

**Acceptance Criteria:**
- Dado que existam turmas associadas ao usuário (e escola ativa), quando o professor acessar “Minhas Turmas”, então deve ver uma lista de turmas com nome, ano/turno/disciplinas (quando disponíveis) e contagem de alunos, podendo entrar em cada turma (Story 2.1).  
- Dada uma turma com alunos importados (via SIMADE ou criação manual), quando o professor abrir a tela de detalhes dessa turma, então cada linha de aluno deve exibir `name`, `call_number`, `student_code` (quando houver) e um indicador visual de inclusão para alunos com `needs_adaptation` ou observações preenchidas (Story 2.2).  
- Dado que o professor edite o campo de observações pedagógicas de um aluno na lista de alunos, quando salvar as alterações, então essas observações devem ser persistidas em `students`, refletidas em fluxos de PDI (snapshot de inclusão) e o indicador de inclusão atualizado na própria lista (Story 2.3).  
- Dado que um aluno precise ser transferido de uma turma para outra (por troca de ano ou reorganização), quando o fluxo de transferência for concluído, então o aluno deve aparecer na turma de destino com `student_code`, observações, perfil inclusivo e histórico de PDIs preservados, sem duplicar ou perder dados (Story 2.4).  

## Spec Change Log

## Design Notes

- O módulo “Minhas Turmas” é tratado como centro de verdade operacional: qualquer alteração em aluno (especialmente observações e inclusão) deve ser visível e consumida por PDI/planejamento, evitando duplicar formulários ou estados paralelos.  
- A distinção entre persistência em Supabase e cache local é mantida como estratégia de resiliência, mas ambas camadas compartilham o mesmo modelo conceitual de aluno/turma, reduzindo risco de divergência.  

## Verification

**Commands:**
- `npm test -- --runTestsByPath apps/web/src/components/ClassManager/ClassDetail.test.tsx` -- esperado: testes de renderização/edição de alunos e indicadores de inclusão passam (se já existirem ou forem criados).  

**Manual checks (if no CLI):**
- Na aplicação rodando, usar um usuário de teste para: (a) importar uma turma via SIMADE, (b) abrir “Minhas Turmas” e a lista de alunos, (c) editar observações de um aluno e verificar propagação para PDI, e (d) executar uma transferência de aluno (se implementada) garantindo que dados de inclusão e PDIs permaneçam acessíveis na turma de destino.  

