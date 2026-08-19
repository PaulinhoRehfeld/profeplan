# Protocolo de decisão — resultado do primeiro piloto real por parte

Data: 19 de agosto de 2026.

Status: **protocolo preparado; dormente até a execução material do teste real**.

PR de referência: #125.

Artefato governado: `Do seu jeito — Sociologia`, SHA-256 `1e7f8d613fdb43a49d4a1f0a031465784b03b31b1d22e1779d279365ad82e39a`.

Parte governada: `Unidade 1 — Antropologia → Capítulo 1 — O pensamento antropológico → Evolucionismo social`, físicas 34–35 / impressas 33–34.

## 1. Finalidade

Este protocolo elimina uma nova rodada de planejamento depois que o teste material for executado. O objetivo é permitir que o resultado seja classificado imediatamente e que a próxima ação já esteja determinada, sem ampliar escopo por impulso e sem transformar uma divergência localizada em nova infraestrutura.

A pergunta continua sendo somente:

> O mecanismo `cartografia preliminar → CartographicPartScope → inspeção seletiva → reconstrução candidata` consegue operar sobre a parte real governada preservando identidade, limites, dupla paginação, hierarquia e evidências sem tratar a obra inteira como contexto?

Este documento não autoriza corpus, chunks, embeddings, retrieval/RAG, grafo global, C.5–C.7, produção ou publicação do PDF.

## 2. Pré-condição de validade da execução

Uma execução só produz resultado arquitetônico classificável se:

1. o checkout executado corresponder ao HEAD governado do PR #125 ou a um descendente explicitamente documentado;
2. `PROFEPLAN_REAL_PILOT_PDF` apontar para o arquivo local fora do Git;
3. o SHA-256 calculado for exatamente o digest governado;
4. as dependências do repositório estiverem resolvidas localmente;
5. o teste usar o `PdfJsDocumentInspectorAdapter`, o `StructuralRecognitionService` e o `PartReconstructionService` reais;
6. não houver substituição manual do resultado por transcrição, fixture ou mock do livro.

Falha de instalação, path, permissão, runtime, dependência ou binário incorreto é **execução inválida**, não evidência de falha arquitetônica. Corrige-se apenas o ambiente e repete-se o mesmo teste antes de classificar o mecanismo.

## 3. Evidência mínima a registrar

Sem reproduzir conteúdo protegido, registrar:

- commit/SHA do código executado;
- digest SHA-256 do PDF;
- total físico observado;
- resultado global do teste;
- faixas cartográficas inspecionadas;
- faixa solicitada pela reconstrução profunda;
- correspondência física ↔ impressa da parte;
- nós hierárquicos encontrados e seus estados;
- tipos de elementos/relações produzidos, sem transcrição extensa;
- warnings ou divergências;
- regressões sintéticas, se houver;
- classificação final deste protocolo.

Não registrar no Git:

- PDF;
- páginas renderizadas;
- imagens extraídas;
- texto integral da parte;
- trechos extensos protegidos;
- cópia de artefatos temporários do livro.

## 4. Resultado VERDE

Classificar como **VERDE** somente quando todos os invariantes materiais relevantes forem confirmados:

1. SHA-256 correto;
2. 449 páginas físicas;
3. cartografia seletiva, menor que a obra inteira;
4. Sumário e entradas fragmentadas reconhecidos sem regra específica da coleção;
5. Unidade 1 na física 29 / impressa 28;
6. Capítulo 1 na física 31 / impressa 30, filho da Unidade 1;
7. `Evolucionismo social` filho do Capítulo 1;
8. parte delimitada nas físicas 34–35;
9. início impresso 33 e preservação 34→33, 35→34;
10. reconstrução profunda solicita **exatamente uma faixa 34–35**;
11. nenhuma evidência da reconstrução profunda vem de fora do `CartographicPartScope`;
12. título da seção é corroborado no corpo;
13. elementos e relações possuem evidência rastreável;
14. nós cartográficos não são promovidos indevidamente a conhecimento pedagógico canônico;
15. contratos permanecem `1.0.0`;
16. provas sintéticas e CI permanecem sem regressão.

### Ações automáticas permitidas após VERDE

Sem nova rodada de planejamento arquitetônico:

1. registrar a evidência mínima no documento do piloto;
2. fechar tecnicamente a Etapa 2 do roadmap;
3. marcar como comprovados os critérios técnicos da Etapa 3 que o teste efetivamente cobre;
4. registrar classificação arquitetônica **B — pequena generalização**, salvo nova evidência contrária;
5. executar revisão humana do resultado resumido;
6. atualizar Checkpoint 053 ou criar o checkpoint seguinte apenas se houver novo marco real;
7. manter o PR #125 como Draft até essa revisão;
8. se revisão humana = `aprovado` e todos os checks estiverem verdes, tornar o PR #125 pronto para revisão/integração;
9. após integração do #125, tornar elegível a entrada mínima em C.4 descrita em `POST-REAL-PILOT-C4-ENTRY-PLAN.md`.

VERDE **não** autoriza saltar diretamente para C.5, corpus ou embeddings.

## 5. Resultado AMARELO

Classificar como **AMARELO** quando a arquitetura central continuar válida, mas existir uma divergência limitada e reproduzível que impeça declarar todos os invariantes verdes.

Exemplos:

- uma entrada lógica do Sumário exige recomposição genérica adicional;
- o mapeamento de `PageLabels` exige ajuste localizado sem alterar o modelo de dupla paginação;
- um limite editorial real está correto conceitualmente, mas o reconhecimento usa uma representação técnica não coberta;
- a reconstrução encontra a parte correta, porém classifica um elemento local de modo incompleto;
- existe warning que não exige OCR geral, obra inteira, novo provider ou mudança de contrato.

### Regra AMARELO

Antes de alterar código, registrar uma frase causal no formato:

```text
observação real → hipótese técnica → menor superfície responsável → teste que reproduz
```

Depois:

1. adicionar ou ajustar o menor teste que reproduza a divergência;
2. alterar somente a menor superfície responsável;
3. manter contratos `1.0.0` quando o comportamento puder ser generalizado internamente;
4. preservar as provas sintéticas existentes;
5. repetir CI e o teste material do mesmo SHA;
6. reclassificar como VERDE, AMARELO ou VERMELHO.

### O que AMARELO não autoriza

- framework genérico preventivo;
- nova ontologia ampla;
- processamento da obra inteira;
- OCR geral;
- provider multimodal novo sem necessidade demonstrada;
- reabertura automática do PR #110;
- C.5/C.6/C.7;
- persistência nova ou produção.

## 6. Resultado VERMELHO

Classificar como **VERMELHO** quando algum princípio arquitetônico central for violado ou quando a correção necessária deixar de ser pequena/local.

São sinais vermelhos:

- o mecanismo precisar ler a obra inteira para delimitar a parte;
- reconstrução profunda solicitar páginas fora do escopo sem âncora objetiva;
- não ser possível preservar a dupla paginação com evidência;
- a hierarquia depender de inferência sem evidência editorial/corporal suficiente;
- a correção exigir regra específica para título/editora/coleção;
- a solução exigir alteração ampla de contrato antes de compreender a causa;
- surgirem cópias persistentes ou exposição indevida do conteúdo protegido;
- a correção proposta misturar C.3/C.4 com C.5, corpus, retrieval ou produção.

### Ação VERMELHO

1. parar a promoção do PR #125;
2. preservar somente a evidência mínima segura da falha;
3. classificar a origem primária em uma das categorias: `artifact_identity`, `cartography`, `page_mapping`, `scope_boundary`, `reconstruction`, `evidence`, `governance`;
4. não implementar solução ampla na mesma tacada;
5. abrir uma definição corretiva curta contendo causa, impacto, alternativa mínima e novo gate;
6. somente depois criar a correção e repetir a mesma prova real.

VERMELHO é uma descoberta arquitetônica, não justificativa para aumentar infraestrutura preventivamente.

## 7. Execução INVÁLIDA

`INVÁLIDA` não é quarta classificação arquitetônica. É um estado operacional anterior à classificação.

Exemplos:

- arquivo ausente;
- SHA divergente;
- pacote não instalado;
- Node/pnpm incompatível;
- path incorreto;
- permissão local;
- teste real em `skip` porque a variável não foi fornecida.

Nesses casos, corrigir apenas o runtime e repetir. Não alterar serviço de produção para resolver um problema de ambiente.

## 8. Matriz de decisão rápida

| Resultado | Arquitetura principal | Próxima ação | Pode integrar #125? | Pode abrir C.4 mínimo? |
|---|---|---|---|---|
| INVÁLIDA | não avaliada | corrigir runtime e repetir | não | não |
| VERDE | comprovada no piloto | registrar, revisar, integrar | após revisão/checks | após integração |
| AMARELO | válida com gap localizado | teste mínimo → correção mínima → repetir | não ainda | não ainda |
| VERMELHO | princípio/gate violado | parar, classificar causa, redefinir gate | não | não |

## 9. Regra de custo e velocidade

O piloto deve economizar ciclos de desenvolvimento, não produzir microgovernança.

- Não criar documento novo para cada comando ou reexecução.
- Não repetir CI sem alteração material.
- Não criar terceira fixture sintética salvo risco novo real.
- Não consultar repetidamente status de workflow em execução.
- Não abrir infraestrutura preventiva para cenários ainda não observados.
- Se o resultado for VERDE, seguir diretamente a sequência deste protocolo.
- Se for AMARELO, limitar a correção à causa observada.
- Se for VERMELHO, investir primeiro em diagnóstico, não em código.

## 10. Encerramento deste protocolo

Este protocolo se considera consumido quando uma execução válida do piloto real tiver classificação registrada e a decisão correspondente tiver sido aplicada.

Até lá, ele é preparação operacional e não altera o estado arquitetônico da Fase C.
