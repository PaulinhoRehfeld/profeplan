# Primeiro Pull Request de Código — escopo autorizado

## Status

**Autorizado no Marco 004 — Lote 0.**

A execução deverá ocorrer em ciclo próprio, sem merge automático e dentro dos limites deste documento.

## Repositório e branch

- repositório: `PaulinhoRehfeld/profeplan`;
- base: `main`;
- branch autorizada: `feat/knowledge-factory-contracts`;
- título autorizado: `feat(knowledge-factory): add versioned domain contracts and fixtures`.

## Objetivo único

Adicionar contratos puros, versionados e testáveis para o núcleo da Knowledge Factory, sem persistência, IA, API, migrations ou alteração de comportamento da aplicação.

## Local autorizado

```text
packages/types/src/knowledge-factory/
```

Alterações adicionais permitidas somente quando estritamente necessárias:

- `packages/types/src/index.ts`, para exports aditivos;
- `packages/types/package.json`, para scripts de validação e tooling mínimo autorizado;
- configuração de teste estritamente local ao pacote;
- documentação diretamente relacionada ao PR.

## Contratos previstos

- `KnowledgeSource`;
- `SourceVersion`;
- `SourcePermission` e evento de autorização;
- `SourceSegment`;
- `PedagogicalComponent`;
- `PedagogicalComponentVersion`;
- `ComponentSourceEvidence`;
- `CurriculumPackage`;
- `CurriculumNode`;
- `ComponentCurriculumLink`;
- `AgentProfile`;
- `AgentKnowledgeScope`;
- `ProductionOrder` e estados;
- `ProductionOrderEvent`;
- `QueryPlan`;
- `SufficiencyResult`;
- `ContextPackage`;
- `ValidationFinding`;
- `DeliveryContract`;
- payloads dos quatro produtos do MVP.

## Enums previstos

- tipos de fonte;
- licença e permissão;
- estados de fonte, componente e OPP;
- tipos de componente;
- tipos de produto;
- resultados de gate;
- códigos de insuficiência;
- componente, etapa, ano e currículo dentro do escopo aprovado.

## Fixtures sintéticas

- fonte válida;
- fonte bloqueada;
- versão e checksum;
- componente draft e approved;
- evidência de origem;
- pacote MG válido;
- RS bloqueado;
- OPP válida;
- OPP fora do escopo;
- resultado de suficiência;
- finding de gate;
- contrato de entrega de plano, texto, atividade e avaliação.

Nenhuma fixture poderá conter dado real, conteúdo PNLD, texto protegido, nome de estudante ou credencial.

## Invariantes a testar

- versão obrigatória;
- fonte bloqueada não é recuperável;
- componente não aprovado não entra em produção;
- licença incompatível bloqueia uso;
- filtros obrigatórios fazem parte do QueryPlan;
- currículo ativo é único, salvo modo comparativo explícito, que permanece desabilitado no MVP;
- RS permanece bloqueado;
- EPIC-018 permanece bloqueado;
- transições inválidas de OPP são rejeitadas;
- finding Must bloqueia aprovação;
- insuficiência não equivale a sucesso;
- contrato de entrega mantém rastreabilidade;
- serialização não perde versão ou IDs.

## Tooling e dependências

`packages/types` não possui scripts de build, typecheck ou test. O PR deverá propor o menor tooling possível para tornar os contratos verificáveis.

Regras:

- reutilizar TypeScript e Vitest já presentes no monorepo quando possível;
- não instalar nova dependência sem autorização;
- Zod existe em `apps/web`, mas não está disponível em `packages/types`;
- se runtime schemas exigirem Zod ou alternativa nova, interromper e pedir aprovação;
- tipos TypeScript e validadores puros sem dependência são aceitáveis como primeira versão, desde que a limitação seja documentada.

## Fora do escopo

- banco e tabelas;
- Prisma e Supabase;
- migrations e RLS;
- buckets e arquivos;
- embeddings e busca;
- OpenAI, Anthropic ou qualquer provider;
- ModelPolicy executável;
- agentes, prompts e Sócrates 2 ativo;
- `packages/agents`;
- `packages/ai`;
- `packages/db`;
- `apps/bff`;
- `api/`;
- frontend;
- Gráfica;
- fontes reais e PNLD;
- Rio Grande do Sul;
- novos agentes e disciplinas;
- refatorações não relacionadas;
- correção ampla das falhas preexistentes.

## Critérios de aceite

1. diff concentrado em `packages/types` e documentação relacionada;
2. API pública explícita e aditiva;
3. contratos compilam em TypeScript strict;
4. testes de invariantes passam;
5. fixtures são sintéticas;
6. nenhuma dependência externa é instalada sem aprovação;
7. nenhuma migration ou arquivo de banco é alterado;
8. nenhum fluxo da aplicação muda;
9. scripts de validação do pacote são reproduzíveis;
10. CI geral continua verde no escopo ativo;
11. falhas preexistentes permanecem separadas;
12. documentação aponta para ADR-019, ADR-027 e ADR-028;
13. o PR declara que atende apenas fatias contratuais das Stories;
14. rollback é um simples revert, sem migração de dados.

## Plano de rollback

- reverter o PR;
- remover exports adicionados;
- nenhuma migração ou dado precisa ser revertido;
- nenhum feature flag é necessário;
- contratos legados não serão substituídos no primeiro PR.

## Stories — fatia contratual

Recebem `Ready for Code — contract slice`:

- US-001.1;
- US-001.2;
- US-002.1;
- US-002.2;
- US-004.1;
- US-004.2;
- US-010.1;
- US-014.1;
- US-015.1;
- US-016.1.

Isso não conclui as Stories de negócio. Apenas entrega contratos e invariantes necessários aos lotes posteriores.
