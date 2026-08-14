# Lote 3A — Schema, constraints, RLS e testes de isolamento

## Status

**Definição aprovada derivada do Lote 3. Nenhuma migration foi criada neste documento. Aplicação em produção continua proibida sem gate humano separado.**

Data: 7 de agosto de 2026.

## Objetivo

Criar a fundação física da ProfePlan Knowledge Factory no Supabase/PostgreSQL de forma aditiva, isolada e reversível, implementando apenas schema relacional, constraints, RLS, proteção append-only e testes SQL/sintéticos.

O Lote 3A não conectará a aplicação ao novo schema. O Lote 3B será responsável pelos adapters concretos e somente poderá começar após validação do 3A em ambiente não produtivo.

## Branch prevista

`feat/knowledge-factory-persistence-schema`

## Pull Request previsto

`feat(knowledge-factory): add persistence schema and RLS foundation`

O PR deverá iniciar como rascunho e não poderá ser mesclado automaticamente.

## Base obrigatória

`main` após o merge do PR documental nº 6.

## Arquivos autorizados

Primariamente:

- `supabase/migrations/<timestamp>_knowledge_factory_schema.sql`;
- `supabase/tests/knowledge_factory_schema.sql` ou diretório equivalente já existente, se houver;
- `docs/profeplan-knowledge-factory/` para evidências, matriz e checkpoint;
- scripts locais estritamente sintéticos de validação, somente se o repositório já possuir padrão equivalente.

Nenhum arquivo em `packages/knowledge-factory`, `packages/types`, `packages/ai`, `packages/agents`, `apps/web`, `api/` ou `packages/db` deve ser alterado sem novo gate humano.

## Schema autorizado

Criar exclusivamente as 15 tabelas aprovadas:

1. `public.kf_sources`;
2. `public.kf_source_versions`;
3. `public.kf_source_permission_events`;
4. `public.kf_source_segments`;
5. `public.kf_pedagogical_components`;
6. `public.kf_component_versions`;
7. `public.kf_component_source_evidence`;
8. `public.kf_curriculum_packages`;
9. `public.kf_curriculum_package_sources`;
10. `public.kf_curriculum_nodes`;
11. `public.kf_curriculum_links`;
12. `public.kf_component_curriculum_links`;
13. `public.kf_production_orders`;
14. `public.kf_production_order_events`;
15. `public.kf_audit_events`.

## Restrições físicas obrigatórias

- IDs em UUID;
- versões em `text NOT NULL` com validação de não vazio;
- timestamps em `timestamptz`;
- estados e tipos em `text + CHECK`, sem PostgreSQL enum;
- FKs explícitas;
- nenhuma `ON DELETE CASCADE` em histórico/proveniência/auditoria;
- `unique(source_id, version)`;
- `unique(component_id, version)`;
- `unique(curriculum_package_id, code, version)`;
- índice único parcial para um único pacote `active` por `(state, stage)`;
- FK de `current_version_id` deve garantir integridade e mecanismo adicional deve impedir apontar para versão de outro componente;
- cadeias de evidência devem impedir relações órfãs;
- nenhuma coluna vetorial;
- nenhum índice de full-text;
- nenhum materialized view;
- nenhum cache.

## RLS e grants

Princípio: deny by default.

### Corpus global

Tabelas de fontes, segmentos, componentes, currículo e evidências:

- RLS habilitada;
- nenhuma leitura direta para `anon`;
- nenhuma leitura direta ampla para `authenticated`;
- escrita de usuário final proibida;
- operações administrativas/técnicas devem depender de papel explicitamente aprovado ou service role no backend, sem expor service role ao cliente.

### OPP

`kf_production_orders`:

- usuário autenticado pode criar OPP somente com `requester_id = auth.uid()`;
- pode ler somente OPP com `requester_id = auth.uid()`;
- update permitido somente na própria OPP e dentro das condições de aplicação/adapters posteriores;
- delete de OPP não é necessário ao MVP e deve permanecer negado por padrão.

`kf_production_order_events`:

- leitura somente se a OPP pai pertencer ao usuário;
- usuário final não insere eventos arbitrários diretamente;
- UPDATE e DELETE proibidos em fluxo normal.

### Auditoria

`kf_audit_events`:

- sem acesso direto de professor;
- append-only;
- leitura administrativa restrita;
- UPDATE/DELETE negados em operação normal.

## Proteção append-only

As tabelas:

- `kf_source_permission_events`;
- `kf_production_order_events`;
- `kf_audit_events`

não podem aceitar UPDATE/DELETE em uso normal.

A implementação pode usar grants, RLS e/ou trigger de proteção. A escolha deve ser mínima, testável e documentada no PR.

## Papéis

Para o Lote 3A:

- `anon`: nenhum acesso às tabelas `kf_*`;
- `authenticated`: somente acesso próprio às OPPs conforme RLS;
- `admin`: pode receber acesso administrativo mínimo quando o padrão atual de `profiles.role = 'admin'` for comprovado de forma não recursiva;
- `manager` e `school_admin`: não recebem automaticamente poder global de curadoria da Knowledge Factory;
- `service_role`: backend/jobs apenas; não substitui gates de licença/domínio.

Se a implementação de `admin` exigir função RLS insegura, recursiva ou dependente de schema legado incerto, o Codex deve parar e solicitar decisão, em vez de ampliar privilégios.

## Seeds e fixtures

Somente dados sintéticos, preferencialmente em testes/transações rollbackáveis.

Exemplos permitidos:

- `WRTECH-SYNTHETIC-SOURCE-001`;
- `synthetic-philosophy-concept`;
- `SYN-MG-PHI-2-001`;
- usuário fictício criado exclusivamente no ambiente de teste.

Nenhum seed real deve ser incluído na migration produtiva.

## Testes mínimos obrigatórios

### Schema

- 15 tabelas existem;
- nenhuma tabela legada é alterada;
- nenhuma coluna `vector` existe nas `kf_*`;
- checks rejeitam enum/status inválido;
- versões vazias são rejeitadas;
- FKs rejeitam órfãos;
- unicidade de versões funciona;
- dois pacotes ativos para mesmo `(state, stage)` são rejeitados;
- `current_version_id` não pode apontar para versão de outro componente.

### RLS

- `anon` não lê corpus;
- professor A não lê OPP do professor B;
- professor A não atualiza OPP do professor B;
- professor não lê segmentos brutos;
- professor não lê componentes diretamente;
- professor não lê auditoria;
- professor não cria evento de permissão;
- professor não ativa pacote curricular;
- `requester_id` adulterado no insert é rejeitado;
- políticas não dependem apenas de dados enviados pelo cliente.

### Append-only

- UPDATE em permission event é rejeitado;
- DELETE em permission event é rejeitado;
- UPDATE em OPP event é rejeitado;
- DELETE em OPP event é rejeitado;
- UPDATE/DELETE em audit event é rejeitado.

### MVP

- MG pode existir como `active` em fixture sintética;
- RS não deve ser ativado pelos seeds/testes do MVP;
- nenhuma regra física habilita EPIC-018.

## Teste de não regressão

O PR deve comprovar que:

- migrations existentes permanecem intactas;
- `curriculum_rag` não é alterada;
- tabelas de PDI, profiles, students e classes não são alteradas;
- CI geral continua verde;
- nenhuma dependência npm/pnpm é adicionada.

## Ambiente de validação

Antes do merge do PR de migration:

- validar sintaxe e ordem das migrations em ambiente isolado/local ou projeto Supabase não produtivo;
- executar a migration em banco limpo compatível;
- executar sobre baseline que represente o schema atual;
- rodar matriz de RLS com pelo menos dois usuários fictícios;
- ensaiar rollback enquanto só houver fixtures sintéticas.

Se não houver ambiente não produtivo disponível, o PR pode ser produzido e revisado, mas **não deve ser mesclado como migration pronta para produção** sem decisão humana sobre o ambiente de teste.

## Gate de merge do código da migration

Obrigatórios:

1. diff exclusivamente aditivo e dentro do escopo;
2. revisão do SQL;
3. testes de schema aprovados;
4. testes RLS aprovados;
5. testes append-only aprovados;
6. rollback ensaiado;
7. CI geral verde;
8. nenhuma tabela legada alterada;
9. nenhuma escolha de embedding/retrieval;
10. aprovação humana explícita do PR 3A.

## Gate de produção

Mesmo após merge do PR 3A, a migration não poderá ser aplicada ao Supabase de produção sem autorização humana separada.

Antes dessa autorização devem ser apresentados:

- ambiente onde foi testada;
- resultado da migration;
- resultado dos testes RLS;
- resultado do rollback;
- divergências entre banco alvo e migrations do repositório;
- backup/pre-flight aplicável;
- risco residual;
- comando/procedimento exato de aplicação;
- procedimento de resposta caso o deploy falhe.

## Rollback

Enquanto houver apenas fixtures sintéticas:

- remover objetos `kf_*` na ordem inversa de dependência;
- remover funções/triggers exclusivos `kf_*`;
- não tocar em tabelas legadas.

Após qualquer uso real:

- não usar drop destrutivo por padrão;
- preferir migration corretiva/roll-forward;
- preservar proveniência e auditoria.

## Stories/capacidades relacionadas

Fatia de persistência das Stories já aprovadas relacionadas a:

- procedência e autorização de fontes;
- componentes pedagógicos versionados;
- pacote curricular e vínculos;
- OPP e eventos;
- rastreabilidade/auditoria.

Nenhuma Story de retrieval, embedding, geração, agente executável ou frontend avança neste lote.

## Critérios para interromper o trabalho

Parar e solicitar nova autorização se ocorrer qualquer um dos seguintes:

- necessidade de alterar contrato público 1.1.0;
- necessidade de alterar pacote de domínio;
- conflito com tabela/migration existente;
- necessidade de nova dependência;
- necessidade de mudar papéis globais do produto;
- RLS exigir bypass amplo;
- necessidade de usar `SECURITY DEFINER` sem justificativa e `search_path` fixo;
- necessidade de tocar `curriculum_rag`;
- necessidade de escolher vetor/embedding;
- falta de forma segura de testar isolamento;
- tentativa de aplicar migration em produção.

## Próximo passo após 3A

Somente após validação e aprovação do Lote 3A será definido/implementado o Lote 3B — adapters Supabase das cinco portas do domínio.
