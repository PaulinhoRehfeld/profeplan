# Sublote C.1.3 — Matriz de competência e EXECUTE da fronteira de lifecycle

Data da definição: 13 de agosto de 2026.

Base canônica: `7faf6af817099ce45757d606b392695bc4baee0d`.

## Status

Definição documental. Nenhuma role, grant, policy, função ou tabela foi alterada por este documento.
A eventual implementação exige novo gate humano e ambiente descartável.

## 1. Princípio central

C.1.3 separa três dimensões que não podem ser colapsadas:

1. identidade técnica que consegue alcançar a RPC;
2. ator de negócio registrado no comando;
3. competência vigente daquele ator para a decisão específica.

`service_role`, SYSTEM, platform admin e technical admin não constituem autorização jurídico-editorial.

## 2. Canal técnico

A fronteira futura será server-only no MVP.

Matriz de `EXECUTE` proposta:

| Identidade técnica | EXECUTE nas RPCs públicas C.1.3 | DML direto nas tabelas | Observação |
|---|---:|---:|---|
| PUBLIC | não | não | nenhuma superfície implícita |
| anon | não | não | lifecycle não é público |
| authenticated comum | não | não | professor não executa governança global |
| school_admin | não | não | papel escolar não é governança global |
| platform admin | não por ser admin | não | leitura administrativa não vira decisão |
| service_role | sim, somente RPCs explicitamente concedidas | não | canal técnico server-only |
| owner/migration runner descartável | físico para migration/teste | físico para migration/teste | não é runtime |

A implementação futura deverá executar:

```text
REVOKE ALL ON FUNCTION ... FROM PUBLIC, anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION ... TO service_role;
```

somente nas RPCs públicas aprovadas. Helpers internos continuam sem `EXECUTE` para `service_role`.

A concessão a `service_role` não concede competência de negócio: a RPC verifica o ator separadamente.

## 3. Fonte autoritativa de competência

A inspeção de C.1.3 demonstrou que os contratos e tabelas atuais registram `actorId`/`actorRole`, mas
não provam a atribuição real do papel. Confiar no papel recebido no payload seria bypass de
governança.

C.1.3 define conceitualmente uma estrutura mínima:

`public.kf_source_actor_assignments`

Responsabilidade exclusiva: provar que um `actor_id` possuía determinado `actor_role` em um instante.

Campos mínimos propostos:

- `id uuid` — identidade da atribuição;
- `actor_id uuid` — ator governado;
- `actor_role text` — um dos papéis de C.1.1;
- `effective_from timestamptz`;
- `effective_until timestamptz null`;
- `created_at timestamptz`.

Invariantes:

- janela válida;
- nenhum booleano `is_admin` ou `can_decide_legal` como atalho universal;
- nenhuma equivalência automática com `profiles.role`;
- nenhuma equivalência automática com `service_role`;
- leitura e DML runtime deny-by-default;
- C.1.3 não cria UI/API para administrar atribuições;
- fixtures sintéticas podem ser criadas apenas na suíte descartável;
- gestão operacional de atribuições em produção permanece gate futuro.

A competência do comando é avaliada no `occurredAt` da decisão.

## 4. Matriz de competência de negócio

| Comando | curator | legal_editorial_reviewer | system_worker | auditor | technical_admin |
|---|---:|---:|---:|---:|---:|
| register_identity | sim | não | não | não | não |
| request_validation | sim | não | não | não | não |
| confirm_validation | sim | não | não | não | não |
| block_source | sim | não | não | não | não |
| replace_source | sim | não | não | não | não |
| archive_source | sim | não | não | não | não |
| grant_authorization | não | sim | não | não | não |
| suspend_authorization | não | sim | não | não | não |
| resume_authorization | não | sim | não | não | não |
| revoke_authorization | não | sim | não | não | não |
| block_purpose | não | sim | não | não | não |
| supersede_authorization | não | sim | não | não | não |
| open_impact_assessment | sim | sim | não | não | não |

`system_worker` permanece deliberadamente sem decisão autônoma. Ele poderá executar operações futuras
já autorizadas, mas não se torna curador ou reviewer por operar tecnicamente.

## 5. SECURITY DEFINER

O uso é justificável porque C.1.2 removeu DML direto das sete tabelas e a fronteira precisa alterar
múltiplas relações em uma única transação.

Toda RPC pública futura deverá possuir:

```text
SECURITY DEFINER
SET search_path = pg_catalog, public
```

Requisitos adicionais:

- owner controlado;
- nenhuma dependência de `search_path` do caller;
- objetos críticos schema-qualified;
- nenhum SQL dinâmico com identificadores vindos do payload;
- validação de payload fechado;
- helpers internos sem `EXECUTE` externo;
- sem leitura de env/secrets no banco;
- sem delegação de competência a claims não verificadas.

## 6. Ordem de autorização dentro da RPC

Para comando novo:

1. idempotência/replay;
2. validação do fingerprint;
3. validação da assignment do ator no `occurredAt`;
4. validação command→role;
5. lock/CAS do agregado;
6. invariantes de domínio verificáveis no banco;
7. escrita atômica.

Replay acontece antes da competência atual porque revogação posterior da assignment não invalida um
comando já comprometido historicamente.

## 7. Negative tests obrigatórios

A suíte de C.1.3 deverá provar:

- anon não executa RPC;
- authenticated comum não executa RPC;
- school_admin não executa RPC;
- platform admin não executa RPC por condição de admin;
- service_role continua sem SELECT/INSERT/UPDATE/DELETE direto nas tabelas C.1.2;
- service_role chama RPC com actor sem assignment → `FORBIDDEN`;
- service_role chama RPC com actor de role errada → `FORBIDDEN`;
- assignment fora da vigência → `FORBIDDEN`;
- curator não concede autorização;
- reviewer não se torna curator implicitamente;
- technical_admin não registra nem decide direitos;
- auditor não modifica lifecycle;
- system_worker não origina decisão de governança;
- RPC com actor competente e pré-condições válidas consegue escrever via SECURITY DEFINER.

## 8. Risco residual reconhecido

C.1.3 prova que o `actorId` possui assignment, mas o canal server-side ainda é responsável por
transportar corretamente a identidade do decisor. Não há assinatura criptográfica individual ou
não-repúdio jurídico nesta fatia.

Adicionar assinatura, workflow de aprovação humana, dupla aprovação ou trilha de autenticação forte
exigirá contrato e gate próprios. C.1.3 não deve inventá-los incidentalmente.

## 9. Produção

Nenhum grant desta definição deve ser aplicado em Supabase hospedado. A futura validação será
exclusivamente descartável/local. Aplicação em produção permanece gate independente.
