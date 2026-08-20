# ProfePlan — Product Context

**Status:** contexto de produto para continuidade
**Data de referência:** 19 de agosto de 2026

## 1. Definição

O ProfePlan é uma plataforma SaaS de Inteligência Artificial especializada na Educação Básica brasileira.

Seu objetivo é reduzir a burocracia docente e apoiar o professor em tarefas de planejamento, avaliação, inclusão, documentação e organização pedagógica sem substituir o julgamento profissional do educador.

O produto não deve ser tratado como um simples gerador de textos. Seu valor depende da integração entre conhecimento educacional, contexto persistente, fluxo pedagógico, legislação, dados autorizados e agentes especializados.

## 2. Problema central

Professores gastam tempo significativo com atividades administrativas e documentais que competem com preparação pedagógica, acompanhamento de estudantes e ensino.

O ProfePlan procura assumir ou simplificar parte desse trabalho mantendo:

- coerência entre documentos;
- alinhamento curricular;
- rastreabilidade;
- inclusão;
- personalização;
- revisão humana.

## 3. Público inicial

Professores da Educação Básica brasileira.

A plataforma deve ser utilizável por professores com diferentes níveis de familiaridade tecnológica. Fluxos que exigem conhecimento técnico desnecessário devem ser evitados.

## 4. Capacidades e módulos

A visão de produto contempla, entre outros:

- planejamento anual;
- planejamento bimestral/trimestral conforme rede e contexto;
- planejamento semanal;
- plano de aula;
- avaliações;
- banco de questões;
- correção;
- rubricas;
- PDI e inclusão;
- relatórios;
- assistente pedagógico;
- apresentações;
- sequências didáticas;
- projetos;
- gestão documental;
- biblioteca pedagógica;
- agentes especializados.

A presença de um módulo em documentação, rota ou protótipo não deve ser interpretada automaticamente como funcionalidade pronta para comunicação comercial. Status de produto deve ser comprovado por evidência corrente.

## 5. Princípios pedagógicos

O ProfePlan deve:

- preservar o professor como responsável pela decisão pedagógica final;
- utilizar BNCC, currículos e materiais autorizados de forma rastreável;
- evitar inventar códigos, habilidades ou referências curriculares;
- favorecer avaliação coerente com o que foi planejado e ministrado;
- tratar inclusão como fluxo central, não como recurso periférico;
- manter acessibilidade e privacidade como requisitos de produto;
- permitir revisão e ajuste humano antes de usos pedagógicos de maior impacto.

## 6. Contexto e continuidade pedagógica

O produto deve buscar coerência longitudinal.

Exemplos:

- planejamento anual orienta períodos menores;
- planejamentos periódicos orientam aulas;
- aulas registradas orientam avaliações;
- perfil e contexto do estudante orientam adaptações e PDI;
- documentos anteriores podem fornecer continuidade quando permitido e relevante.

A otimização de tokens ou latência não deve destruir relações pedagógicas necessárias. Quando houver redução de contexto, ela deve ser feita por seleção, estrutura e recuperação adequada, não por remoção cega de dependências.

## 7. Conhecimento educacional especializado

O ProfePlan deverá evoluir com uma camada própria de conhecimento educacional governado.

A Knowledge Factory é a frente arquitetônica responsável por transformar fontes curriculares, pedagógicas e bibliográficas em estruturas rastreáveis e recuperáveis, sem considerar o livro inteiro uma unidade semântica única.

## 8. IA especializada

A direção do produto admite arquitetura agêntica, com um coordenador e agentes especializados por domínio ou tarefa quando isso reduzir complexidade cognitiva, melhorar rastreabilidade ou permitir validações específicas.

A especialização deve ser funcional, não ornamental.

## 9. UX orientada ao professor

As decisões de experiência devem priorizar:

- poucos cliques;
- linguagem pedagógica clara;
- boa legibilidade;
- estados de sistema compreensíveis;
- continuidade entre tarefas;
- responsividade;
- acessibilidade;
- prevenção de perda de trabalho;
- revisão antes de ações irreversíveis ou de maior impacto.

## 10. Dados e privacidade

Dados educacionais podem envolver informações pessoais e sensíveis. O sistema deve aplicar minimização, controle de acesso e proteção adequada.

Agentes e documentos de continuidade não devem expor dados reais de estudantes quando eles não forem indispensáveis ao trabalho autorizado.

## 11. Fontes auxiliares existentes

Para detalhes históricos e de módulos, consultar também:

- `docs/overview-profeplan.md`;
- `docs/modulo-planejamento.md`;
- `docs/modulo-avaliacao.md`;
- `docs/modulo-pdi-inclusao.md`;
- `docs/modulo-alunos-turmas-pdi.md`;
- `docs/fluxos-criticos-e-guardrails.md`.

Esses documentos devem ser confrontados com implementação e decisões mais recentes quando houver dúvida de atualidade.

## 12. Regra de produto para continuidade

Antes de implementar ou comunicar uma capacidade, distinguir explicitamente:

- visão planejada;
- especificação aprovada;
- implementação existente;
- implementação validada;
- disponibilidade para usuário;
- permissão para comunicação pública.

Essa separação reduz promessa indevida e evita que documentação aspiracional seja confundida com estado executável.
