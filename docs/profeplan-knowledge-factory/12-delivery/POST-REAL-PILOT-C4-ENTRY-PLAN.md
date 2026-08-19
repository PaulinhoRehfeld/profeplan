# Plano de entrada pós-piloto — C.4 mínimo

Data: 19 de agosto de 2026.

Status: **pré-planejado e bloqueado pelo gate material do primeiro piloto real**.

Este documento existe para evitar nova pausa de planejamento caso o PR #125 conclua VERDE. Ele não abre C.4 antecipadamente e não autoriza implementação antes dos gates abaixo.

## 1. Condições de entrada

C.4 mínimo torna-se elegível somente quando:

1. o teste material do primeiro piloto real for uma execução válida;
2. o resultado for classificado VERDE pelo `REAL-PILOT-RESULT-DECISION-PROTOCOL.md`;
3. seletividade 34–35, dupla paginação e hierarquia estiverem comprovadas;
4. as provas sintéticas permanecerem verdes;
5. a revisão humana resumida registrar `aprovado`;
6. o PR #125 estiver integrado à `main`;
7. não existir finding jurídico, de copyright ou de governança que bloqueie continuidade.

Até lá, este plano permanece dormente.

## 2. Pergunta arquitetônica de C.4

A pergunta seguinte não será “como entender todo o livro?” nem “como criar a ontologia completa?”.

Será:

> Qual é a menor superfície formal de C.4 necessária para transformar uma cartografia candidata de uma parte em estrutura editorial confirmada/corrigida, mantendo evidência, limites e procedência, sem destilar ainda conhecimento pedagógico canônico?

## 3. Fronteira de responsabilidade

C.4 mínimo deve possuir apenas autoridade para:

- confirmar ou corrigir a árvore preliminar dentro de uma parte delimitada;
- confirmar limites editoriais da parte;
- reconciliar Sumário, corpo e dupla paginação;
- classificar elementos editoriais observados por função;
- preservar ancestralidade `obra → unidade → capítulo → seção/...`;
- manter evidência/localizadores para cada confirmação/correção;
- produzir mapa estrutural revisável.

C.4 mínimo não terá autoridade para:

- transformar conceito em componente pedagógico canônico;
- deduplicar conhecimento entre obras;
- decidir alinhamento curricular normativo;
- criar embeddings;
- construir retrieval/RAG;
- consolidar grafo global;
- produzir material para professor;
- processar automaticamente a obra inteira.

Essas responsabilidades permanecem em C.5+ ou fases posteriores.

## 4. Reutilização obrigatória do que já foi provado

A entrada em C.4 deverá começar reaproveitando, não substituindo:

- `CartographicPartScope` como fronteira operacional;
- `StructuralRecognitionService` como cartografia preliminar;
- `PartReconstructionService` como prova C.4-local candidata;
- dupla paginação física/impressa;
- evidências/localizadores existentes;
- estados candidatos do protocolo estrutural;
- provas verticais `Introdução`, `Unidade 1 → Capítulo 1` e piloto real.

Nenhum novo parser, provider, OCR ou runtime deve ser introduzido apenas porque o lote recebeu o nome C.4.

## 5. Primeira inspeção obrigatória após VERDE

Antes de código novo, comparar a superfície C.4-local já existente com as responsabilidades formais do Blueprint e produzir uma tabela de três colunas:

| Responsabilidade C.4 | Já comprovada? | Gap real mínimo |
|---|---|---|
| confirmar/corrigir árvore preliminar | sim/parcial/não | evidência |
| segmentar por fronteira editorial | sim/parcial/não | evidência |
| classificar elementos por função | sim/parcial/não | evidência |
| reconciliar Sumário/título/corpo | sim/parcial/não | evidência |
| preservar dupla paginação | sim/parcial/não | evidência |
| produzir mapa revisável | sim/parcial/não | evidência |

Se nenhuma lacuna material exigir contrato novo, não criar contrato novo por simetria arquitetônica.

## 6. Menor pacote de entrega elegível

Se a inspeção confirmar que C.4-local cobre a maior parte da necessidade, o primeiro pacote de C.4 deverá ser pequeno e vertical:

### C.4.1 — fronteira executável

- congelar a entrada e a saída mínimas;
- registrar estados `candidate → confirmed/corrected/rejected` somente se já suportados ou realmente necessários;
- explicitar que confirmação exige evidência no corpo/estrutura;
- proibir promoção sem revisão quando confiança/evidência forem insuficientes.

### C.4.2 — confirmação de uma parte real

Usar a mesma seção do piloto como prova inicial de confirmação estrutural:

```text
Unidade 1 — Antropologia
└── Capítulo 1 — O pensamento antropológico
    └── Evolucionismo social
```

Não selecionar outra obra antes de provar que a passagem candidata → confirmada funciona no exemplo já governado.

### C.4.3 — correção negativa

Adicionar um caso sintético pequeno em que a cartografia preliminar contenha um limite/tipo incorreto e C.4 precise corrigi-lo com evidência. Esse teste só é elegível porque representa comportamento novo: **correção**, não uma terceira repetição de reconstrução bem-sucedida.

### C.4.4 — revisão e mapa resultante

Produzir mapa estrutural revisável da parte com:

- ancestralidade;
- limites físicos;
- labels impressos;
- elementos estruturais;
- evidência/localizadores;
- estado de confirmação/correção;
- warnings.

Sem texto integral persistido.

## 7. Critérios de aceite de C.4 mínimo

1. não lê profundamente fora do `CartographicPartScope` sem âncora explícita;
2. não transforma a obra inteira em unidade de contexto;
3. confirma ou corrige hierarquia com evidência;
4. preserva física ↔ impressa;
5. distingue observação, candidato e confirmação;
6. não inventa heading/atividade/tipo sem evidência;
7. mantém procedência até página/localizador;
8. não exige OCR para o Livro 0 se a camada nativa continuar suficiente;
9. não cria dependência em uma editora/coleção;
10. mantém C.5 e conhecimento pedagógico canônico fora da fronteira;
11. mantém regressões anteriores verdes;
12. produz saída pequena o suficiente para revisão humana.

## 8. Estratégia de execução rápida

Para evitar que C.4 mínimo ocupe várias conversas sem necessidade, a sequência recomendada é:

```text
inspeção read-only da superfície C.4-local
  ↓
tabela gap real
  ↓
definição curta da fronteira
  ↓
testes do comportamento faltante
  ↓
menor implementação necessária
  ↓
prova na mesma parte real
  ↓
revisão
  ↓
integração
```

Definição e implementação podem permanecer no mesmo PR quando:

- o contrato público não muda;
- o gap é localizado;
- os testes tornam a fronteira inequívoca;
- não surge migração, persistência hospedada ou efeito de produção.

Separar PRs apenas se a inspeção revelar mudança de contrato, schema, segurança ou responsabilidade arquitetônica.

## 9. O que vem depois de C.4 mínimo

Somente depois de C.4 demonstrar confirmação/correção estrutural de parte real será elegível definir C.5 de forma igualmente pequena.

A primeira pergunta de C.5 deverá ser sobre **contribuições e relações candidatas apoiadas por evidência dentro de uma parte confirmada**, não sobre grafo global, embeddings ou corpus completo.

C.6, C.7 e Fase D continuam bloqueados até seus próprios gates.

## 10. Regra de não antecipação

Este plano prepara velocidade futura, mas não autoriza o futuro por antecedência.

Enquanto o piloto real do PR #125 não estiver VERDE e integrado:

- não abrir branch técnica C.4;
- não modificar contratos C.4;
- não criar ontologia nova;
- não mover dados para corpus;
- não processar outra obra;
- não reabrir C.3.6 automaticamente.
