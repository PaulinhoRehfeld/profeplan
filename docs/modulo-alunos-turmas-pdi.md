# Módulo de Turmas, Alunos e PDI (Plano de Desenvolvimento Individual)

## 1. Objetivo do módulo

Este módulo garante que o PROFEPLAN trate **educação inclusiva** de forma séria e rastreável, conectando:

- Estrutura escolar: **Escola ↔ Professor ↔ Turma ↔ Aluno ↔ Disciplina**.
- Dados sensíveis de inclusão: **Observações, laudos, condições, neurodivergências, altas habilidades**.
- Geração inteligente de **PDI (Planos de Desenvolvimento Individual)** e **adaptações de aula**.

**Meta principal:** nenhuma refatoração futura pode “achatar” ou simplificar o modelo a ponto de tratar alunos como nomes em lista ou ignorar o vínculo **Aluno → Perfil Inclusivo → PDI**.

---

## 2. Modelo relacional obrigatório

### 2.1. Cadeia hierárquica

A base de dados deve respeitar a seguinte cadeia de relacionamentos:

- `schools` (Escola / Gestão / Créditos)
  - 1:N com `teachers` (Professores)
- `teachers`
  - 1:N com `classes` (Turmas)
- `classes`
  - 1:N com `students` (Alunos)
- `students`
  - N:1 com `classes`
  - 1:N com `pdi_documents`
- `subjects` / `disciplines`
  - Associadas às turmas / aulas / planejamentos.

**Invariantes obrigatórios:**

- Um `student` **sempre** pertence a uma `class` ativa (turma letiva).
- Um `pdi_document` **sempre** referencia um `student` e uma `class` válidos.
- Qualquer operação de PDI deve conseguir navegar a cadeia:
  - `school → class → student → pdi_documents`.

---

### 2.2. Estrutura mínima de dados (visão de schema)

Os nomes de campos podem variar no código, mas **estes conceitos não podem ser removidos**.

#### 2.2.1. Tabela `students`

Campos conceituais obrigatórios:

- Identificação básica:
  - `id` (ID interno)
  - `class_id` (referência para turma)
  - `full_name`
  - `age` (opcional, mas recomendado)
  - `enrollment_code` / `student_code` (código da matrícula, quando disponível)

- Perfil inclusivo (condições):
  - Campo ou estrutura que permita registrar:
    - Deficiências: físicas, visuais, auditivas, intelectuais.
    - Neurodivergências: TEA, TDAH, Dislexia, etc.
    - Altas habilidades / superdotação.
  - Pode ser:
    - Um campo JSON estruturado (`inclusion_profile`), ou
    - Uma relação auxiliar (por exemplo, `student_conditions`), desde que:
      - Seja facilmente acessível pelo fluxo de PDI.

- Observações pedagógicas:
  - Campo de texto rico (por exemplo, `observations`):
    - Histórico pedagógico.
    - Estratégias que já funcionaram / não funcionaram.
    - Informações relevantes do dia a dia.

**Regra de ouro:** o aluno **não pode** ser tratado apenas como “nome em lista”. Qualquer refatoração que reduza o aluno a `id + nome` e remova/ignore perfil inclusivo e observações está **violando a arquitetura**.

---

#### 2.2.2. Tabela `classes` (turmas)

- `id`
- `school_id`
- `external_code` (código da turma em sistemas oficiais, quando houver)
- `name` / `description` (exemplo: “1º EM REG 1”)
- `year`
- `shift` (manhã / tarde / noite)
- `subject` / `discipline`
- Metadados de importação (por exemplo, origem do PDF SIMADE).

---

#### 2.2.3. Tabela `pdi_documents`

Campos conceituais obrigatórios:

- Chaves:
  - `id`
  - `student_id`
  - `class_id`
  - (Opcional, mas desejável) `lesson_plan_id` ou referência ao documento de aula correspondente.

- Conteúdo:
  - `title` / `identification`
  - `objective`
  - `strategies`
  - `material_adaptations`
  - `assessment_criteria`
  - `created_at`, `updated_at`

- Metadados de rastreabilidade:
  - `source_plan_type` (por exemplo, “Plano de Aula Diário”, “Planejamento Trimestral”).
  - `generator_agent_version` (opcional, para rastrear mudanças de agente/versão).

**Invariantes de rastreabilidade:**

- Todo PDI deve permanecer **permanentemente vinculado**:
  - Ao `student` correspondente.
  - À `class` em que foi gerado.
- Ao mover aluno de turma ou de ano, o histórico de `pdi_documents` deve migrar junto.

---

## 3. Fluxo crítico: gatilho de PDI e adaptações

### 3.1. Gatilho baseado no aluno

Quando o professor aciona “Gerar PDI” ou “Gerar adaptação de plano de aula”:

1. O sistema identifica:
   - Aluno selecionado (`student_id`).
   - Turma ativa (`class_id`).
   - Plano-base (por exemplo, plano diário específico, referenciado via ID ou contexto).

2. Antes de chamar a Azure OpenAI, o backend carrega o perfil do aluno:
   - Dados básicos (nome, turma).
   - Perfil inclusivo (condições).
   - Observações pedagógicas.

3. O prompt enviado à Azure OpenAI deve **obrigatoriamente** incluir:
   - As condições específicas do aluno.
   - Observações relevantes para a adaptação.
   - O plano de aula original (ou partes essenciais).

**Não é permitido:**

- Gerar PDI sem carregar o perfil do aluno.
- Ignorar o campo de observações/inclusão no prompt.

---

### 3.2. Adaptação curricular real

A IA não deve gerar um texto genérico. Ela deve:

- **Cruzar**:
  - Conteúdo do plano original (BNCC/PNLD).
  - Condições específicas do aluno.
  - Diretrizes de inclusão (RAG).

- Produzir:
  - Estratégias didáticas adaptadas.
  - Sugestões de recursos específicos (visuais, auditivos, tempo estendido, etc.).
  - Adaptações de tempo de prova e formato de avaliação, quando necessário.

---

### 3.3. Guardrails de ética e privacidade

Mesmo que o perfil do aluno contenha laudos, o documento de saída **não deve**:

- Expor diretamente o nome do transtorno/laudo (por exemplo, “TDAH”, “TEA”) no corpo ou título.
- Rotular o aluno de forma explícita que possa causar estigma em leitura por terceiros.

**Padrão de saída recomendado:** focar em descrições funcionais, como:

- “Aluno que apresenta dificuldade de concentração sustentada…”
- “Aluno que se beneficia de instruções visuais e segmentação de tarefas…”

---

## 4. Campo “Observações” como gatilho de PDI

### 4.1. Na UI de turmas / lista de alunos

Para cada aluno na turma, deve existir um campo visível de **“Observações”**.  
É nele que o professor registra:

- Informações de inclusão (laudos, recomendações, necessidades).
- Contexto que justifica adaptações.

### 4.2. Regra de vinculação

- Se o campo **“Observações”** estiver vazio:
  - O aluno **não aparece** na lista de elegíveis para PDI por inclusão.
- Se o campo **“Observações”** estiver preenchido:
  - O sistema:
    - Vincula este aluno ao módulo de PDI.
    - Indica visualmente na UI (badges, ícones, status “PDI pendente”).
    - Usa este campo como parte essencial do contexto do PDI.

---

## 5. Portabilidade e histórico do aluno

Quando o aluno muda de turma ou avança de ano, devem migrar juntos:

- `enrollment_code` / código de matrícula.
- Campo `observations` / perfil inclusivo.
- Histórico de `pdi_documents` já gerados.

**Consequência prática:** o professor da série seguinte deve conseguir:

- Ver rapidamente quais alunos já possuem histórico de inclusão.
- Ler PDIs anteriores.
- Dar continuidade ao acompanhamento, sem recomeçar do zero.

---

## 6. Regras de ouro para refatorações futuras

Estas regras existem para proteger contra “simplificações” perigosas de IA ou devs.

1. **Proibido achatar o modelo de aluno**  
   Não reduzir `students` a uma lista de nomes sem perfil inclusivo e observações.

2. **Proibido gerar PDI sem buscar o perfil do aluno**  
   Qualquer fluxo de PDI/adaptação deve:
   - Buscar `student` + `observations` + perfil de inclusão.
   - Injetar isso no prompt da Azure OpenAI.

3. **Obrigatório manter rastreabilidade**  
   - `pdi_documents` sempre referenciam `student_id` e `class_id`.
   - O histórico não pode ser “desanexado” do aluno.

4. **Proibido expor laudo clínico diretamente no documento**  
   - Os termos clínicos podem estar no banco, mas a saída do PDI deve ser redigida em linguagem pedagógica, não diagnóstica.

5. **Proibido quebrar a cadeia Escola → Professor → Turma → Aluno → PDI**  
   - Qualquer remodelagem de banco ou código que remova essa cadeia é considerada regressão crítica.

---

## 7. Checklist para agentes de código e devs

Antes de mexer em qualquer parte que envolva Alunos, Turmas ou PDI:

- [ ] Verificar se a cadeia relacional Escola → Professor → Turma → Aluno → PDI permanece íntegra.
- [ ] Garantir que os campos de perfil inclusivo e observações do aluno continuam acessíveis.
- [ ] Confirmar que a geração de PDI **ainda** carrega:
  - Perfil do aluno.
  - Observações.
  - Plano de aula original.
- [ ] Validar que `pdi_documents` continuam amarrados ao `student_id` e `class_id`.
- [ ] Checar se a UI de “Minhas Turmas” mantém o campo “Observações” visível e funcionando como gatilho.
- [ ] Revisar se qualquer mudança em schema ou tipos TypeScript não removeu ou escondeu:
  - Campos de inclusão.
  - Campos de observações.
- [ ] Rodar (ou criar) testes que validem:
  - Criação de PDI para aluno com observações.
  - Não listagem de aluno sem observações para fluxos de PDI por inclusão.
  - Migração correta de histórico ao mover aluno de turma/ano.

Se qualquer item estiver em dúvida, a alteração deve ser revisada manualmente por uma pessoa responsável pela arquitetura pedagógica do PROFEPLAN.

