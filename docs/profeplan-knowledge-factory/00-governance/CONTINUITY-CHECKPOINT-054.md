# CONTINUITY CHECKPOINT 054 — primeiro piloto real VERDE; aprovado para integração do PR #125

Data: 19 de agosto de 2026.

## 1. Marco alcançado

O primeiro piloto real governado da ProfePlan Knowledge Factory foi executado materialmente contra o PDF real autorizado e classificado como **VERDE** pelo protocolo `REAL-PILOT-RESULT-DECISION-PROTOCOL.md`.

A execução ocorreu no worktree local dedicado ao PR #125, sem commit/publicação do PDF e sem uso de conteúdo real em CI remoto.

Em 19/08/2026, após apresentação do resultado resumido, o responsável pelo projeto registrou decisão humana **APROVADO** e autorizou a continuidade da ação de integração.

## 2. Artefato e escopo executados

- obra: `Do seu jeito — Sociologia`;
- Editora Ática (SOMOS Educação);
- 1ª edição, São Paulo, 2024;
- volume único, Manual do Professor;
- PNLD 2026–2029;
- código `0113P260101204816`;
- arquivo governado: `DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf`;
- total físico esperado e confirmado pelo teste: 449 páginas;
- SHA-256 governado: `1e7f8d613fdb43a49d4a1f0a031465784b03b31b1d22e1779d279365ad82e39a`;
- parte: `Unidade 1 — Antropologia → Capítulo 1 — O pensamento antropológico → Evolucionismo social`;
- escopo profundo: físicas 34–35 / impressas 33–34.

## 3. Resultado material

Com Node 22.x e `pnpm 11.5.2`, o pacote `@profeplan/knowledge-factory` executou sua suíte com:

- **132 testes**;
- **132 passados**;
- **0 falhas**;
- **0 cancelados**;
- **0 skips**;
- duração total aproximada de **10,2 s**;
- teste real dedicado concluído em aproximadamente **7,54 s**.

O teste real identificado como:

`real PNLD 2026 PDF reconstructs one mapped section without deep-reading the book`

passou materialmente.

## 4. Invariantes comprovados pelo mesmo teste

A passagem do teste real confirma simultaneamente os asserts governados para:

1. SHA-256 correto antes da cartografia;
2. 449 páginas físicas;
3. cartografia seletiva, menor que a obra inteira;
4. inspeções cartográficas somente por faixas explícitas;
5. Sumário real incluindo a física 7;
6. Unidade 1 na física 29 / impressa 28;
7. Capítulo 1 na física 31 / impressa 30, filho da Unidade 1;
8. `Evolucionismo social` filho do Capítulo 1;
9. delimitação da seção nas físicas 34–35;
10. reconstrução profunda solicitando exatamente uma faixa 34–35;
11. dupla paginação preservada: 34→33 e 35→34;
12. nenhuma página reconstruída fora do `CartographicPartScope`;
13. título da seção corroborado no corpo;
14. todos os elementos e relações apoiados por evidência;
15. evidências locais restritas ao escopo profundo;
16. estados cartográficos permanecendo candidatos;
17. contratos permanecendo `1.0.0`;
18. provas sintéticas e regressões permanecendo verdes.

## 5. Classificação arquitetônica

Resultado do protocolo: **VERDE**.

Classificação arquitetônica mantida: **B — pequena generalização**.

A diferença real observada no Sumário foi resolvida por generalização localizada no `StructuralRecognitionService`, recompondo entradas fragmentadas em objetos textuais consecutivos sem:

- regra específica para a coleção;
- OCR;
- novo provider;
- alteração de contratos;
- alteração de `PdfJsDocumentInspectorAdapter`;
- alteração de `PartReconstructionService`;
- obra inteira como contexto.

## 6. Estado do roadmap após a prova e revisão humana

- Etapa 0 — **12/12 concluída**;
- Etapa 1 — **4/4 concluída**;
- Etapa 2 — **5/5 concluída**;
- Etapa 3 — **5/5 concluída no escopo C.4-local do piloto**;
- Etapa 4 — **revisão humana concluída; decisão APROVADO**;
- Etapa 5 — descarte permanece pendente conforme política de retenção e não bloqueia a integração do código/documentação, desde que o PDF continue fora do Git e fora de qualquer persistência hospedada.

## 7. PR #125

Linha ativa:

`feat/knowledge-factory-real-pilot-reconciliation-v2`

A decisão humana de 19/08/2026 autoriza:

1. tornar o PR #125 pronto para revisão;
2. confirmar os checks remotos do HEAD final;
3. integrar o PR #125 por squash, preservando o gate de SHA do HEAD;
4. somente após a integração, tornar elegível a entrada mínima em C.4 descrita por `POST-REAL-PILOT-C4-ENTRY-PLAN.md`.

A aprovação não autoriza corpus, embeddings, retrieval/RAG, C.5–C.7 ou produção.

## 8. Próximo problema arquitetônico elegível após integração

A pré-auditoria de C.4 indica que o principal gap legítimo não é um novo parser ou uma ontologia ampla. É a menor superfície capaz de transformar estruturas candidatas observadas em decisões confirmadas/corrigidas/rejeitadas, preservando os snapshots candidatos como evidência histórica imutável.

Hipótese preferencial, ainda não promovida a contrato:

- preservar `StructuralRecognitionSnapshot@1.0.0` como observação candidata;
- preservar `PartReconstructionCandidateSnapshot@1.0.0` como reconstrução candidata;
- C.4 emitir decisão/estrutura confirmada separada, referenciando candidatos e evidências;
- permitir `confirmed`, `corrected` ou `rejected` sem reescrever o histórico do candidato.

## 9. Escopo negativo preservado

O VERDE e a aprovação deste piloto não autorizam:

- processar a obra inteira como contexto;
- outra obra/coleção;
- OCR geral;
- corpus/chunks;
- embeddings/retrieval/RAG;
- grafo global;
- C.5–C.7;
- Supabase/Storage hospedado de conteúdo;
- runtime multiagente;
- produção.

## 10. Regra de continuidade

Checkpoint 054 substitui o Checkpoint 053 como ponto operacional mais recente da linha do primeiro piloto real. O Checkpoint 053 permanece histórico e correto para o estado anterior à execução material.

Após o squash do PR #125, criar novo checkpoint somente se houver ganho real de continuidade ao abrir C.4 mínimo; não criar microcheckpoint para ações intermediárias sem valor arquitetônico.
