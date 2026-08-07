# Lote 3B — Fronteira com produção

Status: **aprovado integralmente em 7 de agosto de 2026.**

## Regra principal

**Definir ou implementar adapters Supabase não autoriza aplicar a migration 3A em produção.**

São trilhas relacionadas, porém independentes.

## Trilha A — Lote 3B

Pode avançar usando exclusivamente:

- contratos versionados;
- domínio puro;
- schema/migration versionados no Git;
- Supabase descartável do CI;
- fixtures sintéticas;
- clients locais descartáveis.

Pode concluir adapters sem qualquer acesso ao projeto Supabase hospedado.

## Trilha B — Pre-flight de produção

Permanece bloqueada até autorização específica.

Antes de qualquer conexão operacional com o Supabase real:

1. identificar formalmente o project ref alvo;
2. confirmar que o alvo é produção;
3. capturar snapshot/schema atual;
4. comparar migrations versionadas versus schema real;
5. analisar drift;
6. verificar ausência de `kf_*` conflitantes;
7. confirmar backup/restore capability;
8. definir executor;
9. definir janela e impacto;
10. definir comando exato de aplicação;
11. definir critérios de abort;
12. definir resposta em falha;
13. revisar secrets e permissões;
14. obter autorização humana explícita.

## Secrets

Nunca registrar em:

- documentação;
- issue;
- PR;
- commit;
- fixture;
- log de CI;
- chat;

os seguintes valores reais:

- database password;
- access token;
- service role key;
- JWT secret;
- connection string com senha.

## Wiring de produção

Mesmo após adapters mergeados, eles permanecerão sem wiring de endpoint/serviço de produto até que:

- migration exista no ambiente alvo;
- pre-flight seja aprovado;
- observabilidade esteja pronta;
- health check seja definido;
- rollback/roll-forward seja aprovado.

## Ordem aprovada

```text
Definição 3B aprovada
→ primeiro adapter em CI descartável
→ adapters subsequentes mediante gates próprios
→ definição separada de pre-flight
→ autorização de conexão ao alvo
→ snapshot/drift/backup
→ autorização de aplicação
→ migration em produção
→ smoke test
→ somente depois wiring operacional
```

A ordem só poderá ser alterada por decisão explícita que preserve o gate independente de produção.