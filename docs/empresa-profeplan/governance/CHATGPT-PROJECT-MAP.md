# EMPRESA PROFEPLAN — ChatGPT Project Map

**Objetivo:** orientar a futura organização das conversas e projetos do ChatGPT sem depender de memória global ou mistura de contextos.

## 1. Regra geral

Cada projeto do ChatGPT deve representar um domínio A–M e usar o respectivo Blueprint como porta de entrada. O MASTER-BLUEPRINT mantém a visão integrada da empresa.

## 2. Estrutura proposta

- A — EMPRESA PROFEPLAN & PUCTEC
- B — APLICATIVO PROFEPLAN
- C — KNOWLEDGE FACTORY PNLD
- D — CURRICULUM FACTORY — BNCC & ESTADOS
- E — SITE / SAAS / UX
- F — MARKETING & VENDAS
- G — PDI / DUA FACTORY
- H — ENEM / SAEB
- I — AVALIAÇÕES
- J — APRESENTAÇÕES
- K — EVOLUTION / NEXUS / CRM
- L — NEB
- M — PROFEPLAN KIDS

## 3. Contexto mínimo por projeto

Cada projeto deve receber:
1. referência ao `MASTER-BLUEPRINT.md`;
2. Blueprint específico do domínio;
3. somente os documentos especializados necessários à tarefa;
4. regra de consultar código/ADR/contrato/checkpoint quando houver conflito;
5. instrução de não carregar outros domínios sem necessidade.

## 4. Continuidade

Fluxo esperado:

```text
nova conversa
→ Continuity Pack / bootstrap
→ MASTER-BLUEPRINT
→ Blueprint do domínio
→ documentação especializada
→ estado atual verificável
```

## 5. Projetos com contexto especialmente isolado

- C Knowledge Factory PNLD: não carregar Marketing, PUCTec ou PDI salvo interface explícita.
- F Marketing & Vendas: consumir Product Evidence Pack e status real do produto, não detalhes de implementação interna sem necessidade.
- G PDI/DUA: aplicar proteção reforçada a dados sensíveis e fontes científicas.
- L NEB: não dirigir arquitetura dos demais projetos enquanto permanecer FUTURO.

## 6. Regra de criação de novos projetos

Um novo domínio N+ deve ser criado somente quando houver fronteira própria de responsabilidade, documentação canônica e justificativa para separar contexto.