# Governança de execução proporcional ao risco

**Status:** proposta no PR de definição de C.3; passa a reger a continuidade da Knowledge Factory após integração humana.

**Data:** 17 de agosto de 2026.

## Objetivo

Preservar segurança, rastreabilidade e qualidade arquitetural sem transformar operações reversíveis e isoladas em uma sequência excessiva de microautorizações.

A governança passa a ser proporcional ao impacto material da ação. O critério principal não é o número de arquivos, commits ou chamadas de ferramenta, mas o risco real para produção, credenciais, dados, integridade do histórico e efeitos externos.

## Nível A — execução pré-autorizada dentro do escopo aprovado

Podem ser executados em sequência, sem nova autorização humana para cada microação, quando permanecerem estritamente dentro do lote/sublote já delimitado:

- inspeção remota e leitura de repositório;
- criação e atualização de branch técnica;
- contratos, tipos, fixtures sintéticas e testes;
- código de domínio isolado;
- documentação e reconciliação documental;
- commits e atualização de PR;
- execução e reexecução de CI;
- correções necessárias para fazer o escopo aprovado cumprir seus próprios gates;
- migrations, banco, Storage e recursos exclusivamente descartáveis usados por CI ou prova técnica;
- dados inteiramente sintéticos;
- refactors estritamente internos sem mudança de contrato público ou superfície de produção.

Essas ações devem continuar auditáveis e provider-neutral quando aplicável, mas não exigem uma autorização humana nova por commit, teste, correção ou reexecução.

## Nível B — autorização agrupada por fronteira material

Exigem autorização humana para a fronteira, mas, uma vez autorizadas, suas operações internas podem prosseguir sem microautorizações repetidas:

- merge de um PR técnico previamente delimitado;
- migration funcional em ambiente não produtivo persistente;
- Edge Function, worker, fila ou serviço em Preview/homologação;
- uso de Supabase/Storage hospedado não produtivo;
- primeiro uso de conteúdo real não sensível e juridicamente autorizado;
- ensaio controlado de integração externa sem efeito financeiro ou público;
- introdução de novo parser, OCR, modelo ou provider com impacto de custo/dados;
- mudança compatível de contrato que ultrapasse simples implementação interna.

A autorização deve delimitar ambiente, finalidade e escopo. Não precisa enumerar cada chamada, commit ou retry previsível necessário à execução.

## Nível C — autorização explícita e específica obrigatória

Nunca é coberto por pré-autorização genérica:

- alteração, deploy, migration ou promoção em produção;
- criação, cópia, rotação, revogação ou exposição material de secrets/credenciais;
- uso de dados pessoais, dados de estudantes, laudos, notas ou informação sensível real;
- operação Stripe real, cobrança, reembolso ou evento financeiro real;
- mudança destrutiva, reset, force-push, rebase destrutivo, purge ou exclusão irreversível de histórico/dados;
- publicação externa ou automação com efeito público;
- redução material de RLS, grants, autenticação, autorização ou controles de segurança;
- qualquer ação cujo impacto não possa ser razoavelmente contido em ambiente descartável/Preview.

## Regra de escalonamento

Uma ação sobe automaticamente de nível quando surge qualquer condição material não prevista, por exemplo:

- necessidade de tocar produção;
- necessidade de secret novo ou alteração de credencial;
- dado real sensível;
- efeito financeiro ou público;
- mudança destrutiva;
- ampliação de escopo funcional;
- falha que exija contornar um controle de segurança;
- incerteza relevante sobre isolamento do ambiente.

Quando isso ocorrer, a execução deve parar apenas no ponto material que mudou de nível. O restante do trabalho seguro e independente pode continuar.

## Branches, PRs e checkpoints

Branches e PRs continuam sendo a unidade preferencial de isolamento e revisão. Porém:

- um sublote não precisa gerar autorização humana separada para cada commit, fixture, teste ou correção;
- checkpoint documental não é requisito obrigatório entre sublotes de Nível A quando o estado canônico já pode ser reconstruído por Git, PR, CI e documentação do lote;
- checkpoint deve ser usado em fechamento de lote, mudança material de fronteira, incidente, handoff importante ou quando realmente reduz risco de continuidade;
- revisão pós-merge e CI pós-merge permanecem recomendados para mudanças técnicas relevantes, mas não criam automaticamente um novo gate humano antes da próxima atividade de Nível A;
- avanço concorrente da `main` deve ser reconciliado e auditado, sem uso de reset/rebase destrutivo por conveniência.

## Eficiência de contexto e custo

A proporcionalidade ao risco não implica uso indiscriminado de agentes ou modelos avançados. Dentro de qualquer nível de autorização, a execução deve usar o menor grau de autonomia e contexto que ainda preserve correção e auditabilidade.

A política operacional detalhada está em [COST-AWARE-EXECUTION-MODE.md](COST-AWARE-EXECUTION-MODE.md).

Em síntese:

- a conversa principal orquestra decisões, arquitetura e análise;
- o terminal local é preferido para execução determinística;
- uma conversa de execução pode operar com contexto mínimo por meio de `Execution Packs`;
- Work/Codex ou agente avançado é escalado quando autonomia, exploração ou iteração trouxerem ganho material;
- decisões documentadas não devem ser redescobertas repetidamente por sessões agênticas;
- economia de contexto/créditos nunca reduz gates jurídicos, de segurança ou de autorização.

## Aplicação a C.3

Após integração da definição de C.3:

- C.3.1–C.3.6 podem ser desenvolvidos sequencialmente sob autorização agrupada do lote, desde que permaneçam em branch/PR, CI e infraestrutura descartável ou não produtiva previamente autorizada;
- a passagem de C.3.2 para C.3.3 não exige novo checkpoint apenas por mudança de sublote;
- C.3.3 pode executar extração textual somente com fixtures sintéticas sob Nível A;
- o primeiro PDF/conteúdo real juridicamente autorizado é Nível B e exige uma autorização de fronteira antes da execução;
- OCR/provider novo em C.3.7 é Nível B;
- qualquer uso de produção, secrets ou dados pessoais é Nível C;
- C.3.8 continua sendo o gate integrado de fechamento do lote e handoff para C.4.

## Relação com decisões anteriores

Esta política substitui, para continuidade operacional futura, a interpretação de que todo sublote exige obrigatoriamente uma sequência independente de autorização → implementação → merge → checkpoint → nova autorização.

Ela não reduz gates jurídicos, pedagógicos, de integridade, autorização de fonte, RLS, proveniência ou segurança. O que muda é a granularidade da autorização operacional para ações reversíveis e isoladas.

Decisões históricas e checkpoints permanecem válidos como registro do estado em que foram emitidos; não são reescritos retroativamente.
