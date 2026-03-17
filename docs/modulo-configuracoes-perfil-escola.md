### Módulo Configurações & Perfil / Gestão de Escola

#### 1. Propósito do módulo

- **Objetivo principal**: centralizar **onboarding**, **perfil profissional** e **dados da escola**, garantindo:
  - que o usuário complete o perfil antes de usar módulos críticos,
  - que os módulos Planejamento / PDI / Avaliação tenham contexto institucional mínimo,
  - que o sistema não fique acoplado indevidamente à tabela global de escolas.

- **O que este módulo resolve**:
  - **[IMPLEMENTADO]** Onboarding com bloqueio de uso se perfil incompleto (via `FeatureRenderer` + `isProfileCompleteForMainFlows`).
  - **[IMPLEMENTADO]** Edição de perfil do professor (ProfileTab) com campos livres para nome da escola, cidade, INEP.
  - **[IMPLEMENTADO]** Edição de perfil do gestor (ManagerProfileTab) com dados da escola no próprio `profiles`.
  - **[PARCIAL]** Painel de gestão escolar para ver turmas, alunos e PDIs em nível de escola.

---

#### 2. Escopo funcional

- **Configurações / Perfil do Professor**:
  - Dados pessoais e pedagógicos:
    - nome, email, telefone,
    - rede (estadual/municipal/privada), estado, MASP,
    - preferências de metodologia, tom de voz, estilo de ensino.
  - Dados institucionais mínimos:
    - **[IMPLEMENTADO]** nome da escola (campo livre),
    - **[IMPLEMENTADO]** cidade,
    - **[IMPLEMENTADO]** código INEP (campo livre, não atrelado à tabela `schools`).

- **Perfil / Gestão de Escola (Gestor)**:
  - Dados da unidade escolar:
    - nome da escola, cidade, INEP,
    - estatísticas agregadas (alunos, turmas, PDIs, etc. – futuro).
  - **[IMPLEMENTADO PARCIAL]** Tela específica (ManagerProfileTab) para o papel SCHOOL_MANAGER.

- **Onboarding & Bloqueios**:
  - **[IMPLEMENTADO]** Bloquear uso de features principais se perfil incompleto:
    - via `FeatureRenderer` + `renderProfileBlocker()` para modos INCLUSION, ASSESSMENT, QUARTERLY_PLANNING, PLANNING.

---

#### 3. Modelo de dados

##### 3.1. Perfil de usuário (`profiles` e `UserProfile`)

- **Tipo `UserProfile` (`types.ts`)** – **[IMPLEMENTADO]**:
  - `id`, `email`, `role`, `school_id?`, `school_name?`, `school?`, `city?`,
  - `tier`, `credits`, `allowed_features`, etc.
  - Campos pedagógicos:
    - `favorite_methodology`, `teaching_style`, `assessment_focus`, `tone_of_voice`,
    - personalização de documentos (header/footer/logo).

- **Banco (`profiles`)**:
  - **[IMPLEMENTADO PARCIAL]** Campos para escola (nome, cidade, INEP) agora vivem diretamente em `profiles` e não mais via tabela `schools` no fluxo de Configurações.

##### 3.2. Escola (`schools` e tipos `School`)

- **Tipo `School` (`types.ts`)** – **[IMPLEMENTADO]**:
  - `id`, `name`, `inep_code?`, `city?`, `state?`, etc.

- **Uso atual**:
  - **[IMPLEMENTADO]** A tabela `schools` permanece como base global (BNCC, SIMADE, etc.), mas:
    - **não** é mais usada para autocomplete de Perfil/Configurações (removido),
    - continua podendo ser usada no Admin / relatórios mais avançados.

---

#### 4. Serviços e componentes envolvidos

- **Componentes**:
  - `Settings/Tabs/ProfileTab.tsx` – **[IMPLEMENTADO]**:
    - campos livres para nome da escola/cidade/INEP,
    - **removida** dependência de `SchoolAutocomplete` e `teacherSchoolService`.
  - `Settings/Tabs/ManagerProfileTab.tsx` – **[IMPLEMENTADO]**:
    - edição direta de `school_name`, `city`, `inep_code` em `profiles`,
    - sem criar/ligar registros na tabela `schools`.
  - `FeatureRenderer.tsx` – **[IMPLEMENTADO]**:
    - verifica `isProfileCompleteForMainFlows(profile, settings)`,
    - se incompleto, mostra bloqueio em features críticas.

- **Serviços**:
  - `ProfileService.ts` – **[IMPLEMENTADO PARCIAL]**:
    - carrega/atualiza `UserProfile`,
    - expõe `isProfileCompleteForMainFlows(profile, settings)`:
      - regra de completude do perfil para destravar módulos principais.

---

#### 5. Fluxos críticos

##### 5.1. Onboarding e bloqueio de uso

1. Usuário entra na aplicação pela primeira vez.
2. Sistema verifica, via `ProfileService`:
   - se perfil está preenchido com campos mínimos (escola, cidade, etc.).
3. **Se incompleto**:
   - `FeatureRenderer` bloqueia:
     - INCLUSION, ASSESSMENT, PLANNING, QUARTERLY_PLANNING,
   - Mostra mensagem e atalho para Configurações.

- **OBRIGATÓRIO**:
  - Manter esta verificação sempre que novos módulos forem adicionados ao “grupo principal”.
  - Atualizar a lógica de `isProfileCompleteForMainFlows` se novos campos obrigatórios forem definidos.

##### 5.2. Edição de Perfil do Professor

1. Usuário abre `Configurações > Perfil`.
2. `ProfileTab`:
   - exibe campos de dados pessoais, pedagógicos e institucionais (escola).
3. Ao salvar:
   - `ProfileService` / `supabaseService` atualizam `profiles` com:
     - `school_name`, `city`, `inep_code` como **texto livre** (sem criar/alterar `schools`).

- **PROIBIDO**:
  - Reintroduzir autocomplete obrigatório ou dependência dura com a tabela `schools` (ver guardrail no doc de Fluxos Críticos).

##### 5.3. Perfil de Gestor e Gestão de Escola

1. Usuário com papel SCHOOL_MANAGER acessa `ManagerProfileTab`.
2. Pode configurar:
   - dados da escola (nome, cidade, INEP),
   - (futuro) parâmetros de gestão (ex.: normas de avaliação, limites, etc.).
3. Essas informações:
   - alimentam dashboards de escola e podem ser usadas como contexto em Planejamento/PDI.

- **[TODO]**:
  - Documentar e implementar de forma clara:
    - quais estatísticas a visão de gestor mostrará (turmas, alunos, PDIs),
    - como elas são calculadas a partir das tabelas existentes.

---

#### 6. Guardrails (OBRIGATÓRIO / PROIBIDO)

- **OBRIGATÓRIO**:
  - Manter o **onboarding obrigatório** para uso de módulos principais.
  - Centralizar dados de escola usados no dia a dia em `profiles` (nome, cidade, INEP).
  - Atualizar este documento e `fluxos-criticos-e-guardrails.md` sempre que:
    - novos campos obrigatórios forem adicionados ao perfil,
    - a lógica de bloqueio for alterada.

- **PROIBIDO**:
  - Voltar a salvar automaticamente novas escolas digitadas em uma base global `schools`.
  - Remover o bloqueio de perfil incompleto sem uma decisão arquitetural explícita.

---

#### 7. Checklist rápido para agentes / devs

- [ ] Verificar se `ProfileTab` e `ManagerProfileTab` **não** fazem mais queries/inserts em `schools`.  
- [ ] Confirmar que campos de escola em `profiles` refletem exatamente o que as telas editam.  
- [ ] Garantir que `isProfileCompleteForMainFlows` cubra todos os campos realmente necessários para Planejamento / PDI / Avaliação.  
- [ ] Atualizar este doc e `fluxos-criticos-e-guardrails.md` quando novos campos de perfil tornarem-se obrigatórios.  

