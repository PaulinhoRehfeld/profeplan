# Matriz de RLS e autorização — Lote 3

## Status

**Proposta documental. Não cria policies.**

## Princípio

A Knowledge Factory seguirá `deny by default`.

RLS não será usada como única barreira. Para o corpus global haverá defesa em profundidade:

1. `REVOKE` explícito de privilégios diretos para `anon` e `authenticated`;
2. RLS habilitada;
3. ausência de policy de professor para corpus global;
4. acesso de backend somente por adapter autorizado;
5. políticas de licença/status aplicadas no domínio;
6. auditoria de operações administrativas.

## Papéis físicos disponíveis no produto atual

O schema atual possui papéis de perfil como:

- `teacher`;
- `manager`;
- `school_admin`;
- `admin`;
- legado `school_manager`.

Para governança global da Knowledge Factory, **somente `admin` será reconhecido como administrador de plataforma neste lote**.

`manager`, `school_admin` e `school_manager` são papéis escolares e não receberão privilégios de curadoria global por associação nominal.

Papéis futuros como `curator`, `legal_editorial_reviewer` e `curriculum_reviewer` permanecem conceituais e não serão adicionados neste lote.

## Helper mínimo proposto

Função:

`public.kf_is_platform_admin()`

Características:

- `SECURITY DEFINER`;
- `SET search_path = public`;
- retorna `true` apenas quando `profiles.id = auth.uid()` e `profiles.role = 'admin'`;
- owner controlado;
- execute concedido somente a `authenticated` quando necessário;
- não recebe user id como argumento, evitando impersonação por parâmetro.

A função não concede escrita direta no corpus. Serve apenas para policies administrativas de leitura/auditoria onde aprovadas.

## Classes de dados

### Classe A — corpus global curado

Tabelas:

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

### Classe B — produção privada

- `kf_production_orders`;
- `kf_production_order_events`.

### Classe C — auditoria

- `kf_audit_events`.

## Matriz de acesso direto

| Ator                 |            Corpus global SELECT | Corpus global WRITE | OPP própria SELECT | OPP INSERT direto | OPP UPDATE direto | Eventos OPP SELECT | Auditoria SELECT | Auditoria WRITE |
| -------------------- | ------------------------------: | ------------------: | -----------------: | ----------------: | ----------------: | -----------------: | ---------------: | --------------: |
| anon                 |                           negar |               negar |              negar |             negar |             negar |              negar |            negar |           negar |
| teacher              |                           negar |               negar |           permitir |             negar |             negar |  permitir próprios |            negar |           negar |
| manager              |                           negar |               negar |  permitir próprias |             negar |             negar |  permitir próprios |            negar |           negar |
| school_admin         |                           negar |               negar |  permitir próprias |             negar |             negar |  permitir próprios |            negar |           negar |
| admin                | permitir leitura administrativa |        negar direta |  permitir próprias |             negar |             negar |  permitir próprios |         permitir |    negar direta |
| service_role/backend |                     via backend |         via backend |        via backend |      negar direto |      negar direto |        via backend |      via backend |     via backend |

Observação: `service_role` pode contornar RLS no Supabase. Portanto, autorização de backend deve aplicar as políticas do domínio; service role não é permissão pedagógica nem jurídica.

## Policies conceituais

### Corpus global

Para `anon`:

- nenhuma policy.

Para `authenticated` comum:

- nenhuma policy de SELECT/INSERT/UPDATE/DELETE.

Para `admin`:

- SELECT administrativo pode usar `kf_is_platform_admin()`;
- nenhuma escrita direta por tabela neste lote.

Escrita ocorre por adapter/backend com domínio validado.

## OPP — SELECT

Policy conceitual:

```sql
USING (requester_id = auth.uid())
```

No MVP individual, isso representa isolamento entre usuários.

## OPP — INSERT

Policy conceitual:

```sql
WITH CHECK (requester_id = auth.uid())
```

O schema 3A implementou esse INSERT direto como preparação. O 3B.5.3 o substituiu por RPC REQUESTER
que deriva `requester_id = auth.uid()` e grava atomicamente OPP `requested`, evento `created` e
recibo. A migration revogou o INSERT direto de `authenticated` e de `service_role`; grants,
atomicidade e bypass negado foram aprovados no DB CI nº 31. A policy histórica permanece no schema,
mas não constitui superfície executável sem privilégio de tabela.

## OPP — UPDATE/DELETE

Nenhuma policy de update/delete para professor.

Motivo:

- transição de status precisa passar pela máquina de estados do domínio;
- impedir `requested → ready` por update direto;
- manter linha do tempo coerente.

## Eventos de OPP

Professor pode ler eventos quando:

```text
evento.opp_id pertence a OPP cujo requester_id = auth.uid()
```

Não pode inserir, atualizar ou excluir diretamente.

## Comandos de OPP definidos no 3B.5

Criação:

- executável por `authenticated` via RPC estreita;
- `auth.uid()` obrigatório e usado como requester;
- payload não escolhe requester, status ou timestamps da OPP;
- atomicidade com evento `created` e recibo.

Transição:

- não executável por `anon` ou `authenticated`;
- executável somente pelo backend server-side;
- política de domínio deve aceitar a transição antes da chamada;
- RPC verifica requester esperado, estado esperado, timestamp esperado e matriz estrutural;
- UPDATE da OPP, evento e recibo são uma unidade.

RLS permanece a defesa primária das leituras. A RPC server-only não transforma `service_role` em
permissão pedagógica: seu uso é restrito à transição já autorizada pela aplicação, sem DML direto.

## Auditoria

`kf_audit_events`:

- sem SELECT para teacher/manager/school_admin;
- SELECT para `admin` com helper;
- escrita somente por backend/worker;
- UPDATE/DELETE proibidos em fluxo normal;
- metadados minimizados.

## Append-only

Tabelas:

- `kf_source_permission_events`;
- `kf_production_order_events`;
- `kf_audit_events`.

Requisitos:

- nenhuma API/repository port expõe delete;
- grants comuns não permitem update/delete;
- trigger de proteção deve ser considerado para impedir mutação acidental por role não privilegiada;
- correções de auditoria usam novo evento, não edição silenciosa.

## Acesso a segmentos protegidos

`kf_source_segments.extracted_text` nunca será retornado diretamente ao professor.

Mesmo que a fonte seja curricular pública, o padrão é acesso por serviço/retrieval futuro.

Para fonte restrita:

- teacher: negar;
- admin: leitura somente quando necessária à governança;
- backend: somente após política de elegibilidade e finalidade;
- logs não devem copiar `extracted_text`.

## Revogação de licença

O Lote 3 deverá garantir persistência suficiente para o domínio responder a revogação:

1. novo `kf_source_permission_events` append-only;
2. atualização controlada do status/allowed uses da raiz da fonte;
3. evidências continuam navegáveis historicamente;
4. componentes derivados não são apagados automaticamente;
5. lote futuro deverá recalcular elegibilidade/derivados.

Não haverá cascade delete de fonte para componente.

## FK e CASCADE

Regra padrão:

- evitar `ON DELETE CASCADE` em entidades de procedência, versões e auditoria;
- preferir `RESTRICT`/`NO ACTION`;
- dados históricos não devem desaparecer pela exclusão de uma raiz;
- uso normal arquiva/bloqueia, não apaga.

## Threat tests obrigatórios do PR 3A

1. anon tenta SELECT em `kf_sources` → negar;
2. teacher tenta SELECT em `kf_sources` → negar;
3. teacher tenta SELECT em `kf_source_segments` → negar;
4. admin pode ler corpus global autorizado → permitir;
5. school_admin não ganha acesso ao corpus global → negar;
6. usuário A lê OPP A → permitir;
7. usuário A lê OPP B → negar;
8. usuário A cria OPP com requester B → negar;
9. usuário A tenta UPDATE direto de status → negar;
10. usuário A tenta inserir evento OPP → negar;
11. usuário A lê eventos da própria OPP → permitir;
12. usuário A lê eventos da OPP B → negar;
13. teacher lê auditoria → negar;
14. admin lê auditoria → permitir;
15. UPDATE em evento append-only por role comum → negar;
16. DELETE em evento append-only por role comum → negar;
17. fonte bloqueada continua persistida e auditável, não é deletada;
18. duas versões curriculares `active` concorrentes do mesmo Estado/etapa → constraint falha;
19. evidência com segmento inexistente → FK falha;
20. componente aponta `current_version_id` de outro componente → constraint/trigger falha.

## Dados de estudante

Nenhuma tabela do Lote 3 contém:

- student_id;
- nome de estudante;
- CPF;
- diagnóstico;
- laudo;
- nota individual.

O corpus global não depende de dados de estudantes.

## Segredos

Nenhuma tabela `kf_*` armazena:

- service role key;
- provider API key;
- access token;
- senha;
- credencial de storage.

## Service role

Regras obrigatórias para lotes futuros:

- nunca no frontend;
- client criado no backend;
- adapter recebe finalidade/contexto;
- domínio valida licença/status antes de operação de conhecimento;
- operação administrativa produz audit event;
- queries devem ser restritas por IDs/filtros, não por SELECT global por conveniência.

## Gate de aprovação

Nenhuma migration de RLS poderá ser implementada antes de aprovação desta matriz e do plano de rollback.
