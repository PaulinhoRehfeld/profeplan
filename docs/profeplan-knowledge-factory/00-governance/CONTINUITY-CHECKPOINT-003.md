# Continuidade — Marco 003

## Status

Marco 003 aprovado integralmente em 6 de agosto de 2026, sem ressalvas.

Este arquivo é o snapshot operacional sincronizado no repositório canônico durante o Lote 0.

## Procedência

- origem normativa: `PaulinhoRehfeld/profeplan_v5`;
- branch: `docs/profeplan-knowledge-factory`;
- commit: `cb36d71b1533fe7fa022c1aedca2c8790ab69692`;
- caminho original: `docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-003.md`.

O documento integral no commit acima permanece a referência normativa deste checkpoint.

## Decisões transferidas ao Marco 004

- `PaulinhoRehfeld/profeplan` é o repositório canônico da implementação;
- o monorepo será reutilizado modularmente;
- contratos e testes precederão banco, APIs, IA e agentes;
- filtros determinísticos precederão similaridade;
- embedding, dimensão, índice, fusão, reranker e cache dependerão de experimentos;
- o corpus compartilhado não terá leitura pública direta;
- gates Must serão não compensatórios;
- Sócrates 2 será um perfil versionado do runtime comum;
- o primeiro PR de código será estritamente contract-first;
- EPIC-018 e US-018.1 permanecem fora do MVP.

## Escopo autorizado para o Lote 0

1. inspecionar o monorepo;
2. confirmar a branch base;
3. auditar comandos e CI;
4. registrar falhas preexistentes;
5. sincronizar documentação;
6. confirmar módulos de destino;
7. produzir relatório de diferenças;
8. preparar a tarefa restrita do primeiro PR.

## Escopo não autorizado

- código de produto;
- migrations;
- banco ou RLS;
- embeddings ou escolha de dimensão;
- fontes reais ou PNLD;
- ativação do Sócrates 2;
- RS, novos agentes ou novas disciplinas;
- Gráfica avançada, PDF ou PPTX sofisticados.

## Gate anterior ao primeiro código

O primeiro PR somente pode ser iniciado após:

- conclusão e aprovação humana do Lote 0;
- baseline técnico conhecido;
- falhas preexistentes separadas;
- módulos de destino confirmados;
- branch e rollback definidos;
- autorização humana explícita.
