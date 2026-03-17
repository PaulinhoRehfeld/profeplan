# Fluxos Críticos e Guardrails do PROFEPLAN

Este documento consolida **regras inegociáveis** de negócio e arquitetura.  
Ele serve como **cinturão de segurança** contra refatorações perigosas (por humanos ou por agentes de IA).

---

## 1. Princípios gerais

- **Fidelidade documental**:
  - Sempre que envolver BNCC e PNLD, o sistema está **proibido** de inventar currículos, códigos de habilidades ou referências.
- **Educação inclusiva como primeira classe**:
  - Alunos com necessidades específicas não podem ser “apagados” por simplificações de modelo.
- **Rastreabilidade total**:
  - Documentos (planos, PDIs, avaliações) precisam manter vínculos fortes com:
    - Alunos.
    - Turmas.
    - Planejamentos.
    - Escolas.

---

## 2. Guardrails por módulo

### 2.1. Módulo 1 – Configurações, Onboarding e Perfil Profissional

**Fluxo crítico: onboarding obrigatório**

- Se o usuário recém-registrado:
  - Tiver perfil vazio ou incompleto → o sistema **deve bloquear** o uso normal.
- A plataforma deve:
  - Redirecionar automaticamente para o modal de “Configurações > Perfil e Preferências”.
  - Impedir geração de planos/PDIs/avaliações até o salvamento inicial das configurações.

**Regras de negócio do INEP (críticas):**

- Campo “Nome da Escola”:
  - Deve realizar **autocompletar inteligente** com base em banco pré-cadastrado.
  - Ao selecionar a escola da lista:
    - Sistema preenche “Cidade” e “Código INEP”.
- Fallback manual:
  - Se o professor digitar um nome que não existe na base, ele pode manter o texto digitado.
  - **Mas**:
    - O “Código INEP” deve permanecer `null`.
    - O sistema **não deve** salvar essa nova escola na tabela global.
    - O nome deve ficar **apenas no escopo do perfil do professor**.

> Guardrail: é proibido alterar essa lógica para “aprender” automaticamente novas escolas a partir de qualquer digitação, para não poluir a base central.

---

### 2.2. Módulo 2 – Minhas Turmas e Gestão de Alunos

**Fluxo crítico: importação via PDF SIMADE**

- O motor de extração deve, obrigatoriamente:
  - Identificar:
    - Código e nome da escola.
    - Código e identificação da turma.
    - Ano letivo, turno e disciplina.
  - Extrair lista de alunos separando em:
    - Número de chamada.
    - Código/matrícula do aluno.
    - Nome completo.

**Campo “Observações” (gatilho de inclusão e PDI):**

- Deve existir ao lado do nome de **cada aluno**.
- Regra:
  - Se “Observações” estiver preenchido:
    - O aluno deve ser vinculado ao módulo de PDI.
    - A UI deve sinalizar (badge, ícone, status).
  - Se “Observações” estiver vazio:
    - O aluno não deve aparecer na lista de elegíveis para PDI por inclusão.

> Guardrail: é proibido remover ou ocultar este campo em nome de “simplificação de tela”.

**Portabilidade de histórico:**

- Ao transferir o aluno de turma ou ao avançar de ano:
  - Devem ser mantidos:
    - Código de matrícula.
    - Observações.
    - Histórico de PDIs.

> Guardrail: qualquer migração ou refatoração que “zera” histórico ao mudar de turma é regressão grave.

---

### 2.3. Módulo 3 – Planejamento Trimestral e Arquitetura Multi-Agentes

**Fidelidade à BNCC/PNLD:**

- O agente responsável pelo planejamento está:
  - **Proibido** de inventar códigos de habilidades ou competências.
  - Obrigado a usar RAG com os documentos oficiais na base.

**Arquitetura multi-agentes:**

- Agentes especializados:
  - Agente RAG da BNCC.
  - Agente PNLD.
- Eles podem operar em loops até que o planejamento atenda:
  - Parâmetros informados pelo professor.
  - Regras de completude e coerência de conteúdo.

> Guardrail: qualquer mudança que substitua esse modelo por “um único prompt genérico” é considerada perda arquitetural.

---

### 2.4. Módulo 4 – Aulas Semanais e Diárias

**Regra de ouro: varredura de contexto**

- Antes de gerar qualquer aula:
  - O agente deve varrer todo o planejamento trimestral.
  - Não pode olhar apenas o “título da aula atual”.
  - Deve considerar aulas anteriores e futuras para:
    - Continuidade de conteúdo.
    - Coerência entre atividades e avaliações.

**Alinhamento BNCC/PNLD:**

- Se alinhamento com BNCC estiver ativado:
  - O agente deve buscar as **competências e habilidades reais**, sem inventar.
- Se o professor ativar “Utilizar Livro PNLD”:
  - Com livro na base:
    - O plano deve referenciar capítulos e páginas exatas.
  - Sem livro na base:
    - A IA usa temporariamente a BNCC.
    - Dispara um “robô de busca” para tentar localizar e indexar o livro futuramente.

> Guardrail: é proibido remover a verificação da BNCC/PNLD para “ganhar desempenho” ou simplificar prompts.

---

### 2.5. Módulo 5 – Adaptações PDI/DUA

**Dependência estrutural crítica:**

Para carregar o PDI, o sistema deve validar:

1. Turmas ativas.
2. Filtro de inclusão (lista apenas alunos com “Observações”).
3. Seletor de contexto (qual plano/aula será adaptado).

**Agente especialista em DUA – tripla varredura:**

- Leitura do perfil do aluno (observações).
- Leitura do plano de aula original.
- Busca na base RAG por diretrizes de inclusão.
- Ação: cruzar as três fontes para gerar a estratégia.

**Ética e privacidade:**

- Os documentos não devem expor laudo clínico no título ou corpo.
- Foco em descrever necessidades pedagógicas, não rótulos médicos.

> Guardrail: qualquer alteração que faça o PDI ignorar o perfil do aluno ou duplicar termos clínicos diretamente na saída é inaceitável.

---

### 2.6. Módulo 6 – Simulados ENEM/Saeb

**Banco de 17.000 questões estático:**

- Nesse módulo, a IA atua como uma **bibliotecária**, não como geradora.
- É estritamente proibido:
  - Inventar questões.
  - Alterar o enunciado das questões oficiais.

**Modos de busca:**

- Manual (por palavra-chave, código BNCC, ano).
- Modo espelho:
  - Varre o planejamento trimestral.
  - Só seleciona questões que cobram habilidades já ensinadas.

> Guardrail: qualquer feature que permita “editar automaticamente” questões de banco oficial deve ser tratada com extrema cautela ou bloqueada.

---

### 2.7. Módulo 7 – Avaliações Contextualizadas

**Fonte da verdade:**

- As avaliações inéditas:
  - Não podem ser baseadas em conhecimento genérico solto.
  - Devem se basear:
    - No planejamento trimestral.
    - Nos planos de aula ministrados.

**Controle de dificuldade:**

- O professor define:
  - Número de questões fáceis.
  - Número de questões médias.
  - Número de questões difíceis.

**Balanceamento de gabarito:**

- Regra do 2:
  - Nenhuma alternativa correta pode ter predominância superior a 2 questões a mais que as demais.

> Guardrail: remover esse balanceamento gera avaliações enviesadas e é regressão de qualidade.

---

### 2.8. Módulo 8 – Meus Arquivos

**Nomenclatura obrigatória:**

- Sistema proibido de salvar documentos com nomes genéricos:
  - Exemplo proibido: “Aula 1”.
- Fórmula:
  - `[Tipo do Documento] [Número/Referência] - [Tema Específico] - [Disciplina]`
  - Ex.: `Aula 04 - Revolução Francesa - História`.

**Modo foco de edição:**

- Ao clicar em “Editar”:
  - Painéis paralelos são ocultados.
  - O professor vê o documento em modo folha de papel (tela cheia).

> Guardrail: é proibido “otimizar” a UX removendo o modo foco de edição.

---

### 2.9. Módulo 9 – FREEDAY

**Omnipresença na interface:**

- Botão de acionamento fixo em todas as abas e módulos.
- Nunca deve ser tratado como apenas “mais uma página de chat”.

**Capacidades principais:**

- Navegar entre telas:
  - “Abra minhas turmas”.
  - “Abra o PDI do aluno X”.
- Ações de sistema:
  - “Salve este documento”.
  - “Exporte para PDF”.
- Leitura em voz alta:
  - “FREEDAY, leia este plano de aula para mim”.

**Context awareness:**

- Sempre que acionada, a FREEDAY deve receber o contexto da tela atual.

> Guardrail: remover a injeção de contexto transforma a FREEDAY em um chat genérico e quebra a proposta do produto.

---

## 3. Guardrails globais sobre dados e IA

1. **Nenhum agente pode “achatar” o modelo de alunos/turmas/PDI.**
2. **Nenhum módulo currícular pode alucinar BNCC/PNLD.**
3. **Nenhuma operação pode apagar histórico pedagógico sem caminho explícito de arquivamento/backup.**
4. **Qualquer mudança de dimensão de embeddings (atualmente 768) exige revisão arquitetural.**
5. **Agentes de IA devem ser tratados como camadas de serviço, não como donos da verdade:**
   - Sempre que possível, regras de negócio devem estar no backend, não apenas no prompt.

---

## 4. Como usar este documento

Antes de qualquer alteração significativa:

- Leia:
  - `overview-profeplan.md`
  - `arquitetura-geral-profeplan.md`
  - Este arquivo (`fluxos-criticos-e-guardrails.md`)
- Se a mudança envolver:
  - Alunos/Turmas/PDI → também `modulo-alunos-turmas-pdi.md`

Se alguma alteração planejada contrariar um guardrail:

- Registre explicitamente:
  - O motivo.
  - O risco.
  - Como será mitigado.
- Exija revisão humana de arquitetura antes de aplicar.

