# Lote C.4 mínimo — confirmação/correção estrutural de uma parte

Data: 19 de agosto de 2026.

Base de abertura: `main@d3fd27e2ea8f65b1e47fb27416814e89be5486e5`, após integração do PR #125 e primeiro piloto real VERDE.

## 1. Pergunta arquitetônica

> Qual é a menor superfície formal necessária para transformar uma reconstrução estrutural candidata de uma parte em decisão `confirmed`, `corrected` ou `rejected`, preservando a cartografia/reconstrução candidata como evidência histórica imutável?

## 2. Gap real após o piloto

| Responsabilidade C.4 | Já comprovada? | Gap real mínimo |
|---|---|---|
| delimitar parte por `CartographicPartScope` | sim | nenhum |
| reconstruir somente a parte | sim | nenhum |
| preservar física ↔ impressa | sim | nenhum |
| preservar hierarquia e ancestralidade | sim, como candidato | representar decisão sem reescrever candidato |
| classificar elementos locais com evidência | sim, parcialmente | ampliar apenas quando caso real exigir |
| confirmar título/limite no corpo | sim, como evidência candidata | formalizar decisão |
| corrigir candidato | não | registrar correção explícita + evidência local |
| rejeitar candidato | não | registrar rejeição explícita + evidência local |
| produzir saída revisável | parcial | snapshot de decisão separado |

Conclusão: o principal gap legítimo é **candidate → decisão estrutural**, não parser, OCR, provider, persistência ou nova ontologia.

## 3. Decisão de desenho

C.4 não altera `StructuralRecognitionSnapshot@1.0.0` nem `PartReconstructionCandidateSnapshot@1.0.0`.

É criada uma superfície separada `StructuralConfirmationSnapshot@1.0.0` que referencia ambos e registra somente a decisão sobre a raiz do `CartographicPartScope`, preservando a cadeia ancestral candidata para revisão.

Estados da decisão:

- `confirmed`: candidato corroborado no corpo;
- `corrected`: resolução explícita diferente do candidato, acompanhada de razão e evidência local;
- `rejected`: candidato rejeitado com razão e evidência local.

## 4. Invariantes

1. reconhecimento e reconstrução devem apontar para o mesmo `sourceVersion`, artefato SHA-256 e snapshot estrutural;
2. a raiz deve existir no reconhecimento e não pode estar previamente `rejected` em C.3;
3. o `CartographicPartScope` deve corresponder à fronteira candidata da raiz quando essa fronteira existe;
4. `confirmed` exige `part_title` corroborado no corpo e ligado por evidência ao nó raiz;
5. `corrected` exige razão não vazia e evidência de reconstrução explícita;
6. `rejected` exige razão não vazia e evidência de reconstrução explícita;
7. evidência local usada para correção/rejeição não pode escapar do `CartographicPartScope`;
8. C.4 nunca muda retroativamente o estado do candidato C.3;
9. o snapshot de decisão mantém ancestralidade candidata para revisão, mas não promove automaticamente todos os ancestrais a `confirmed`;
10. nenhum texto integral, PDF, imagem ou nova persistência faz parte deste lote.

## 5. Superfície executável inicial

Arquivos materiais:

- `packages/types/src/knowledge-factory/structural-confirmation.ts`;
- `packages/knowledge-factory/src/reconstruction/structural-confirmation.service.ts`;
- `packages/knowledge-factory/test/structural-confirmation.test.mjs`.

A prova sintética cobre:

- confirmação sem mutação do candidato original;
- preservação da ancestralidade Unidade → Capítulo → seção;
- correção negativa de limite com evidência local;
- falha sem corroboração do título;
- falha quando evidência escapa do scope;
- falha quando artefato/snapshot não correspondem.

## 6. Estado dos sublotes

- C.4.1 — **implementação candidata preparada**: contrato e serviço mínimo;
- C.4.2 — **pendente**: aplicar a confirmação à mesma parte real `Evolucionismo social`, físicas 34–35;
- C.4.3 — **implementação sintética candidata preparada**: caso de correção negativa;
- C.4.4 — **parcial**: snapshot revisável definido; revisão real depende de C.4.2.

## 7. Próximo gate material

Após CI verde desta branch, executar localmente a mesma cadeia já governada do Livro 0 e passar o `PartReconstructionCandidateSnapshot` real ao `StructuralConfirmationService` em modo `confirm`.

O objetivo não é reler outra parte nem outra obra. É comprovar que a saída candidata do piloto real pode atravessar a nova fronteira C.4 sem perder SHA, scope, dupla paginação, ancestralidade ou evidência.

## 8. Fora de escopo

Sem:

- outra obra/parte;
- obra inteira como contexto;
- OCR/multimodal novo;
- corpus, chunks, embeddings, retrieval/RAG;
- C.5–C.7;
- persistência hospedada;
- Supabase/Storage para conteúdo;
- produção.
