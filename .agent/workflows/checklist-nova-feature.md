---
description: Checklist de proteção IP para implementação de novas features
---

# Checklist de Proteção IP - Nova Feature

Execute este checklist **ANTES** de implementar qualquer nova funcionalidade significativa no PROFEPLAN.

---

## Propósito

Garantir que toda inovação técnica seja devidamente documentada e protegida, evitando:
- ❌ Perda de direitos sobre invenções
- ❌ Vazamento de informações proprietárias
- ❌ Falta de evidências de autoria
- ❌ Desatualização da documentação IP

---

## FASE 1: Análise Inicial

### 1.1. Classificação da Feature

**Tipo de mudança:**
- [ ] Nova funcionalidade (ex: geração de PDI automático)
- [ ] Melhoria de algoritmo existente (ex: RAG mais preciso)
- [ ] Refatoração arquitetural (ex: novo padrão de design)
- [ ] Integração com tecnologia nova (ex: nova IA, nova API)
- [ ] Mudança de UX/UI (ex: novo componente visual)

**Impacto:**
- [ ] CRÍTICO → Altera core business ou arquitetura principal
- [ ] ALTO → Adiciona capacidade significativa ao produto
- [ ] MÉDIO → Melhoria incremental com valor comercial
- [ ] BAIXO → Ajuste técnico ou correção de bug

---

## FASE 2: Questões de Proteção

### 2.1. Algoritmo Inovador?

**Pergunta:** A feature introduz algoritmo, técnica ou metodologia inovadora?

**Exemplos:**
- Novo método de cálculo ou scoring
- Técnica proprietária de processamento
- Arquitetura de dados única
- Lógica de negócio complexa

**Se SIM:**
- [ ] Documentar algoritmo em `CATALOGO_INOVACOES.md`
- [ ] Criar pseudocódigo (não código real) em documento físico
- [ ] Adicionar evidência de criação (commit, timestamp)
- [ ] Avaliar: Segredo Industrial ou Patente?

**Decisão:**
```
┌─────────────────────────────────────────┐
│ É facilmente descoberto por engenharia  │
│ reversa ou observação do produto?       │
└─────┬───────────────────────────────────┘
      │
      ├─ SIM → Considerar PATENTE
      │        (divulga, mas garante exclusividade)
      │
      └─ NÃO → Manter como SEGREDO INDUSTRIAL
               (não divulga, proteção indefinida)
```

---

### 2.2. Dados Sensíveis?

**Pergunta:** A feature utiliza, processa ou armazena dados sensíveis?

**Tipos de dados:**
- [ ] Dados de alunos (LGPD aplicável)
- [ ] Dados pedagógicos de escolas (confidencialidade)
- [ ] Credenciais de API de terceiros
- [ ] Tabelas proprietárias (ex: mapeamento ISBN→BNCC)

**Se SIM:**
- [ ] Atualizar `POLITICA_SEGREDO_INDUSTRIAL.md` → Seção de Dados
- [ ] Implementar criptografia (em trânsito e em repouso)
- [ ] Documentar medidas de proteção (logs, acesso restrito)
- [ ] Adicionar auditoria de acesso
- [ ] Revisar conformidade com LGPD

---

### 2.3. Patenteabilidade?

**Critérios para considerar patente:**

| Critério | Descrição | Checklist |
|----------|-----------|-----------|
| Novidade | Nunca foi divulgado publicamente | [ ] Sim |
| Atividade Inventiva | Não é óbvio para especialista | [ ] Sim |
| Aplicação Industrial | Tem uso prático e comercial | [ ] Sim |
| Legalidade | Não é software puro (no Brasil) | [ ] Sim/Não |

**Se TODOS marcados:**
- [ ] Consultar advogado especializado em PI (patentes)
- [ ] Preparar relatório descritivo da invenção
- [ ] Fazer busca de anterioridade (USPTO, EPO, INPI)
- [ ] Avaliar custo-benefício (R$ 10-50k + manutenção anual)

**Decisão Final:**
- [ ] Patentear (custo alto, proteção forte)
- [ ] Segredo Industrial (custo zero, risco médio)
- [ ] Não proteger (baixo valor estratégico)

---

### 2.4. Impacto na Marca?

**Pergunta:** A feature afeta ou expande o uso da marca "PROFEPLAN"?

**Exemplos:**
- Nova categoria de produto (ex: PROFEPLAN PDI)
- Novo mercado (ex: PROFEPLAN para Ensino Superior)
- Sub-marca ou variação (ex: PROFEPLAN AI)

**Se SIM:**
- [ ] Avaliar registro de nova marca ou extensão
- [ ] Verificar se Classes 09 e 42 cobrem
- [ ] Considerar registro em novas classes NCL
- [ ] Atualizar especificações de serviços/produtos

---

## FASE 3: Documentação Obrigatória

### 3.1. Commit com Evidência

```bash
# Criar commit específico para a feature
git add .
git commit -m "feat: [NOME_FEATURE] - [BREVE_DESCRICAO]

Inovação técnica: [DESCREVER TÉCNICA/ALGORITMO]
Valor comercial: [DESCREVER BENEFÍCIO]
Evidência de autoria: Paulo Roberto Rehfeld
Data: $(date +%Y-%m-%d)
"

# IMPORTANTE: Assinar commit com GPG
git commit --amend -S
```

---

### 3.2. Atualizar CATALOGO_INOVACOES.md

Se feature introduz **algoritmo inovador** ou **técnica proprietária**:

```markdown
## INOVAÇÃO #00X: [NOME DA INOVACAO]

### Identificação
- **ID:** INOV-00X
- **Nome:** [Nome descritivo]
- **Data de Criação:** [DD/MM/AAAA]
- **Versão Atual:** 1.0

### Descrição Técnica
[Explicação do algoritmo, técnica ou método]

### Vantagem Competitiva
[Comparação com alternativas existentes]

### Evidências de Criação
- **Commit:** [hash do commit]
- **Branch:** [nome do branch]
- **Testes:** [path para testes]

### Investimento
- **Horas:** [horas investidas]
- **Custos:** [custos diretos, se aplicável]
```

---

### 3.3. Atualizar POLITICA_SEGREDO_INDUSTRIAL.md

Se feature introduz **dados sensíveis** ou **segredo industrial**:

Adicionar à seção pertinente:
```markdown
### 2.X. [Nome do Novo Segredo]

**Descrição:**
[O que é o segredo]

**Componentes Secretos:**
1. [Componente 1]
2. [Componente 2]

**Valor Econômico:**
[Por que vale proteger]

**Precauções:**
- [Medida 1]
- [Medida 2]
```

---

### 3.4. Atualizar README.md (se aplicável)

Se feature é **user-facing** ou **arquiteturalmente significativa**:

- [ ] Adicionar à seção de funcionalidades
- [ ] Atualizar diagramas (se aplicável)
- [ ] Documentar nova tecnologia no stack
- [ ] Incrementar número de versão (semver)

---

## FASE 4: Medidas de Proteção

### 4.1. Código-Fonte

**Verificar:**
- [ ] Feature está em repositório **privado**
- [ ] Não há hardcoded secrets (API keys, passwords)
- [ ] Logs não expõem lógica proprietária
- [ ] Comentários não revelam técnicas sensíveis

### 4.2. Documentação

**Verificar:**
- [ ] Documentação técnica interna (não pública)
- [ ] Diagramas em arquivos privados
- [ ] Pseudocódigo de algoritmos críticos documentado fisicamente
- [ ] Não há descrições detalhadas em fóruns públicos

### 4.3. Deploy e Operação

**Verificar:**
- [ ] Feature não expõe endpoints sensíveis
- [ ] APIs com autenticação e rate limiting
- [ ] Logs de acesso habilitados
- [ ] Monitoramento de uso anômalo

---

## FASE 5: Compliance e Legalidade

### 5.1. LGPD (Lei Geral de Proteção de Dados)

Se feature processa **dados pessoais**:

- [ ] Finalidade claramente definida
- [ ] Base legal identificada (consentimento, legítimo interesse, etc.)
- [ ] Minimização de dados (coletar apenas necessário)
- [ ] Prazo de retenção definido
- [ ] Direitos do titular implementados (acesso, exclusão, portabilidade)

### 5.2. Licenças de Terceiros

Se feature usa **bibliotecas de código aberto**:

- [ ] Verificar licença (MIT, Apache, GPL, etc.)
- [ ] Garantir compatibilidade com código proprietário
- [ ] Documentar em `package.json` ou `requirements.txt`
- [ ] Creditar autores (se exigido pela licença)

---

## FASE 6: Checklist Final

Antes de fazer **merge para produção**:

### Proteção IP
- [ ] Commit assinado com GPG
- [ ] `CATALOGO_INOVACOES.md` atualizado (se aplicável)
- [ ] `POLITICA_SEGREDO_INDUSTRIAL.md` atualizado (se aplicável)
- [ ] Evidências de autoria documentadas

### Segurança
- [ ] Sem secrets vazados no código
- [ ] Autenticação implementada
- [ ] Logs de auditoria habilitados
- [ ] Criptografia aplicada (se dados sensíveis)

### Compliance
- [ ] LGPD compliance (se dados pessoais)
- [ ] Licenças de terceiros verificadas
- [ ] Termos de uso atualizados (se necessário)

### Documentação
- [ ] `README.md` atualizado
- [ ] Changelog atualizado (CHANGELOG.md)
- [ ] Testes automatizados criados

---

## Template de Decisão Rápida

```
┌─────────────────────────────────────────┐
│ NOVA FEATURE: [Nome da Feature]         │
└─────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│ Introduz algoritmo inovador?            │
└──┬─ SIM → Catalogar inovação            │
   └─ NÃO → Próxima pergunta              │
              │
              ▼
┌─────────────────────────────────────────┐
│ Usa dados sensíveis?                    │
└──┬─ SIM → Atualizar política segredo    │
   └─ NÃO → Próxima pergunta              │
              │
              ▼
┌─────────────────────────────────────────┐
│ Patenteável?                            │
└──┬─ SIM → Consultar advogado PI         │
   └─ NÃO → Próxima pergunta              │
              │
              ▼
┌─────────────────────────────────────────┐
│ Afeta marca PROFEPLAN?                  │
└──┬─ SIM → Avaliar extensão de marca     │
   └─ NÃO → Implementar normalmente       │
              │
              ▼
        [CONCLUSÃO]
```

---

**Última atualização:** 16/02/2026  
**Uso:** Antes de iniciar qualquer feature significativa
