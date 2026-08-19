# Roadmap de execução — piloto real controlado (Fase C)

> Documento vivo. Cada item é marcado ✅ quando concluído e verificado; ⬜ enquanto pendente; 🚧 quando em andamento.

Última atualização: 19 de agosto de 2026.

Documento normativo de referência: [REAL-PILOT-AUTHORIZATION-BOUNDARY-DEFINITION.md](REAL-PILOT-AUTHORIZATION-BOUNDARY-DEFINITION.md).
Documento técnico do piloto: [FIRST-REAL-SINGLE-PART-PILOT.md](FIRST-REAL-SINGLE-PART-PILOT.md).
Protocolo de decisão do resultado: [REAL-PILOT-RESULT-DECISION-PROTOCOL.md](REAL-PILOT-RESULT-DECISION-PROTOCOL.md).
Plano pós-VERDE: [POST-REAL-PILOT-C4-ENTRY-PLAN.md](POST-REAL-PILOT-C4-ENTRY-PLAN.md).

## Etapa 0 — Fronteira jurídica e operacional

| Item | Status | Nota |
|---|---|---|
| Natureza do uso declarada (referencial, não cópia) | ✅ | Seção 2 do documento de fronteira — PR #120 |
| Base jurídica de acesso ao exemplar | ✅ | Seção 3.1 — acesso próprio do professor via cadastro na editora |
| Ambiente descartável definido | ✅ | `private-inputs/pnld/piloto-real/<slug>/`, fora do Git |
| Pasta do Livro 0 criada | ✅ | `private-inputs/pnld/piloto-real/livro-0-sociologia/`, fora do Git |
| Retenção definida | ✅ | 30 dias corridos ou até a revisão humana, o que ocorrer primeiro |
| Descarte definido | ✅ | remoção pelo responsável do projeto |
| Revisão humana definida | ✅ | revisão obrigatória antes de qualquer promoção |
| Proibições confirmadas | ✅ | sem publicação/corpus/produção; sem texto literal extenso |
| Obra/edição definida | ✅ | `Do seu jeito — Sociologia`, Editora Ática (SOMOS Educação), 1ª edição, São Paulo, 2024; volume único; Manual do Professor; PNLD 2026–2029; cód. `0113P260101204816` |
| Arquivo identificado | ✅ | `DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf`; 449 páginas físicas; SHA-256 `1e7f8d613fdb43a49d4a1f0a031465784b03b31b1d22e1779d279365ad82e39a` |
| Parte única delimitada | ✅ | `Unidade 1 — Antropologia → Capítulo 1 — O pensamento antropológico → Evolucionismo social` |
| Páginas físicas delimitadas | ✅ | físicas 34–35; impressas 33–34; próximo irmão cartográfico na física 36 |

**Etapa 0 concluída: 12/12.** A autorização material fica restrita exatamente ao artefato identificado pelo SHA-256 e à parte/páginas acima. O PDF permanece fora do Git e não pode ser publicado ou promovido.

## Etapa 1 — Cartografia preliminar da parte

| Item | Status | Nota |
|---|---|---|
| Arquivo depositado na pasta dedicada, fora do Git | ✅ | arquivo real local confirmado em 19/08/2026 |
| Identidade do arquivo e assinatura mínima confirmadas | ✅ | `%PDF-`, SHA-256 e 449 páginas físicas confirmados |
| Reconhecimento estrutural aplicado à janela inicial | ✅ | `Conheça seu livro` física 5; Sumário físicas 7–9; PDF PageLabels observados |
| Mapa candidato da parte produzido | ✅ | Unidade 1 física 29/impressa 28; Capítulo 1 física 31/impressa 30; `Evolucionismo social` física 34/impressa 33; limite pelo próximo irmão física 36 |

**Etapa 1 concluída: 4/4.** A cartografia real evidenciou fragmentação técnica das entradas do Sumário em objetos textuais consecutivos, sem necessidade de OCR.

## Etapa 2 — Extração nativa da parte (C.3.3)

| Item | Status | Nota |
|---|---|---|
| Parte única selecionada conforme Etapa 0 | ✅ | escopo profundo: físicas 34–35 |
| Generalização mínima para Sumário fragmentado preparada | ✅ | limitada a `StructuralRecognitionService`; contratos permanecem em `1.0.0` |
| Teste real dedicado preparado | ✅ | `real-single-part-vertical-reconstruction.test.mjs`, condicionado a `PROFEPLAN_REAL_PILOT_PDF` |
| Teste dedicado executado materialmente contra o SHA governado | ✅ | execução local válida em 19/08/2026; teste real passou |
| Extração nativa restrita às páginas autorizadas comprovada pelo teste | ✅ | reconstrução profunda solicitou exatamente físicas 34–35 |

**Etapa 2 concluída: 5/5.** A execução material usou o PDF real governado e terminou com 132 testes passados, 0 falhas e 0 skips.

## Etapa 3 — Reconstrução estrutural local (C.4-local)

| Item | Status | Nota |
|---|---|---|
| Reconstrução da parte sem tratar a obra inteira como unidade | ✅ | teste real comprovou cartografia seletiva e reconstrução por `CartographicPartScope` |
| Dupla paginação físicas 34–35 / impressas 33–34 preservada | ✅ | labels 34→33 e 35→34 verificados materialmente |
| Hierarquia Unidade → Capítulo → seção preservada | ✅ | parentage verificada no snapshot real |
| Elementos e relações apoiados por evidência | ✅ | asserts exigem evidência para todo elemento/relação |
| Apenas referências/estrutura persistidas | ✅ | o teste não cria persistência do PDF/texto integral; snapshot permanece candidato e em memória |

**Etapa 3 concluída: 5/5 no escopo C.4-local do piloto.** Isso não equivale à abertura ou conclusão integral do Lote C.4.

## Etapa 4 — Revisão humana

| Item | Status | Nota |
|---|---|---|
| Resultado material revisado | 🚧 | revisão técnica concluída; aprovação humana do responsável ainda é gate de integração |
| Classificação arquitetônica final registrada (A/B/C/D) | ✅ | **B — pequena generalização** |
| Decisão registrada: aprovado / corrigido / rejeitado | ⬜ | aguardando decisão humana explícita antes de tirar o PR #125 de Draft/merge |

## Etapa 5 — Descarte

| Item | Status | Nota |
|---|---|---|
| Arquivo original descartado ao fim do prazo de retenção/revisão | ⬜ | não antecipar antes da decisão humana e fechamento do piloto |
| Artefatos temporários descartados | ⬜ | |
| Descarte registrado neste roadmap | ⬜ | |

## Resultado material do primeiro piloto real

**Classificação: VERDE.**

Execução local válida em 19/08/2026:

- pacote instalado com `pnpm 11.5.2` e Node 22.x;
- PDF real carregado fora do Git;
- SHA-256 governado aceito pelo teste;
- teste real `real PNLD 2026 PDF reconstructs one mapped section without deep-reading the book` passou;
- 132 testes totais;
- 132 passados;
- 0 falhas;
- 0 cancelados;
- 0 skips;
- duração total aproximada: 10,2 s;
- duração do teste real: aproximadamente 7,54 s.

Pelos asserts já incorporados ao teste, o VERDE material implica simultaneamente: 449 páginas físicas; cartografia seletiva; Sumário real; hierarquia Unidade 1 → Capítulo 1 → `Evolucionismo social`; escopo 34–35; dupla paginação 33–34; reconstrução profunda restrita exatamente a 34–35; evidências localizadas; estados cartográficos candidatos; contratos `1.0.0`; ausência de regressão das provas sintéticas.

## Gate de decisão após o VERDE

A execução material encerrou o gate técnico do piloto. O próximo gate é exclusivamente humano/governado:

1. revisar o resumo do resultado;
2. registrar `aprovado`, `corrigido` ou `rejeitado`;
3. se `aprovado` e checks remotos permanecerem verdes, tirar o PR #125 de Draft e integrar;
4. somente após integração, tornar elegível a entrada mínima em C.4 descrita em `POST-REAL-PILOT-C4-ENTRY-PLAN.md`.

VERDE não autoriza saltar para corpus, embeddings, retrieval/RAG ou produção.

## Fora de escopo neste piloto

- obra inteira como contexto semântico;
- outra obra ou coleção;
- OCR geral ou novo provider sem necessidade demonstrada;
- Supabase/Storage hospedado de produção;
- corpus, chunks, embeddings, retrieval/RAG ou grafo global;
- validação semântica BNCC;
- runtime multiagente;
- qualquer efeito público, comercial ou de produção.

## Histórico de atualizações

- 19/08/2026 — roadmap criado e fronteira jurídica/operacional progressivamente preenchida pelos PRs #119–#123.
- 19/08/2026 — Livro 0 depositado localmente e identificado pelo SHA-256 governado; leitura nativa e cartografia preliminar observadas.
- 19/08/2026 — reconciliação com o PR #118: corrigida a divergência documental do PR #124 e recuperada a parte real já delimitada (`Evolucionismo social`, físicas 34–35). Etapa 0 passa a 12/12 e Etapa 1 a 4/4.
- 19/08/2026 — implementação/teste do PR #118 reaplicados sobre a `main` atual em branch de reconciliação. O próximo gate material deixa de ser nova documentação e passa a ser a execução local do teste real contra o mesmo SHA-256.
- 19/08/2026 — protocolo VERDE/AMARELO/VERMELHO e plano de entrada mínima em C.4 preparados antecipadamente para evitar nova pausa de planejamento após a execução material.
- 19/08/2026 — piloto real executado materialmente no Ubuntu contra o SHA governado: 132/132 testes verdes, 0 falhas e 0 skips. Etapas 2 e 3 encerradas no escopo do piloto; classificação VERDE e arquitetura B — pequena generalização.
