# PROJECT MATURITY MAP — EMPRESA PROFEPLAN

**Objetivo:** registrar o estágio operacional dos domínios A–M e orientar sua migração documental por maturidade.

## 1. Critério de maturidade

Um domínio pode migrar para sua estrutura documental definitiva quando atingir estabilidade suficiente para que sua identidade, interfaces, dependências e estado possam ser descritos sem alto risco de reorganização repetida.

O critério NÃO é "produto finalizado".

## 2. Mapa atual

| ID | Domínio | Estado atual | Prioridade | Gate de próxima maturidade |
|---|---|---|---|---|
| A | Empresa ProfePlan & PUCTec | Operacional / contínuo | P0 | consolidar governança institucional e referências empresariais |
| B | Aplicativo ProfePlan | Operacional / evolução | P0 | consolidar Blueprint do produto e interfaces com fábricas |
| C | Knowledge Factory — PNLD | Desenvolvimento ativo | P0 | concluir marco estrutural PNLD v1 e reconciliar Blueprint/contratos/checkpoints |
| D | Curriculum Factory — BNCC & Estados | Implantação prioritária | P0 | definir arquitetura da fábrica, fontes oficiais e primeiro pipeline vertical |
| E | Site / SaaS / UX | Operacional / evolução | P0 | consolidar estado funcional, evidências e roadmap de UX/conversão |
| F | Marketing & Vendas | Implantação urgente | P0 | estruturar operação comercial, funil, evidências de produto e calendário de execução |
| G | PDI / DUA Factory | Arquitetura a construir | P1 | definir fontes, critérios científicos, contratos de evidência e primeiro caso vertical |
| H | ENEM / SAEB | Futuro próximo | P1 | delimitar fontes oficiais, matrizes e relação com Avaliações |
| I | Avaliações | Existente / evolução | P1 | separar claramente lógica própria, dependências curriculares e integração com ENEM/SAEB |
| J | Apresentações | Existente / evolução | P1 | consolidar geração, templates e integração com conteúdos pedagógicos |
| K | Evolution / Nexus / CRM | Futuro | Futuro | permanecer congelado até necessidade comercial/operacional justificar retomada |
| L | NEB | Futuro | Futuro | permanecer congelado até haver justificativa para IA/agentes próprios |
| M | ProfePlan Kids | Incubation / Discovery | P2 | capturar requisitos e decisões essenciais sem antecipar implementação; meta aproximada fev/2027 |

## 3. Regra de migração documental

Para cada domínio:

1. manter documentação atual onde está enquanto houver desenvolvimento estrutural intenso;
2. atingir um marco estável;
3. reconciliar estado real, Blueprint, decisões e evidências;
4. mapear caminhos antigos e novos;
5. migrar somente quando o ganho de organização superar o risco de churn;
6. manter redirects/documentos de transição quando necessários para rastreabilidade.

## 4. Situação especial — Knowledge Factory PNLD

A documentação atual em `docs/profeplan-knowledge-factory/` permanece fisicamente intacta durante o desenvolvimento ativo.

O domínio C será migrado/reconciliado na arquitetura institucional após o marco PNLD v1, preservando sua genealogia de ADRs, contratos, evidências e checkpoints.

## 5. Situação especial — Aplicativo e Site

Aplicativo e Site/SaaS já funcionam satisfatoriamente e não precisam ser reconstruídos para entrar na arquitetura institucional.

O trabalho nesses domínios deve priorizar:

- documentação do estado atual;
- evidência funcional;
- interfaces com fábricas;
- melhoria incremental;
- UX, conversão e sustentabilidade financeira.

## 6. Revisão

Este mapa é vivo. Mudanças de estado devem ser registradas quando houver evidência material de avanço, não apenas intenção.
