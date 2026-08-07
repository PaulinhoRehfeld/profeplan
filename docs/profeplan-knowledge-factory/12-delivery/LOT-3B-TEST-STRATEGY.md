# Lote 3B — Estratégia de testes

Status: proposta documental.

## Princípio

Nenhum teste do Lote 3B poderá depender de projeto Supabase hospedado, dados reais ou credenciais de produção.

A estratégia terá três níveis obrigatórios.

## Nível 1 — unitário

Objetivo: provar mappers, classificação de erros e comportamento da porta sem banco.

Ferramentas preferidas:

- runner já utilizado pelo pacote;
- fakes/mocks mínimos do cliente Supabase;
- nenhuma rede.

Cobertura mínima por adapter:

- row → contrato;
- contrato → row;
- `null` quando aplicável;
- erro de provider → erro sanitizado;
- arrays relacionais reconstruídos corretamente;
- logging sem segredo/payload bruto.

## Nível 2 — integração em Supabase descartável

Reutilizar o stack já criado pelo workflow:

`.github/workflows/knowledge-factory-db-ci.yml`

A integração deve usar:

- migration 3A real;
- baseline sintética mínima;
- dados `kf_*` exclusivamente sintéticos;
- clientes criados contra a instância local;
- zero `SUPABASE_ACCESS_TOKEN`;
- zero project ref hospedado.

O workflow poderá ser estendido ou composto, mas não duplicado sem necessidade.

## Nível 3 — autorização/isolamento

Para adapters requester-scoped:

- user A lê própria OPP;
- user A não lê OPP B;
- requester adulterado falha;
- professor não lê corpus global;
- `school_admin` não vira admin global;
- operação proibida falha por RLS/grant.

Para adapters system-scoped:

- system consegue a operação explicitamente permitida;
- adapter não expõe o client/secret;
- nenhuma operação proibida é oferecida pela API do adapter.

## Primeiro PR 3B — AuditRepository

### Unitários

- mapper `DomainEvent` → insert row;
- mapper row → `DomainEvent`;
- append chama somente INSERT em `kf_audit_events`;
- list chama SELECT por aggregate e ordena por `occurred_at`;
- nenhuma função update/delete existe;
- erros são traduzidos;
- logger recebe metadados sanitizados.

### Integração

No Supabase descartável:

1. aplicar baseline + migration 3A;
2. inserir evento sintético via adapter system;
3. listar por aggregate;
4. comparar contrato reconstruído;
5. comprovar trigger append-only via SQL já existente;
6. comprovar que usuário comum não lê audit diretamente;
7. destruir ambiente.

## Reutilização do CI 3A

Mudança preferida futura:

- incluir `packages/knowledge-factory-supabase/**` nos paths do workflow;
- instalar dependências Node após o stack estar disponível;
- executar testes de integração do pacote contra `127.0.0.1:54321/54322` conforme configuração local;
- preservar o job atual de migration/schema/RLS/rollback.

Alternativa permitida:

- criar job adicional no mesmo workflow, dependente do job de validação do schema, desde que não duplique stack desnecessariamente.

## Evidências

Guardar em artifacts apenas:

- commit;
- versão da CLI;
- suíte executada;
- nomes dos cenários;
- pass/fail;
- tempos;
- mensagens sanitizadas.

Não guardar:

- chaves locais geradas;
- token;
- service role;
- conteúdo pedagógico bruto.

## Teste de não dependência de produção

O CI deverá falhar se o teste exigir qualquer uma destas variáveis:

- project ref hospedado;
- `SUPABASE_ACCESS_TOKEN`;
- `SUPABASE_SERVICE_ROLE_KEY` de projeto real;
- URL externa de produção.

## Gate de Ready for Code

O primeiro PR só estará Ready for Code após aprovação documental de:

- package boundary;
- dependência Supabase;
- system context injetado;
- erro sanitizado;
- logger injetado;
- reuse do disposable CI;
- escopo exclusivo de AuditRepository.