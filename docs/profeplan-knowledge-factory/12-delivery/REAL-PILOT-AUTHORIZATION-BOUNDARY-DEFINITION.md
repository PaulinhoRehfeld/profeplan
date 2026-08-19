# Piloto real controlado — definição da fronteira jurídica e operacional (pré-C.3.8)

Data da definição: 19 de agosto de 2026.

Base canônica de referência: `main@c943241f218cbebf65184cb6315c8fbae0fd9eb1` (estado registrado no
Checkpoint 051).

## Status

**Documento de definição, ainda sem autorização de execução.** Este documento não inicia o piloto
real. Ele apenas delimita, em conformidade com o Checkpoint 051 (`../00-governance/CONTINUITY-CHECKPOINT-051.md`,
seção 8) e com a `RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md`, os campos que uma autorização de
Nível B precisa preencher antes que qualquer parte real seja processada.

Não há, no momento desta definição, nenhum arquivo real em `private-inputs/pnld`. Portanto nenhuma
execução de Nível B é elegível ainda; apenas o trabalho documental de Nível A abaixo.

## 1. Por que este documento existe agora

O Checkpoint 051 e o `BLUEPRINT.md` (seção 14) registram, de forma explícita, que:

- a segunda prova vertical (`Unidade 1`) confirmou generalização mínima suficiente do mecanismo de
  cartografia + reconstrução local;
- não há justificativa para uma terceira prova sintética por rotina;
- o próximo avanço material é preparar uma fronteira jurídica e operacional separada para um
  piloto controlado sobre **uma única parte real, juridicamente autorizada**.

Redigir essa fronteira é trabalho documental (Nível A). Processar o conteúdo real em si é Nível B e
exige autorização humana explícita e específica antes da execução, conforme
`../00-governance/RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md`.

## 2. Escopo material a ser preenchido antes da autorização

Antes de qualquer execução, os campos abaixo devem estar preenchidos e confirmados por quem detém
autoridade jurídica sobre o material:

| Campo | Descrição | Preenchido? |
|---|---|---|
| Obra/edição | título, editora, edição, componente curricular, PNLD/ano | ⬜ pendente |
| Base jurídica | licença, autorização de uso, ou titularidade que legitima o processamento | ⬜ pendente |
| Arquivo | identidade do arquivo, hash/versão, origem | ⬜ pendente |
| Parte única | uma parte editorial delimitada (ex.: uma introdução, um capítulo) — nunca a obra inteira | ⬜ pendente |
| Páginas físicas | intervalo exato de páginas físicas autorizadas para leitura profunda | ⬜ pendente |
| Ambiente | ambiente temporário e descartável, não produtivo, isolado do restante do sistema | ⬜ pendente |
| Retenção | prazo máximo de retenção do arquivo/artefatos derivados | ⬜ pendente |
| Descarte | mecanismo e responsável pelo descarte ao final do prazo | ⬜ pendente |
| Revisão | quem revisa humanamente o resultado antes de qualquer uso posterior | ⬜ pendente |
| Proibições | proibição explícita de publicação, corpus, produção ou reuso fora do piloto | ⬜ pendente |

## 3. Regras que já se aplicam independentemente do preenchimento

Estas regras já são vinculantes por herança de C.1, C.2 e da governança proporcional ao risco, e não
dependem de nenhuma decisão nova:

1. a parte candidata deve ser exatamente uma, nunca a obra inteira (`PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md`);
2. permissão de uso é histórica, temporal, escopada e revogável (`LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`);
3. autorização técnica não substitui autorização de negócio;
4. nenhum dado pessoal, de estudante, laudo ou nota real pode fazer parte do piloto (Nível C, fora de escopo);
5. nenhuma infraestrutura de produção, Supabase/Storage hospedado produtivo ou secret pode ser usada;
6. nenhum runtime multiagente, corpus, embeddings/retrieval ou publicação externa é autorizado neste piloto;
7. o material real, se e quando fornecido, deve permanecer fora do repositório Git, em
   `private-inputs/pnld`, conforme a separação já estabelecida no ambiente local.

## 4. Sequência operacional após autorização (não iniciar antes)

Somente após os campos da seção 2 estarem preenchidos e uma autorização humana explícita e
específica de Nível B ter sido concedida para esta fronteira:

```text
1. depositar o arquivo único autorizado em private-inputs/pnld (fora do Git)
2. confirmar identidade do arquivo e assinatura mínima de formato
3. aplicar o protocolo de reconhecimento estrutural (cartografia preliminar) apenas à janela
   inicial necessária
4. selecionar a parte única já delimitada na autorização
5. extrair nativamente apenas essa parte (C.3.3), respeitando páginas autorizadas
6. reconstruir estruturalmente a parte (C.4-local) sem tratar o livro inteiro como unidade
7. revisão humana do resultado antes de qualquer promoção ou reuso
8. ao fim do prazo de retenção, descartar o arquivo e os artefatos temporários conforme definido
   na seção 2
```

Nenhuma etapa desta sequência deve ser executada antes da autorização explícita mencionada acima.

## 5. Fora de escopo (reforço)

- obra inteira;
- OCR ou novo provider sem necessidade demonstrada;
- Supabase/Storage hospedado de produção;
- persistência permanente além do ambiente descartável do piloto;
- embeddings, retrieval, corpus, C.5–C.7 técnicos;
- runtime multiagente;
- qualquer efeito público, comercial ou de produção.

## 6. Próximo passo real

Este documento fica pronto para revisão. O avanço seguinte depende de uma decisão humana explícita:
fornecer os dados da seção 2 e autorizar formalmente o piloto de Nível B, ou manter a Fase C parada
neste ponto até que essa autorização exista.

Nenhum arquivo real deve ser processado, e nenhuma etapa da seção 4 deve começar, sem essa decisão.
