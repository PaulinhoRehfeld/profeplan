---
feature: "Simulados ENEM/SAEB"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Simulados ENEM/SAEB (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Permitir que o professor:

- Pesquise e selecione questões **reais** do ENEM/SAEB a partir de um banco com ~17.000 itens.
- Monte simulados equilibrados por área/disciplina, a partir de buscas manuais ou espelhadas em um planejamento trimestral.
- Exporte provas (Word/DOCX) e registrar o simulado como conteúdo gerado no PROFEPLAN (para histórico e reuso).

**Princípio central:** a fonte de verdade das questões é o **banco de dados** (tabela `enem_questions`), **nunca** o modelo de IA.

---

## 2. Entidades e Contexto Técnico

- **Tabela `enem_questions` (Supabase)**
  - Aproximadamente 17.000 questões.
  - Campos relevantes:
    - `id: number`
    - `content: string` – enunciado completo (texto base para indexação).
    - `metadata: jsonb` – objeto `EnemQuestion['metadata']` contendo:
      - `discipline`/`disciplina`
      - `year`
      - `context`
      - `alternativesIntroduction`
      - `alternatives[]` (letra, texto, flag `isCorrect`)
      - `bncc`, `tags`, etc.
    - (Opcional) `embedding` – para busca semântica (pode estar desabilitada).

- **Tipos**
  - `EnemQuestion` (`apps/web/src/types.ts`)
  - `SimulationQuestion` (`apps/web/src/features/SimulationFactory/types/question.types.ts`)

- **Serviços principais**
  - `questionService.ts` (DEPRECATED – apontando para SimulationFactory)
    - `searchQuestions(query, areas?)` – hoje usando busca textual pura em `enem_questions`.
  - **SimulationFactory** (`apps/web/src/features/SimulationFactory/index.ts`)
    - `questionBank` – API pública principal para busca:
      - `search({ query, areas, limit })`
      - `getCacheStats()`
      - `checkHealth()`
      - `isHybridEnabled()`
    - `semanticSearch` – camada opcional (pode estar desligada).
    - `simulationAnalytics` – eventos de busca/uso.
    - `exportSimulationToDocx`, `generateSimulationTitle`, `generateContentSummary`, `shuffleQuestions`.

- **UI principal**
  - `SimulationWorkspace.tsx` (aba de simulados dentro do Planejamento/Workspace):
    - Modo **manual**: busca por texto + filtro de áreas.
    - Modo **espelho**: busca híbrida a partir do planejamento trimestral selecionado.
    - Carrinho de questões (`simCart`) e exportação DOCX.

---

## 3. Fluxos de Usuário – Simulados ENEM/SAEB

### 3.1 Busca Manual (Modo "Busca Manual e BNCC")

**Entrada:**

- Professor digita um texto de busca (`simSearchQuery`), opcionalmente marca áreas:
  - `['Linguagens', 'Matemática', 'Humanas', 'Natureza']`.

**Comportamento esperado:**

1. `handleSimSearch` em `SimulationWorkspace`:
   - Valida que `simSearchQuery` não está em branco.
   - Chama `questionBank.search({ query, areas, limit: 15 })`.
2. `questionBank.search` (via `questionService` e/ou serviços próprios):
   - Usa **sempre** a tabela `enem_questions` como fonte:
     - Busca textual principal em `content` (`ilike '%query%'` com índice apropriado).
     - Pode complementar com busca semântica/híbrida se as embeddings estiverem disponíveis.
   - Aplica filtro client-side por área/disciplina a partir do `AREA_MAP`/`AREA_DISCIPLINE_MAP`.
3. **Resultado:**
   - Lista `simSearchResults` contendo objetos `SimulationQuestion` com:
     - `id`, `metadata.discipline`, `metadata.year`, `metadata.context`, `metadata.alternativesIntroduction`, `metadata.alternatives`.
   - A UI apresenta cartão com ID, disciplina, ano e preview do enunciado.

**Contrato forte:**

- Nenhuma questão exibida pode ser inventada por IA:
  - Toda questão deve ter `id` correspondente em `enem_questions`.
  - `metadata.alternatives` deve refletir as alternativas reais, com apenas **uma** correta marcada (`isCorrect`).

---

### 3.2 Busca Espelhada (Modo "Modo Espelho (Via Plano)")

**Entrada:**

- Professor seleciona um **Planejamento Trimestral** (`selectedTermPlanId`).

**Comportamento esperado:**

1. `handleMirrorSearch` em `SimulationWorkspace`:
   - Valida que existe um plano selecionado (`plan`).
   - Monta uma query rica:
     - `Questões de {plan.subject} sobre {plan.grade} {plan.period}º {plan.regime}. Tópicos: {plan.generatedText.slice(0, 200)}...`
   - Atualiza `simSearchQuery` com esse texto.
   - Usa `hybridSearchProfeplan({ textoBusca, disciplina: plan.subject, limit: 15, matchThreshold: 0.5 })`.
2. `hybridSearchProfeplan` (em `searchService.ts`):
   - Deve sempre priorizar a tabela `enem_questions` e/ou visões/material relacionados às questões cadastradas.
   - Pode usar apenas busca textual (estado atual pós-migração), mas precisa ser consistente com a disciplina passada.
3. **Resultado:**
   - `simSearchResults` preenchido com questões relevantes à disciplina/série/período daquele plano.

**Contrato forte:**

- A disciplina do plano (`plan.subject`) deve ser respeitada na busca:
  - Filtro por disciplina/área precisa garantir que questões de outras áreas não entrem silenciosamente.
  - É proibido usar defaults genéricos do tipo “História” quando o contexto é outra disciplina.

---

### 3.3 Montagem do Simulado (Carrinho)

**Entrada:**

- Professor adiciona questões retornadas à seleção (`simCart`).

**Comportamento esperado:**

1. `handleAddToCart(question)`:
   - Adiciona a questão ao array `simCart` se ainda não houver questão com o mesmo `id`.
2. A lateral direita (“Minha Seleção”) mostra:
   - Lista ordenada (#1, #2, ...) com preview de cada questão selecionada.
3. `handleRemoveFromCart(id)` remove uma questão específica.

**Contrato:**

- O carrinho **não** pode conter duplicatas de `id`.
- O professor deve conseguir ver um preview fiel da questão antes de exportar.

---

### 3.4 Exportação e Registro do Simulado

**Entrada:**

- Professor escolhe uma das ações:
  - `Equilibrar` (análise futura).
  - `Word` (versão única).
  - `Versão A/B` (duas provas embaralhadas).

**Comportamento esperado (ações Word / A/B):**

1. Validação:
   - Se `simCart.length === 0`, exibir alerta claro: “Selecione questões primeiro!”.
2. Geração de metadados:
   - `generateSimulationTitle('Simulado' | 'Simulado_AB')`.
   - `generateContentSummary(simCart)` ou texto descritivo para A/B.
3. Registro em `generated_contents` (via `savePlan`):
   - `type: 'simulado'`
   - `folder: PlanFolder.SIMULADOS`
   - `title`: título gerado.
   - `content`: resumo do simulado (para histórico).
   - `createdAt`: timestamp.
4. Exportação DOCX:
   - `exportSimulationToDocx(simCart, simObservations, 'Versão Única' | 'Versão A'/'Versão B', settings)`:
     - Usa sempre o conteúdo da base (`SimulationQuestion`) para montar o documento.
     - Assegura que o gabarito é consistente com `alternatives[].isCorrect`.
   - Para A/B:
     - Versão A com `simCart` original.
     - Versão B com `shuffleQuestions(simCart)` (ordem embaralhada).

**Contrato forte:**

- O texto da questão e as alternativas no DOCX devem ser **idênticos** às armazenadas em `enem_questions` (salvo formatação).
- A IA não pode “reescrever” enunciados ou alternativas por conta própria.
- O gabarito não pode ser perdido na exportação.

---

## 4. Banco de 17.000 Questões – Disponibilidade e Indexação

Para cumprir o requisito de que o banco de ~17.000 questões esteja **disponível e indexado**:

1. **Fonte de verdade**
   - Tabela `enem_questions` deve conter todas as questões, com:
     - Índices adequados em:
       - `content` (para busca textual).
       - Campos de filtro (ex.: ano, área/disciplina) ou chaves derivadas no `metadata`.

2. **Serviço de busca**
   - `questionBank.search` e `searchQuestions`:
     - Devem usar sempre a tabela `enem_questions`.
     - Buscar prioritariamente em `content` (campo mais denso).
     - Opcional: considerar `metadata->>context` e `metadata->>alternativesIntroduction` como campos auxiliares.

3. **Fallbacks e estados degradados**
   - Se a busca semântica estiver desabilitada (`semanticSearch.checkAvailability() === false`), a aplicação deve:
     - Exibir mensagem indicativa: “Buscando apenas por texto. Banco de questões disponível.”
   - Se a tabela estiver vazia ou inacessível:
     - A UI deve sinalizar explicitamente “banco de questões indisponível ou vazio”.
     - É proibido fingir cobertura total apenas com IA.

4. **Saúde do módulo**
   - `checkSimulationFactoryHealth()` deve ser usado em diagnósticos:
     - `database` (estado do `questionBank`).
     - `semanticSearch.available`.
     - `hybridSearch.enabled`.
     - `cache` (métricas).

---

## 5. Erros, Estados e Mensagens

- **Busca sem query**
  - Não dispara chamada desnecessária – apenas orienta o professor a digitar uma busca.

- **Nenhuma questão encontrada**
  - Mensagem clara: “Nenhuma questão encontrada para estes critérios. Tente ajustar a busca ou as áreas.”.

- **Erro de banco ou rede**
  - Deve ser tratado com:
    - Log técnico em console ou serviço de logging.
    - Mensagem amigável ao professor: “Erro ao buscar questões. Tente novamente mais tarde.”.

- **Falha na exportação DOCX**
  - Informar que o download falhou e sugerir nova tentativa.
  - Nunca apagar o `simCart` por causa de falha de exportação.

---

## 6. Checklist de Validação (para agentes/QA)

Quando o Guardião de Simulados ou QA revisar essa aba, deve checar:

1. **Uso do banco real**
   - [ ] As funções de busca (`questionBank.search`, `searchQuestions`, `hybridSearchProfeplan`) usam sempre a tabela `enem_questions` como fonte de questões.
   - [ ] Não existe nenhum caminho que gere questões “do zero” com IA para compor simulados.

2. **Filtragem por área/disciplina**
   - [ ] O filtro de áreas em `SimulationWorkspace` reflete corretamente `AREA_DISCIPLINE_MAP`/`AREA_MAP`.
   - [ ] Questões retornadas em modo espelho respeitam a disciplina do plano trimestral.

3. **Integridade das questões**
   - [ ] Cada questão tem `id` e `metadata` completos (disciplina, ano, alternativas, gabarito).
   - [ ] Apenas uma alternativa está marcada como correta (`isCorrect`).

4. **Exportação**
   - [ ] Os documentos gerados via `exportSimulationToDocx` batem com o que há em `enem_questions`.
   - [ ] O tipo/registro do simulado é salvo como `type: 'simulado'`, `folder: PlanFolder.SIMULADOS`.

5. **Saúde e Índices**
   - [ ] `checkSimulationFactoryHealth` reporta que o módulo está saudável e que a busca textual está operando sobre o banco real.
   - [ ] Há índices adequados em `enem_questions` para suportar buscas rápidas, mesmo com ~17.000 registros.

