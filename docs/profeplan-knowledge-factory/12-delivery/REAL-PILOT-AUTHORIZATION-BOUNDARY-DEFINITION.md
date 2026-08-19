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

## 2. Natureza pretendida do uso (declaração do responsável pelo projeto, 19/08/2026)

O responsável pelo projeto declarou explicitamente a intenção de produto para este piloto e para a
Fase C como um todo:

> O sistema não usará o conteúdo das obras como cópia. O uso é referencial: o Sócrates/ProfePlan
> deve indicar ao professor **onde**, na obra que ele já possui e utiliza, está o conteúdo relevante
> para o que ele precisa — não reproduzir ou substituir esse conteúdo. A catalogação é de
> referência (localização, estrutura, cobertura), não de cópia.

Esta declaração é registrada aqui como decisão de produto/arquitetura e **reduz materialmente o
risco de redistribuição**, mas não substitui, sozinha, a confirmação de base jurídica exigida na
seção 3. Dois pontos permanecem verdadeiros ao mesmo tempo:

1. um sistema puramente referencial (ponteiros de localização, estrutura, cobertura — sem
   armazenar nem expor texto literal extenso da obra) é significativamente mais seguro do ponto de
   vista de direitos autorais do que um sistema que reproduz ou redistribui o conteúdo;
2. mesmo assim, C.2/C.3 exigem **ingerir e ler o arquivo real** para produzir esses ponteiros. Ler
   um exemplar da obra para indexá-la ainda pressupõe acesso legítimo a esse exemplar (compra,
   licença institucional, autorização do professor/escola detentor do PNLD, ou base legal
   equivalente). Este documento não tem autoridade para determinar sozinho se um uso específico se
   enquadra em alguma exceção de direito autoral aplicável; isso deve ser confirmado por quem
   detém a base jurídica antes da execução.

Consequência arquitetônica vinculante para qualquer implementação de C.3–C.7 sobre conteúdo real:

- persistir e expor apenas **estrutura, localização, metadados e trechos mínimos estritamente
  necessários** para orientar o professor (ex.: título de seção, número de página, resumo curto
  gerado, referência cruzada com o currículo) — nunca o texto integral de páginas, capítulos ou
  imagens da obra;
- qualquer trecho literal citado deve ser curto, com finalidade de localização/citação, e nunca
  substituir a leitura da obra pelo professor;
- nenhuma exportação, corpus ou API deve permitir reconstruir a obra a partir dos dados
  armazenados.

## 3. Escopo material a ser preenchido antes da autorização

Antes de qualquer execução, os campos abaixo devem estar preenchidos e confirmados por quem detém
autoridade jurídica sobre o material. A declaração da seção 2 esclarece a **finalidade** do
processamento; a declaração abaixo (3.1) endereça especificamente o campo "Base jurídica":

### 3.1 Base jurídica — declaração do responsável pelo projeto (19/08/2026)

> Os exemplares a serem utilizados são cópias às quais o responsável, na condição de professor,
> tem acesso liberado diretamente pelas editoras, mediante cadastro próprio junto a elas. As
> editoras incentivam esse acesso para consulta e elaboração de material didático. Os arquivos
> não são compostos apenas de imagens digitalizadas nem possuem marca d'água ou criptografia que
> restrinjam sua leitura/consulta.

Isso preenche o campo "Base jurídica" **para exemplares que atendam a essa descrição** (acesso
próprio do professor, liberado pela editora, para consulta/elaboração de material — não cópia de
terceiros nem material obtido fora desse canal). Continua valendo, por obra individual, que:

- cada exemplar efetivamente usado deve se enquadrar nessa descrição (acesso cadastrado próprio
  junto à editora daquela obra específica), não apenas em geral;
- a finalidade permanece estritamente referencial (seção 2) — a base jurídica de acesso ao
  exemplar não autoriza, por si só, redistribuição, republicação ou reprodução integral;
- esta é uma auto-declaração do responsável pelo projeto, registrada para fins de rastreabilidade
  documental; ela não constitui parecer jurídico independente.

| Campo | Descrição | Preenchido? |
|---|---|---|
| Obra/edição | título, editora, edição, componente curricular, PNLD/ano | ⬜ pendente — depende de uma obra real específica |
| Base jurídica | acesso próprio do professor, liberado pela editora mediante cadastro, para consulta/elaboração de material; arquivo sem watermark/criptografia — ver 3.1 | ✅ preenchido |
| Arquivo | identidade do arquivo, hash/versão, origem | ⬜ pendente — depende de uma obra real específica |
| Parte única | uma parte editorial delimitada (ex.: uma introdução, um capítulo) — nunca a obra inteira | ⬜ pendente — depende de uma obra real específica |
| Páginas físicas | intervalo exato de páginas físicas autorizadas para leitura profunda | ⬜ pendente — depende de uma obra real específica |
| Ambiente | ambiente temporário e descartável, não produtivo, isolado do restante do sistema — ver 3.2 | ✅ preenchido |
| Retenção | prazo máximo de retenção do arquivo/artefatos derivados — ver 3.2 | ✅ preenchido |
| Descarte | mecanismo e responsável pelo descarte ao final do prazo — ver 3.2 | ✅ preenchido |
| Revisão | quem revisa humanamente o resultado antes de qualquer uso posterior — ver 3.2 | ✅ preenchido |
| Proibições | proibição explícita de publicação, corpus, produção ou reuso fora do piloto; e proibição explícita de armazenar/expor texto literal extenso da obra (apenas referência) — já vinculante pelas seções 2 e 6 | ✅ preenchido |

### 3.2 Política operacional padrão (ambiente, retenção, descarte, revisão)

Estes quatro campos são decisões de processo, não fatos sobre uma obra específica, e por isso podem
ser definidos como política padrão do piloto, sem depender de um arquivo real já existir:

- **Ambiente:** pasta dedicada e efêmera `private-inputs/pnld/piloto-real/<slug-da-obra>/`, fora do
  Git, sem infraestrutura hospedada, sem Supabase/Storage de produção e sem cópia do arquivo fora
  dessa pasta. Processamento local, dentro deste workspace.
- **Retenção:** 30 dias corridos a partir do depósito do arquivo, ou até a conclusão da revisão
  humana (o que ocorrer primeiro). Qualquer prorrogação exige nova decisão explícita registrada
  neste documento.
- **Descarte:** remoção do arquivo físico e de todos os artefatos temporários da pasta dedicada,
  ao final do prazo de retenção ou logo após a revisão humana concluir, o que ocorrer primeiro.
  Responsável: o responsável pelo projeto, com a exclusão confirmada na Etapa 5 do
  [roadmap de execução](REAL-PILOT-EXECUTION-ROADMAP.md).
- **Revisão:** o responsável pelo projeto revisa o resultado (estrutura, referências e metadados
  produzidos) antes de qualquer promoção ou reuso. Nenhuma promoção automática é permitida.

Esta política é o padrão aplicável salvo decisão explícita em contrário registrada por obra.

## 4. Regras que já se aplicam independentemente do preenchimento

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

## 5. Sequência operacional após autorização (não iniciar antes)

Somente após os campos da seção 3 estarem preenchidos e uma autorização humana explícita e
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
   na seção 3
```

Nenhuma etapa desta sequência deve ser executada antes da autorização explícita mencionada acima.

## 6. Fora de escopo (reforço)

- obra inteira;
- OCR ou novo provider sem necessidade demonstrada;
- Supabase/Storage hospedado de produção;
- persistência permanente além do ambiente descartável do piloto;
- embeddings, retrieval, corpus, C.5–C.7 técnicos;
- runtime multiagente;
- qualquer efeito público, comercial ou de produção.

## 7. Próximo passo real

Restam quatro campos pendentes na seção 3, e todos dependem de uma obra real específica que ainda
não existe neste ambiente: **Obra/edição, Arquivo, Parte única e Páginas físicas**. Os demais
campos (base jurídica, ambiente, retenção, descarte, revisão, proibições) já estão preenchidos.

O avanço seguinte depende de uma decisão humana explícita fornecendo esses quatro dados e
autorizando formalmente o piloto de Nível B, ou manter a Fase C parada neste ponto até que essa
decisão exista.

Nenhum arquivo real deve ser processado, e nenhuma etapa da seção 5 deve começar, sem essa decisão.

A declaração de finalidade referencial (seção 2) já orienta, desde já, qualquer implementação
futura de C.5–C.7 sobre conteúdo real: essas camadas devem ser desenhadas para armazenar e expor
referências e estrutura, não texto integral da obra.
