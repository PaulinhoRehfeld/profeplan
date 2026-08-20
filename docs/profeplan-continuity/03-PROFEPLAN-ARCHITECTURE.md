# ProfePlan — Architecture Context

**Status:** visão arquitetônica de continuidade
**Data de referência:** 19 de agosto de 2026
**Baseline verificada:** `main@d3fd27e2ea8f65b1e47fb27416814e89be5486e5`

## 1. Objetivo deste documento

Este arquivo fornece contexto suficiente para orientar uma nova sessão ou agente. Ele não substitui inspeção do código, ADRs, contratos ou blueprints específicos.

Quando houver conflito entre este resumo e uma fonte técnica mais específica e atual, prevalece a fonte específica.

## 2. Organização do repositório

O repositório canônico é:

`PaulinhoRehfeld/profeplan`

O projeto está organizado como monorepo com `pnpm`, workspaces em `apps/*` e `packages/*`, Node.js 22 e TypeScript.

Aplicações observadas na baseline:

- `apps/web` — aplicação principal do professor;
- `apps/site` — site público;
- `apps/bff` — camada backend-for-frontend/serviços;
- `packages/*` — pacotes compartilhados e capacidades especializadas.

## 3. Frontend principal

`apps/web` utiliza, entre outras dependências verificadas:

- React 19;
- TypeScript;
- Vite;
- React Router;
- Zustand;
- React Hook Form;
- Zod;
- Tailwind CSS;
- Supabase JS;
- Stripe JS;
- PDF.js;
- geração/exportação de DOCX, PDF e PPTX;
- Capacitor para capacidades móveis.

O frontend deve continuar orientado a baixa carga cognitiva, poucos cliques, estados explícitos e acessibilidade.

## 4. Backend e serviços

`apps/bff` contém uma camada TypeScript apoiada em Azure Functions e integrações com Supabase e OpenAI.

Dependências verificadas incluem:

- `@azure/functions`;
- Azure Identity;
- Azure Key Vault;
- Supabase JS;
- OpenAI SDK;
- JWT;
- logging compartilhado.

A existência dessas dependências descreve o estado do repositório, não uma obrigação eterna de arquitetura. Mudanças de provider devem respeitar contratos, dados existentes, custos, segurança e ADRs aplicáveis.

## 5. Dados

Supabase/PostgreSQL constitui uma camada central de persistência e autenticação em partes relevantes do produto.

Alterações em schema, RLS, grants, lifecycle de dados, Storage ou funções devem ser tratadas como mudanças de risco superior ao de simples documentação/UI e precisam de evidência e autorização compatíveis.

## 6. IA

O repositório possui dependências de OpenAI e Anthropic, além de pacotes internos de agentes. Documentação histórica também menciona Azure OpenAI, Gemini e estratégias vetoriais específicas.

Portanto, agentes não devem inferir que um provider histórico é universalmente canônico apenas porque aparece em um documento antigo.

Para qualquer alteração em IA:

1. identificar o módulo e contrato efetivamente usados;
2. verificar implementação corrente;
3. consultar ADRs/blueprints da frente;
4. preservar compatibilidade de dados;
5. justificar mudança de modelo/provider por qualidade, custo, latência, segurança ou capacidade.

## 7. Arquitetura agêntica

A direção estratégica favorece um agente coordenador capaz de delegar tarefas a agentes especializados quando isso trouxer ganho real.

Princípios:

- contexto deve ser selecionado por tarefa;
- agentes devem ter contratos e responsabilidades claras;
- regras críticas não devem viver apenas em prompts;
- evidência e revisão humana devem existir em decisões de maior impacto;
- não criar agentes para resolver problemas que um serviço simples resolve melhor.

## 8. Knowledge Factory

A Knowledge Factory possui arquitetura e governança próprias em:

`docs/profeplan-knowledge-factory/`

Sua linha corrente deve ser consultada antes de qualquer trabalho de ingestão, cartografia, reconstrução, chunking, embeddings, RAG ou conteúdo editorial real.

Não extrapolar automaticamente padrões da aplicação principal para a Knowledge Factory, nem o inverso.

## 9. Princípios arquitetônicos transversais

Priorizar:

- baixo acoplamento;
- alta coesão;
- contratos explícitos;
- provider-neutralidade quando houver benefício comprovado;
- observabilidade;
- idempotência onde operações possam ser repetidas;
- segurança por padrão;
- rastreabilidade;
- testes proporcionais ao risco;
- mudanças incrementais.

## 10. Mudanças de alto impacto

Exigem inspeção específica e governança reforçada:

- schemas e migrations;
- autenticação e autorização;
- RLS/grants;
- secrets;
- produção;
- pagamentos;
- armazenamento de dados pessoais/sensíveis;
- contratos públicos entre módulos;
- troca de dimensões/formatos persistidos;
- ingestão de material editorial protegido;
- alterações que mudem invariantes pedagógicas.

## 11. Documentação histórica

`docs/arquitetura-geral-profeplan.md` e documentos de fases anteriores preservam decisões e intenções importantes, mas alguns trechos refletem estados anteriores da arquitetura.

Não apagá-los apenas por estarem antigos. Quando houver necessidade, reconciliar explicitamente por ADR, atualização documental ou decisão registrada.

## 12. Regra para agentes

Nunca responder “a arquitetura é X” apenas a partir deste resumo quando a tarefa exigir precisão operacional.

Primeiro localizar a fonte específica e o código correspondente. O Continuity Pack orienta a navegação; não elimina a verificação.
