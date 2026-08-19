# Roadmap de execução — piloto real controlado (Fase C)

> Documento vivo. Mantido aberto para acompanhamento contínuo. Cada item é marcado ✅ assim que
> concluído e verificado; ⬜ enquanto pendente; 🚧 quando em andamento.

Última atualização: 19 de agosto de 2026.

Documento normativo de referência: [REAL-PILOT-AUTHORIZATION-BOUNDARY-DEFINITION.md](REAL-PILOT-AUTHORIZATION-BOUNDARY-DEFINITION.md).

## Etapa 0 — Fronteira jurídica e operacional (pré-requisito de qualquer execução real)

| Item | Status | Nota |
|---|---|---|
| Natureza do uso declarada (referencial, não cópia) | ✅ | Seção 2 do documento de fronteira — PR #120 |
| Base jurídica de acesso ao exemplar | ✅ | Seção 3.1 — acesso próprio do professor via cadastro na editora |
| Ambiente descartável definido | ✅ | Seção 3.2 — pasta dedicada em `private-inputs/pnld/piloto-real/<slug>/`, fora do Git |
| Pasta do Livro 0 (Sociologia) criada | ✅ | `private-inputs/pnld/piloto-real/livro-0-sociologia/`, fora do Git, com `LEIA-ME.txt` |
| Retenção definida | ✅ | Seção 3.2 — 30 dias corridos ou até a revisão humana, o que ocorrer primeiro |
| Descarte definido | ✅ | Seção 3.2 — remoção do arquivo/artefatos, responsável: o próprio responsável pelo projeto |
| Revisão humana definida | ✅ | Seção 3.2 — o responsável pelo projeto revisa antes de qualquer promoção |
| Proibições confirmadas | ✅ | Seções 2 e 6 — sem publicação/corpus/produção; sem texto literal extenso |
| Obra/edição definida | ✅ | Sociologia — Volume Único, Coleção "Do Seu Jeito", PNLD EM 2026 (Cód. 0113P260101204816) |
| Arquivo identificado | ✅ | `DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf`, 119 MB, 449 págs. físicas, SHA-256: `1e7f8d61...ad82e39a` |
| Parte única delimitada | ⬜ | usuário ainda não escolheu qual parte processar — ver mapa abaixo |
| Páginas físicas delimitadas | ⬜ | definido após escolha da parte única |

**A Etapa 0 só é considerada concluída quando todos os itens acima estiverem ✅.** 10/12 itens já
estão concluídos. Restam apenas: **parte única** e **páginas físicas** — ambos dependem da escolha
do usuário sobre qual parte do livro processar primeiro.

### Mapa editorial do Livro 0 (cartógrafia preliminar observada, 19/08/2026)

Este mapa foi construído a partir da inspeção real do arquivo. Deslocamento de paginação
observado: página física 1 = capa; paginação impressa começa em 10 (pág física ~11). Offset ≈ +1.

| Parte editorial | Pág. impressa | Pág. física (est.) |
|---|---|---|
| **Introdução** — O que é a sociedade? | 10 | ~11 |
| **Unidade 1** — Antropologia | — | ~30 |
|   Cap. 1 — Diversidade cultural e etnocentrismo | 30 | ~31 |
|   Cap. 2 — Identidade e cultura | 44 | ~45 |
|   Cap. 3 — Da estrutura à identidade | 70 | ~71 |
|   Debate plural: Cotas étnico-raciais | 92 | ~93 |
| **Unidade 2** — Antropologia no espaço e no tempo | 94 | ~95 |
|   Cap. 4 — Antropologia no Brasil | 96 | ~97 |
|   Cap. 5 — Antropologia contemporânea | 116 | ~117 |
|   Debate plural: Masculinidades | 140 | ~141 |
| **Unidade 3** — Sociologia | 142 | ~143 |
|   Cap. 6 — Pensar a sociedade capitalista | 144 | ~145 |
|   Cap. 7 — Mundos do trabalho | 165 | ~166 |
|   Cap. 8 — Classe e estratificação social | 188 | ~189 |
|   Agir no mundo | 210 | ~211 |
| **Unidade 4** — Sociologia no espaço e no tempo | 212 | ~213 |
|   Cap. 9 — Sociologia brasileira | 214 | ~215 |
|   Cap. 10 — Temas contemporâneos da Sociologia | 236 | ~237 |
|   Debate plural: Indústria cultural | 258 | ~259 |
| **Unidade 5** — Ciência Política | 260 | ~261 |
|   Cap. 11 — Política, poder e Estado | 262 | ~263 |
|   Cap. 12 — Globalização e política | 280 | ~281 |
|   Cap. 13 — A sociedade diante do Estado | 300 | ~301 |
|   Debate plural: Protestos e manifestações | 318 | ~319 |
| **Unidade 6** — Ciência Política no espaço e no tempo | 320 | ~321 |
|   Cap. 14 — A política no Brasil | 322 | ~323 |
|   Cap. 15 — Temas contemporâneos da Ciência Política | 342 | ~343 |
|   Agir no mundo | 362 | ~363 |
| Transcrição de áudios | 364 | ~365 |
| Referências bibliográficas comentadas | 366 | ~367 |

**Notas do mapa:** (a) deslocamento físico/impresso exato será confirmado na extração da parte
escolhida; (b) o Manual do Professor está intercalado ao livro do estudante (tipo MP); (c) esta
é uma cartografia candidata, não autoridade canônica — confirmação pertence a C.4.

## Etapa 1 — Cartografia preliminar da parte

| Item | Status | Nota |
|---|---|---|
| Arquivo depositado em `private-inputs/pnld/piloto-real/livro-0-sociologia/` (fora do Git) | ✅ | `DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf`, 119 MB, 449 págs. físicas |
| Identidade do arquivo e assinatura mínima confirmadas | ✅ | `%PDF-` ✅, SHA-256 registrado, tamanho confirmado |
| Reconhecimento estrutural aplicado à janela inicial | ✅ | págs. 1–30 inspecionadas; sumário extraído; mapa editorial candidato produzido (ver Etapa 0) |
| Mapa candidato da parte produzido | ⬜ | aguardando usuário escolher a parte (ver tabela acima) |

## Etapa 2 — Extração nativa da parte (C.3.3)

| Item | Status | Nota |
|---|---|---|
| Parte única selecionada conforme Etapa 0 | ⬜ | |
| Extração nativa restrita às páginas autorizadas | ⬜ | sem OCR, sem leitura do restante da obra |
| Evidência de extração persistida no ambiente descartável | ⬜ | |

## Etapa 3 — Reconstrução estrutural local (C.4-local)

| Item | Status | Nota |
|---|---|---|
| Reconstrução da parte sem tratar a obra inteira como unidade | ⬜ | reaproveita o mecanismo já provado (Introdução/Unidade 1) |
| Classificação de elementos editoriais da parte | ⬜ | |
| Apenas referências/estrutura persistidas (sem texto integral) | ⬜ | conforme seção 2 da fronteira |

## Etapa 4 — Revisão humana

| Item | Status | Nota |
|---|---|---|
| Resultado revisado por quem foi designado na Etapa 0 | ⬜ | |
| Decisão registrada: aprovado / corrigido / rejeitado | ⬜ | |

## Etapa 5 — Descarte

| Item | Status | Nota |
|---|---|---|
| Arquivo original descartado ao fim do prazo de retenção | ⬜ | |
| Artefatos temporários descartados | ⬜ | |
| Descarte registrado neste roadmap | ⬜ | |

## Fora de escopo neste piloto (não será marcado como pendente, é bloqueio deliberado)

- obra inteira;
- OCR ou novo provider sem necessidade demonstrada;
- Supabase/Storage hospedado de produção;
- embeddings, retrieval, corpus, C.5–C.7 técnicos;
- runtime multiagente;
- qualquer efeito público, comercial ou de produção.

## Histórico de atualizações deste roadmap

- 19/08/2026 — criação do roadmap; Etapa 0 com 2/11 itens concluídos (natureza do uso e base
  jurídica); demais etapas não iniciadas.
- 19/08/2026 — Etapa 0 avança para 7/11: política operacional padrão definida (ambiente, retenção,
  descarte, revisão) e proibições confirmadas como já vinculantes. Restam apenas os 4 itens que
  dependem de uma obra real específica (obra/edição, arquivo, parte única, páginas físicas).
- 19/08/2026 — criada a pasta dedicada `private-inputs/pnld/piloto-real/livro-0-sociologia/`
  (fora do Git, com `LEIA-ME.txt`) para o "Livro 0", um livro de Sociologia que servirá de modelo.
  Etapa 0 avança para 8/12.
- 19/08/2026 — PDF depositado e lido com sucesso pelo PDF.js do projeto. Obra identificada:
  Sociologia Vol. Único “Do Seu Jeito”, PNLD EM 2026. 449 págs. Sumário e mapa editorial extraídos.
  Etapa 0 avança para 10/12. Etapa 1 parcialmente concluída (3/4). Bloqueio final: usuário
  precisa escolher a parte única a processar.
