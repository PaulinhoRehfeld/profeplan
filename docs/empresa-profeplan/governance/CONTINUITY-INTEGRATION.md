# EMPRESA PROFEPLAN — Continuity Pack Integration

## 1. Decisão

O Continuity Pack e a camada `docs/empresa-profeplan/` possuem funções diferentes e complementares.

## 2. Responsabilidades

### Continuity Pack
Responsável por bootstrap de novos chats, agentes e ambientes. Deve ensinar COMO entrar no ecossistema e quais fontes consultar.

### MASTER BLUEPRINT
Responsável por explicar O QUE é a EMPRESA PROFEPLAN, seus domínios, dependências, prioridades e arquitetura institucional.

### Blueprints A–M
Responsáveis pela fronteira e estado de cada domínio.

### Documentação especializada
Responsável por decisões, contratos, evidências, roadmaps e detalhes técnicos/pedagógicos de cada projeto.

## 3. Fluxo oficial

```text
novo ambiente
→ Continuity Pack
→ docs/empresa-profeplan/MASTER-BLUEPRINT.md
→ Blueprint A–M relevante
→ documentação especializada
→ código/schema/ADR/contrato/checkpoint
```

## 4. Consequência para o PR #128

O PR #128 não deve ser descartado nem absorvido integralmente. Após a consolidação desta camada institucional, deverá receber reconciliação mínima para:
- trocar a visão institucional duplicada por referências ao MASTER-BLUEPRINT quando apropriado;
- manter regras de bootstrap, continuidade e IA;
- preservar estado resumido da Knowledge Factory enquanto necessário;
- evitar duas fontes concorrentes para identidade e arquitetura corporativa.

## 5. Regra anti-duplicação

Quando uma informação institucional existir no MASTER-BLUEPRINT, o Continuity Pack deve preferir link/referência e manter apenas o resumo mínimo necessário para bootstrap.