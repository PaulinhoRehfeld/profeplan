# Lote 3B — Estratégia de transações e atomicidade

## Status

**Aprovado integralmente em 7 de agosto de 2026.**

## Problema

As portas do domínio são assíncronas e simples, mas algumas operações futuras envolvem mais de uma tabela.

Supabase JS/PostgREST executa chamadas HTTP independentes. Uma sequência de duas ou três chamadas `.from()` **não é uma transação**.

Não foi identificada no monorepo uma abstração canônica de Unit of Work que forneça transação PostgreSQL real para essas chamadas.

## Regra central aprovada

> O Lote 3B não criará uma abstração que prometa atomicidade sem poder garanti-la fisicamente.

## Categorias de operação

### Categoria A — operação simples em uma tabela

Exemplos:

- `KnowledgeSourceRepository.findById`;
- `KnowledgeSourceRepository.save(source)`;
- `AuditRepository.append`;
- `AuditRepository.listByAggregate`;
- `CurriculumRepository.findNodeById`.

Pode ser implementada diretamente via Supabase JS.

### Categoria B — leitura composta

Exemplos:

- `PedagogicalComponentRepository.findVersion()` precisa hidratar IDs de evidência e currículo;
- `CurriculumRepository.findPackageById()` precisa hidratar `sourceVersionIds`.

Pode usar:

- nested select/PostgREST quando seguro e claro; ou
- múltiplas leituras explicitamente reconhecidas como não transacionais.

Não afirmar snapshot consistente se o provider não o garante.

Caso a consistência estrita seja requisito, criar read model/RPC em migration específica.

### Categoria C — comando multi-tabela com invariante

Exemplos:

- criar componente + primeira versão + apontar `current_version_id`;
- criar/alterar versão + vínculos curriculares;
- transicionar OPP + gravar evento;
- transicionar OPP + gravar auditoria;
- criar fonte + versão + evento de permissão em uma operação futura de ingestão.

Essas operações exigem transação PostgreSQL real.

## Estratégia aprovada

Para Categoria C:

1. definir o comando e suas invariantes;
2. criar função PostgreSQL `public.kf_*` estreita e específica;
3. função executa todas as mudanças numa única transação da chamada SQL;
4. controlar `search_path`, privilégios e `SECURITY DEFINER` somente se realmente necessário;
5. conceder `EXECUTE` apenas aos papéis mínimos;
6. testar sucesso, falha parcial e rollback no Supabase descartável;
7. versionar a função em migration separada;
8. adapter chama `supabase.rpc()` como operação única;
9. traduzir erros sem vazar SQL para camadas superiores;
10. registrar telemetria sem conteúdo sensível.

Qualquer RPC/migration futura continua exigindo gate humano próprio. A aprovação deste documento não autoriza criar RPC no primeiro PR.

## O que não será criado

Não criar inicialmente:

- `GenericUnitOfWork`;
- `TransactionManager` que apenas agrupe Promises;
- transação em memória;
- compensação silenciosa como substituto de atomicidade;
- retry automático de mutações não idempotentes;
- RPC genérica que aceite tabela/SQL como parâmetro.

## Idempotência

Cada futuro comando transacional deverá responder explicitamente:

- é idempotente?
- qual chave impede duplicidade?
- retry é seguro?
- evento append-only pode ser repetido?

Retry de leitura pode ser permitido futuramente; retry de escrita só quando a operação comprovar idempotência.

## ProductionOrderRepository

### Criação de OPP

O schema 3A permite INSERT autenticado de OPP própria em status `requested`.

Essa criação isolada pode ocorrer com requester-scoped client em fase futura.

### Transição de estado

Uma transição real não deve ser implementada como:

```text
UPDATE kf_production_orders
→ depois INSERT kf_production_order_events
```

Porque a segunda operação pode falhar deixando timeline divergente.

Antes do adapter de transição, criar RPC específica que:

- valida estado esperado;
- atualiza OPP;
- insere evento;
- opcionalmente insere auditoria quando aprovado;
- falha como unidade.

Nenhum nome de função é fechado por este documento; o contrato da função será definido no ciclo correspondente.

## PedagogicalComponentRepository

Criação inicial de componente é circular com `current_version_id`:

- componente exige `current_version_id`;
- versão exige `component_id`;
- FK é deferrable no schema 3A justamente para permitir operação transacional.

Isso reforça que a criação completa deve ser um comando PostgreSQL transacional futuro, não duas requisições PostgREST independentes.

A FK composta de `current_version_id` é `DEFERRABLE INITIALLY DEFERRED`. Dentro de uma única transação, ela permite inserir o componente apontando para a primeira versão, inserir essa versão com o mesmo `component_id` e validar a coerência no commit. Ela não cria atomicidade entre requisições PostgREST independentes.

### Leituras do 3B.4A

`findVersion()` pode executar leitura base e hidratações sequenciais de evidências e vínculos curriculares sem prometer snapshot forte. No estado atual não existe consumidor operacional nem writer do componente integrado. Qualquer falha de hidratação deve rejeitar o resultado inteiro.

Nenhuma RPC/read model é necessária para o 3B.4A. Um futuro consumidor que exija decisão consistente sob concorrência deverá obter ADR e fronteira de leitura forte próprios.

### Escritas do 3B.4B

`saveComponent()` não pode ser tratado genericamente como operação simples de uma tabela:

- criação isolada termina sem versão válida para o `current_version_id` obrigatório;
- o contrato não diferencia criação de atualização;
- promoção de nova versão corrente atravessa componente e versão.

`saveVersion()` também não representa apenas a linha `kf_component_versions`:

- `curriculumNodeIds` vivem em `kf_component_curriculum_links`;
- `sourceEvidenceIds` apontam para linhas completas de `kf_component_source_evidence`;
- a porta não oferece criação de `EvidenceOrigin`;
- insert, upsert e substituição integral dos vínculos ainda não têm semântica aprovada;
- o schema não concede DELETE ao `service_role`, portanto apagar e recriar vínculos não pode ser presumido.

Essa insuficiência contratual é registrada como GAP-3B-06. Não criar método lateral, acesso direto externo, compensação ou RPC antes da decisão humana sobre o comando e seu payload.

Antes de 3B.4B são obrigatórios:

1. comando de aplicação completo;
2. payload com evidências e vínculos;
3. semântica de criação, atualização e promoção;
4. idempotency key e retry seguro;
5. privilégios mínimos;
6. função PostgreSQL/RPC estreita;
7. migration isolada;
8. testes de rollback no Supabase descartável;
9. decisão contratual explícita;
10. gate humano próprio.

## KnowledgeSourceRepository

A porta atual somente salva `KnowledgeSource` em `kf_sources`.

Isso é Categoria A e pode ser implementado sem nova RPC em fase posterior.

O fluxo completo de ingestão — fonte + versão + segmentos + permissão — não está contratado pela porta atual e permanece fora do 3B inicial.

## AuditRepository

`append(event)` é uma única inserção em tabela append-only.

Não requer transação multi-tabela e é o primeiro corte aprovado.

## Gate para nova migration transacional

Toda função/RPC nova exige:

- documento/ADR específico;
- migration isolada;
- DB CI descartável;
- teste de rollback;
- revisão de privilégios/RLS;
- aprovação humana.

Merge de RPC continua sem autorizar produção automaticamente.
