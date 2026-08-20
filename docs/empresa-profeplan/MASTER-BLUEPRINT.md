# MASTER BLUEPRINT — EMPRESA PROFEPLAN

**Status:** arquitetura institucional inicial
**Escopo:** visão integrada da empresa, produto e fábricas especializadas

## 1. Identidade operacional

A identidade operacional desta arquitetura é **EMPRESA PROFEPLAN**.

Referências a WRTech AI devem permanecer apenas quando necessárias por razões históricas, jurídicas ou documentais, sem orientar a nova organização operacional.

## 2. Arquitetura global

A EMPRESA PROFEPLAN é composta por três grandes camadas:

### 2.1. Empresa e mercado

Abrange governança empresarial, estratégia, PUCTec, administração, contabilidade, jurídico, marketing, vendas e sustentabilidade financeira.

### 2.2. Produto

O Aplicativo ProfePlan é a plataforma principal de acesso do professor. Ele recebe, organiza e entrega os produtos gerados pelas fábricas especializadas.

O Site/SaaS/UX é a camada pública e de experiência de aquisição, onboarding, comunicação visual, checkout e evolução da jornada do usuário.

### 2.3. Fábricas especializadas

Produzem conhecimento, estruturas e artefatos que alimentam o produto principal.

Entre elas:

- Knowledge Factory — PNLD;
- Curriculum Factory — BNCC & Currículos Estaduais;
- PDI/DUA Factory;
- ENEM/SAEB;
- Avaliações;
- Apresentações.

Projetos futuros como Evolution/Nexus/CRM, NEB e ProfePlan Kids possuem ciclos próprios e entram nesta arquitetura por maturidade.

## 3. Domínios A–M

- **A — EMPRESA PROFEPLAN & PUCTEC:** estratégia, administrativo, contabilidade, jurídico, societário, propriedade intelectual, PUCTec, contratos, orçamento, investimentos e governança.
- **B — APLICATIVO PROFEPLAN:** plataforma principal do professor e integradora das fábricas.
- **C — KNOWLEDGE FACTORY — PNLD:** cartografia editorial, reconstrução estrutural, evidências e tratamento governado de livros e manuais PNLD.
- **D — CURRICULUM FACTORY — BNCC & CURRÍCULOS ESTADUAIS:** estruturação da BNCC e documentos oficiais dos 26 estados + DF.
- **E — SITE / SAAS / UX:** site público, experiência, checkout, onboarding e identidade visual.
- **F — MARKETING & VENDAS:** posicionamento, campanhas, criativos, funis, conversão, CAC e receita.
- **G — PDI / DUA FACTORY:** inclusão, PDI, DUA, adaptações, relatórios, legislação e evidências científicas rastreáveis.
- **H — ENEM / SAEB:** matrizes, descritores, competências, habilidades, questões, TRI e dados oficiais.
- **I — AVALIAÇÕES:** avaliações diagnósticas, formativas, somativas, rubricas e versões adaptadas.
- **J — APRESENTAÇÕES:** slides e materiais visuais pedagógicos.
- **K — EVOLUTION / NEXUS / CRM:** futuro.
- **L — NEB:** futuro; IA própria, agentes especializados, orquestração, roteamento e observabilidade.
- **M — PROFEPLAN KIDS:** incubation/discovery para Educação Infantil e Anos Iniciais, com meta aproximada de lançamento em fevereiro de 2027.

## 4. Dependências principais

### Curriculum Factory

Fornece currículo estruturado para:

- Aplicativo ProfePlan;
- Planejamentos;
- Avaliações;
- PDI/DUA;
- Apresentações;
- ENEM/SAEB quando houver relação curricular pertinente.

### Knowledge Factory — PNLD

Fornece conteúdo editorial estruturado e evidenciado para:

- Aplicativo ProfePlan;
- Planejamentos;
- Avaliações;
- Apresentações;
- outros módulos pedagógicos autorizados.

### PDI/DUA Factory

Consome:

- currículo;
- legislação;
- evidências científicas;
- contexto pedagógico autorizado.

Fornece:

- adaptações;
- estratégias inclusivas;
- relatórios e estruturas de apoio individual;
- artefatos consumidos pelo Aplicativo ProfePlan.

### Aplicativo ProfePlan

É o principal consumidor e integrador das fábricas. Não deve replicar internamente toda a lógica especializada quando ela pertence claramente a uma fábrica com ciclo próprio.

## 5. Knowledge Bridge

Cada Blueprint específico deverá declarar:

### Consome de
Fontes e domínios necessários para operar.

### Fornece para
Domínios que dependem de seus resultados.

### Interfaces
Contratos, schemas, APIs, datasets e documentos de integração.

### Documentos relacionados
Caminhos canônicos que descrevem estado e decisões.

## 6. Migração por maturidade

A reorganização documental NÃO será executada de forma massiva.

Cada domínio migra quando atingir um marco estável suficiente para possuir:

1. identidade de domínio clara;
2. estado verificável;
3. principais interfaces conhecidas;
4. dependências compreendidas;
5. documentação consolidável sem alto risco de churn estrutural.

"Finalizado" não é requisito. SaaS e fábricas continuam evoluindo.

## 7. Estado operacional de referência

- Site/SaaS/UX: operacional, em evolução;
- Aplicativo ProfePlan: operacional, em evolução;
- Knowledge Factory PNLD: desenvolvimento estrutural ativo;
- Curriculum Factory: implantação prioritária;
- Marketing & Vendas: implantação urgente;
- PDI/DUA: arquitetura a construir;
- demais domínios conforme `governance/PROJECT-MATURITY-MAP.md`.

## 8. Hierarquia de verdade

Em caso de conflito, considerar recência, especificidade e estado real, usando como referência:

`código/schema/runtime vigente`

→ `ADRs aceitas`

→ `contratos técnicos`

→ `Blueprints vigentes`

→ `roadmaps`

→ `checkpoints/evidências`

→ `Continuity Pack`

→ `documentação histórica`

→ `conversas de IA`

→ `memória de IA`.

Nenhum documento deve vencer automaticamente apenas por ser mais antigo ou mais categórico.

## 9. Relação com IA

- **GitHub/documentação:** fonte institucional rastreável.
- **Continuity Pack:** bootstrap para novos chats, agentes e ambientes.
- **ChatGPT/Codex/agentes:** consumidores e operadores sobre fontes canônicas.
- **Memória de IA:** camada de conveniência, não fonte exclusiva de verdade.

Fluxo recomendado:

`novo ambiente -> Continuity Pack -> MASTER BLUEPRINT -> Blueprint do domínio -> fontes específicas -> execução`.

## 10. Repositórios

A preferência atual é manter `profeplan` como monorepo principal.

Os domínios A–M são fronteiras organizacionais e documentais, não exigem repositório próprio.

Novo repositório só deve ser criado quando houver justificativa real, como lifecycle, deploy, segurança, equipe, versionamento ou tecnologia independentes.

## 11. Migração institucional do GitHub

O estado atual permanece em `PaulinhoRehfeld/profeplan`.

Destino previsto: `Profeplan-Edtech/profeplan`.

A transferência de propriedade pode ocorrer antes da reorganização completa de todos os domínios, desde que a auditoria administrativa de GitHub, Actions, secrets, environments, Apps, Vercel, remotes e integrações esteja concluída.

A reorganização documental A–M ocorrerá gradualmente por maturidade.

## 12. Princípio de execução

A documentação deve reduzir risco e carga cognitiva, não se transformar em fim em si mesma.

Priorizar:

- governança proporcional ao risco;
- menor mudança material capaz de produzir clareza;
- preservação do histórico útil;
- velocidade de negócio;
- redução de duplicação;
- receita e valor entregue ao professor.
