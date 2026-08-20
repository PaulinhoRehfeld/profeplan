# Master Blueprint — Empresa ProfePlan

**Status:** arquitetura documental-mãe — versão inicial

**Escopo:** EMPRESA PROFEPLAN, produto ProfePlan, fábricas e frentes associadas

**Revisão de referência:** 20 de agosto de 2026

## 1. Finalidade

Este documento define o mapa operacional e documental de mais alto nível da **EMPRESA PROFEPLAN**. Ele existe para manter coerência entre estratégia, produto, fábricas de conhecimento, projetos, agentes e repositórios, sem transformar uma conversa ou uma frente especializada no centro acidental da empresa.

Ele responde a sete perguntas:

1. quem é a EMPRESA PROFEPLAN e qual problema prioritário resolve;
2. como empresa, produto, fábricas e projetos se relacionam;
3. onde está a fonte de verdade de cada decisão;
4. como conhecimento validado atravessa projetos sem cópia indiscriminada;
5. como pessoas, ChatGPT, Codex, agentes e GitHub colaboram;
6. qual governança é exigida conforme o risco;
7. como preservar continuidade sem depender de memória de IA.

## 2. Identidade operacional

**EMPRESA PROFEPLAN** é a identidade operacional adotada para organizar produto, documentação, projetos, tecnologia e comunicação institucional. O ProfePlan é uma plataforma brasileira de Inteligência Artificial especializada na Educação Básica, inicialmente orientada ao professor.

Sua missão operacional é devolver tempo ao professor, assumir trabalho burocrático repetitivo e elevar a qualidade pedagógica por meio de fluxos integrados de planejamento, avaliação, inclusão, documentação e apoio à aprendizagem.

As decisões devem preservar, em conjunto:

- qualidade pedagógica e utilidade real para o professor;
- conformidade com BNCC, currículos e legislação aplicável;
- inclusão, acessibilidade e princípios de DUA;
- ética em IA, privacidade e segurança de dados;
- experiência simples, responsiva e de baixa carga cognitiva;
- sustentabilidade técnica, operacional e financeira.

O nome **WRTech AI** permanece apenas onde for juridicamente, contratualmente, registralmente ou historicamente necessário. Não deve ser usado como identidade operacional padrão nem propagado para novos artefatos sem uma dessas justificativas.

## 3. Arquitetura global: empresa → produto → fábricas → projetos

```text
EMPRESA PROFEPLAN
├── Produto central: Aplicativo ProfePlan
├── Fábricas especializadas de conhecimento e conteúdo
│   ├── Knowledge Factory — PNLD
│   ├── Curriculum Factory — BNCC & Currículos Estaduais
│   ├── PDI/DUA Factory
│   └── demais fábricas formalmente aprovadas
├── Capacidades transversais
│   ├── Site/SaaS/UX
│   ├── Marketing & Vendas
│   ├── Avaliações e exames
│   ├── Apresentações
│   └── integrações, dados, IA, segurança e operação
└── Portfólio futuro e incubação
    ├── Evolution/Nexus/CRM
    ├── NEB
    └── ProfePlan Kids
```

- **Empresa** define missão, estratégia, prioridades, governança e portfólio.
- **Produto** entrega valor ao professor por meio de módulos e experiências integradas.
- **Fábricas** produzem ativos governados, reutilizáveis e rastreáveis para o produto; não são produtos paralelos por padrão.
- **Projetos** são esforços temporários com objetivo, domínio responsável, entregáveis, riscos e critério de encerramento.
- **Agentes** executam papéis delimitados dentro dessa arquitetura; não constituem fontes de verdade autônomas.

## 4. Registro oficial de domínios A–M

| Código | Domínio | Papel atual | Prioridade/estado | Referência inicial |
|---|---|---|---|---|
| A | Empresa ProfePlan & PUCTEC | identidade, estratégia, governança institucional e relação com o ecossistema PUCTEC | estruturante | este documento |
| B | Aplicativo ProfePlan | produto SaaS central e experiência integrada do professor | prioridade máxima de negócio | `docs/overview-profeplan.md` e documentação de produto/arquitetura vigente |
| C | Knowledge Factory — PNLD | ingestão, reconstrução e governança de conhecimento proveniente do PNLD | fábrica especializada ativa | [`docs/profeplan-knowledge-factory/`](../profeplan-knowledge-factory/README.md) |
| D | Curriculum Factory — BNCC & Currículos Estaduais | conhecimento curricular normativo e territorial governado | fundação estratégica | blueprint futuro |
| E | Site/SaaS/UX | aquisição, onboarding, experiência, acessibilidade e operação SaaS | transversal ao produto e receita | documentação vigente de site, frontend e UX |
| F | Marketing & Vendas | posicionamento, aquisição, conversão, relacionamento e receita | essencial à validação de negócio | blueprint futuro |
| G | PDI/DUA Factory | inclusão, personalização, PDI e desenho universal para aprendizagem | diferencial pedagógico estratégico | documentação vigente de PDI/inclusão; blueprint futuro |
| H | ENEM/SAEB | capacidades e ativos ligados a avaliações externas | expansão planejada | blueprint futuro |
| I | Avaliações | criação, aplicação, correção, rubricas e uso pedagógico de evidências | módulo central | documentação vigente do módulo; blueprint futuro |
| J | Apresentações | geração e gestão de materiais de apresentação pedagógica | módulo complementar | blueprint futuro |
| K | Evolution/Nexus/CRM | comunicação, automação e relacionamento | futuro | não iniciar sem decisão explícita |
| L | NEB | frente a definir e validar estrategicamente | futuro | não iniciar sem decisão explícita |
| M | ProfePlan Kids | hipótese de produto/experiência para público infantil | incubação | não tratar como produto ativo sem gate estratégico |

O registro não autoriza execução automática. Cada domínio deve receber um blueprint próprio somente quando houver responsável, propósito, fronteiras, dependências e fontes canônicas suficientemente definidos.

## 5. Prioridade de negócio

A ordem de decisão é:

1. validar e fortalecer o valor entregue ao professor da Educação Básica pelo Aplicativo ProfePlan;
2. garantir segurança, qualidade pedagógica, inclusão, conformidade e continuidade operacional;
3. consolidar as fábricas que alimentam diretamente o produto e reduzem risco ou retrabalho;
4. melhorar aquisição, ativação, retenção e sustentabilidade do SaaS;
5. expandir módulos e mercados apenas com hipótese, evidência, capacidade e gate explícitos.

Frentes futuras não devem desviar pessoas, capital ou contexto das prioridades 1–4 sem decisão estratégica registrada. Sofisticação técnica, volume documental ou entusiasmo por IA não substituem valor pedagógico e validação de negócio.

## 6. Hierarquia das fontes de verdade

Em caso de divergência, aplicar a fonte mais específica, vigente e autorizada dentro desta ordem:

1. lei, regulação, contrato vinculante e política de segurança/privacidade aplicável;
2. comportamento executável em produção e schema vigente, considerados como evidência do estado real — não como justificativa para manter defeitos;
3. ADR ou decisão formal aceita;
4. contrato técnico, política normativa ou especificação especializada vigente;
5. blueprint vigente do domínio;
6. este Master Blueprint, para relações e regras interdomínios;
7. roadmap, checkpoint ou registro operacional corrente;
8. [`docs/profeplan-continuity/`](../profeplan-continuity/README.md), como camada de bootstrap e continuidade transversal;
9. documentação histórica e evidências de PR;
10. conversas, resumos e memória de IA.

Uma fonte inferior pode revelar uma divergência, mas não deve sobrescrever silenciosamente a superior. A divergência deve ser registrada e encaminhada ao responsável pela fonte canônica.

## 7. Master Blueprint e Continuity Pack

Este Master Blueprint e o Continuity Pack são complementares:

- o **Master Blueprint** define identidade operacional, portfólio, domínios, relações, prioridade e governança global;
- o **Continuity Pack** fornece contexto mínimo, regras de bootstrap, estado transversal e orientação para retomada por novas pessoas ou agentes.

O Master Blueprint não duplica o conteúdo de `docs/profeplan-continuity/`. Novas sessões devem começar pelo Continuity Pack e consultar este documento quando precisarem compreender a arquitetura da empresa ou decidir entre domínios.

## 8. Knowledge bridge entre projetos

O conhecimento atravessa domínios por contratos explícitos, não por cópia integral de pastas ou conversas.

Todo bridge material deve declarar:

- **origem:** domínio e fonte canônica;
- **ativo:** dado, regra, vocabulário, contrato, componente ou evidência compartilhada;
- **responsável:** quem pode validar e alterar o ativo;
- **consumidores:** domínios, módulos ou agentes autorizados;
- **versão e proveniência:** estado consumido e como rastreá-lo;
- **restrições:** licença, privacidade, segurança, finalidade pedagógica e retenção;
- **sincronização:** evento ou processo que propaga mudanças;
- **falha segura:** comportamento quando a fonte estiver ausente, inválida ou divergente.

Princípios do bridge:

- referenciar a fonte canônica em vez de duplicá-la;
- compartilhar contratos e ativos aprovados, não o contexto interno inteiro de um projeto;
- impedir que uma fábrica altere diretamente regras de outra sem revisão do domínio responsável;
- manter dados pessoais, conteúdo protegido e secrets fora da documentação e dos prompts;
- registrar mudanças incompatíveis e seus consumidores antes da adoção.

## 9. ChatGPT, Codex, agentes e GitHub

- **GitHub/repositório canônico:** registro durável de código, documentação, decisões, histórico de revisão e evidências versionadas.
- **ChatGPT:** espaço de análise, descoberta, estratégia, síntese e preparação de decisões; sua memória não é fonte canônica.
- **Codex:** ambiente de inspeção, implementação, testes e produção de evidências sobre um estado verificável do repositório.
- **Agente coordenador:** decompõe trabalho, seleciona agentes especializados, preserva contexto e integra resultados.
- **Agentes especializados:** operam com escopo, permissões, entradas, saídas e critérios de parada definidos.
- **Pessoas responsáveis:** autorizam decisões materiais, validam pedagogia e negócio e assumem accountability.

Toda saída relevante de IA deve ser verificada proporcionalmente ao risco e promovida para a fonte canônica adequada. Prompts e conversas podem explicar intenção, mas decisões duráveis devem terminar em documento, ADR, contrato, issue, PR, teste ou código versionado.

## 10. Regras de continuidade

Antes de iniciar ou retomar trabalho material:

1. identificar repositório, branch, commit e estado da árvore;
2. ler o Continuity Pack e este Master Blueprint no nível necessário;
3. identificar domínio A–M, fonte canônica e responsável;
4. consultar o blueprint e o checkpoint específicos, quando existirem;
5. distinguir fatos verificados, decisões vigentes, hipóteses e pendências;
6. declarar o menor incremento útil e seus critérios de conclusão;
7. produzir evidência verificável e atualizar apenas a fonte apropriada;
8. encerrar com estado, riscos, decisões, links e próximo gate.

É vedado:

- depender apenas de memória ou histórico de uma IA;
- transformar um chat longo em documentação oficial sem reconciliação;
- reabrir decisão formal sem registrar a razão;
- expandir o escopo para outro domínio por conveniência;
- movimentar ou apagar documentação histórica durante uma reorganização sem plano específico;
- incluir secrets ou dados pessoais/sensíveis desnecessários em documentos, prompts ou logs.

## 11. Governança proporcional ao risco

| Nível | Exemplos | Controle mínimo |
|---|---|---|
| Baixo | documentação sem efeito normativo, correção de link, refatoração interna comprovadamente neutra | revisão simples, diff e checagem de links/testes pertinentes |
| Médio | contrato interno, UX relevante, integração reversível, mudança de pipeline não produtivo | responsável definido, critérios de aceite, testes e plano de reversão |
| Alto | schema, RLS, autenticação, cobrança, produção, conteúdo pedagógico em escala, dados de estudantes | ADR/decisão, revisão especializada, evidência automatizada e manual, rollout e rollback |
| Crítico | efeito jurídico, segurança material, irreversibilidade, migração destrutiva, decisão automatizada de alto impacto | autorização humana explícita, segregação de funções, auditoria, ensaio e gate formal |

O nível é determinado pelo maior risco entre impacto pedagógico, privacidade, segurança, negócio, operação, reversibilidade e alcance. Urgência não reduz o controle mínimo; quando necessário, reduz-se o escopo.

## 12. Regras para blueprints e projetos

Um **blueprint** deve ser estável e declarar: propósito, escopo, não escopo, usuários, capacidades, arquitetura, fontes de verdade, interfaces, riscos, métricas, responsáveis e critérios de evolução.

Um **projeto** deve apontar para exatamente um domínio líder e registrar: objetivo, entregáveis, dependências, responsável, status, riscos, decisões, evidências e critério de encerramento. Projetos multidomínio devem declarar consumidores e bridges, sem criar uma autoridade paralela.

Estrutura prevista:

```text
docs/empresa-profeplan/
├── README.md
├── MASTER-BLUEPRINT.md
├── blueprints/
│   └── README.md
└── projects/
    └── README.md
```

Não serão criados documentos A–M vazios apenas para completar uma árvore. O registro da seção 4 funciona como índice inicial até que cada blueprint tenha conteúdo material.

## 13. Responsabilidade de manutenção

Alterações neste Master Blueprint exigem revisão como decisão transversal quando afetarem identidade, prioridade, hierarquia de autoridade, limites entre domínios ou governança. Mudanças locais pertencem ao blueprint ou projeto específico.

O critério de sucesso desta camada é permitir que uma nova pessoa ou agente descubra rapidamente:

- qual é a prioridade da empresa;
- em qual domínio a tarefa se encontra;
- qual fonte deve governar a decisão;
- que conhecimento pode atravessar projetos e sob quais condições;
- qual nível de controle o risco exige;
- onde registrar o resultado para que a continuidade não dependa do chat.
