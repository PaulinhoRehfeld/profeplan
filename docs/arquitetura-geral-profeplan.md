# Arquitetura Geral do PROFEPLAN

## 1. Visão macro da arquitetura

O PROFEPLAN é um sistema SaaS modular que combina:

- **Frontend web** para professores, escolas e secretarias.
- **Backend de serviços de negócio e IA**.
- **Banco de dados relacional (Supabase/Postgres)** com extensão vetorial.
- **Serviços de IA externos**:
  - Azure OpenAI (geração de texto).
  - Google Gemini (embeddings).

O sistema é organizado em módulos alinhados aos fluxos pedagógicos (onboarding, turmas, planejamento, aulas, PDI, avaliações, simulados, arquivos e FREEDAY).

---

## 2. Componentes principais

### 2.1. Frontend

Responsável por:

- Interface para professores:
  - Onboarding e perfil profissional.
  - Criação e gestão de turmas e alunos.
  - Geração e edição de planos e PDIs.
  - Criação e uso de avaliações e simulados.
- Interface para gestores:
  - Painéis de uso.
  - Gestão de créditos.
  - Gestão de escolas e secretarias.
- Componente global da FREEDAY:
  - Botão fixo em todas as telas.
  - Caixa de diálogo/chat.

Pontos de atenção arquitetural:

- A UI deve sempre refletir estados críticos como:
  - “Onboarding pendente”.
  - “PDI pendente para aluno com observações”.
  - “Plano em rascunho / aguardando revisão”.

---

### 2.2. Backend de negócio

Responsável por:

- Regras de negócio e orquestração dos módulos:
  - Onboarding (bloqueio de acesso até perfil preenchido).
  - Minhas turmas e alunos (incluindo campo de observações).
  - Planejamento trimestral.
  - Planos diários.
  - PDI/DUA.
  - Simulados e avaliações.
  - Meus arquivos.
  - Integração com FREEDAY.
- Exposição de APIs para o frontend.
- Integração com bancos externos (ex.: bases de escolas/INEP, SIMADE PDF).

Este backend é também a camada que:

- Faz controle de acesso.
- Garante integridade das relações Escola ↔ Professor ↔ Turma ↔ Aluno ↔ PDI.
- Constrói prompts para os serviços de IA, aplicando guardrails e políticas.

---

### 2.3. Núcleo de IA (AiCore)

Responsável por:

- Unificar chamadas à **Azure OpenAI** e à **camada de RAG com Gemini**.
- Implementar serviços como:
  - `LessonPlanService` / equivalente.
  - `PdiDocumentService` / equivalente.
  - Serviços para avaliações e simulados.
- Aplicar políticas de:
  - Não-alucinação de BNCC/PNLD.
  - Consulta obrigatória à base vetorial.
  - Proteção de privacidade no conteúdo gerado.

Divisão crítica:

- **Azure OpenAI**:
  - Trabalha com prompts estruturados.
  - Responsável pela geração textual final.

- **Gemini + Supabase (vector(768))**:
  - Responsável por:
    - Indexação de documentos BNCC/PNLD.
    - Busca e recuperação de contexto.
    - Apoio às decisões da IA (RAG).

---

### 2.4. Banco de dados (Supabase/Postgres)

Responsável por:

- Modelagem das entidades centrais:
  - Usuários (professores, gestores).
  - Escolas.
  - Turmas.
  - Alunos.
  - PDIs.
  - Planos de aula.
  - Planejamentos trimestrais.
  - Avaliações e simulados.
  - Arquivos/documentos.
- Armazenar embeddings vetoriais com:
  - Tipo `vector(768)` para compatibilidade com Gemini.

Regras de integridade destacadas:

- Cadeia **Escola ↔ Professor ↔ Turma ↔ Aluno ↔ PDI** é obrigatória.
- Histórico de PDIs e planos não deve ser apagado em refatorações normais.

---

## 3. Fluxos críticos de dados

### 3.1. Onboarding e Perfil Profissional

Fluxo:

1. Usuário recém-registrado faz login.
2. Backend verifica se o perfil está completo.
3. Se incompleto:
   - Bloqueia acesso a outros módulos.
   - Força abertura do modal de “Configurações > Perfil e Preferências”.
4. Após salvar o perfil:
   - Libera acesso ao restante da plataforma.

Dependências:

- Banco de escolas com **Código INEP**.
- Regras para não poluir essa base com variações digitadas.

---

### 3.2. Importação de turmas (PDF SIMADE)

Fluxo:

1. Professor ou gestor faz upload do PDF de relação nominal de alunos.
2. Motor de extração:
   - Identifica escola e turma (código + nome).
   - Extrai:
     - Ano letivo.
     - Turno.
     - Disciplina.
   - Cadastra alunos com:
     - Número de chamada.
     - Código de matrícula.
     - Nome completo.
3. Registra turmas e alunos nas tabelas correspondentes.

Dependências:

- Mapeamento correto de campos do PDF → schema de `classes` e `students`.

---

### 3.3. Planejamento trimestral e aulas diárias

Fluxo macro:

1. Professor define parâmetros e contexto para o **planejamento trimestral**.
2. Arquitetura multi-agentes:
   - Usa RAG na BNCC/PNLD para montar o planejamento.
   - Garante fidelidade documental (sem inventar códigos).
3. Para cada aula diária:
   - Agente varre todo o planejamento trimestral.
   - Considera aulas passadas e futuras.
   - Gera plano diário padronizado.

Dependências:

- Indexação correta da BNCC e PNLD.
- Estrutura consistente de planos e seus vínculos com turmas/disciplinas.

---

### 3.4. PDI/DUA e adaptações

Este fluxo é detalhado em `modulo-alunos-turmas-pdi.md`, mas em alto nível:

1. A UI filtra alunos com observações para exibir lista de elegíveis para PDI.
2. Professor seleciona:
   - Aluno.
   - Turma.
   - Plano/aula a ser adaptado.
3. Backend:
   - Carrega perfil completo do aluno (incluindo inclusão e observações).
   - Carrega plano original.
   - Envia tudo para o núcleo de IA (Azure OpenAI + RAG).
4. Núcleo de IA:
   - Lê perfil do aluno.
   - Lê plano original.
   - Busca diretrizes de inclusão em RAG.
   - Gera PDI/adaptação.
5. Backend:
   - Salva PDI em `pdi_documents`.
   - Garante vínculos com aluno e turma.

---

### 3.5. Simulados e avaliações

Simulados (ENEM/Saeb):

- Usam banco estático de questões (sem alucinar).
- Podem ser filtrados e combinados em avaliações.

Avaliações contextualizadas:

- Dependem de:
  - Planejamento trimestral.
  - Planos diários ministrados.
- Regra: não cobrar conteúdo que não foi registrado nos planos.

---

## 4. Guardrails arquiteturais

Alguns pontos que **não podem ser quebrados** sem análise arquitetural deliberada:

1. **Separação entre geração de texto e embeddings**  
   - Azure OpenAI ≠ Gemini.  
   - Embeddings **devem** permanecer com dimensão 768 para compatibilidade com Supabase.

2. **Cadeia de dados educacionais**  
   - Escola ↔ Professor ↔ Turma ↔ Aluno ↔ PDI deve continuar representável no banco.

3. **Não-alucinação de currículos (BNCC/PNLD)**  
   - Qualquer módulo que envolva currículo precisa consultar as bases oficiais via RAG.

4. **Persistência de histórico pedagógico**  
   - Planos, PDIs e avaliações devem permitir rastreabilidade histórica.

5. **FREEDAY sempre contextualizada**  
   - A arquitetura deve garantir que o agente de voz receba o contexto da tela atual.

---

## 5. Uso desta arquitetura por agentes de IA

Agentes de código e de planejamento devem:

- Ler primeiro:
  - `overview-profeplan.md`
  - Este arquivo (`arquitetura-geral-profeplan.md`)
- Depois, para alterações em:
  - Turmas, alunos e PDI → `modulo-alunos-turmas-pdi.md`
  - Regras rígidas de negócio → `fluxos-criticos-e-guardrails.md`
  - Boas práticas de edição por IA → `guia-para-agentes-e-devs.md`

Antes de propor mudanças grandes em arquitetura, o agente deve:

- Explicitar:
  - O que será mudado.
  - Quais guardrails podem ser afetados.
  - Como preservar compatibilidade com dados e fluxos existentes.

