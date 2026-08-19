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
| Retenção definida | ✅ | Seção 3.2 — 30 dias corridos ou até a revisão humana, o que ocorrer primeiro |
| Descarte definido | ✅ | Seção 3.2 — remoção do arquivo/artefatos, responsável: o próprio responsável pelo projeto |
| Revisão humana definida | ✅ | Seção 3.2 — o responsável pelo projeto revisa antes de qualquer promoção |
| Proibições confirmadas | ✅ | Seções 2 e 6 — sem publicação/corpus/produção; sem texto literal extenso |
| Obra/edição definida | ⬜ | título, editora, edição, componente curricular, PNLD/ano — depende do usuário |
| Arquivo identificado | ⬜ | identidade do arquivo, hash/versão, origem — depende do usuário |
| Parte única delimitada | ⬜ | uma parte editorial (nunca a obra inteira) — depende do usuário |
| Páginas físicas delimitadas | ⬜ | intervalo exato autorizado — depende do usuário |

**A Etapa 0 só é considerada concluída quando todos os itens acima estiverem ✅.** 7/11 itens já
estão concluídos. Os 4 itens restantes exigem que o usuário forneça o arquivo real e delimite a
obra/parte/páginas — não podem ser preenchidos por decisão técnica. Enquanto houver qualquer ⬜
nesta etapa, nenhuma etapa abaixo pode começar (Nível B ainda não elegível).

## Etapa 1 — Cartografia preliminar da parte

| Item | Status | Nota |
|---|---|---|
| Arquivo depositado em `private-inputs/pnld` (fora do Git) | ⬜ | |
| Identidade do arquivo e assinatura mínima confirmadas | ⬜ | |
| Reconhecimento estrutural aplicado à janela inicial | ⬜ | sumário, organização da obra, paginação |
| Mapa candidato da parte produzido | ⬜ | árvore editorial preliminar |

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
