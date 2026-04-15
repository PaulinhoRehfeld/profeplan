# Documentação PROFEPLAN – Índice Principal

Esta pasta contém a documentação de alto nível do PROFEPLAN, organizada para uso por **agentes de IA** e **desenvolvedores humanos**.

---

## 1. Porta de entrada

- **Visão geral do produto**
  - `overview-profeplan.md`

- **Arquitetura do sistema**
  - `arquitetura-geral-profeplan.md`

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

---

## 4. Plano de execução ativo

- **Estabilização + Migração Azure (paralelo)**
  - `plano-execucao-estabilizacao-migracao-azure.md`

---

## 5. Como usar estes documentos

1. Comece sempre por:
   - `overview-profeplan.md`
   - `arquitetura-geral-profeplan.md`
2. Se for mexer em:
   - Turmas/Alunos/PDI → leia também `modulo-alunos-turmas-pdi.md`.
3. Antes de qualquer refatoração grande:
   - Leia `fluxos-criticos-e-guardrails.md`.
4. Se você é um agente de código ou está automatizando mudanças:
   - Siga as orientações de `guia-para-agentes-e-devs.md`.

