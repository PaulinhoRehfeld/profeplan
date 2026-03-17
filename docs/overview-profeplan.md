# PROFEPLAN – Visão Geral do Produto

## 1. O que é o PROFEPLAN

O PROFEPLAN é um **ecossistema SaaS de Inteligência Artificial voltado para a educação básica**, cujo objetivo central é **eliminar a sobrecarga burocrática dos professores** por meio da geração automatizada de:

- Planos de aula (trimestrais, semanais e diários).
- Avaliações e simulados.
- Adaptações curriculares e **PDIs (Planos de Desenvolvimento Individual)**.

Tudo isso com **alinhamento rigoroso** a:

- **BNCC (Base Nacional Comum Curricular)**.
- **PNLD (Programa Nacional do Livro e do Material Didático)**.

---

## 2. Modelo de negócio e personas

### 2.1. Modelo de negócio

- **B2B2C**:
  - B2B: relacionamento com **escolas** e **secretarias de educação**.
  - B2C (via B2B2C): relacionamento indireto com **professores** e, indiretamente, alunos e famílias.

### 2.2. Estratégia de acesso

- **Bottom-Up (Gratuito)**:
  - Foco em professores individuais (persona “Ana”).
  - Entrega principal: velocidade (planos em menos de 3 minutos) e redução de burnout.

- **Top-Down (Premium B2B)**:
  - Foco em Escolas/Secretarias (persona “Carlos” – gestor).
  - Entrega principal:
    - Gestão centralizada do uso.
    - Padronização curricular.
    - RAG com material didático próprio.
    - Pool de créditos escolar.

---

## 3. Diferenciais tecnológicos (núcleo de arquitetura)

### 3.1. Arquitetura híbrida de IA

- **Geração de texto (core)**:
  - Usa **Azure OpenAI** para:
    - Planos de aula.
    - PDIs.
    - Chat pedagógico.
    - Geração de avaliações.
  - Centralizado em um núcleo de serviços de IA (AiCore / PdiDocumentService e similares).

- **Embeddings e busca vetorial (RAG)**:
  - Usa **Google Gemini** para embeddings.
  - Vetores de **768 dimensões**.
  - Integrado nativamente ao banco de dados **Supabase** com tipo `vector(768)`.

**Regra crítica:** esta divisão é **estrita** para não quebrar o banco de dados.  
Não é permitido trocar o tamanho de dimensão dos vetores ou misturar provedores de embeddings sem revisão arquitetural.

---

### 3.2. Assistente FREEDAY

O PROFEPLAN inclui a **FREEDAY**, um agente conversacional de IA **onipresente** (voz e texto), que atua como:

- **Mentora pedagógica contextual**.
- Interface autônoma para operação do sistema (navegação, salvar, exportar, ler documentos em voz alta).

Características:

- **Interação multimodal**, com foco em voz:
  - Speech-to-Text (STT): captura comandos de voz do professor.
  - Text-to-Speech (TTS): lê em voz alta planos, PDIs, avaliações, etc.
- **Function Calling / Execução de tarefas**:
  - Pode acionar botões, salvar documentos, navegar entre telas.
- **Consciência de contexto**:
  - Sempre recebe o contexto da tela atual (por exemplo: “professor está editando o PDI do aluno Carlos”).

---

## 4. Módulos principais do PROFEPLAN

### 4.1. Módulo 1 – Configurações, Onboarding e Perfil Profissional

Responsável por:

- Bloquear o uso da plataforma até que o **perfil profissional** seja preenchido.
- Coletar:
  - Nome completo.
  - E-mail institucional.
  - Matrícula/MASP.
  - Vínculos com múltiplas escolas/cargos.
- Buscar e vincular escolas por **Código INEP**, com regras estritas para evitar poluição de base.
- Configurar:
  - Preferências de IA (metodologia padrão, estilo pedagógico, foco avaliativo, tom).
  - Personalização dos documentos (logo, cabeçalho e rodapé de PDFs).

### 4.2. Módulo 2 – Minhas Turmas e Gestão de Alunos

Responsável por:

- Criação de turmas via upload de **PDF de relação nominal de alunos** (SIMADE).
- Extração automática de:
  - Código e nome da escola.
  - Código e identificação da turma.
  - Ano letivo, turno e disciplina.
- Cadastro de alunos com:
  - Número de chamada.
  - Código/matrícula.
  - Nome completo.
- Campo **“Observações”** por aluno, que serve como gatilho crítico para o módulo de PDI/inclusão.
- Gestão de portabilidade e histórico de alunos (ao mudar de turma ou ano).

### 4.3. Módulo 3 – Planejamento Trimestral

Responsável por:

- Planejamento macro das aulas em ciclos trimestrais.
- Operado por **arquitetura multi-agentes**:
  - Agente RAG da BNCC.
  - Agente PNLD.
- Garantir:
  - Consulta ESTRITA à BNCC/PNLD (sem alucinar currículos).
  - Ciclos de verificação com feedback do professor (verification loops).

### 4.4. Módulo 4 – Aulas Semanais e Diárias

Responsável por:

- Geração de **planos de aula diários** alinhados ao planejamento trimestral.
- Varredura obrigatória de contexto:
  - Planejamento trimestral completo.
  - Aulas passadas e futuras.
- Estrutura padronizada de saída:
  - Cabeçalho.
  - Habilidades BNCC.
  - Objetivos.
  - Recursos.
  - Desenvolvimento (Introdução, Desenvolvimento, Fechamento).
  - Avaliação diária.

### 4.5. Módulo 5 – Adaptações PDI/DUA

Responsável por:

- Gerar PDIs e adaptações de aula baseadas:
  - No **perfil do aluno** (observações, inclusão).
  - No **plano de aula original**.
  - Em diretrizes de inclusão (RAG).
- Garantir:
  - Filtragem de alunos com observações (lista de elegíveis).
  - Validação de turmas ativas e contexto de aula antes de gerar PDI.
  - Guardrails de ética e privacidade.

### 4.6. Módulo 6 – Simulados ENEM/Saeb

Responsável por:

- Trabalhar sobre um **banco estático de ~17.000 questões**, sem alucinação.
- Modos de busca:
  - Manual (palavras-chave, código BNCC, ano).
  - Modo espelho (via Planejamento Trimestral).
- Pós-processamento:
  - Seleção de questões.
  - Balanceamento estatístico (TRI).
  - Versões A/B (antifraude).

### 4.7. Módulo 7 – Avaliações Contextualizadas

Responsável por:

- Criar provas inéditas a partir do que já foi **realmente ministrado**:
  - Varre Planejamento Trimestral e Planos de Aula.
  - Só cobra o que está documentado.
- Controle granular de dificuldade:
  - N questões fáceis, médias e difíceis.
- Sistema de provas A/B/C com gabarito mestre.

### 4.8. Módulo 8 – Meus Arquivos e Gestão de Documentos

Responsável por:

- Nomenclatura inteligente de documentos (sem “Aula 1” genérico).
- Interface de edição em modo foco (tela cheia).
- Filtros por escola, turma e categoria (Planos, Provas, PDIs).
- Exportação com cabeçalho e logo padronizados.

### 4.9. Módulo 9 – FREEDAY (Agente Autônomo de Voz)

Responsável por:

- Interface global para interação com a IA.
- Comandos de voz para:
  - Navegar entre módulos.
  - Gerar e revisar documentos.
  - Ler planos/PDIs em voz alta.

---

## 5. Objetivo desta documentação

Esta documentação foi criada para:

- Servir de **fonte de verdade** para qualquer agente de código ou desenvolvedor.
- Evitar regressões críticas como:
  - Simplificar demais o modelo de alunos/turmas/PDI.
  - Quebrar os vínculos entre inclusão, observações e PDIs.
  - Alterar guardrails de BNCC/PNLD.
- Dar contexto suficiente para:
  - Evoluir o produto de forma segura.
  - Planejar novas features.
  - Alimentar PRDs “brownfield” (sobre sistema já existente).

Use este arquivo como **porta de entrada**. Para detalhes de arquitetura, fluxos críticos e instruções específicas para agentes/IA, consulte:

- `arquitetura-geral-profeplan.md`
- `modulo-alunos-turmas-pdi.md`
- `fluxos-criticos-e-guardrails.md`
- `guia-para-agentes-e-devs.md`

