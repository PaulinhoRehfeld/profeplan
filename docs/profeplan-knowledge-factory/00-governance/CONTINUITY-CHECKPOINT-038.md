# Checkpoint 038 — C.1.2 integrado; C.1.3 permanece bloqueado

Data: 13 de agosto de 2026.

## Estado canônico verificado

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit canônico pós-merge: `673318c2d3370f60997fd0a15b68bc69c6be5755`;
- tree canônica: `f187e84e3d7917b15f19d4b397376f6bf1006087`;
- commit pai: `2db5fc07378cc7c062753078b2a3fb2025cb1afe`;
- PR nº 34: integrado por squash merge em 13 de agosto de 2026;
- título do merge: `feat(knowledge-factory): implement C.1.2 source lifecycle persistence (#34)`.

## Estado do Lote C.1

- C.1 — definição documental integrada pelo PR nº 32;
- C.1.1 — contratos normativos integrados pelo PR nº 33;
- C.1.2 — persistência incremental, RLS, grants, rollback e testes integrados pelo PR nº 34;
- C.1.3 — não iniciado e bloqueado;
- C.1.4 — bloqueado;
- C.1.5 — bloqueado;
- C.1.6 — bloqueado;
- C.2–C.7 — bloqueados.

A integração de C.1.2 não autoriza continuidade automática para C.1.3.

## Evidências de C.1.2 integradas

C.1.2 adiciona e integra exclusivamente a fundação física do lifecycle governado de fontes:

- sete tabelas aditivas para identidades, fundamentos, projeções, autorizações, eventos e recibos;
- histórico de eventos como fonte autoritativa;
- projeções correntes reconstruíveis;
- estados registrais e estados de autorização separados;
- elegibilidade preservada como decisão derivada, não booleano persistido;
- autorização histórica por finalidade, escopo e janela temporal;
- `commandId`, fingerprint, versão e sequência preparados para idempotência e concorrência futuras;
- constraints, FKs e índices coerentes com C.1.1;
- proteção append-only e imutabilidade física de escopo;
- RLS deny-by-default nas sete tabelas;
- ausência de policies de escrita direta;
- grants mínimos, com `service_role` sem DML direto;
- platform admin autenticado limitado a leitura administrativa RLS-controlled;
- compatibilidade preservada com `kf_sources`, `kf_source_versions` e `kf_source_permission_events`;
- nenhum backfill semântico do legado;
- rollback destrutivo restrito a ambiente descartável e recusado quando houver histórico;
- estratégia forward-only obrigatória após existência de dados reais.

## Evidências de validação antes da integração

HEAD final revisado do PR nº 34:

`d83a6ab8461e79d02569fa61936737542b2cc742`

Gates verificados antes do squash merge:

- CI Pipeline nº 288 — `success`;
- Knowledge Factory DB CI nº 40 — `success`;
- Vercel — `success`;
- migration C.1.2 aplicada em Supabase descartável;
- schema e constraints verdes;
- matriz RLS verde;
- rollback guardado verde;
- reaplicação das migrations verde;
- segunda passagem integral verde;
- integração dos adapters preexistentes preservada;
- lint do banco verde;
- evidência descartável produzida;
- nenhum acesso ao Supabase hospedado ou produção.

## Verificação pós-merge

Após a integração do PR nº 34, a `main` foi consultada novamente e confirmou:

- SHA `673318c2d3370f60997fd0a15b68bc69c6be5755`;
- tree `f187e84e3d7917b15f19d4b397376f6bf1006087`;
- parent `2db5fc07378cc7c062753078b2a3fb2025cb1afe`;
- assinatura GitHub válida no commit de squash;
- PR nº 34 em estado `closed`, `merged: true`;
- `merge_commit_sha` igual ao SHA canônico acima.

## Escopo explicitamente não realizado

C.1.2 não criou ou iniciou:

- RPCs de lifecycle;
- fronteira transacional de comandos;
- adapters novos para lifecycle governado;
- wiring;
- API pública;
- frontend;
- job ou fila;
- ingestão;
- extração;
- segmentação;
- destilação;
- componentização;
- embeddings ou retrieval;
- conteúdo PNLD real;
- uso de Supabase hospedado;
- alteração de produção;
- C.1.3.

## GAPs

- `GAP-3B-04` — permanece ativo e contido. C.1.2 satisfaz a parcela de persistência/segurança, mas o gap só poderá ser decidido em C.1.6 após fronteira atômica, adapters e testes integrados;
- `GAP-3B-05` — permanece ativo e contido;
- `GAP-3B-07` — permanece ativo e contido.

Nenhum desses GAPs é declarado encerrado por este checkpoint.

## Próximo gate seguro

O próximo sublote tecnicamente candidato é **C.1.3 — fronteira atômica para lifecycle e permissão**, porque sua Definition of Ready exige C.1.2 integrado.

Entretanto, C.1.3 continua **bloqueado** até nova autorização humana explícita. Antes de qualquer implementação de C.1.3 devem ser inspecionados, no mínimo:

- invariantes multi-registro que exigem atomicidade;
- sequências de comando e seus estados finais válidos;
- semântica de `commandId`, fingerprint, versão e sequência;
- estratégia de compare-and-set;
- taxonomia provider-neutral de falhas;
- competência jurídico-editorial no contexto server-only;
- grants `EXECUTE` mínimos;
- ausência de DML paralelo;
- rollback, idempotência e concorrência;
- testes negativos de privilégio e bypass;
- compatibilidade com ADR-043 e ADR-058.

Nenhum SQL, RPC, adapter, branch de implementação ou mudança de produção de C.1.3 é autorizado por este checkpoint.

## Regra de continuidade

Este checkpoint formaliza exclusivamente o estado pós-merge de C.1.2. A próxima conversa ou ação deve partir da `main` em `673318c2d3370f60997fd0a15b68bc69c6be5755` e da tree `f187e84e3d7917b15f19d4b397376f6bf1006087`, salvo mudança canônica posterior verificada explicitamente.
