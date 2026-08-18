# Primeiro piloto real — reconstrução vertical de uma única parte

Data: 18 de agosto de 2026.

Base de abertura: `main@cfe7ad72701c57c5a38f39c0f1d539557f029a2f`.

## 1. Pergunta arquitetônica

Este piloto responde somente:

> O mecanismo `cartografia preliminar -> CartographicPartScope -> inspeção seletiva -> reconstrução candidata`, já comprovado em duas estruturas sintéticas, consegue reconstruir uma parte de um PDF editorial real preservando limites, dupla paginação, hierarquia e evidências sem transformar a obra inteira em contexto?

O piloto não inaugura corpus nem processamento em escala.

## 2. Artefato real autorizado

Obra delimitada para o ensaio:

- título: `Português: Conexão e Uso`;
- editora: Editora do Brasil;
- coleção: `Conexão e Uso`;
- disciplina: Língua Portuguesa;
- ano: 7º ano;
- volume: 1;
- identificação editorial informada: `PNLD 2023 OBJETO 2`;
- arquivo de trabalho: `PNLD_2023_OBJETO_2_7_ANO_EF_AI_LINGUA_PORTUGUESA_VOLUME_1_WF1.pdf`;
- total físico esperado: 41 páginas.

A autorização desta prova é exclusivamente técnica e temporária. Ela não autoriza publicação, redistribuição, corpus, treinamento, indexação ou retenção permanente do PDF.

O binário protegido **não deve ser commitado** no repositório.

## 3. Parte escolhida

Escopo profundo único:

```text
Unidade 1 – No mundo da fantasia
páginas físicas: 9–14
páginas impressas esperadas: 7–12
```

O sumário/índice foi previamente localizado na página física 6 e funciona como evidência cartográfica inicial, não como conteúdo profundo da parte.

O piloto não autoriza reconstrução semântica das demais unidades.

## 4. Envelope operacional Nível B

### Entrada temporária

O teste lê o PDF somente a partir do caminho informado por:

```text
PROFEPLAN_REAL_PILOT_PDF
```

Opcionalmente, o operador pode fixar o digest esperado em:

```text
PROFEPLAN_REAL_PILOT_SHA256
```

Se o digest for informado e não coincidir, o teste falha antes da cartografia.

### Retenção

Não reter:

- PDF bruto;
- cópia do livro;
- imagens extraídas;
- texto integral;
- corpus ou chunks.

Pode permanecer como evidência mínima do piloto:

- SHA-256 calculado no momento da execução;
- identidade bibliográfica necessária;
- faixa física e labels impressos;
- tipos de elementos e relações candidatas;
- localizadores/evidências;
- warnings e classificação arquitetônica A/B/C/D;
- resultado dos testes e CI sem reprodução extensa do conteúdo protegido.

### Descarte

O arquivo temporário é responsabilidade do ambiente que o disponibiliza. O teste não cria cópia persistente nem artifact de CI e não faz upload do PDF.

## 5. Critérios executáveis

O teste real passa somente se demonstrar, no mínimo:

1. o artefato possui 41 páginas físicas;
2. a inspeção preliminar encontra a região de sumário incluindo a física 6;
3. a cartografia produz candidato para `Unidade 1 – No mundo da fantasia`;
4. a Unidade 1 fica delimitada nas físicas 9–14;
5. o início impresso declarado é `7`;
6. a reconstrução profunda usa `CartographicPartScope` 9–14;
7. as páginas 9–14 preservam labels impressos esperados 7–12;
8. qualquer página externa inspecionada pela reconstrução pertence somente a região auxiliar já cartografada e possui justificativa estrutural objetiva;
9. o título da parte é corroborado no corpo;
10. todos os elementos e relações produzidos possuem evidência;
11. nós cartográficos permanecem em estados candidatos, nunca `confirmed`;
12. `STRUCTURAL_RECOGNITION_CONTRACT_VERSION` e `PART_RECONSTRUCTION_CONTRACT_VERSION` permanecem `1.0.0` enquanto nenhuma necessidade contratual nova for demonstrada;
13. as duas provas sintéticas existentes continuam sem regressão.

O teste não exige `warnings = []`: warnings reais são evidência diagnóstica. Porém falhas nos invariantes acima classificam o piloto como B, C ou D em vez de serem mascaradas.

## 6. O que o piloto pretende descobrir

O PDF real pode revelar, entre outros:

- entradas de sumário fragmentadas em múltiplos objetos de texto;
- ausência ou inadequação de `PDF PageLabels`;
- títulos quebrados;
- headers/footers repetidos;
- ordem de leitura inadequada;
- múltiplas colunas;
- boxes e elementos editoriais;
- múltiplos XObjects;
- necessidade localizada de observabilidade física adicional.

Nenhuma dessas hipóteses justifica alteração antecipada.

## 7. Classificação do resultado

### Resultado A — generaliza bem

Pouca ou nenhuma alteração além da própria prova.

### Resultado B — pequena generalização

Necessidade localizada e orientada por evidência, sem redesenho do modelo.

### Resultado C — parser/inspector insuficiente

A observabilidade física do PDF não fornece a informação necessária. Melhorar seletivamente a camada de inspeção antes de alterar a reconstrução.

### Resultado D — modelo estrutural insuficiente

A estrutura real não cabe nas abstrações atuais. Parar e reconsiderar o modelo antes de acumular regras especiais.

## 8. Estado de execução desta branch

A preparação do piloto pode ser versionada sem o PDF. A execução material real exige que o artefato autorizado esteja temporariamente disponível ao runtime.

Nesta abertura, o compartilhamento remoto anteriormente usado para o PDF não estava acessível pelos conectores disponíveis. Portanto, **não registrar falsamente o piloto como executado ou verde** até que `PROFEPLAN_REAL_PILOT_PDF` aponte para o binário real autorizado e o teste tenha efetivamente rodado.

## 9. Escopo negativo

Sem:

- commit do PDF real;
- obra inteira como contexto semântico;
- outra obra ou coleção;
- corpus;
- chunks;
- embeddings;
- retrieval/RAG;
- grafo global;
- validação semântica BNCC;
- OCR geral;
- interpretação multimodal profunda;
- migration, RPC ou nova persistência;
- Supabase/Storage hospedado para o conteúdo;
- runtime multiagente;
- reabertura do PR nº 110;
- PR nº 99;
- produção.

## 10. Próxima decisão

Depois da primeira execução contra o binário real:

1. registrar o SHA-256 e os invariantes observados sem copiar conteúdo integral;
2. classificar A/B/C/D;
3. implementar somente a menor correção demonstrada, se houver;
4. repetir a mesma prova real;
5. somente após resultado estável decidir se C.3.6, multimodal/OCR localizado ou outra fronteira merece ser aberta.
