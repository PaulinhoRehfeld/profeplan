# Sublote C.1.2 — Matriz RLS e grants do lifecycle de fontes

Data: 12 de agosto de 2026.

## Status

Implementada na branch de C.1.2 e validada no Supabase descartável pelo `Knowledge Factory DB CI`
run nº 32 (`31657560628`) do Draft PR nº 34. O run concluiu com `success`, incluindo duas passagens
dos testes de schema/RLS e ensaio de rollback/reaplicação. Nenhuma política ou grant foi aplicado a
ambiente hospedado ou produção. A integração à `main` ainda depende de autorização humana específica.

## Princípios

- deny-by-default para todas as sete tabelas novas;
- papel PostgreSQL, papel técnico e competência jurídico-editorial são dimensões distintas;
- `service_role`, SYSTEM e administrador técnico não concedem autorização de negócio;
- RLS não substitui a política de domínio;
- nenhuma escrita direta é exposta em C.1.2;
- os documentos jurídicos integrais não são persistidos: somente tipo e digest/referência minimizada.

## Matriz efetiva de acesso direto

| Identidade técnica/contexto | Leitura direta | Escrita direta | Justificativa |
|---|---|---|---|
| `PUBLIC` | negada | negada | nenhum privilégio implícito |
| `anon` | negada | negada | lifecycle administrativo não é público |
| `authenticated` comum/professor | zero linhas por RLS | negada | corpus e governança não são superfície de professor |
| `authenticated` `school_admin` | zero linhas por RLS | negada | administração escolar não é administração global da Knowledge Factory |
| `authenticated` platform admin | leitura das sete tabelas via `kf_is_platform_admin()` | negada | leitura administrativa minimizada, sem autoridade jurídica/editorial |
| `service_role` | negada por ausência explícita de grant | negada por ausência explícita de grant | bypass de RLS não pode virar DML ou autorização de negócio |
| owner/migration runner descartável | física, para migration/teste | física, para migration/teste | não é identidade de runtime nem autorização de uso |

Todos os privilégios são primeiro revogados de `PUBLIC`, `anon`, `authenticated` e `service_role`.
Somente `SELECT` é devolvido a `authenticated`; sete políticas `FOR SELECT` admitem linhas apenas
quando `public.kf_is_platform_admin()` é verdadeiro. Não existem policies de `INSERT`, `UPDATE`,
`DELETE` ou `ALL`.

## Papéis conceituais de C.1.1

| Papel conceitual | Competência futura | Situação em C.1.2 |
|---|---|---|
| `curator` | registrar e validar procedência | persistido em eventos; não mapeado a role PostgreSQL e sem DML direto |
| `legal_editorial_reviewer` | conceder, restringir, suspender, revogar e superseder | persistido em eventos; validação da competência fica para a fronteira C.1.3 |
| `system_worker` | executar somente decisão previamente autorizada | persistido em eventos; não recebe autoridade jurídica |
| `auditor` | consultar trilha minimizada | nenhuma role/runtime nova nesta fatia |
| `technical_admin` | operar tecnicamente sem decidir direitos | não recebe escrita; platform admin mantém somente leitura administrativa |

C.1.3 deverá validar competência de negócio em contexto server-only por mecanismo aprovado — claims,
tabela de atribuições, função de autorização ou composição — e conceder somente `EXECUTE` na
fronteira estreita. Esta matriz não antecipa essa decisão nem cria role PostgreSQL nova.

## Proteção append-only

Triggers bloqueiam `UPDATE` e `DELETE` em identidades, fundamentos, eventos, recibos e relação
recibo–evento, inclusive para executor privilegiado. Um trigger adicional permite atualizar a
projeção corrente da autorização sem permitir mutação de sujeito, finalidade, restrições,
fundamento, janela ou `created_at`.

As projeções registrais e o estado/versionamento projetado da autorização só poderão ser escritos
pela fronteira transacional futura. Em C.1.2, nenhum role de runtime tem DML direto.

## Evidência de teste executada

`knowledge_factory_source_lifecycle_rls.sql` cobre `anon`, professor, `school_admin`, platform admin
e `service_role`, além de RLS habilitada nas sete tabelas e ausência de policies de mutação.
`knowledge_factory_source_lifecycle_schema.sql` cobre append-only e imutabilidade de escopo.

No `Knowledge Factory DB CI` run nº 32 (`31657560628`), ambas as suítes passaram antes e depois do
ensaio de rollback/reaplicação, no HEAD `c742a422373271633dea86ade80afeb3d1a7c396`. O artefato
`knowledge-factory-db-validation-31657560628` foi produzido como evidência do ambiente descartável.
O `CI Pipeline` run nº 280 também concluiu com `success`. Esses resultados não autorizam acesso a
ambiente hospedado, produção nem o início de C.1.3.
