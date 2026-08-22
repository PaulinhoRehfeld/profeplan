# L — NEB — Blueprint

**Status:** futuro

## 1. Missão do domínio

Reservar a evolução futura da infraestrutura própria de IA e equipe de agentes especializados do ProfePlan, com foco em orquestração, roteamento, avaliação, observabilidade, contexto e eficiência de custo.

## 2. Escopo futuro

- agentes especializados;
- agente coordenador/orquestrador;
- roteamento de modelos;
- avaliação de modelos e agentes;
- observabilidade;
- gerenciamento de contexto;
- economia de tokens/custos;
- infraestrutura própria de IA quando houver justificativa.

## 3. Relações com outros projetos

### Consome de
- necessidades reais de B–J;
- A: orçamento e governança;
- métricas de custo e qualidade.

### Fornece para
- todos os projetos que utilizem IA quando o NEB for ativado.

### Interfaces
- contratos de agentes;
- ferramentas;
- observabilidade;
- políticas de modelo;
- context packages;
- métricas de qualidade/custo.

### Documentos relacionados
- `../../agents/`;
- `.agent/` como tooling existente fora desta camada documental;
- futura pasta `projects/L-neb/`.

## 4. Regra de congelamento

Não criar infraestrutura própria ou novas abstrações de agentes apenas por elegância. O domínio deve ser ativado quando custos, escala, qualidade ou controle justificarem materialmente essa arquitetura.