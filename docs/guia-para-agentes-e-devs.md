# Guia para Agentes de IA e Desenvolvedores – PROFEPLAN

Este guia é um **manual de conduta** para qualquer agente (IA) ou desenvolvedor humano que vá:

- Ler, alterar ou gerar código relacionado ao PROFEPLAN.
- Criar novas features, refatorar módulos ou mexer em prompts.

O objetivo é **evitar que o sistema “se quebre” silenciosamente**, especialmente em áreas sensíveis como:

- Modelagem de Alunos/Turmas/PDI.
- Fluxos de inclusão e educação especial.
- Integração bncc/pnld e RAG.

---

## 1. Ordem recomendada de leitura

Antes de propor qualquer mudança significativa:

1. **Comece por:**
   - `overview-profeplan.md`
   - `arquitetura-geral-profeplan.md`
2. Depois leia, conforme o escopo:
   - `modulo-alunos-turmas-pdi.md` (sempre que envolver turmas/alunos/PDI).
   - `fluxos-criticos-e-guardrails.md` ( SEMPRE antes de grandes refatorações).

Se você é um **agente de código**:

- Trate estes arquivos como **fonte de verdade** de alto nível.
- Não confie apenas no que está nos arquivos de código isoladamente.

---

## 2. Regras gerais para qualquer alteração

### 2.1. Sempre preservar invariantes de negócio

Antes de alterar algo, responda:

- Esta mudança:
  - Mantém a cadeia Escola ↔ Professor ↔ Turma ↔ Aluno ↔ PDI?
  - Mantém o gatilho de PDI baseado em Observações / inclusão?
  - Mantém a obrigatoriedade de consultar BNCC/PNLD via RAG?

Se a resposta for “não sei” para qualquer uma:

- Pare.
- Leia os documentos novamente.
- Peça confirmação explícita de escopo (para um humano, se disponível).

---

### 2.2. Separar claramente:

- **Regras de negócio** → devem estar no backend, em código verificável.
- **Ajustes de linguagem** → podem estar em prompts ou templates.

Evite mover regras de negócio importantes **apenas** para prompts, pois isso:

- Dificulta testes automatizados.
- Aumenta risco de um outro agente sobrescrever o prompt e quebrar a regra.

---

## 3. Checklist rápido antes de refatorar

Use esta lista **especialmente em modo “YOLO”**:

- [ ] Li `overview-profeplan.md` e entendi o produto.
- [ ] Li `arquitetura-geral-profeplan.md` e sei onde meu código se encaixa.
- [ ] Li `fluxos-criticos-e-guardrails.md` e sei o que **não posso** quebrar.
- [ ] Se estou mexendo em turmas/alunos/PDI, li também `modulo-alunos-turmas-pdi.md`.
- [ ] Mapeei quais tabelas, serviços e componentes de UI serão afetados.
- [ ] Verifiquei se há dependências cruzadas com:
  - PDI/DUA.
  - Planejamento trimestral.
  - FREEDAY.
- [ ] Planejei como testar:
  - Fluxos felizes.
  - Fluxos de erros.
  - Casos de inclusão (alunos com observações).

Se qualquer passo acima estiver em branco, preencha antes de continuar.

---

## 4. Orientações específicas para agentes de código (LLMs)

### 4.1. Sobre geração de migrações e schemas

Ao propor mudanças em schemas (Supabase/Postgres):

- Nunca:
  - Remova colunas ligadas a inclusão ou observações de alunos sem:
    - Planejar migração de dados.
    - Atualizar todos os fluxos dependentes.
- Sempre:
  - Mantenha compatibilidade mínima com dados já existentes.
  - Documente as mudanças em linguagem natural (pode ser em um arquivo de notas/migração).

Exemplos de mudanças perigosas:

- Transformar `students` em uma entidade sem perfil inclusivo.
- “Simplificar” `pdi_documents` removendo referências a `student_id` ou `class_id`.

---

### 4.2. Sobre alteração de prompts

Quando editar prompts de:

- Planejamento trimestral.
- Planos de aula.
- PDI/DUA.
- Avaliações.

Verifique:

- Se os prompts ainda:
  - Exigem leitura da BNCC/PNLD via RAG (quando aplicável).
  - Fazem tripla varredura para PDI (perfil do aluno, plano original, diretrizes de inclusão).
- Se não:
  - Atualize os prompts para restaurar essas exigências.

Nunca remova trechos do tipo:

- “Você está proibido de inventar códigos da BNCC”.
- “Leia o plano de aula original e o perfil do aluno antes de adaptar”.

Esses trechos são **guardrails funcionais**, não apenas “texto bonito”.

---

### 4.3. Sobre FREEDAY (agente de voz)

Ao alterar fluxos de navegação ou comandos de voz:

- Garanta que:
  - A FREEDAY continua recebendo o contexto da tela atual.
  - É possível executar comandos do tipo:
    - “Abra minhas turmas”.
    - “Leia este plano”.
    - “Exporte este PDI para PDF”.
- Não transforme a FREEDAY em um chat genérico sem consciência de contexto.

---

## 5. Exemplos de “erros clássicos” a evitar

### 5.1. “Refatoração” que quebra PDI

Sintoma:

- O PDI passa a ser gerado com texto genérico.
- Adaptações não parecem conversar com o perfil do aluno.

Possíveis causas:

- Código deixou de carregar:
  - Observações.
  - Perfil inclusivo.
  - ou o plano original.
- Prompt foi simplificado e perdeu:
  - Instruções sobre tripla varredura.

Como evitar:

- Sempre seguir `modulo-alunos-turmas-pdi.md` ao tocar em `students`, `classes`, `pdi_documents` ou serviços correlatos.

---

### 5.2. “Otimização” que remove varredura de contexto

Sintoma:

- Planos diários ignoram planejamento trimestral.
- Aulas parecem desconectadas entre si.

Causa provável:

- Algum agente ou dev tirou a etapa de:
  - Ler o planejamento trimestral completo antes de gerar a aula.

Como evitar:

- Nunca remover a varredura de contexto em nome de:
  - Menos tokens.
  - Menos tempo de resposta, sem compensações claras.

---

## 6. Quando pedir ajuda humana

Peça revisão de um humano (product owner, arquiteto ou responsável pedagógico) quando:

- For alterar:
  - Modelo de aluno/turma/PDI.
  - Estrutura de histórico de documentos.
  - Dimensão de embeddings ou tecnologia de RAG.
- Tiver que:
  - Relaxar algum guardrail definido em `fluxos-criticos-e-guardrails.md`.

---

## 7. Resumo em uma frase

> **Se você é agente ou dev, sua missão é evoluir o PROFEPLAN sem nunca trair as garantias pedagógicas, de inclusão e de fidelidade curricular já estabelecidas nesta documentação.**

