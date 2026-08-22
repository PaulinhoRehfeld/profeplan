# ProfePlan Continuity Pack

**Status:** v1 inicial
**Data de referência:** 19 de agosto de 2026
**Baseline verificada:** `main@d3fd27e2ea8f65b1e47fb27416814e89be5486e5`

## 1. Propósito

O ProfePlan Continuity Pack é a camada de continuidade institucional da WRtech para o ProfePlan.

Seu objetivo é permitir que uma nova conversa, agente, modelo, ferramenta ou integrante autorizado compreenda rapidamente o produto e o estado corrente do trabalho sem depender de milhares de mensagens históricas ou da memória privada de uma conta de IA.

A regra central é:

> O conhecimento essencial do ProfePlan pertence à WRtech e deve ser recuperável a partir de fontes corporativas canônicas. Memória e histórico de IA são camadas de conveniência, não a fonte final de verdade.

## 2. O que este pacote é — e o que não é

Este pacote:

- organiza o contexto mínimo de continuidade;
- aponta para documentos canônicos já existentes;
- explicita a hierarquia entre fontes quando há conflito;
- registra o estado corrente de frentes críticas;
- reduz o contexto necessário para novos agentes;
- facilita portabilidade entre ChatGPT, Codex, IDEs e futuros agentes.

Este pacote não:

- substitui código executável, schemas, ADRs, contratos ou evidências;
- replica toda a documentação existente;
- armazena secrets, tokens, senhas ou credenciais;
- transforma conversas antigas em fonte canônica;
- autoriza mudanças de produção.

## 3. Ordem de leitura

Para um novo agente ou nova sessão:

1. `00-WRTECH-MASTER-CONTEXT.md`
2. `01-PROFEPLAN-PRODUCT-CONTEXT.md`
3. `03-PROFEPLAN-ARCHITECTURE.md`
4. `08-AI-WORKING-RULES.md`
5. `09-CURRENT-OPEN-THREADS.md`
6. documento específico da frente em que o trabalho ocorrerá;
7. `04-KNOWLEDGE-FACTORY-CURRENT-STATE.md`, quando a tarefa envolver a Knowledge Factory.

O arquivo `15-CONTINUITY-BOOTSTRAP-PROMPT.md` pode ser usado como ponto de partida em um ambiente de IA limpo.

## 4. Hierarquia de autoridade

Em caso de conflito, aplicar esta ordem, respeitando o escopo específico de cada artefato:

1. comportamento executável e schema vigente;
2. ADRs aceitas e decisões arquitetônicas formalizadas;
3. contratos técnicos e políticas normativas específicas;
4. blueprint ou especificação vigente da frente;
5. roadmap/checkpoint corrente;
6. este Continuity Pack;
7. documentação histórica/auxiliar;
8. PRs e evidências históricas;
9. conversas de IA;
10. memória de IA.

Quando uma fonte antiga contradizer uma fonte mais nova e mais específica, não reconciliar silenciosamente. Registrar a divergência e seguir a fonte de maior autoridade.

## 5. Fontes já existentes que permanecem relevantes

O Continuity Pack não duplica integralmente estes materiais:

- `docs/overview-profeplan.md`
- `docs/arquitetura-geral-profeplan.md`
- `docs/fluxos-criticos-e-guardrails.md`
- `docs/guia-para-agentes-e-devs.md`
- `docs/profeplan-knowledge-factory/BLUEPRINT.md`
- `docs/profeplan-knowledge-factory/README.md`
- `docs/profeplan-knowledge-factory/00-governance/`
- `docs/profeplan-knowledge-factory/12-delivery/`

Alguns documentos gerais mais antigos contêm premissas históricas que podem ter sido superadas. Devem ser usados como referência auxiliar e sempre confrontados com código, ADRs, contratos e checkpoints vigentes.

## 6. Arquivos da v1

- `PROFEPLAN-CONTINUITY-001.md` — decisão institucional que cria este mecanismo;
- `00-WRTECH-MASTER-CONTEXT.md` — contexto institucional e princípios;
- `01-PROFEPLAN-PRODUCT-CONTEXT.md` — definição atual do produto;
- `03-PROFEPLAN-ARCHITECTURE.md` — visão arquitetônica de continuidade;
- `04-KNOWLEDGE-FACTORY-CURRENT-STATE.md` — estado corrente da Knowledge Factory;
- `08-AI-WORKING-RULES.md` — regras de trabalho para agentes e humanos;
- `09-CURRENT-OPEN-THREADS.md` — frentes abertas que afetam continuidade;
- `15-CONTINUITY-BOOTSTRAP-PROMPT.md` — prompt mínimo de inicialização.

Os demais documentos propostos para a estrutura definitiva serão adicionados somente quando houver material suficiente e valor prático, evitando documentação vazia ou redundante.

## 7. Regra de atualização

Atualizar este pacote quando uma mudança material alterar:

- identidade ou foco do produto;
- arquitetura consolidada;
- fonte canônica;
- governança de execução;
- estado de uma frente crítica;
- próximo gate material;
- política de IA, dados ou segurança.

Não atualizar por pequenas mudanças cosméticas ou detalhes que já estejam corretamente representados em documentação especializada.

## 8. Segurança

É proibido registrar neste diretório:

- secrets;
- chaves de API;
- tokens;
- senhas;
- dados pessoais desnecessários;
- dados sensíveis de estudantes;
- documentos privados de terceiros;
- binários editoriais protegidos.

Pode-se registrar apenas o nome lógico de variáveis ou referências opacas necessárias à documentação.

## 9. Critério de sucesso

O Continuity Pack é considerado útil quando um agente novo, com acesso ao repositório, consegue responder corretamente:

1. o que é a WRtech e o ProfePlan;
2. qual é o foco inicial do produto;
3. como o sistema está organizado em alto nível;
4. quais fontes de verdade deve consultar;
5. quais decisões não pode sobrescrever por conveniência;
6. qual frente está ativa;
7. qual é o próximo gate material;
8. quais ações exigem autorização adicional.
