# Continuidade — Aprovação e preparação do Lote 2

## Status

**Definição do Lote 2 aprovada integralmente. Próxima etapa: implementação controlada em nova conversa, sem antecipar Lote 3.**

Data da aprovação humana: 7 de agosto de 2026.

## Repositório canônico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch base para o próximo ciclo: `main`;
- último merge funcional aprovado antes desta definição: `dec9992fbdfe92e75177b3708d41afde0c8e0a01`;
- Pull Request nº 3: merged;
- Pull Request documental nº 4: definição do Lote 2.

## Histórico consolidado

- Marco 001: arquitetura conceitual e escopo — aprovado;
- Marco 002: Epics, Features, Stories, critérios e gates — aprovado;
- Marco 003: plano técnico e estratégia incremental — aprovado;
- Marco 004 / Lote 0: baseline e sincronização — aprovado;
- Lote 1: contratos puros, fixtures e invariantes — concluído e merged no PR nº 3;
- Lote 2: domínio, ciclo de vida e repositórios abstratos — definição aprovada, implementação ainda não iniciada.

## Decisões aprovadas para o Lote 2

### ADR-029 — pacote dedicado ao domínio

Criar:

`packages/knowledge-factory/`

Workspace:

`@profeplan/knowledge-factory`

Responsabilidade:

- regras de negócio;
- políticas de elegibilidade;
- ciclo de vida;
- política curricular do MVP;
- validação lógica do escopo Sócrates 2;
- política de OPP;
- eventos de domínio;
- portas abstratas de repositório.

`@profeplan/types` continuará sendo somente a camada de contratos compartilhados.

### ADR-030 — repositórios como portas abstratas

Portas mínimas:

- `KnowledgeSourceRepository`;
- `PedagogicalComponentRepository`;
- `CurriculumRepository`;
- `ProductionOrderRepository`;
- `AuditRepository`.

Nenhuma implementação concreta de Supabase, PostgreSQL, Prisma, SQL, HTTP ou provider será aceita neste lote.

### ADR-031 — domínio puro e sem I/O

Toda política do Lote 2 deverá ser:

- determinística;
- sem estado global;
- sem banco;
- sem rede;
- sem filesystem;
- sem provider;
- testável com contratos e fixtures sintéticas.

## Branch autorizada para a implementação

Criar somente no início da próxima conversa:

`feat/knowledge-factory-domain-core`

Base:

`main`

Título previsto do Pull Request:

`feat(knowledge-factory): add domain policies and repository ports`

O Pull Request deverá iniciar como rascunho e não poderá ser mesclado automaticamente.

## Dependências autorizadas

Dependência interna permitida:

`@profeplan/types: workspace:*`

Nenhuma dependência externa nova está autorizada.

Mudança mínima de `pnpm-lock.yaml` será aceita apenas se for consequência automática da criação do workspace e da dependência interna aprovada.

Se a implementação exigir biblioteca externa, deverá parar e solicitar autorização humana antes da alteração.

## Escopo funcional autorizado

### 1. Elegibilidade de fontes

Implementar regras para:

- status;
- licença;
- finalidade permitida;
- bloqueio;
- revogação/suspensão;
- razões tipadas de inelegibilidade.

### 2. Ciclo de vida de componentes pedagógicos

Controlar transições entre:

- `draft`;
- `in_review`;
- `approved`;
- `rejected`;
- `superseded`;
- `suspended`.

### 3. Elegibilidade de componentes

Componente produtivo deverá, no mínimo:

- estar aprovado;
- possuir versão;
- possuir evidência permitida ou justificativa de material próprio;
- possuir vínculo curricular quando exigido;
- respeitar componente, etapa, ano e currículo do escopo;
- não depender de fonte bloqueada;
- não estar suspenso ou substituído.

### 4. Política curricular do MVP

No Lote 2:

- MG é o único Estado permitido;
- RS permanece bloqueado;
- Filosofia / Ensino Médio / 2º ano permanece o escopo piloto;
- nenhum documento curricular real será importado.

### 5. Escopo lógico do Sócrates 2

Pode-se validar o escopo do perfil, mas não executar agente.

Aceitar somente:

- Filosofia;
- Ensino Médio;
- 2º ano;
- Minas Gerais;
- produtos já previstos no MVP.

Pedido fora do escopo deverá retornar decisão tipada de fallback ou rejeição.

### 6. Política da OPP

Implementar regras que impeçam:

- transição impossível;
- salto de gate;
- aprovação após insuficiência;
- aprovação com finding Must aberto;
- avanço sem requisitos mínimos da etapa.

### 7. Eventos de domínio

Eventos serão lógicos e não persistidos. Devem conter somente metadados e identificadores necessários.

### 8. Portas abstratas

Interfaces deverão expressar intenção de domínio sem vazar detalhes de infraestrutura.

## Stories principais autorizadas no Lote 2

- US-002.1 — regras de procedência e porta abstrata;
- US-002.2 — licença/permissão e bloqueio;
- US-004.1 — validade de componente canônico;
- US-004.2 — tipologia do piloto;
- US-004.3 — ciclo de vida e versionamento lógico;
- US-010.1 — validade da OPP;
- US-010.2 — eventos e linha do tempo lógica.

## Stories autorizadas parcialmente

- US-006.1 — política MG sem documento curricular real;
- US-006.2 — regra de vínculo sem persistência;
- US-009.1 — escopo lógico do Sócrates 2 sem runtime;
- US-013.2 — auditoria/lineage lógico sem armazenamento.

## Escopo explicitamente proibido

Não implementar neste lote:

- banco;
- migrations;
- RLS;
- Supabase;
- PostgreSQL concreto;
- Prisma;
- APIs;
- jobs;
- OpenAI;
- IA executável;
- embeddings;
- pgvector;
- busca lexical;
- busca vetorial;
- reranking;
- ingestão de PDF;
- OCR;
- PNLD real;
- material protegido;
- currículo MG real;
- currículo RS;
- runtime do Sócrates 2;
- frontend;
- Gráfica;
- correções gerais do monorepo;
- EPIC-018.

## Gate de contrato

Se o Lote 2 revelar lacuna ou incompatibilidade nos contratos públicos criados no Lote 1:

1. parar a implementação daquela parte;
2. registrar a lacuna;
3. explicar impacto e alternativas;
4. solicitar autorização humana antes de modificar contrato público;
5. não alterar `@profeplan/types` silenciosamente para fazer a implementação passar.

## Critérios de aceite técnicos

O Lote 2 somente poderá ser considerado concluído quando:

1. `@profeplan/knowledge-factory` existir como pacote separado;
2. depender apenas de `@profeplan/types` entre os pacotes do produto;
3. nenhuma dependência externa nova tiver sido adicionada;
4. não houver importação de DB, IA, agents, API ou frontend;
5. políticas forem puras e determinísticas;
6. regras de sucesso e falha tiverem testes;
7. transições inválidas de componentes estiverem cobertas;
8. elegibilidade de fontes cobrir status e licenças permitidas/proibidas;
9. componente derivado de fonte bloqueada for inelegível;
10. currículo RS continuar bloqueado;
11. Sócrates 2 rejeitar outro componente, ano ou Estado;
12. OPP não puder pular gates nem converter insuficiência em sucesso;
13. repositórios abstratos não vazarem tecnologia de persistência;
14. eventos não carregarem conteúdo sensível desnecessário;
15. fixtures forem exclusivamente sintéticas;
16. typecheck específico passar;
17. testes específicos passarem;
18. CI geral aplicável permanecer verde;
19. falhas preexistentes permanecerem separadas;
20. rollback continuar sendo revert simples, sem restauração de dados.

## Rollback

Rollback do futuro PR de implementação:

- remover `packages/knowledge-factory`;
- restaurar eventual alteração mínima de workspace/lockfile;
- nenhuma migration ou tabela deverá existir;
- nenhum dado deverá ser restaurado;
- nenhum serviço de produção deverá ser afetado.

## Próximo fork

Este checkpoint encerra a fase de definição do Lote 2.

**O próximo fork deve ocorrer após o merge do Pull Request documental nº 4 e antes da criação da branch de código `feat/knowledge-factory-domain-core`.**

A nova conversa deverá iniciar diretamente pela inspeção da `main`, criação da branch de código e implementação controlada do Lote 2.

## Mensagem de continuidade

Use a mensagem preparada pelo assistente após o merge do PR documental nº 4. A mensagem deverá citar este checkpoint e proibir qualquer avanço para Lote 3.
