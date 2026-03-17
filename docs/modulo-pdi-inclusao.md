### Módulo PDI / Inclusão

#### 1. Propósito do módulo

- **Objetivo principal**: Centralizar o **Plano de Desenvolvimento Individual (PDI)** de cada estudante que precisa de adaptações pedagógicas, garantindo:
  - rastreabilidade entre aluno ↔ turma ↔ PDI;
  - uso responsável de IA (sem “inventar” diagnósticos);
  - alinhamento com observações pedagógicas reais do professor.

- **O que este módulo resolve**:
  - **[IMPLEMENTADO PARCIAL]** Criar / obter documentos PDI por aluno/ano usando `PdiDocumentService.getOrCreatePdi`.
  - **[IMPLEMENTADO PARCIAL]** Preencher PDIs com ajuda de IA usando `AiPdiService.generateStudentAdaptation`.
  - **[TODO]** Fluxos de edição humana mais avançados (ex.: bloqueios por seção, histórico de alterações).

- **O que este módulo NÃO é**:
  - Não é um sistema médico/diagnóstico.
  - Não substitui laudos, pareceres clínicos ou documentos oficiais externos.
  - Não deve alterar ou apagar dados de turma/alunos de forma independente (usa o que vem do Módulo Minhas Turmas).

---

#### 2. Escopo funcional

- **Funcionalidades centrais**:
  - **[IMPLEMENTADO PARCIAL]** Criar e manter **documentos PDI** por aluno e ano letivo (já existe fluxo de get-or-create, ainda em consolidação com a nova migração).
  - **[IMPLEMENTADO PARCIAL]** Exibir e editar o conteúdo do PDI em blocos/seções via UI (já há estrutura, mas o formato JSONB e blocos ainda podem evoluir).
  - **[PARCIAL]** Integrar dados de:
    - `students` (perfil de inclusão do aluno) – **já usado por `getStudentInclusionSnapshot`**,  
    - planejamentos – **[TODO]** integração mais explícita,  
    - relatórios/evidências – **[TODO]**.

- **Principais usuários**:
  - Professores regentes.
  - Professores de apoio/inclusão.
  - Gestores escolares (sobretudo em leitura/consulta).

---

#### 3. Modelo de dados

##### 3.1. Tabela `students` (campos relevantes para PDI)

- **Fonte de verdade vinda do Módulo Minhas Turmas**:
  - **[IMPLEMENTADO]** `id UUID PRIMARY KEY`
  - **[IMPLEMENTADO]** `needs_adaptation BOOLEAN`
  - **[IMPLEMENTADO]** `deficiencies TEXT[]` (ou equivalente, conforme migrations de inclusão)
  - **[IMPLEMENTADO]** `pedagogical_observations TEXT` / `observations TEXT`
  - **[IMPLEMENTADO]** `student_code TEXT` (código do aluno na rede – SIMADE)
  - **[IMPLEMENTADO]** `call_number INTEGER` (número de chamada)

- **Regra**:
  - **[IMPLEMENTADO PARCIAL]** Este módulo **NÃO cria nem gerencia** alunos diretamente. Ele consome `students`.
  - **[TODO]** Garantir que nenhuma tela/serviço de PDI tente alterar `students` sem seguir regras documentadas no Módulo Minhas Turmas.

##### 3.2. Tabela `pdi_documents`

- **Baseado nas migrations (incluindo `20260124_create_pdi_documents.sql` e `20260317_align_pdi_with_students.sql`):**
  - **[IMPLEMENTADO]** `id UUID PRIMARY KEY`
  - **[IMPLEMENTADO]** `student_id UUID REFERENCES public.students(id) ON DELETE CASCADE` (migração de alinhamento já criada)
  - **[IMPLEMENTADO]** `year INT` (coluna adicionada na migração mais recente, substituindo o uso de `period` como chave lógica)
  - **[IMPLEMENTADO]** `status TEXT` (incluindo valor `'em_andamento'`, alinhado com CHECK no banco)
  - **[IMPLEMENTADO PARCIAL]** `content JSONB` (estrutura dos blocos de PDI – já existe, mas o formato ainda está evoluindo)
  - **[IMPLEMENTADO]** `created_at TIMESTAMP`, `updated_at TIMESTAMP` (campos padrão de Supabase)
  - **[PARCIAL]** `owner_id` / `teacher_id` – se existirem, ainda não estão totalmente consolidados na documentação.

- **Chave lógica do documento**:
  - **[IMPLEMENTADO PARCIAL]** `student_id + year + status = 'em_andamento'`  
    (lógica já aplicada em `PdiDocumentService.getOrCreatePdi`, mas precisa ser auditada pós-migração de `year`).

---

#### 4. Integração com serviços e tipos TypeScript

##### 4.1. Tipos PDI (`apps/web/src/types/pdi.ts`)

- **Interface alvo**: `PdiDocument`
  - **[IMPLEMENTADO PARCIAL]** Já contém campos como `id`, `student_id`, `status`, `content`, e foi ajustada para incluir `period?: string;`.  
  - **[TODO]** Alinhar definitivamente para:
    - usar `year: number` como campo principal em vez de `period` nas novas versões,
    - garantir presença de `created_at`, `updated_at` se forem usados.

##### 4.2. `PdiDocumentService`

- **Responsabilidades atuais**:
  - **[IMPLEMENTADO PARCIAL]** `getOrCreatePdi`:
    - atualizada para usar `year` e `status: 'em_andamento'` conforme migração,
    - já migrou o join de `school_students` → `students`.
  - **[IMPLEMENTADO PARCIAL]** `getSchoolPdis` / `getPdiDocument`:
    - usam join com `students` (alias `school_students`),
    - necessitam auditoria final após a migração de `year`.

- **Regra obrigatória**:
  - **[PARCIAL]** Toda lógica deve usar `student_id` + `year` como chaves naturais do PDI.
  - **[TODO]** Remover qualquer resquício de uso de `period` como filtro principal.

##### 4.3. `AiPdiService`

- **Funções principais**:
  - **[IMPLEMENTADO]** `generateStudentAdaptation`:
    - já consome o snapshot de inclusão (`getStudentInclusionSnapshot`),
    - já usa `deficiencies` e `observations` no prompt,
    - estrutura de saída encaixa em blocos para `pdi_documents.content`.

- **[TODO]**:
  - Refinar e documentar claramente o formato esperado de `content` (ex.: seções nomeadas, ids de blocos, etc.).
  - Garantir que o prompt deixe explícito que a IA não pode inventar diagnósticos.

---

#### 5. Fluxos críticos

##### 5.1. Fluxo: Criar / obter PDI de um aluno

1. **[IMPLEMENTADO PARCIAL]** Usuário seleciona aluno + ano letivo.
2. Front chama `PdiDocumentService.getOrCreatePdi(studentId, year)`.
3. Serviço:
   - busca por `student_id`, `year`, `status='em_andamento'` (já ajustado na última revisão),
   - se não encontrar, cria novo registro em `pdi_documents` com estrutura mínima em `content`.
4. Front abre editor de PDI com o documento retornado.

- **OBRIGATÓRIO**:
  - **[PARCIAL]** Sempre filtrar por `student_id` + `year` + `status`.
  - **[TODO]** Garantir que não existam múltiplos registros `em_andamento` para o mesmo par (`student_id`, `year`), ou, se existirem, que haja uma regra clara.

##### 5.2. Fluxo: Enriquecer PDI com dados do aluno e IA

1. **[IMPLEMENTADO]** Carregar dados do aluno a partir de `students`.
2. **[IMPLEMENTADO]** Montar `getStudentInclusionSnapshot(student)` com:
   - `needs_adaptation`,
   - `deficiencies`,
   - `pedagogical_observations` / `observations`,
   - (opcional) outros campos de contexto.
3. **[IMPLEMENTADO]** Passar snapshot + contexto para `AiPdiService.generateStudentAdaptation`.
4. **[IMPLEMENTADO PARCIAL]** Receber blocos de texto estruturados para preencher/editar `content`.

- **OBRIGATÓRIO**:
  - **[IMPLEMENTADO PARCIAL]** Snapshot deve refletir exatamente o schema atual de `students` (já há função consolidando campos, mas precisa ser re-checada após mudanças recentes).
  - **[TODO]** Garantir no prompt que a IA:
    - não inventa diagnósticos,
    - não altera dados de identificação.

##### 5.3. Fluxo: Edição humana e salvamento

1. **[IMPLEMENTADO PARCIAL]** Professor revisa e ajusta o conteúdo do PDI na UI.
2. Ao salvar:
   - atualiza `pdi_documents.content` e `updated_at`.
3. **[TODO]** Definir política clara de:
   - como a IA pode ou não sobrescrever blocos já editados,
   - como versionar/registrar alterações importantes.

- **PROIBIDO**:
  - **[TODO]** Sobrescrever silenciosamente blocos já editados manualmente ao chamar IA de novo.
  - **[TODO]** Deletar PDIs em massa sem regras nem logs.

---

#### 6. Guardrails (OBRIGATÓRIO / PROIBIDO)

- **OBRIGATÓRIO**:
  - **[IMPLEMENTADO PARCIAL]** Usar `student_id` + `year` + `status='em_andamento'` como chave lógica em todos os serviços.
  - **[IMPLEMENTADO]** Manter FK `student_id → students(id)` (migração já cria `ON DELETE CASCADE`).
  - **[PARCIAL]** Manter `getStudentInclusionSnapshot` sincronizado com o schema de `students` (função criada, mas precisa de revisão sempre que `students` mudar).
  - **[TODO]** Atualizar este doc e `fluxos-criticos-e-guardrails.md` a cada alteração em `pdi_documents` ou `students`.

- **PROIBIDO**:
  - **[TODO / PROMPT]** IA sugerir, criar ou alterar diagnósticos médicos/psicopedagógicos.
  - **[IMPLEMENTADO PARCIAL]** Alterar campos de aluno (`students`) a partir do módulo PDI sem regras bem definidas (hoje isso não é feito, mas precisa continuar proibido).
  - **[TODO]** Criar múltiplos PDIs `em_andamento` por ano/aluno sem decisão explícita.

---

#### 7. Pontos de integração com outros módulos

- **Módulo Minhas Turmas & Alunos**:
  - **[IMPLEMENTADO]** Fonte de:
    - `needs_adaptation`, `deficiencies`, `observations`,
    - `student_code`, `call_number`.
  - **[OBRIGATÓRIO]** Qualquer mudança nesses campos em `students` deve:
    - ser refletida aqui,
    - ser atualizada em `getStudentInclusionSnapshot`.

- **Módulo Planejamento**:
  - **[TODO]** Definir como objetivos/competências planejados alimentam metas e estratégias do PDI.

- **Módulo Relatórios / Avaliação**:
  - **[TODO]** Definir como informações do PDI aparecem em relatórios e dashboards.

---

#### 8. Checklist rápido para agentes / devs

- [ ] Confirmar que a migração `20260317_align_pdi_with_students.sql` foi aplicada e que `pdi_documents.student_id` referencia `public.students(id)` com `ON DELETE CASCADE`.  
- [ ] Ajustar `PdiDocument` (TS) para usar `year` como campo principal (e remover dependência de `period` como chave).  
- [ ] Auditar `PdiDocumentService.getOrCreatePdi`, `getSchoolPdis` e `getPdiDocument` para garantir uso consistente de `student_id` + `year` + `status`.  
- [ ] Revisar `getStudentInclusionSnapshot` para alinhar 100% com o schema atual de `students`.  
- [ ] Revisar o prompt de `AiPdiService.generateStudentAdaptation` para reforçar os guardrails (não inventar diagnósticos, usar apenas dados de `students` + contexto).  
- [ ] Documentar qualquer mudança futura em `pdi_documents` e `students` aqui e em `docs/fluxos-criticos-e-guardrails.md`.

