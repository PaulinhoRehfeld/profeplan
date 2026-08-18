# Lote C.3 — Extração e validação observável

Status reconciliado em 18 de agosto de 2026.

Base canônica de referência: `main@c7cea4b7d0e4c12182a28fa85a4a2ad8f57b282e`.

ADR de fronteira: [ADR-063](../00-governance/ADR-063-C3-EXTRACTION-VALIDATION-BOUNDARY.md).

Governança operacional: [execução proporcional ao risco](../00-governance/RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md).

Reconciliação arquitetônica:
[`PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md`](PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md).

## 1. Estado atual

```text
C.3.1 — integrado
C.3.2 — integrado
C.3.3 — integrado
C.3.4 — integrado
C.3.5 — integrado
C.3.6 — PR #110 aberto, não integrado, suspenso para reconciliação
C.3.7 — não iniciar
C.3.8 — não iniciar no desenho anterior
```

A infraestrutura já integrada de C.3.1–C.3.5 permanece válida. Esta atualização não realiza rollback nem reabre seus contratos sem necessidade demonstrada.

A progressão automática para C.3.6–C.3.8 foi interrompida porque a experiência prática mostrou que o caminho principal da obra precisa ser provado com **cartografia preliminar e processamento por partes** antes de novo hardening de exceções.

## 2. Objetivo

C.3 transforma um artefato governado e elegível de C.2 em evidência extraída observável, rastreável, mensurável e revisável.

C.3 responde:

> O que foi fisicamente observado e extraído, em qual parte/página/elemento, com qual método, cobertura, proveniência, autorização vigente e decisão de qualidade?

C.3 não responde como verdade canônica:

- qual é o significado pedagógico final de um trecho;
- qual hierarquia editorial está definitivamente confirmada;
- qual relação conceitual é válida;
- qual vínculo BNCC é normativamente correto;
- qual componente está pronto para retrieval.

Essas autoridades pertencem a C.4–C.7.

## 3. Correção de rota: C.3 não processa a obra cegamente

A fronteira semântica entre C.3 e C.4 permanece, mas a ordem operacional é reconciliada.

A interpretação anterior:

```text
C.3 processa o livro inteiro
  -> somente depois C.4 entende sua estrutura
```

não é mais válida.

Antes do aprofundamento, uma responsabilidade de coordenação cartográfica pode produzir **hipóteses estruturais rastreáveis** a partir de observações documentais como:

- filename;
- capa/folha de rosto;
- ficha catalográfica;
- organização da obra;
- sumário/índice;
- marcadores internos;
- títulos observados;
- paginação física/impressa;
- regiões identificadas do Manual do Professor.

Essas hipóteses orientam quais partes C.3 processa e em que ordem.

Elas **não substituem a confirmação estrutural de C.4**.

## 4. Fronteiras entre C.1, C.2, cartografia, C.3 e C.4

| Camada | Autoridade | Produz | Não produz |
|---|---|---|---|
| C.1 | identidade, direitos e vigência | fonte/versão/permissões | bytes, extração |
| C.2 | staging, integridade e handoff | artefato temporário, receipts, `APPROVED_FOR_EXTRACTION` | páginas, semântica |
| Coordenação cartográfica | hipótese operacional de estrutura | mapa preliminar, plano de partes, correspondência inicial de páginas | hierarquia canônica, componente |
| C.3 | evidência observável | páginas, texto, elementos, métricas, cobertura, qualidade | segmento semântico, conhecimento canônico |
| C.4 | estrutura confirmada | segmentos, hierarquia editorial confirmada, classificação estrutural | mutação da evidência histórica C.3 |

A coordenação cartográfica é responsabilidade transversal da Fase C. Não constitui um novo lote independente nem autoriza runtime agêntico.

## 5. Autoridade e pré-condições

C.3 somente opera quando:

- fonte/versão existem em C.1;
- `IngestionHandoffEvidence` de C.2 é válido;
- o artefato temporário permanece íntegro e legível;
- `purpose=extraction` está vigente;
- a operação respeita a fronteira de risco autorizada;
- a unidade de trabalho possui identificação suficiente para manter procedência.

Para execução orientada por parte, a unidade deve também possuir um **cartographic scope candidato**, contendo o necessário para delimitar a faixa sem afirmar semântica canônica.

O handoff de C.2 é necessário e insuficiente.

## 6. Identidade e escopo de parte

A identidade C.3 continua distinguindo:

- `extractionRunId`;
- `sourceId`;
- `sourceVersionId`;
- `ingestionRunId`;
- versão do handoff;
- digest do artefato;
- versão do contrato;
- método/versão do extrator;
- tentativa/recovery quando aplicável.

A evolução futura deverá permitir associar a execução a uma parte candidata sem tornar seu título ou posição identidade primária por conveniência.

Conceitualmente:

```text
ExtractionRun
  -> governed source/version
  -> artifact
  -> cartographic scope candidate
  -> observed pages/elements
```

O identificador da parte deve ser estável dentro do mapa preliminar e rastreável até sua origem.

## 7. Filename e metadados

Nome do arquivo pode ser observado como `filename_hint`, mas nunca vira identidade canônica.

A Knowledge Factory deverá manter distinção conceitual entre:

```text
filename_hints
observed/detected_metadata
canonical_metadata
```

C.3 pode registrar o que observou no artefato. Reconciliação bibliográfica completa permanece na governança apropriada.

## 8. Paginação física e impressa

C.3 pode registrar:

- índice físico da página no arquivo;
- número/rótulo impresso quando observável;
- método de observação;
- confiança;
- relação candidata entre ambas.

Não presumir `pdf_page == printed_page`.

Páginas preliminares, romanos, rótulos ausentes e deslocamentos são comportamento normal.

A correspondência final pode ser corrigida durante a reconstrução sem apagar a observação original.

## 9. Lifecycle

O lifecycle integrado permanece:

```text
REQUESTED
  -> READY
  -> EXTRACTING
  -> VALIDATING
  -> PENDING_REVIEW
  -> VALIDATED_FOR_SEGMENTATION
```

Saídas controladas:

- `REQUIRES_ALTERNATE_EXTRACTION`;
- `BLOCKED_AUTHORIZATION`;
- `REJECTED`;
- `FAILED`;
- `CANCELLED`.

Não existe estado durável `AUTHORIZED`.

Autorização deve ser reavaliada antes de:

1. claim;
2. abertura/retomada relevante do artefato;
3. finalização/handoff.

## 10. Porta de leitura

A porta read-only/provider-neutral permanece estreita:

- abrir stream/bytes por referência governada;
- obter metadados mínimos de integridade/retenção;
- revalidar digest/tamanho;
- fechar handle;
- distinguir indisponibilidade, expiração, integridade inválida e negação.

Não expõe URL pública, credencial ou listagem irrestrita.

## 11. Extração textual nativa

Texto nativo continua baseline.

O parser já comprovado em C.3.3 permanece base técnica para o golden sample e para a primeira prova vertical.

A extração deve ser executável sobre uma faixa/parte delimitada e não exige leitura semântica do arquivo inteiro.

C.3 pode observar:

- texto;
- linhas/blocos físicos;
- ordem observada;
- cabeçalho/rodapé/box/coluna quando detectados;
- relações físicas de tabelas quando expostas pelo adapter;
- marcadores de elementos visuais.

## 12. Cartografia candidata não é semântica canônica

Exemplo de observação permitida:

```text
source = table_of_contents
candidate_type = chapter
observed_title = "..."
printed_page = 42
confidence = ...
```

Isso não significa que C.3 “confirmou o capítulo”.

C.4 posteriormente confronta a hipótese com o corpo e decide confirmação/correção/rejeição.

Essa distinção resolve a contradição entre:

- cartografia antes da extração semântica integral;
- C.4 como autoridade estrutural.

## 13. Representação observável de elementos

C.3 deve preservar heterogeneidade física suficiente para que C.4 possa reconhecer funções posteriores.

Marcadores observáveis podem indicar candidatos físicos a:

- texto;
- título visual;
- box;
- tabela;
- imagem;
- gráfico;
- mapa;
- infográfico;
- legenda;
- nota;
- coluna.

C.3 não transforma automaticamente isso em categoria pedagógica canônica.

## 14. Elementos visuais e C.3.7

C.3.7 é reinterpretado como **recuperação multimodal e fallback visual governado**.

A futura decisão deverá avaliar três caminhos:

```text
texto nativo
  -> padrão

compreensão multimodal localizada
  -> visual/layout relevante

OCR localizado
  -> texto relevante não recuperável nativamente
```

OCR é técnica, não objetivo arquitetônico.

Antes da primeira prova vertical, nenhum provider/modelo visual novo deve ser introduzido.

O golden sample poderá usar descrições/fixtures sintéticas determinísticas para provar contratos sem conteúdo protegido.

## 15. Manual do Professor

Quando uma região de Manual do Professor for observada, C.3 deve preservar sua localização e evidência sem a misturar com o texto do aluno.

Relações pedagógicas como:

```text
atividade -> orientação -> resposta esperada
```

não são autoridade C.3, mas C.3 deve preservar evidência/localizadores suficientes para que C.4/C.5 possam construí-las posteriormente.

## 16. Declarações curriculares

C.3 pode observar códigos/textos curriculares declarados pela obra como conteúdo do documento.

Não valida BNCC.

A distinção futura deve preservar:

- declarado pela obra;
- detectado;
- proposto;
- validado normativamente;
- aprovado pelo curador.

## 17. Qualidade e cobertura

C.3.5 permanece responsável pela policy de qualidade de extração.

Métricas candidatas preservadas:

- páginas esperadas/abertas/extraídas/vazias/rejeitadas/pendentes;
- cobertura por método;
- caracteres inválidos;
- densidade/continuidade;
- ambiguidade de ordem;
- integridade tabular observável;
- falhas/retries;
- decisão humana.

### Cobertura por parte e obra

A reconciliação passa a distinguir:

```text
cobertura local da parte
cobertura acumulada da obra
```

Uma parte pode estar pronta para handoff estrutural local enquanto a obra global ainda está em processamento, desde que:

- a parte esteja claramente delimitada;
- suas páginas tenham decisão;
- sua proveniência esteja íntegra;
- o contrato C.4 aceite esse handoff incremental;
- não seja apresentada como “obra concluída”.

## 18. Handoff para C.4

O desenho anterior pressupunha predominantemente um snapshot final monolítico.

A evolução deve avaliar um **handoff incremental/versionado por parte**, sem remover a possibilidade de snapshot consolidado da obra.

Conceitualmente:

```text
ValidatedPartExtractionSnapshot
  -> source/version
  -> extraction run
  -> cartographic scope
  -> observed pages/elements
  -> coverage local
  -> quality decision

ConsolidatedWorkExtractionSnapshot
  -> conjunto ordenado/reconciliado de partes
  -> cobertura global
```

Os nomes finais dependem de contrato próprio; esta definição não cria tipos/código.

C.4 nunca muta evidência histórica C.3.

## 19. C.3.6 — recovery/concorrência/cleanup

O PR #110 está aberto e seu gate específico falhou; CI geral e DB CI foram bem-sucedidos, mas a prova C.3.6 encontrou incompatibilidade de fronteira ao tentar acionar `fail_extraction` pela RPC C.3.5.

Essa falha não será corrigida imediatamente.

Motivo arquitetônico: antes de cristalizar recovery, precisamos provar se a unidade operacional relevante é:

- run global;
- parte;
- batch;
- combinação hierárquica.

O conteúdo do PR #110 é preservado como candidato a hardening.

## 20. C.3.7 — não iniciar ainda

Não iniciar provider OCR ou multimodal por continuidade automática.

Primeiro executar golden sample + prova vertical.

Depois classificar lacunas reais:

- perda textual nativa;
- visual informacional;
- texto embutido em visual;
- tabela/layout;
- outras.

Somente então definir contrato/provedor/limites.

## 21. C.3.8 — redefinição necessária

C.3.8 não deve mais ser pensado apenas como:

```text
C.2 -> C.3 completo da obra -> handoff único C.4
```

O fechamento integrado deverá provar pelo menos:

1. cartografia preliminar;
2. seleção de parte;
3. extração nativa da parte;
4. persistência/cobertura local;
5. qualidade/revisão;
6. handoff incremental read-only para reconstrução;
7. consolidação posterior sem perda da cobertura global;
8. negativos de autorização e integridade.

Detalhes finais serão definidos depois da primeira prova vertical.

## 22. Golden sample

A próxima fixture deve ser inteiramente sintética e conter:

- filename informativo;
- capa/ficha;
- organização da obra;
- sumário;
- deslocamento de paginação;
- `Introdução`;
- títulos/subtítulos;
- texto sintético;
- visual sintético + legenda;
- atividade;
- orientação docente;
- declaração curricular;
- região final de Manual do Professor.

Nenhum conteúdo protegido será copiado.

## 23. Primeira prova vertical

Caminho obrigatório:

```text
arquivo sintético
  -> reconhecer metadados/pistas
  -> localizar sumário/organização
  -> reconciliar paginação
  -> produzir mapa candidato
  -> selecionar `Introdução`
  -> extrair somente a parte
  -> persistir/reconciliar evidência
  -> disponibilizar saída para reconstrução estrutural
```

A prova deve registrar o que não conseguiu resolver.

## 24. Definition of Ready do próximo desenvolvimento

Antes de código novo de cartografia/prova vertical:

- esta reconciliação documental deve estar revisada;
- contrato mínimo do mapa candidato deve estar delimitado;
- golden sample deve estar especificado;
- não deve haver dependência de conteúdo real;
- integração com o que já existe em C.3.3–C.3.5 deve ser explicitada;
- critérios de sucesso da `Introdução` devem estar definidos.

## 25. Definition of Done revisada para C.3

C.3 só será considerado fechado quando:

- C.3.1–C.3.5 permanecem comprovados;
- a extração orientada por parte estiver demonstrada;
- a relação com cartografia candidata e C.4 estiver contratualmente clara;
- coverage local/global puder ser reconciliado;
- recovery/cleanup tiver unidade operacional correta e prova correspondente;
- fallback multimodal/OCR tiver sido decidido com base em necessidade;
- handoff incremental/consolidado estiver definido e read-only;
- E2E sintético vertical estiver verde;
- conteúdo real usado, se houver, tiver autorização própria;
- nenhuma produção tiver sido antecipada.

## 26. Governança

Mantém-se execução proporcional ao risco:

- documentação/fixtures/testes sintéticos/correções dentro de escopo aprovado: Nível A;
- conteúdo real protegido, provider novo relevante ou infraestrutura hospedada de prova: Nível B quando aplicável;
- produção, secrets, dados sensíveis, efeitos financeiros/destrutivos: Nível C.

Não solicitar microautorização para cada correção técnica dentro da fronteira já aprovada.

## 27. Fora de escopo

Esta reconciliação não autoriza:

- PDF/livro real no pipeline;
- PNLD real;
- OCR real;
- modelo multimodal sobre conteúdo protegido;
- chunks/embeddings;
- C.5–C.7 técnicos;
- runtime multiagente;
- Supabase/Storage de produção;
- secrets;
- wiring de produção.

## 28. Próximo passo

Após integração documental:

```text
1. definir contrato do Protocolo de Reconhecimento Estrutural
2. criar golden sample
3. provar cartografia preliminar
4. provar Introdução verticalmente
5. revisar lacunas
6. decidir C.3.6
7. decidir multimodal/OCR
8. redefinir/fechar C.3.8
```

Síntese:

> **C.3 deve ser robusto para extrair a parte certa da obra certa; não apenas robusto para sobreviver a falhas enquanto processa páginas sem compreender a estrutura que deveria orientar o trabalho.**
