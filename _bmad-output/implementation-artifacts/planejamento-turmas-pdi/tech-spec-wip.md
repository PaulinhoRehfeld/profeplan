---
title: 'Epic 1 - Testes Críticos da Importação SIMADE → Students'
type: 'feature'
created: '2026-03-17'
status: 'in-progress'
baseline_commit: '7c53775153c6aaa907807a2ab3a18f01fd089888'
context:
  - 'docs/prd-planejamento-turmas-pdi.md'
  - 'docs/modulo-alunos-turmas-pdi.md'
  - 'docs/fluxos-criticos-e-guardrails.md'
---

# Epic 1 - Testes Críticos da Importação SIMADE → Students

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Embora o fluxo de importação via PDF SIMADE já exista, ainda não há uma suíte de testes automatizados crítica que garanta, ponta a ponta, que o parsing e a persistência de turmas/alunos respeitam os guardrails do PRD — especialmente a extração e preservação correta de `student_code` e `call_number`, o tratamento explícito de linhas parciais e a recusa segura de arquivos inválidos.  

**Approach:** Criar uma suíte de testes automatizados focada em três cenários principais (PDF válido, PDF com linhas parciais e arquivo inválido), cobrindo `AiUtilityService.parseClassListFromText`, o fluxo de pré-visualização em `ImportProcess` e a camada de salvamento em `ClassBatchImportModal`/serviços, usando fakes/mocks de Supabase para validar que `student_code` e `call_number` são persistidos apenas quando disponíveis e nunca inventados ou apagados silenciosamente.

## Boundaries & Constraints

**Always:**
- Respeitar o PRD `prd-planejamento-turmas-pdi.md` e os guardrails de `fluxos-criticos-e-guardrails.md` sobre integridade de dados de aluno, especialmente `student_code` e `call_number`.  
- Modelar testes de forma a não depender de chamadas reais de IA ou Supabase: usar fixtures de texto SIMADE e fakes/mocks para serviços externos.  
- Garantir que os testes cubram explicitamente o comportamento de não inventar `student_code`/`call_number` quando ausentes e de não sobrescrever valores válidos por vazios.  
- Manter o escopo dos testes limitado ao fluxo de importação SIMADE → `ParsedClassData` → criação de `classes` + `students`, sem alterar regras de negócio ou schemas de banco.

**Ask First:**
- Introduzir novas dependências de teste (ex.: bibliotecas adicionais além do stack já usado no projeto) ou alterar significativamente a estrutura de pastas de testes.  
- Refatorar de forma ampla componentes de produção apenas para facilitar testabilidade; pequenas extrações (ex.: helpers puros) são aceitáveis, mas mudanças maiores exigem validação humana.  

**Never:**
- Tocar em schemas de `students` ou `classes` neste trabalho; o foco é exclusivamente em cobertura de testes e ajustes mínimos de testabilidade.  
- Introduzir lógica nova de importação fora do fluxo já definido (ex.: novo parser paralelo); qualquer melhoria estrutural deve ser feita em outro escopo.  
- Silenciar falhas relevantes nos testes (ex.: usar `any` ou ignorar asserts críticos) apenas para “fazer passar”.  

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| HAPPY_PATH_VALID_PDF | Texto SIMADE de referência com linhas no padrão `N CODIGO NOME` e metadados de turma legíveis; mock de Supabase saudável | `parseClassListFromText` retorna `ParsedClassData` com `className`, `subject` e `students[]` contendo `name`, `student_code`, `call_number`; `ImportProcess` exibe pré-visualização com contagem correta de alunos; ao simular confirmação, a função de salvamento é chamada com payload contendo `student_code`/`call_number` corretos | Em exceção de parsing ou de persistência simulada, teste deve falhar, explicitando a regressão |
| PDF_WITH_PARTIAL_LINES | Fixture de texto SIMADE com algumas linhas mal formatadas ou sem código/número para certos alunos | `parseClassListFromText` retorna alunos com `student_code`/`call_number` ausentes apenas para linhas problemáticas; `ImportProcess` (ou helper) marca essas entradas como “dados incompletos”; a chamada de salvamento nunca preenche códigos/números inventados | Teste verifica que alunos incompletos continuam presentes com campos vazios e que nenhuma tentativa de escrita de valores artificiais ocorre |
| NON_PDF_OR_UNREADABLE | Conteúdo vazio, binário ou explicitamente sinalizado como “não texto SIMADE” | Função responsável por iniciar o parsing (ou wrapper testável) rejeita o input com erro claro ou retorna estrutura de erro que impede avanço para salvamento; nenhuma chamada a Supabase é disparada | Teste garante que, nesse cenário, o fluxo de salvamento não é chamado e o estado permanece consistente |

</frozen-after-approval>

## Code Map

- `apps/web/src/services/ai/AiUtilityService.ts` -- Implementa `parseClassListFromText`; alvo de testes unitários puros com fixtures de texto SIMADE.
- `apps/web/src/components/ClassManager/ImportProcess.tsx` -- Orquestra upload, parsing e pré-visualização; alvo de testes de componente/integration para garantir passagem correta de `ParsedClassData`.
- `apps/web/src/components/ClassBatchImportModal.tsx` -- Responsável por acionar salvamento de turma/alunos a partir de `ParsedClassData`; alvo de testes com mocks de Supabase/serviço de persistência.
- `apps/web/src/services/supabaseService.ts` ou wrapper equivalente -- Ponto a ser “mockado” nos testes para inspecionar payloads de criação de `classes` e `students`.
- `apps/web/src/components/ClassManager/__tests__/ImportProcess.test.tsx` -- Novo arquivo de testes focado em fluxo de pré-visualização e cenários happy/partial/erro.

## Tasks & Acceptance

**Execution:**
- [ ] `apps/web/src/services/ai/AiUtilityService.ts` + `apps/web/src/services/ai/__tests__/AiUtilityService.parseClassListFromText.test.ts` -- Adicionar testes unitários de `parseClassListFromText` cobrindo os três cenários da matriz (PDF válido, linhas parciais, input inválido), usando fixtures de texto SIMADE e asserts sobre `students[].student_code`/`call_number` -- garante que o parser respeita o PRD e não inventa dados.  
- [ ] `apps/web/src/components/ClassManager/ImportProcess.tsx` + `apps/web/src/components/ClassManager/__tests__/ImportProcess.test.tsx` -- Criar testes de componente/integration que mockam `parseClassListFromText`, verificando que a UI/fluxo de pré-visualização exibe a contagem correta de alunos, sinaliza “dados incompletos” e só permite “confirmar” após parsing bem-sucedido -- valida comportamento de borda na camada de UX.  
- [ ] `apps/web/src/components/ClassBatchImportModal.tsx` + testes associados -- Adicionar testes que simulam confirmação de importação e inspecionam chamadas para a função de salvamento (ou Supabase mockado), garantindo que `student_code` e `call_number` são enviados quando presentes e permanecem ausentes quando não fornecidos pelas fixtures -- cobre integridade de payload até o limite deste escopo.  
- [ ] `apps/web/src/services/supabaseService.ts` (ou wrapper) -- Introduzir, se necessário, um pequeno wrapper/fábrica que facilite o mocking em testes, sem alterar a lógica de negócio; atualizar testes para usar esse ponto único de injeção -- melhora testabilidade mantendo invariantes.  
- [ ] Rodar a suíte de testes e ajustar pequenos detalhes de tipagem ou mocks até que os três cenários da matriz estejam cobertos sem falsos positivos/negativos.  

**Acceptance Criteria:**
- Dado um fixture de texto SIMADE representando um PDF válido, quando os testes de `parseClassListFromText` e `ImportProcess` são executados, então todos devem confirmar que `student_code` e `call_number` são extraídos e propagados corretamente para a pré-visualização e para o payload de salvamento simulado.  
- Dado um fixture com linhas parciais, quando os testes são executados, então eles devem verificar que alunos afetados aparecem com `student_code`/`call_number` vazios, são marcados como “dados incompletos” (ou equivalente) e que nenhuma tentativa de “inventar” valores ocorre na chamada de salvamento mockada.  
- Dado um input inválido (não-PDF/ilegível) ou explicitamente sinalizado como “não texto SIMADE”, quando os testes rodam, então o fluxo deve impedir avanço para salvamento (nenhuma chamada de persistência é feita) e o teste deve falhar caso qualquer gravação seja tentada, garantindo alinhamento com os guardrails de integridade de dados.  

## Spec Change Log

## Design Notes

- A estratégia privilegia testes unitários puros para o parser e testes de integração leves para o fluxo de importação, mantendo tempo de execução baixo e alta cobertura de cenários críticos.  
- O uso de fixtures de texto SIMADE, em vez de PDFs binários reais, segue boas práticas de testabilidade e evita dependência de bibliotecas de parsing de PDF nos testes.  

## Verification

**Commands:**
- `npm test -- --runTestsByPath apps/web/src/services/ai/__tests__/AiUtilityService.parseClassListFromText.test.ts` -- esperado: testes de parsing SIMADE cobrem happy path, linhas parciais e input inválido.  
- `npm test -- --runTestsByPath apps/web/src/components/ClassManager/__tests__/ImportProcess.test.tsx` -- esperado: fluxo de pré-visualização e chamada de salvamento simulada se comportam corretamente nos três cenários.  

**Manual checks (if no CLI):**
- Exercitar o fluxo de importação na aplicação com: (a) um PDF SIMADE completo, (b) um PDF com linhas problemáticas e (c) um arquivo inválido, verificando se o comportamento observado corresponde ao que foi fixado nos testes automatizados (sem campos inventados, com mensagens de erro claras e sem gravações parciais indevidas).  

