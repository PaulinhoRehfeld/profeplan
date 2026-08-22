# EMPRESA PROFEPLAN — Project Dependency Map

**Status:** governança institucional inicial
**Escopo:** domínios A–M

## 1. Objetivo

Registrar as relações de consumo, fornecimento e dependência entre os projetos da EMPRESA PROFEPLAN sem forçar acoplamento técnico prematuro.

## 2. Regra central

Nenhum projeto deve precisar carregar todo o contexto dos demais. Cada domínio consome somente contratos, datasets, APIs, schemas e documentos necessários à sua função.

## 3. Fluxo macro

```text
EMPRESA / PUCTEC (A)
        │
        ├───────────────┐
        ▼               ▼
APLICATIVO (B)      MARKETING (F)
   ▲   ▲   ▲            ▲
   │   │   │            │
   │   │   └──── SITE/SAAS/UX (E)
   │   │
   │   ├──── KNOWLEDGE FACTORY PNLD (C)
   │   ├──── CURRICULUM FACTORY (D)
   │   ├──── PDI/DUA FACTORY (G)
   │   ├──── ENEM/SAEB (H)
   │   ├──── AVALIAÇÕES (I)
   │   └──── APRESENTAÇÕES (J)
   │
   └──── FUTUROS: NEXUS/CRM (K), NEB (L), KIDS (M)
```

## 4. Matriz resumida

| Projeto | Consome de | Fornece para |
|---|---|---|
| A Empresa/PUCTEC | métricas de B, E, F e custos operacionais | prioridades, limites, governança e decisões |
| B Aplicativo | C, D, G, H, I, J; diretrizes A/E | experiência final do professor; sinais de uso para A/F |
| C Knowledge Factory PNLD | fontes PNLD autorizadas; contratos internos | B, I, J e demais fluxos que precisem de conteúdo editorial estruturado |
| D Curriculum Factory | BNCC e documentos oficiais estaduais | B, G, H, I, J e planejamentos |
| E Site/SaaS/UX | A, B e F | aquisição, onboarding, checkout, experiência e conversão |
| F Marketing/Vendas | A, B, E e evidências reais de produto | demanda, leads, vendas, feedback comercial |
| G PDI/DUA | D, evidência científica e legislação | B, I, J e relatórios/adaptações |
| H ENEM/SAEB | matrizes e provas oficiais; D | I, B, J |
| I Avaliações | D, C, G, H e contexto de B | B, relatórios e materiais de J |
| J Apresentações | C, D, G, H, I e contexto de B | B e professor final |
| K Nexus/CRM | futuramente F/B/A | relacionamento e automações futuras |
| L NEB | necessidades de todos os domínios | infraestrutura de IA/agentes futura |
| M ProfePlan Kids | D adaptado à EI/AI, G e novos referenciais | produto Kids futuro |

## 5. Regras de interface

1. Relações entre projetos devem ser explicitadas por contrato ou documento quando houver troca de dados estruturados.
2. Blueprints não devem duplicar schemas técnicos completos; devem apontar para a fonte canônica.
3. Dependências de negócio não significam dependências de runtime.
4. Projetos futuros não devem dirigir a arquitetura atual sem decisão explícita.
5. O Aplicativo ProfePlan é a principal camada de entrega ao professor; fábricas especializadas devem produzir capacidades consumíveis pelo produto.

## 6. Relações prioritárias P0

### C → B
Knowledge Factory PNLD fornece estrutura editorial e evidências para experiências pedagógicas do Aplicativo.

### D → B/I/G/J
Curriculum Factory fornece a base curricular oficial estruturada para planejamento, avaliações, inclusão e apresentações.

### E ↔ B
Site/SaaS/UX conduz aquisição, onboarding e acesso; o Aplicativo entrega valor após entrada do professor.

### F ↔ E/B
Marketing depende de evidência real do produto; Site e Aplicativo recebem demanda e feedback comercial.

### A → todos
Empresa/PUCTEC define limites financeiros, jurídicos, estratégicos e de governança.

## 7. Atualização

Atualizar este mapa quando surgir uma nova interface material entre projetos ou quando um domínio mudar de responsabilidade.