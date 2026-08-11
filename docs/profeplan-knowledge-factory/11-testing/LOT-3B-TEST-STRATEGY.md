# Lote 3B — Estratégia de testes dos adapters Supabase

## Status

**Aprovado integralmente em 7 de agosto de 2026.**

## Objetivo

Provar que adapters:

- implementam exatamente as portas;
- mapeiam corretamente SQL ↔ contratos;
- traduzem erros;
- respeitam append-only;
- funcionam no Supabase real descartável;
- não dependem de produção;
- não enfraquecem RLS.

## Nível 1 — testes unitários

Executados sem rede e sem banco.

### Escopo

- mapper row → contrato;
- mapper contrato → payload;
- `null`/optional;
- datas;
- arrays;
- erro Supabase/PostgREST → erro estável;
- query esperada;
- filtros obrigatórios;
- ordenação esperada;
- telemetria;
- redaction;
- comportamento append-only da API do adapter.

### Test double

Pode reutilizar como referência o padrão já existente no monorepo de query builder Supabase controlado, porém o novo pacote deve possuir seus próprios helpers mínimos e não importar testes do frontend.

### Regra

Unit test não prova RLS, FK ou trigger.

## Nível 2 — integração com Supabase descartável

Reutilizar o stack criado por:

`.github/workflows/knowledge-factory-db-ci.yml`

Não criar um segundo ambiente paralelo de banco.

### Fluxo aprovado

```text
checkout
→ Supabase CLI
→ baseline sintética
→ migration 3A
→ SQL schema/RLS já existentes
→ instalar/buildar pacote adapter
→ executar testes de integração TypeScript contra stack local
→ lint DB
→ destruir ambiente sem backup
```

### Credenciais locais

Somente chaves geradas pelo Supabase local descartável.

Regras:

- capturar sem imprimir;
- aplicar `add-mask` no GitHub Actions;
- não subir em artifact;
- não salvar em arquivo versionado;
- apagar temporários ao fim.

Nenhuma secret hospedada é necessária.

## Nível 3 — isolamento e autorização

### Corpus global

Adapters SYSTEM usam client privilegiado; portanto RLS não é o único gate.

Testar:

- adapter não cria/consulta sem filtro quando método exige ID;
- mapper não retorna campo não contratado;
- erro não contém secret;
- conteúdo sensível não entra em log;
- código não chama `createClient`/`process.env` dentro do pacote.

A matriz SQL do Lote 3A continua provando negação direta ao professor.

### OPP/requester

No Lote 3B.5 concluído:

- usuário A lê OPP A;
- usuário A não lê OPP B;
- usuário B não lê OPP A;
- OPP estrangeira retorna `null`, sem permitir enumeração;
- requester adulterado falha;
- contexto sem identidade falha como `UNAUTHORIZED`;
- professor não atualiza status diretamente;
- professor não insere evento arbitrário;
- client request-scoped é usado no fluxo do professor;
- service role não substitui teste de RLS.
- criação persiste OPP, `created` e recibo ou reverte tudo;
- transição persiste UPDATE, evento e recibo ou reverte tudo;
- `authenticated` não executa RPC de transição;
- backend não usa DML direto para transicionar;
- requester/status/timestamp esperados são comparados sob lock;
- evento é derivado do destino, não fornecido pelo chamador;
- replay não duplica OPP nem evento;
- concorrência produz resultado determinístico;
- matriz SQL de transições mantém paridade com o contrato TypeScript.

As provas foram concluídas pelos Pull Requests nº 25 a 28 e pelo DB CI nº 31. Wiring, Supabase
hospedado e produção permanecem bloqueados por gates próprios.

## Primeiro PR — AuditRepository

### Testes unitários obrigatórios

1. `append()` mapeia `DomainEvent` para `kf_audit_events`;
2. usa INSERT, nunca UPSERT;
3. `listByAggregate()` filtra `aggregate_id`;
4. lista ordenada por `occurred_at`;
5. row SQL reconstrói `DomainEvent`;
6. erro `23505` → `CONFLICT` quando aplicável;
7. `42501`/permission denied → `FORBIDDEN`;
8. falha de rede → `UNAVAILABLE`;
9. erro desconhecido → `UNKNOWN`;
10. logger recebe operação/duração/outcome, não payload integral;
11. nenhum token/chave é logado;
12. adapter não expõe update/delete;
13. campos físicos adicionais de auditoria não são inventados no retorno `DomainEvent`;
14. US-013.2 permanece fatia parcial conforme GAP-3B-05.

### Testes de integração obrigatórios

1. stack 3A sobe limpa;
2. insert sintético via `AuditRepository.append()`;
3. linha existe em `kf_audit_events`;
4. `listByAggregate()` retorna apenas aggregate solicitado;
5. dois aggregates não se misturam;
6. tentativa de mutação UPDATE da linha pelo executor privilegiado falha pelo trigger append-only;
7. tentativa DELETE falha pelo trigger;
8. dados do teste são removidos pela destruição do ambiente, não por delete do adapter;
9. DB lint continua verde.

## Testes de contrato do pacote

Cada classe concreta deverá ser atribuível à interface correspondente no typecheck.

É proibido fazer o adapter compilar por `any` generalizado.

`unknown` pode ser usado na borda do provider e deve ser refinado antes de entrar no domínio.

## Testes de produção proibidos

Nenhuma suíte deve usar:

- `SUPABASE_SERVICE_ROLE_KEY` hospedada;
- project ref real;
- URL do projeto de produção;
- usuário real;
- dado real;
- PNLD real;
- currículo real;
- snapshot de produção como fixture versionada.

## Evidência de CI

Para cada PR de adapter registrar:

- commit SHA;
- CI geral;
- DB CI;
- número de testes unitários;
- número de testes de integração;
- resultado de lint DB quando aplicável;
- confirmação de zero secrets hospedadas;
- confirmação de ambiente destruído.

Artifacts nunca devem conter chaves locais, mesmo descartáveis.

## Failure injection

Unitários deverão simular:

- resposta `{ data: null, error: null }`;
- erro de constraint;
- erro de permissão;
- resposta malformada;
- timeout/falha de fetch;
- retorno de array vazio;
- retorno inesperado de mais de uma linha em operação single.

O objetivo é impedir que o adapter trate ausência, indisponibilidade e violação de regra como a mesma coisa.

## Critério de saída por adapter

Um adapter fica pronto para revisão quando:

1. typecheck próprio verde;
2. unitários verdes;
3. integração descartável verde;
4. CI geral verde;
5. DB CI verde;
6. sem secret real;
7. sem produção;
8. sem mudança de porta não aprovada;
9. sem migration não aprovada;
10. escopo do PR permanece uma fatia pequena.
