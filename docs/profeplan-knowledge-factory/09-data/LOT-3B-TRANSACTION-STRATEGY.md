# Lote 3B — Estratégia de transações e atomicidade

## Status

**Proposta documental — aguardando aprovação humana.**

## Problema

As portas do domínio são assíncronas e simples, mas algumas operações futuras envolvem mais de uma tabela.

Supabase JS/PostgREST executa chamadas HTTP independentes. Uma sequência de duas ou três chamadas `.from()` **não é uma transação**.

Não foi identificada no monorepo uma abstração canônica de Unit of Work que forneça transação PostgreSQL real para essas chamadas.

## Regra central

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

## Estratégia aprovada proposta

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

Essa criação isolada pode ocorrer com requester-scoped client.

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

## KnowledgeSourceRepository

A porta atual somente salva `KnowledgeSource` em `kf_sources`.

Isso é Categoria A e pode ser implementado sem nova RPC.

O fluxo completo de ingestão — fonte + versão + segmentos + permissão — não está contratado pela porta atual e permanece fora do 3B inicial.

## AuditRepository

`append(event)` é uma única inserção em tabela append-only.

Não requer transação multi-tabela e é o primeiro corte recomendado.

## Gate para nova migration transacional

Toda função/RPC nova exige:

- documento/ADR específico;
- migration isolada;
- DB CI descartável;
- teste de rollback;
- revisão de privilégios/RLS;
- aprovação humana.

Merge de RPC continua sem autorizar produção automaticamente.
