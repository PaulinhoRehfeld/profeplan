# Lote 3 — Persistência, proveniência e RLS

## Status

**Proposta documental. Nenhuma migration, alteração de banco ou adapter está autorizado antes de aprovação humana explícita deste lote.**

Base: `main` no commit `738255844d95abbb698ee3621707dbbeb228ec58`.

## Objetivo

Transformar os contratos e políticas puras dos Lotes 1 e 2 em persistência segura, auditável e reversível, sem introduzir retrieval, embeddings, IA executável ou ingestão real.

O Lote 3 deverá persistir:

- fontes e versões;
- histórico de permissão;
- segmentos estruturais;
- componentes pedagógicos e versões;
- evidências de origem;
- pacotes e nós curriculares;
- vínculos entre componentes e currículo;
- OPPs e sua linha do tempo;
- eventos de auditoria.

## Princípio de arquitetura

```text
@profeplan/types
        ↓
contratos
        ↓
@profeplan/knowledge-factory
        ↓
políticas e portas
        ↓
@profeplan/knowledge-factory-supabase
        ↓
adapters concretos
        ↓
public.kf_*
PostgreSQL / Supabase
```

A camada de domínio continuará sem I/O. A infraestrutura será isolada em pacote próprio.

## Decisão de plataforma

Para este lote, a persistência canônica proposta é **SQL Supabase/PostgreSQL por migrations em `supabase/migrations/`**.

`packages/db`/Prisma não será usado pela Knowledge Factory neste lote porque:

- está associado à stack legada;
- permanece excluído do CI geral;
- a aplicação operacional já utiliza Supabase;
- duplicar o schema em Prisma e SQL criaria duas fontes de verdade.

Essa decisão é exclusiva da Knowledge Factory e não exige remoção do pacote Prisma legado.

## Escopo físico

### Corpus global curado

Persistência de conhecimento compartilhado, sem leitura pública direta:

- `kf_sources`;
- `kf_source_versions`;
- `kf_source_permission_events`;
- `kf_source_segments`;
- `kf_pedagogical_components`;
- `kf_component_versions`;
- `kf_component_source_evidence`;
- `kf_curriculum_packages`;
- `kf_curriculum_package_sources`;
- `kf_curriculum_nodes`;
- `kf_curriculum_links`;
- `kf_component_curriculum_links`.

### Produção privada do professor

- `kf_production_orders`;
- `kf_production_order_events`.

### Auditoria

- `kf_audit_events`.

## O que NÃO entra

O Lote 3 não implementará:

- coluna `vector`;
- embeddings;
- IVFFlat;
- HNSW;
- full-text retrieval;
- ranking;
- cache;
- ingestão de arquivo;
- bucket de arquivos;
- OCR;
- PNLD real;
- conteúdo protegido real;
- currículo MG real;
- currículo RS;
- ativação do Sócrates 2;
- runtime de agentes;
- prompts;
- modelos de IA;
- API de produto;
- frontend;
- Gráfica;
- delivery products;
- validation runs;
- retrieval runs;
- geração;
- EPIC-018.

A migration legada `curriculum_rag` não será reutilizada como tabela canônica da Knowledge Factory.

## Justificativa para não reutilizar `curriculum_rag`

A tabela legada combina decisões que agora estão separadas arquiteturalmente:

- conteúdo curricular;
- texto bruto;
- dimensão vetorial fixa em 768;
- IVFFlat;
- full-text search;
- leitura pública.

A Knowledge Factory exige:

- fonte e versão navegáveis;
- licença como condição de acesso;
- componentes pedagógicos autorais separados da fonte;
- currículo versionado em nós;
- RLS deny-by-default;
- configuração de embedding decidida apenas por experimento.

`curriculum_rag` poderá continuar atendendo código legado enquanto existir, mas não será dependência da nova arquitetura.

## Estratégia de implementação em dois PRs

### Lote 3A — Schema, constraints, RLS e testes SQL

Objetivo único:

Criar a fundação física sem conectar a aplicação.

Inclui:

- migration incremental;
- tabelas `kf_*`;
- constraints e índices determinísticos;
- RLS;
- helper administrativo mínimo;
- proteção append-only de eventos;
- fixtures exclusivamente sintéticas para testes;
- testes de isolamento e constraints;
- rollback documentado.

Não inclui adapters TypeScript.

### Lote 3B — Adapters concretos de repositório

Pré-requisito: Lote 3A aprovado, aplicado e validado em ambiente não produtivo.

Criará:

`packages/knowledge-factory-supabase/`

Workspace proposto:

`@profeplan/knowledge-factory-supabase`

Responsabilidades:

- implementar as cinco portas do Lote 2;
- mapear linhas SQL ↔ contratos;
- receber contexto de execução explicitamente;
- preservar domínio sem dependência de Supabase;
- testes de integração com dados sintéticos.

Dependências permitidas deverão ser aprovadas antes do PR 3B. Nenhuma dependência é autorizada por este documento por antecipação.

## Modelo de isolamento do MVP

O produto inicial é individual. Portanto, a OPP usará isolamento primário por usuário:

```text
requester_id = auth.uid()
```

Não será criado um novo conceito físico de `tenant` apenas para a Knowledge Factory enquanto o modelo canônico de organização/tenant do produto não estiver consolidado.

Consequências:

- usuário A não lê OPP de usuário B;
- professor não lê tabelas globais diretamente;
- futura expansão para escolas poderá adicionar tenant/organization sem alterar a identidade da OPP;
- nenhum `school_id` será assumido como tenant universal da Knowledge Factory.

## Stories relacionadas — fatia de persistência

Principais:

- US-002.1 — procedência da fonte;
- US-002.2 — autorização e bloqueio;
- US-004.1 — componente canônico;
- US-004.2 — tipologia do componente;
- US-004.3 — revisão e versionamento;
- US-010.1 — OPP válida;
- US-010.2 — linha do tempo da OPP.

Parciais:

- US-003.2 — segmento persistível, sem ingestão;
- US-006.1 — pacote curricular persistível;
- US-006.2 — vínculos curriculares persistíveis;
- US-013.2 — procedência e auditoria navegáveis.

Nenhuma Story de retrieval ou geração recebe `Done` neste lote.

## Critérios de aceite do Lote 3A

1. migration é exclusivamente aditiva em relação ao produto atual;
2. nenhuma tabela legada é removida, renomeada ou alterada;
3. nenhuma coluna vetorial é criada;
4. todas as entidades versionadas preservam `id` e `version`;
5. chaves estrangeiras de procedência impedem evidência órfã;
6. pacote curricular possui regra que impede duas versões ativas concorrentes do mesmo Estado/etapa;
7. corpus global não possui leitura de professor por padrão;
8. `anon` não acessa nenhuma tabela `kf_*`;
9. usuário autenticado só pode ler/criar a própria OPP conforme política aprovada;
10. usuário não pode alterar diretamente estado/eventos da OPP por bypass de domínio;
11. eventos de permissão, OPP e auditoria são append-only em uso normal;
12. tentativa de cross-user access falha;
13. tentativa de leitura direta de fonte/segmento por professor falha;
14. seeds e testes usam apenas conteúdo sintético;
15. rollback foi ensaiado em ambiente descartável/não produtivo;
16. migration não será aplicada em produção automaticamente pelo merge.

## Critérios de aceite do Lote 3B

1. cada porta do Lote 2 possui adapter concreto;
2. adapters não implementam regra pedagógica que pertença ao domínio;
3. domínio continua sem importar Supabase;
4. mapeamento reconstrói arrays relacionais de evidência/currículo corretamente;
5. contexto do requester/ator/correlação é explícito;
6. testes comprovam leitura/escrita autorizada e negação indevida;
7. nenhuma fonte real é necessária para os testes;
8. nenhuma dependência nova é adicionada sem aprovação humana.

## Gate de aplicação em banco

Aprovar o PR de código da migration **não equivale** a autorizar execução em produção.

Ordem obrigatória:

```text
definição documental aprovada
→ PR 3A
→ CI/revisão
→ ambiente não produtivo
→ testes RLS/rollback
→ aprovação humana de merge
→ merge
→ autorização separada para aplicar em produção
```

## Rollback

O plano detalhado está em `LOT-3-ROLLBACK-PLAN.md`.

Princípios:

- não tocar em tabelas legadas;
- rollback por remoção apenas de objetos `kf_*` quando ainda não houver dependentes posteriores;
- snapshot de schema antes de aplicar;
- backup antes de produção;
- bloquear rollback destrutivo se houver dados reais não exportados;
- nenhum rollback automático em produção.

## Gates de parada

Interromper a implementação se ocorrer qualquer um:

- contrato público insuficiente;
- necessidade de vetor/embedding;
- necessidade de fonte real;
- necessidade de alterar `curriculum_rag`;
- necessidade de alterar tabelas existentes do produto;
- RLS depender de um conceito de tenant ainda não consolidado;
- nova dependência não aprovada;
- ausência de ambiente seguro para testar migration;
- migration não puder ser revertida em ambiente descartável;
- tentativa de incluir Lote 4 ou EPIC-018.

## Branches propostas

Documentação:

`docs/knowledge-factory-lot3-definition`

Futuro Lote 3A:

`feat/knowledge-factory-persistence-schema`

Futuro Lote 3B:

`feat/knowledge-factory-supabase-adapters`

## Títulos previstos

PR 3A:

`feat(knowledge-factory): add persistence schema and RLS`

PR 3B:

`feat(knowledge-factory): add Supabase repository adapters`

## Estado de saída desta definição

Após aprovação humana:

- ADRs propostas deste lote poderão ser marcadas como aprovadas;
- será criado checkpoint de continuidade;
- somente o PR 3A ficará autorizado para implementação;
- PR 3B continuará bloqueado até validação do schema em ambiente não produtivo.