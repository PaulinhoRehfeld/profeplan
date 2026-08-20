# EMPRESA PROFEPLAN — Domain Migration Policy

## 1. Objetivo

Definir quando um domínio A–M deve ter sua documentação fisicamente reorganizada para a estrutura institucional definitiva.

## 2. Princípio

Domínios não migram porque “terminaram”. Migram quando atingem maturidade suficiente para reduzir, e não aumentar, o custo de mudança.

## 3. Critérios mínimos

Um domínio pode migrar quando:
- possui Blueprint vigente;
- seu estado atual é verificável;
- principais interfaces e consumidores estão identificados;
- documentos canônicos e históricos podem ser distinguidos;
- o risco de quebrar referências é conhecido;
- existe um marco estável de desenvolvimento;
- a migração não bloqueia prioridade superior.

## 4. Modos de migração

### Modo 1 — Referência sem movimento
Blueprint novo aponta para documentação antiga. Preferido durante desenvolvimento estrutural intenso.

### Modo 2 — Consolidação parcial
Novos documentos passam a nascer na nova estrutura, enquanto arquivos históricos permanecem no local original.

### Modo 3 — Migração física
Arquivos ativos são movidos para a nova estrutura com atualização controlada de referências.

### Modo 4 — Arquivamento
Documentos superseded/históricos são preservados com status explícito, sem permanecer como porta de entrada operacional.

## 5. Domínios atuais

- A: Modo 2 quando necessário.
- B: Modo 1/2; produto operacional.
- C: Modo 1 até próximo marco PNLD v1.
- D: novos documentos podem nascer diretamente em Modo 2.
- E: Modo 1/2; operação atual preservada.
- F: novos documentos podem nascer em Modo 2.
- G: novos documentos podem nascer em Modo 2 após arquitetura inicial.
- H: Modo 1 enquanto futuro próximo.
- I/J: Modo 1/2 após inventário das capacidades existentes.
- K/L: sem migração enquanto FUTURO.
- M: Modo 2 apenas para discovery essencial.

## 6. Regra de segurança

Nenhuma movimentação em massa deve ocorrer na mesma janela de uma transferência de repositório, alteração de produção ou mudança crítica de infraestrutura.