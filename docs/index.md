# Documentação PROFEPLAN – Índice Principal

Esta pasta contém a documentação de alto nível do PROFEPLAN, organizada para uso por **agentes de IA** e **desenvolvedores humanos**.

---

## 0. Continuidade institucional

- **ProfePlan Continuity Pack**
  - `profeplan-continuity/README.md`

Use o Continuity Pack como porta de entrada para uma nova conversa, novo agente ou novo ambiente. Ele orienta quais fontes canônicas devem ser consultadas e evita depender exclusivamente de memória/histórico de IA.

---

## 1. Porta de entrada histórica do produto

- **Visão geral do produto**
  - `overview-profeplan.md`

- **Arquitetura do sistema**
  - `arquitetura-geral-profeplan.md`

- **Comparativo de Repositórios (V4 vs V5) para Alinhamento**
  - `COMPARATIVO_REPOSITORIOS.md`

> Observação: documentos gerais anteriores continuam relevantes como referência histórica e de domínio, mas devem ser confrontados com código, ADRs, contratos e checkpoints vigentes quando houver dúvida de atualidade.

---

## 2. Áreas críticas de negócio

- **Turmas, Alunos e PDI (Educação Inclusiva)**
  - `modulo-alunos-turmas-pdi.md`

- **Fluxos críticos e regras inegociáveis**
  - `fluxos-criticos-e-guardrails.md`

---

## 3. Guia para quem vai alterar o sistema

- **Boas práticas para agentes de IA e devs**
  - `guia-para-agentes-e-devs.md`

- **Regras de trabalho atuais para IA**
  - `profeplan-continuity/08-AI-WORKING-RULES.md`

---

## 4. Knowledge Factory

- **Documentação especializada**
  - `profeplan-knowledge-factory/README.md`

- **Estado resumido para continuidade**
  - `profeplan-continuity/04-KNOWLEDGE-FACTORY-CURRENT-STATE.md`

O checkpoint mais recente da Knowledge Factory prevalece sobre resumos anteriores para o estado operacional corrente.

---

## 5. Planos e documentação histórica

Documentos de fases, migrações e planos anteriores permanecem no repositório para rastreabilidade. Antes de tratá-los como plano ativo, confirmar se não foram superados por uma decisão, roadmap ou checkpoint posterior.

---

## 6. Como iniciar trabalho novo

1. Comece por `profeplan-continuity/README.md`.
2. Confirme o estado atual da `main`.
3. Identifique a frente específica.
4. Leia apenas as fontes canônicas necessárias à tarefa.
5. Antes de grandes refatorações, consulte guardrails e decisões específicas.
6. Para iniciar um ambiente de IA limpo, use `profeplan-continuity/15-CONTINUITY-BOOTSTRAP-PROMPT.md`.
