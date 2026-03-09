---
feature: "Adaptações PDI/DUA"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Adaptações PDI/DUA (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Permitir que o professor gere, registre e acompanhe **adaptações curriculares individualizadas** (Bloco 9 do PDI) para aulas específicas, seguindo os princípios de **DUA (Desenho Universal para Aprendizagem)**, com vínculo claro:

- Ao **estudante** (PDI ativo).
- À **aula/planejamento de ensino**.
- À **disciplina**, **série/ano** e **habilidades BNCC**.

---

## 2. Entidades e Contexto Técnico

- **PdiDocument** (`pdi_documents`)
  - Representa o PDI anual do estudante.
  - Campos relevantes:
    - `id`, `student_id`, `school_id`, `year`, `status`
    - `content_data` (JSONB consolidando blocos 1–8, 9, 10, 11)
    - `block_9_content` (lista de adaptações geradas)

- **PdiRecord / PdiRecordType** (`pdi_records`)
  - Linha do tempo de eventos PDI:
    - `type` ∈ {`EVALUATION`, `OCCURRENCE`, `LESSON_PLAN`, `OBSERVATION`, `ADAPTATION`}.

- **Block9AdaptationEntry** (`block_9_content` embutido no PDI)
  - Campos relevantes:
    - `lesson_id`, `lesson_title`, `subject`
    - `habilidades_bncc: string[]`
    - `adaptacao_metodologica: string`
    - `recursos_adaptados: string[]`
    - `objetivos_adaptados: string[]`
    - `estrategias_ensino: string[]`
    - `tempo_estimado?: string`
    - `generated_at`, `generated_by_ai`

- **Serviços chave**
  - `PdiDocumentService` (arquivo atual):
    - `generateAdaptationsForLesson(...)`
    - `generateBlock9Adaptation(...)`
    - `getStudentAdaptations(...)`
    - `getAdaptationStats(...)`
  - **IA (Azure OpenAI)**:
    - `createSimpleCompletion` em `AiCore.ts` é usado por `generateBlock9Adaptation`.
  - **Créditos**:
    - `checkUsageQuota(userId)` é chamado dentro de `generateBlock9Adaptation` quando há `userId`.

---

## 3. Fluxo Principal – Gerar Adaptações para uma Aula

### 3.1 Entrada

- Origem: aba **Adaptações PDI/DUA** (ou ação equivalente na tela de aula).
- Pré-condições:
  - Professor autenticado, com `profile.school_id` configurado.
  - Aula selecionada: `lessonId`, `lessonTitle`, `lessonContent`, `subject`, `gradeLevel`.
  - Lista de habilidades BNCC associadas à aula: `habilidadesBncc: string[]`.
  - Turma/Escola/Ano letivo: `classId`, `schoolId`, `year`.

### 3.2 Orquestração (conforme `generateAdaptationsForLesson`)

1. Buscar **PDIs em andamento** para os estudantes da escola/turma:
   - `pdi_documents` com:
     - `school_id = schoolId`
     - `year = year`
     - `status = 'em_andamento'`
2. Para cada `PdiDocRow`:
   - Montar `studentPdiContext` (dados clínicos/pedagógicos/cognitivos):
     - `nome_completo` a partir de `school_students.name`.
     - `diagnostico_clinico` de `content_data.clinical_health.diagnosis_cid`.
     - `necessidades_especificas`, `potencialidades`, `desafios`, `objetivo_geral`, `recursos_tecnologicos`, `materiais_adaptados` de `content_data.pedagogical` e `content_data.cognitive`.
   - **Contrato forte:** se não houver `nome_completo`, essa PDI **não entra** na geração (erro de formulário base).
3. Chamar `generateBlock9Adaptation(...)` para cada estudante elegível:

   - Prompt atual (fonte de verdade):
     - Define o papel da IA: especialista em Inclusão + DUA.
     - Inclui:
       - `AULA: {lessonTitle} ({subject} - {gradeLevel})`
       - `Conteúdo: {lessonContent.substring(0, 2500)}`
       - `Habilidades BNCC: ...`
       - `PERFIL DO ALUNO` com diagnóstico, necessidades, objetivo geral.
     - Instrução de sistema:
       - `"Você é um especialista em inclusão e DUA escrevendo adaptações de aula. Seja específico e aplicável na sala de aula."`
   - Saída esperada:
     - `adaptacao_metodologica`: texto em Markdown organizado em seções:
       - **Objetivos Adaptados**
       - **Estratégias de Acesso**
       - **Atividade Adaptada**
       - **Avaliação Diferenciada**
     - Arrays adicionais podem ser deixados vazios por enquanto (`recursos_adaptados`, etc.), desde que a adaptação principal venha estruturada.

4. Persistência:
   - Criar um novo item em `block_9_content` para o PDI do estudante (`addBlock9Adaptation`).
   - Opcional: registrar evento em `pdi_records` (`type: 'ADAPTATION'`), se a UI exigir trilha de auditoria detalhada.

5. Resultado da operação:
   - Retorno agregador:
     - `{ success: boolean; adaptationsCreated: number; errors: string[] }`
   - **Contrato:** erros por estudante **não devem** abortar toda a turma; devem ser acumulados em `errors`.

---

## 4. Contratos Fortes (Invariantes)

1. **Vínculo aluno–aula–PDI**
   - Cada adaptação gerada deve referenciar:
     - `lesson_id` e `lesson_title` corretos.
     - `subject` da aula.
     - O PDI do **mesmo estudante** (não pode cruzar alunos).

2. **Disciplina e Série**
   - O texto de adaptação deve sempre respeitar:
     - A **disciplina** (`subject`) da aula de origem.
     - O **nível/série** (`gradeLevel`) informado.
   - **Proibido**:
     - Trocar a disciplina por outra (ex.: Sociologia → História) dentro da adaptação.

3. **Escopo DUA**
   - Toda adaptação deve:
     - Estar ancorada em necessidades e potencialidades do aluno.
     - Trazer **estratégias concretas de acesso** (não apenas descrições genéricas).
   - Campos mínimos no Markdown:
     - `## Objetivos Adaptados`
     - `## Estratégias de Acesso`
     - `## Atividade Adaptada`
     - `## Avaliação Diferenciada`

4. **Créditos de IA**
   - Quando houver `userId`:
     - É obrigatório chamar `checkUsageQuota(userId)` antes da geração.
     - Em caso de bloqueio (`allowed === false`), lançar erro com mensagem clara.
   - Erros de créditos **não podem** quebrar a tela inteira; devem ser exibidos ao professor.

5. **Resiliência da Operação em Lote**
   - Falha em um estudante:
     - Não impede adaptações para os demais (sem "tudo ou nada").
   - `adaptationsCreated` deve sempre refletir o que foi realmente salvo.

---

## 5. Erros, Estados e Mensagens

- **Nenhum PDI em andamento encontrado**
  - Retorno: `{ success: true/false; adaptationsCreated: 0; errors: ["Mensagem explicando que não há PDIs ativos para aquele ano/escola."] }`
  - UI deve mostrar um aviso claro ao professor.

- **Formulário base incompleto (sem nome do estudante)**
  - O estudante é pulado na geração.
  - Erro específico é acrescentado à lista `errors` com identificação do aluno (quando possível).

- **Erro de IA (Azure OpenAI)**
  - Para cada estudante:
    - A mensagem de erro é registrada em `errors`.
  - A UI deve informar que a geração falhou para alguns/nenhum estudante, sem recarregar a página ou entrar em loop.

- **Erro de persistência (`addBlock9Adaptation`)**
  - Adaptação não conta em `adaptationsCreated`.
  - Mensagem de erro específica deve ser registrada.

---

## 6. Checklist de Validação (para agentes/QA)

Quando o agente Guardião de PDI/DUA ou QA revisar essa aba, deve checar:

1. **Contexto e Entrada**
   - [ ] A chamada principal usa `generateAdaptationsForLesson(...)` com todos os parâmetros obrigatórios.
   - [ ] `schoolId`, `classId` e `year` são coerentes com o ambiente da escola.

2. **Consulta de PDIs**
   - [ ] Apenas PDIs com `status = 'em_andamento'` são considerados.
   - [ ] O vínculo `school_students` está correto (nome do estudante vem da mesma escola).

3. **Prompt de IA**
   - [ ] O prompt inclui `AULA: {lessonTitle} ({subject} - {gradeLevel})`.
   - [ ] O conteúdo da aula é truncado de forma segura (`substring(0, 2500)`).
   - [ ] `Habilidades BNCC` são listadas.
   - [ ] O perfil do aluno contém diagnóstico, necessidades e objetivo geral (quando disponíveis).
   - [ ] A instrução de sistema reforça claramente o papel de especialista em inclusão + DUA.

4. **Disciplina e Série**
   - [ ] A disciplina do texto gerado é coerente com `subject` (sem quedas para História, etc.).
   - [ ] O nível de linguagem/metodologia faz sentido para `gradeLevel`.

5. **Persistência**
   - [ ] Cada adaptação salva em `block_9_content` referencia corretamente `lesson_id`, `lesson_title` e `subject`.
   - [ ] `adaptationsCreated` bate com o número de entradas salvas.

6. **Créditos e Erros**
   - [ ] `checkUsageQuota(userId)` é chamado quando `userId` existir.
   - [ ] Erros de quota/IA são tratados com mensagens claras e não travam a aplicação.

