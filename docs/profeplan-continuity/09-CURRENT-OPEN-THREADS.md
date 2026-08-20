# ProfePlan — Current Open Threads

**Status:** quadro de continuidade
**Data de referência:** 19 de agosto de 2026

Este arquivo lista somente frentes abertas que alteram a continuidade do projeto. Ele não substitui roadmaps específicos.

## 1. Knowledge Factory — piloto real de uma única parte

**Estado:** ativo.

Baseline corrente:

- `main@d3fd27e2ea8f65b1e47fb27416814e89be5486e5`;
- PR #125 integrado;
- Checkpoint 053 como referência operacional.

Próximo gate:

- executar localmente o teste real dedicado contra o PDF governado;
- validar integridade do arquivo;
- registrar o resultado material;
- auditar seletividade, dupla paginação, hierarquia e evidências se o teste ficar verde.

Bloqueados até esse resultado:

- expansão do piloto;
- nova obra;
- OCR geral;
- corpus em escala;
- embeddings/RAG;
- grafo global.

## 2. Continuity Pack

**Estado:** v1 em criação documental.

Objetivo:

- reduzir dependência de memória e histórico de IA;
- tornar contexto corporativo portável;
- criar bootstrap para novos agentes/ambientes;
- preparar futura migração de custos/ambiente sem perda de continuidade.

Gate desta frente:

- revisão humana da v1;
- integração documental por PR;
- posterior teste de portabilidade em ambiente limpo.

## 3. Migração de custos para a WRtech

**Estado:** decisão estratégica aprovada; execução financeira ainda separada da documentação.

Diretriz:

- preservar a conta atual enquanto ela carregar valor de continuidade;
- migrar pagamentos/faturamento elegíveis para a empresa quando contabilmente adequado;
- não criar conta isolada apenas por causa do pagamento;
- não executar migração irreversível de workspace antes do checkpoint de portabilidade.

A confirmação fiscal/contábil cabe à contabilidade da WRtech.

## 4. Incidente/modernização de credenciais — PR #99

**Estado:** frente separada da Knowledge Factory.

Regra de continuidade:

- não misturar alterações de credenciais com trabalho da Knowledge Factory;
- manter validação isolada de Preview quando aplicável;
- produção, revogação, cutover e secrets permanecem sujeitos a autorização específica.

Antes de retomar essa frente, inspecionar o PR #99 e o estado remoto atual; não usar este resumo como substituto.

## 5. Documentação geral legada

**Estado:** coexistência controlada.

Há documentação geral anterior que contém contexto ainda útil, mas também premissas potencialmente superadas sobre providers, modelo comercial ou arquitetura.

Ação futura recomendada:

- reconciliar apenas quando uma frente concreta exigir;
- evitar uma grande limpeza documental sem pergunta material;
- usar ADR/Decision Log quando uma premissa antiga precisar ser formalmente substituída.

## 6. Regra de manutenção deste arquivo

Ao fechar uma frente:

- remover do quadro corrente;
- manter a evidência histórica na documentação/PR/checkpoint apropriado.

Ao abrir nova frente crítica:

- registrar apenas se ela alterar decisões, riscos, dependências ou sequência de trabalho de outras áreas.
