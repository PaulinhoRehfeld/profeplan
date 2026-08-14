# Plano de rollback — Lote 3

## Status

**Proposta documental. Nenhuma execução em banco está autorizada por este documento.**

## Objetivo

Garantir que a introdução da persistência da Knowledge Factory seja reversível sem afetar o produto atual.

## Princípio central

O Lote 3A será exclusivamente aditivo.

Não poderá:

- alterar tabela legada;
- renomear coluna existente;
- remover policy existente;
- alterar função existente;
- migrar dados atuais;
- substituir `curriculum_rag`;
- alterar auth/profile/school schema;
- habilitar vetores.

Com isso, rollback pode remover apenas objetos `kf_*` enquanto ainda não houver dependentes posteriores.

## Ambientes

### Desenvolvimento/descartável

Obrigatório para primeiro ensaio:

1. aplicar migration;
2. executar testes de constraints/RLS;
3. executar rollback;
4. reaplicar migration;
5. repetir testes.

### Homologação

Obrigatório antes de produção:

- schema equivalente ao necessário;
- somente fixtures ou corpus autorizado;
- credenciais distintas;
- nenhum dump informal de produção.

### Produção

Aplicação somente após aprovação humana separada.

Merge de PR não autoriza execução produtiva.

## Pré-flight antes de aplicar

Registrar:

- commit exato da migration;
- ambiente alvo;
- timestamp UTC;
- executor;
- versão do Supabase/PostgreSQL disponível;
- snapshot do schema;
- lista atual de objetos `kf_*`;
- confirmação de backup;
- confirmação de que não há migration posterior dependente.

## Estratégia de rollback físico

A migration deverá acompanhar um script de rollback revisável, porém **não executado automaticamente**.

Ordem de remoção proposta, respeitando FKs:

1. policies `kf_*`;
2. triggers/funções auxiliares específicas do Lote 3;
3. `kf_component_curriculum_links`;
4. `kf_curriculum_links`;
5. `kf_curriculum_package_sources`;
6. `kf_component_source_evidence`;
7. `kf_production_order_events`;
8. `kf_audit_events`;
9. `kf_production_orders`;
10. `kf_curriculum_nodes`;
11. `kf_curriculum_packages`;
12. FK de `current_version_id`;
13. `kf_component_versions`;
14. `kf_pedagogical_components`;
15. `kf_source_segments`;
16. `kf_source_permission_events`;
17. `kf_source_versions`;
18. `kf_sources`;
19. helper `kf_is_platform_admin()` se não houver dependentes.

A ordem final deverá ser validada contra o SQL real antes do merge.

## Regra contra perda de dados

Rollback destrutivo é permitido apenas quando:

- ambiente é descartável; ou
- tabelas contêm exclusivamente fixtures; ou
- houve export/backup validado e autorização humana explícita.

Se qualquer tabela `kf_*` contiver dados reais úteis, o rollback padrão deixa de ser `DROP` e passa a exigir plano de preservação/migração específico.

## Roll-forward preferencial em produção

Após uso real, a preferência será corrigir via nova migration, não apagar o schema.

Exemplos:

- policy incorreta → migration corretiva;
- índice inadequado → migration de índice;
- check incompleto → migration de constraint;
- coluna faltante → migration aditiva.

DROP em produção é último recurso.

## Rollback por falha de RLS

Se teste ou produção indicar exposição indevida:

1. interromper tráfego da feature/futuro endpoint;
2. revogar grants diretos de `anon`/`authenticated` para `kf_*`;
3. desabilitar feature/adapter consumidor;
4. preservar dados e eventos;
5. corrigir policy em migration nova;
6. testar matriz completa antes de reativar.

Não deletar dados como primeira resposta a falha de autorização.

## Rollback do adapter — Lote 3B

O PR 3B deverá ser reversível independentemente do schema.

Rollback:

- remover/retirar adapter do build consumidor;
- nenhum frontend estará conectado neste lote;
- nenhuma OPP de produção dependerá do adapter ainda;
- schema pode permanecer inativo até decisão posterior.

## Critérios de sucesso do ensaio de rollback

- todos os objetos criados pelo Lote 3A são removidos no ambiente descartável;
- nenhuma tabela/função/policy legada é alterada;
- migration reaplica do zero após rollback;
- testes voltam a passar após reaplicação;
- nenhum objeto `curriculum_rag` é tocado;
- nenhum segredo aparece em log;
- tempo e passos do processo são registrados.

## Bloqueadores de merge do PR 3A

Não mesclar se:

- migration não puder ser aplicada em ambiente seguro;
- rollback não puder ser ensaiado;
- RLS cross-user não tiver teste;
- corpus global puder ser lido por teacher;
- duas versões curriculares ativas puderem coexistir indevidamente;
- evidencia órfã puder ser criada;
- script tocar objetos legados;
- não houver confirmação de nenhuma coluna vetorial;
- houver dependência de fonte real para validar schema.

## Bloqueadores de produção

Mesmo após merge, não aplicar em produção se:

- backup não estiver confirmado;
- ambiente alvo não estiver identificado;
- migrations locais e remotas divergirem sem reconciliação;
- não houver janela/recurso para reversão;
- não houver aprovação humana explícita da execução;
- surgir migration posterior não analisada que dependa do mesmo schema.

## Registro pós-aplicação

Após qualquer aplicação autorizada, registrar:

- commit;
- migration;
- ambiente;
- executor;
- início/fim;
- resultado;
- testes executados;
- RLS verificada;
- contagem de registros sintéticos/real;
- necessidade ou não de rollback;
- incidentes.