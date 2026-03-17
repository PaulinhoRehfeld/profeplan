---
stepsCompleted:
  - step-01-validate-prerequisites
  - step-02-design-epics
  - step-03-create-stories
  - step-02-design-epics
inputDocuments:
  - docs/prd-planejamento-turmas-pdi.md
  - docs/modulo-minhas-turmas-e-alunos.md
  - docs/modulo-pdi-inclusao.md
  - docs/modulo-planejamento.md
  - docs/modulo-alunos-turmas-pdi.md
  - docs/fluxos-criticos-e-guardrails.md
  - docs/index.md
  - docs/overview-profeplan.md
  - docs/arquitetura-geral-profeplan.md
---

# PROFEPLAN - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for PROFEPLAN, decomposing the requirements from the PRD, UX Design if it exists, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: Importação SIMADE confiável  
Deve ser possível importar turmas e alunos a partir de PDF do SIMADE, extraindo e persistindo para cada aluno, sempre que disponível, o `student_code` (código oficial) e o `call_number` (número de chamada), garantindo que a turma e seus alunos sejam criados corretamente no banco.

FR2: Gestão de Turmas & Alunos  
O sistema deve listar turmas do professor/gestor e, para cada turma, exibir alunos com: nome, número de chamada, código do aluno e indicadores de inclusão (badge / `needs_adaptation`), servindo de centro de verdade operacional.

FR3: Planejamento Trimestral  
Deve ser possível criar e editar planejamentos trimestrais (`TermPlan`) por disciplina/série/período, gerando um conjunto coerente de aulas (`lessons`) com objetivos, BNCC válidas e texto de planejamento.

FR4: PDI por aluno/ano  
Para cada par (`student_id`, `year`), o sistema deve criar/obter um único PDI em andamento (`status='em_andamento'`), permitir registrar adaptações de aula (Bloco 9) e avaliações/registros (Bloco 10/final), mantendo histórico.

FR5: Integração Planejamento ↔ PDI  
Para alunos com PDI ativo, o sistema deve oferecer caminho direto para gerar adaptação de aula (PDI) a partir de um planejamento/lesson recém-salvo, garantindo que o conteúdo da aula seja insumo obrigatório do PDI.

### NonFunctional Requirements

NFR1: Anti-alucinação BNCC/PNLD  
Planejamento e PDI não podem inventar códigos de habilidades; devem usar RAG sobre bases oficiais de BNCC/PNLD.

NFR2: Ética e privacidade no PDI  
A IA não pode inventar diagnósticos; deve se limitar a necessidades/descrições já registradas, e a saída não deve expor laudos clínicos de forma direta ou estigmatizante.

NFR3: Rastreabilidade  
Toda adaptação de aula/PDI deve apontar de forma rastreável para: aluno (`student_id`), documento de PDI (`pdi_document_id`) e aula/planejamento de origem (`lesson_id` ou equivalente).

NFR4: Integridade de dados de aluno  
`student_code` e `call_number` nunca devem ser sobrescritos silenciosamente por valores vazios ou inconsistentes ao longo dos fluxos de importação e edição.

### Additional Requirements

- A1 – Cadeia relacional obrigatória  
  A modelagem e os fluxos devem preservar a cadeia `Escola → Professor → Turma → Aluno → PDI`, permitindo sempre navegar do PDI até aluno/turma/escola, sem “achatar” o modelo.

- A2 – Aluno não pode ser só “nome em lista”  
  A entidade `students` deve manter perfil inclusivo e observações pedagógicas acessíveis; qualquer fluxo de PDI precisa consumir `needs_adaptation`, `deficiencies`, `observations` (snapshot de inclusão).

- A3 – Campo Observações como gatilho de PDI  
  Na UI de turmas, o campo “Observações” deve existir para cada aluno. Se vazio, o aluno não aparece na lista de elegíveis para PDI por inclusão. Se preenchido, o aluno é vinculado ao módulo de PDI e sinalizado na UI (badge/ícone/status).

- A4 – Portabilidade de histórico do aluno  
  Ao mudar de turma/ano, devem migrar juntos: código de matrícula (`student_code`), observações/perfil inclusivo e histórico de `pdi_documents`, garantindo continuidade do acompanhamento.

- A5 – FK e chave lógica de PDI  
  `pdi_documents.student_id` deve referenciar `students(id)` com `ON DELETE CASCADE`, e a chave lógica do PDI é (`student_id`, `year`, `status='em_andamento'`), evitando múltiplos PDIs abertos por ano/aluno sem regra explícita.

- A6 – Uso obrigatório de BNCC/PNLD reais no planejamento  
  `AiPlanningService` e fluxos de planejamento devem sempre usar BNCC/PNLD reais via RAG, não prompts genéricos; é proibido substituir a arquitetura multi-agentes por um único prompt genérico sem RAG.

- A7 – Vínculo forte TermPlan ↔ Lessons ↔ Turmas ↔ PDI  
  Planejamentos trimestrais, lessons e PDIs precisam manter vínculos claros entre si (TermPlan → lessons → turmas → PDI/adaptações), para que relatórios e fluxos de avaliação possam confiar nesses encadeamentos.

- A8 – Ética na saída de PDI  
  Mesmo que o perfil do aluno contenha laudos, o texto gerado não deve nomear diagnósticos; deve usar descrições funcionais do tipo “dificuldade de concentração sustentada”, “beneficia-se de instruções visuais…”.

### FR Coverage Map

### FR Coverage Map

FR1: Epic 1 - Importação confiável de turmas e alunos via SIMADE, com `student_code` e `call_number` corretamente persistidos.
FR2: Epic 2 - Gestão operacional de turmas e alunos como centro de verdade, com códigos, números de chamada e indicadores de inclusão.
FR3: Epic 3 - Planejamento trimestral estruturado e alinhado à BNCC/PNLD, gerando aulas coerentes.
FR4: Epic 4 - Gestão de PDI por aluno/ano com documento único em andamento e histórico preservado.
FR5: Epic 4 - Integração entre planejamento/aulas e geração de adaptações PDI a partir das lessons.

## Epic List

### Epic 1: Importação Confiável de Turmas e Alunos via SIMADE
Professores e gestores conseguem importar turmas e listas de alunos a partir do PDF SIMADE, com número de chamada e código oficial corretos, sem retrabalho manual.
**FRs covered:** FR1, parte de FR2

### Epic 2: Minhas Turmas & Gestão Operacional de Alunos
Professores visualizam e gerenciam suas turmas, enxergando claramente os alunos, seus códigos, números de chamada e indicadores de inclusão, usando esse módulo como “centro de verdade” do dia a dia.
**FRs covered:** restante de FR2

### Epic 3: Planejamento Trimestral Alinhado à BNCC/PNLD
Professores conseguem criar planejamentos trimestrais estruturados por disciplina/série/período, com conjunto coerente de aulas (`lessons`) alinhadas à BNCC/PNLD, prontos para uso em sala.
**FRs covered:** FR3

### Epic 4: PDI por Aluno/Ano e Adaptações a partir do Planejamento
Professores de turma e inclusão gerenciam PDIs por aluno/ano, gerando adaptações de aula baseadas no planejamento, com rastreabilidade completa e respeito à ética e privacidade.
**FRs covered:** FR4, FR5

## Epic 1: Importação Confiável de Turmas e Alunos via SIMADE

### Story 1.1: Upload de PDF SIMADE e Pré-visualização da Turma

As a professor ou gestor,
I want enviar um PDF SIMADE e visualizar a turma e a lista de alunos extraída pela IA,
So that eu possa conferir se os dados importados (turma e alunos) estão corretos antes de salvar.

**Acceptance Criteria:**

**Given** que estou autenticado e acesso o fluxo de importação de turmas  
**When** seleciono um arquivo PDF SIMADE válido e confirmo o upload  
**Then** o sistema deve exibir uma pré-visualização com os metadados da turma (nome/código, ano, turno, disciplina) e a lista de alunos extraída.

**Given** que o PDF contém linhas no padrão SIMADE com número, código e nome do aluno  
**When** a IA e o pós-processamento terminam o parsing  
**Then** cada linha deve ser apresentada como objeto de aluno contendo, quando disponível, `call_number`, `student_code` e `name`, com indicação clara de eventuais campos ausentes.

### Story 1.2: Salvamento de Turma e Alunos com student_code e call_number

As a professor ou gestor,
I want salvar a turma e os alunos confirmados da pré-visualização no banco,
So that eu possa reutilizar essas informações em outros módulos (planejamento, PDI, avaliações).

**Acceptance Criteria:**

**Given** que revisei a pré-visualização da turma e dos alunos  
**When** aciono o comando de “Salvar turma e alunos”  
**Then** o sistema deve criar um registro em `classes` e inserir registros em `students` vinculados à turma, persistindo `student_code` e `call_number` para todos os alunos em que esses dados existirem no PDF.

**Given** que a gravação em banco foi concluída com sucesso  
**When** eu abro a tela “Minhas Turmas”  
**Then** a nova turma deve aparecer na lista e, ao entrar em seus detalhes, os alunos devem estar disponíveis com os mesmos `student_code` e `call_number` exibidos na pré-visualização.

### Story 1.3: Tratamento de Erros e Linhas Inválidas na Importação SIMADE

As a professor ou gestor,
I want ser avisado quando o PDF SIMADE tiver linhas inválidas ou parcialmente legíveis,
So that eu possa decidir se corrijo manualmente ou sigo com a importação sabendo dos riscos.

**Acceptance Criteria:**

**Given** que o parser encontre linhas que não se encaixam no padrão esperado ou não consiga extrair `student_code` e `call_number`  
**When** a pré-visualização é exibida  
**Then** o sistema deve listar os alunos afetados com um rótulo de aviso (ex.: “dados incompletos”) e não deve preencher `student_code`/`call_number` com valores inventados.

**Given** que existam erros de leitura ou inconsistências graves no PDF  
**When** o usuário tenta avançar para o salvamento  
**Then** o sistema deve exibir um resumo dos problemas encontrados e solicitar confirmação explícita antes de permitir o salvamento definitivo da turma e alunos.

## Epic 2: Minhas Turmas & Gestão Operacional de Alunos

### Story 2.1: Listagem de Turmas do Professor/Gestor

As a professor ou gestor,
I want ver uma lista de todas as minhas turmas cadastradas,
So that eu possa acessar rapidamente os detalhes de cada turma para operar meu dia a dia.

**Acceptance Criteria:**

**Given** que existam turmas associadas ao meu usuário  
**When** acesso a tela “Minhas Turmas”  
**Then** devo ver uma tabela/cartões com pelo menos nome da turma, ano letivo, turno e contagem de alunos.

**Given** que clico em uma turma da lista  
**When** a navegação é concluída  
**Then** devo ser levado à tela de detalhes da turma com a lista de alunos correspondente.

### Story 2.2: Visualizar Alunos de uma Turma com Código, Número de Chamada e Inclusão

As a professor,
I want ver os alunos de uma turma com número de chamada, código oficial e indicadores de inclusão,
So that eu possa organizar a chamada, identificar rapidamente os alunos e saber quem precisa de PDI.

**Acceptance Criteria:**

**Given** que estou na tela de detalhes de uma turma com alunos cadastrados  
**When** a lista de alunos é carregada  
**Then** cada linha deve exibir pelo menos `name`, `call_number`, `student_code` (ou identificador equivalente) e um indicador visual quando `needs_adaptation` ou observações estiverem presentes.

**Given** que um aluno possui `needs_adaptation = true` ou observações preenchidas  
**When** a lista é renderizada  
**Then** esse aluno deve aparecer com um badge/ícone indicando elegibilidade para PDI, alinhado aos guardrails de inclusão.

### Story 2.3: Edição de Observações e Dados Básicos do Aluno

As a professor,
I want editar observações e alguns dados básicos de alunos diretamente pela tela da turma,
So that eu possa manter atualizados os registros que alimentam o PDI e outros módulos.

**Acceptance Criteria:**

**Given** que estou na lista de alunos de uma turma  
**When** aciono a edição de um aluno  
**Then** devo conseguir alterar, no mínimo, o campo de observações pedagógicas e, quando permitido pelas regras de negócio, campos básicos como nome, respeitando integridade de `student_code` e `call_number`.

**Given** que salvo as alterações em observações  
**When** volto a abrir a tela ou consulto o snapshot de inclusão do aluno em outro módulo  
**Then** as novas observações devem estar disponíveis e ser utilizadas como contexto para PDI/adaptações.

### Story 2.4: Portabilidade de Aluno entre Turmas com Preservação de Histórico

As a gestor ou professor,
I want mover um aluno de uma turma para outra mantendo histórico e dados de inclusão,
So that a continuidade pedagógica e o histórico de PDI não sejam perdidos na troca de turma/ano.

**Acceptance Criteria:**

**Given** que preciso transferir um aluno para outra turma do novo ano letivo  
**When** executo o fluxo de transferência de aluno  
**Then** o sistema deve associar o aluno à nova turma sem apagar `student_code`, observações, perfil de inclusão ou histórico de PDIs anteriores.

**Given** que o aluno foi transferido com sucesso  
**When** o novo professor acessa “Minhas Turmas” e abre a turma de destino  
**Then** o aluno deve aparecer na lista com seus dados completos e indicadores de histórico de inclusão/PDI disponíveis para consulta.

## Epic 3: Planejamento Trimestral Alinhado à BNCC/PNLD

### Story 3.1: Criação de um Novo Planejamento Trimestral (TermPlan)

As a professor,
I want criar um planejamento trimestral informando disciplina, série, período e parâmetros pedagógicos,
So that eu tenha uma estrutura macro organizada para o trimestre letivo.

**Acceptance Criteria:**

**Given** que acesso a área de Planejamento Trimestral  
**When** preencho os campos obrigatórios (disciplina, série/ano, período, carga horária semanal, etc.) e aciono “Criar planejamento”  
**Then** o sistema deve criar um registro de `TermPlan` persistido com esses metadados e estado inicial adequado.

**Given** que já existe um `TermPlan` para a combinação de disciplina/série/período  
**When** tento criar outro planejamento igual  
**Then** o sistema deve ou bloquear a duplicação ou pedir confirmação explícita, conforme regra de negócio definida, evitando múltiplos planejamentos conflitantes.

### Story 3.2: Geração de Conteúdo de Planejamento com BNCC/PNLD via IA

As a professor,
I want gerar o texto do planejamento trimestral e uma proposta inicial de lessons usando BNCC/PNLD reais,
So that eu tenha um ponto de partida consistente e alinhado às diretrizes oficiais.

**Acceptance Criteria:**

**Given** que tenho um `TermPlan` criado e com parâmetros completos  
**When** aciono a geração automática de planejamento  
**Then** o sistema deve chamar os serviços de IA configurados utilizando RAG sobre BNCC/PNLD e retornar um texto de planejamento (`generatedText`) sem inventar códigos de habilidades.

**Given** que a geração automática foi concluída  
**When** reviso o planejamento na UI  
**Then** devo ver uma proposta de sequência de aulas (`lessons`) contendo ao menos títulos, objetivos e códigos BNCC válidos, associados ao `TermPlan`.

### Story 3.3: Persistência de Lessons Vinculadas ao TermPlan e à Turma

As a professor,
I want salvar as aulas geradas/ajustadas como `lessons` vinculadas ao planejamento e, quando aplicável, a uma turma,
So that eu possa reutilizar essas aulas em PDI, avaliações e histórico pedagógico.

**Acceptance Criteria:**

**Given** que revisei a lista de lessons geradas a partir de um `TermPlan`  
**When** salvo o planejamento  
**Then** cada lesson deve ser persistida em `lessons` com vínculo claro ao `term_plan_id` e, quando houver seleção de turma, ao `class_id`, mantendo dados como objetivos, descrição e códigos BNCC.

**Given** que o salvamento foi concluído  
**When** acesso novamente o planejamento ou telas que consomem lessons (ex.: seleção de aula para PDI)  
**Then** as mesmas lessons devem estar disponíveis, sem perda de vínculo com o `TermPlan` ou com a turma associada.

### Story 3.4: Visualização e Edição de Lessons do Planejamento

As a professor,
I want visualizar e editar as aulas do meu planejamento trimestral,
So that eu possa ajustar títulos, objetivos e conteúdos às necessidades reais da turma.

**Acceptance Criteria:**

**Given** que tenho um `TermPlan` com lessons persistidas  
**When** abro a tela de edição de planejamento  
**Then** devo ver a sequência de lessons com possibilidade de visualizar detalhes de cada aula.

**Given** que edito campos permitidos de uma lesson (ex.: título, objetivos, descrição)  
**When** salvo as alterações  
**Then** as mudanças devem ser refletidas tanto na listagem de lessons quanto em qualquer fluxo que utilize essa aula (ex.: seleção de aula para gerar PDI).

## Epic 4: PDI por Aluno/Ano e Adaptações a partir do Planejamento

### Story 4.1: Criar ou Obter PDI Único por Student/Year

As a professor ou professor de inclusão,
I want abrir o PDI de um aluno em um determinado ano letivo, criando-o se ainda não existir,
So that eu possa centralizar todas as adaptações e registros daquele aluno em um único documento por ano.

**Acceptance Criteria:**

**Given** que seleciono um aluno e informo o ano letivo em uma tela de PDI  
**When** aciono a opção de “Abrir PDI”  
**Then** o sistema deve buscar em `pdi_documents` um registro com `student_id`, `year` e `status='em_andamento'` e retorná-lo se existir, ou criar um novo com essa combinação caso não exista.

**Given** que já existe um PDI `em_andamento` para o par (`student_id`, `year`)  
**When** tento criar outro PDI para o mesmo aluno e ano  
**Then** o sistema não deve criar um segundo documento em andamento para essa combinação, mas sim reutilizar o existente ou exigir uma ação explícita de arquivamento/fechamento antes de um novo.

### Story 4.2: Gerar Adaptação de Aula a partir de Lesson e Snapshot de Inclusão

As a professor,
I want gerar uma adaptação de aula para um aluno elegível usando a lesson planejada e o snapshot de inclusão,
So that o PDI reflita estratégias pedagógicas personalizadas e alinhadas às necessidades do aluno.

**Acceptance Criteria:**

**Given** que existe um `TermPlan` com lessons e um PDI `em_andamento` para o aluno  
**When** seleciono uma lesson e aciono “Gerar adaptação PDI para esta aula”  
**Then** o sistema deve montar um snapshot de inclusão a partir de `students` (incluindo `needs_adaptation`, `deficiencies`, `observations`) e enviar junto com o conteúdo da lesson para o serviço de IA de PDI.

**Given** que a IA retorna o texto de adaptação  
**When** visualizo o PDI do aluno  
**Then** a nova adaptação deve ser registrada na seção/bloco apropriado do PDI, vinculada à aula de origem e escrita em linguagem pedagógica, sem inventar diagnósticos clínicos.

### Story 4.3: Persistência e Histórico de Conteúdo do PDI

As a professor de inclusão,
I want salvar e revisar as adaptações e registros do PDI ao longo do ano,
So that eu tenha histórico completo das intervenções realizadas com o aluno.

**Acceptance Criteria:**

**Given** que edito ou acrescento conteúdo em seções do PDI (incluindo adaptações geradas por IA e registros manuais)  
**When** salvo o documento  
**Then** o sistema deve atualizar `pdi_documents.content` preservando entradas anteriores e metadados de criação/atualização.

**Given** que o ano letivo avança ou preciso consultar o histórico  
**When** acesso a área de PDIs do aluno  
**Then** devo conseguir visualizar PDIs de anos anteriores como documentos arquivados, sem perder o vínculo com o aluno e com as turmas em que foram gerados.

### Story 4.4: Lista de Alunos Elegíveis e Acesso ao PDI a partir de Turmas/Planejamento

As a professor,
I want ver rapidamente quais alunos de uma turma são elegíveis para PDI e acessar seu PDI a partir da turma ou do planejamento,
So that eu possa iniciar/adaptar PDIs sem navegar por muitos menus.

**Acceptance Criteria:**

**Given** que estou na tela de alunos de uma turma  
**When** filtro ou visualizo alunos com `needs_adaptation = true` ou observações preenchidas  
**Then** o sistema deve apresentar esses alunos como elegíveis para PDI, alinhado ao guardrail de que alunos sem observações não aparecem nessa lista.

**Given** que seleciono um desses alunos elegíveis a partir da turma ou de uma lesson no planejamento  
**When** aciono a opção de “Abrir PDI” ou “Gerar adaptação PDI”  
**Then** o sistema deve me levar diretamente ao fluxo de PDI correspondente (Story 4.1/4.2), sem exigir que eu navegue manualmente por outras telas intermediárias.


