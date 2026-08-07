# Lote 3B — Estratégia de transações

Status: proposta documental.

## Princípio

Supabase JS não será tratado como se oferecesse transação multi-call entre operações independentes.

Nenhuma sequência do tipo:

1. grava tabela A;
2. grava tabela B;
3. grava evento;

será chamada de atômica apenas porque está dentro de um mesmo método TypeScript.

## Classes de operação

### Classe A — operação unitária

Uma única instrução lógica em uma tabela, sem necessidade de estado coordenado em outra tabela.

Exemplo inicial:

- `AuditRepository.append`.

Pode usar Supabase JS diretamente.

### Classe B — leitura composta

Múltiplos SELECTs usados para reconstruir um contrato, sem alteração de estado.

Exemplos:

- componente + evidências + links curriculares;
- pacote curricular + sourceVersionIds.

Pode usar chamadas independentes, desde que:

- não prometa snapshot transacional forte;
- documente consistência esperada;
- falha intermediária resulte em erro do adapter, não em objeto parcial silencioso.

### Classe C — escrita multi-tabela atômica

Exemplos:

- componente + primeira versão + current_version;
- versão de componente + evidências + vínculos curriculares;
- OPP + evento de transição;
- fonte + versão + evento de permissão, quando existir caso de uso.

Não poderá ser implementada como sequência best-effort.

## Estratégia recomendada para Classe C

Preferência: função SQL/RPC transacional, pequena e orientada ao comando de domínio.

Exemplos futuros conceituais:

- `kf_create_component_with_version(...)`;
- `kf_transition_production_order(...)`.

Esses nomes são ilustrativos e **não autorizam criação de RPC nesta fase**.

Cada RPC futura exigirá:

- documentação;
- migration separada;
- testes SQL;
- RLS/GRANT review;
- rollback;
- autorização humana.

## Unit of Work

Não foi encontrada Unit of Work canônica no monorepo.

Não criar uma abstração genérica antes de existir caso comprovado e suporte real do provider.

## Compensação

Compensating actions não substituem atomicidade em:

- proveniência;
- current version;
- timeline de OPP;
- auditoria.

Podem ser utilizadas futuramente apenas para integrações externas inevitavelmente distribuídas, mediante ADR própria.

## Primeiro PR 3B

`AuditRepository` não precisa de transação multi-tabela e, por isso, é a fatia segura para provar a infraestrutura de adapters.

## Gate

Se a implementação de uma porta exigir escrever mais de uma tabela de modo logicamente indivisível, interromper e abrir decisão específica de transação antes do código.