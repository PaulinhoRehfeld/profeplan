# CONTINUITY CHECKPOINT 051 — duas provas verticais integradas e generalização mínima comprovada

**Data:** 18 de agosto de 2026

## 1. Estado canônico

Repositório: `PaulinhoRehfeld/profeplan`

```text
main:   c943241f218cbebf65184cb6315c8fbae0fd9eb1
tree:   df26a01e61d0aa515ac41ba028073adc0114451a
parent: abe7997257ab0d832536a19a4431acf674a43783
```

Commit:

`feat(knowledge-factory): reconstruct Unit 1 vertically (#116)`

O commit possui assinatura GitHub válida e um único parent.

## 2. Integrações que compõem o marco

- PR nº 111 — reconciliação da Fase C em torno da cartografia vertical;
- PR nº 112 — contrato de reconhecimento estrutural;
- PR nº 113 — golden sample e cartografia preliminar;
- PR nº 114 — primeira prova vertical da Introdução;
- PR nº 116 — segunda prova vertical da Unidade 1.

O hotfix comercial PR nº 115 entrou na `main` entre as frentes da Knowledge Factory e já está
preservado na ancestralidade do estado atual.

## 3. Evidência pré-merge do PR nº 116

HEAD auditado:

`c9c6ea9591c6d2ef2e59f85f267196cc4c5bb610`

Comparação:

- 1 commit à frente;
- 0 atrás;
- 5 arquivos;
- 326 adições;
- 9 deleções;
- nenhum arquivo fora de documentação, Knowledge Factory e contrato compartilhado autorizado.

Gates verdes do HEAD:

- CI Pipeline nº 688;
- Knowledge Factory C.2.6 Closure CI nº 57;
- Knowledge Factory C.1.5 Lifecycle CI nº 126.

Após o squash, nenhuma nova execução de workflow foi emitida para o SHA canônico nas consultas
realizadas. Este checkpoint não atribui falsamente um CI pós-merge inexistente; registra os gates do
HEAD auditado e a identidade/diff do squash.

## 4. Primeira prova — Introdução

Escopo profundo:

```text
páginas físicas 11–13
```

Consulta auxiliar dirigida:

```text
página física 18 — região teacher_manual
```

Demonstrou títulos, subtítulos, texto, marcador visual, legenda, atividade, comando e orientação
docente relacionada, sem processar a obra inteira.

## 5. Segunda prova — Unidade 1

Escopo profundo:

```text
páginas físicas 14–17
Unidade 1
  -> Capítulo 1
```

Demonstrou:

- preservação de `chapter_heading` a partir da cartografia;
- continuidade do contexto do capítulo entre páginas;
- ausência de consulta ao Manual quando não há atividade reconhecida;
- inexistência de regressão na prova da Introdução;
- ausência de nova fixture, heurística ou redesenho do serviço.

## 6. Decisão

Resultado: **pequena generalização suficiente**.

O mecanismo não está restrito à Introdução. A cartografia e a reconstrução local funcionam para duas
partes estruturalmente distintas com correções mínimas orientadas por evidência.

Regras consolidadas:

1. livro é contêiner;
2. parte cartografada é unidade operacional;
3. tipos explícitos da cartografia são preservados;
4. contexto estrutural pode atravessar páginas dentro da parte;
5. texto sem evidência adicional permanece `body_text`;
6. região auxiliar só é consultada por âncora objetiva;
7. resultado permanece candidato e rastreável;
8. páginas não relacionadas não são lidas profundamente.

## 7. Estado de C.3.6

O PR nº 110 continua aberto, não integrado e suspenso. Não há autorização implícita para rebase,
correção ou merge. O primeiro piloto controlado deverá revelar quais capacidades de recovery,
concorrência e cleanup são realmente necessárias por parte.

## 8. Próxima fronteira

O próximo avanço material é preparar uma autorização Nível B para uma única parte real,
juridicamente autorizada, fixando escopo, páginas, ambiente temporário, retenção, descarte, revisão e
proibição de publicação/corpus.

Não iniciar por continuidade:

- obra inteira;
- OCR geral ou novo provider;
- Supabase/Storage hospedado para conteúdo real;
- persistência adicional;
- embeddings/retrieval;
- corpus;
- produção;
- runtime multiagente;
- dados pessoais ou sensíveis.

## 9. Continuidade

Este checkpoint substitui o Checkpoint 050 apenas para o estado corrente da cartografia e da
reconstrução vertical. O Checkpoint 050 continua sendo evidência histórica do fechamento de C.2.

A próxima conversa ou frente deve começar pela delimitação jurídica e operacional do piloto real,
não por uma terceira prova sintética automática.
