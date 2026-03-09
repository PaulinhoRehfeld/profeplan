---
feature: "Admin Sistema"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Admin Sistema (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Permitir que administradores da plataforma:

- Gerenciem **usuários**, perfis, créditos e vínculos com escolas.
- Acompanhem **relatórios de uso da IA** (feedback, incidentes).
- Orquestrem **ingestões RAG** (currículos, bases de conhecimento).

---

## 2. Entidades e Contexto Técnico

- **Usuários**
  - Tabelas principais:
    - `profiles` – dados de perfil de aplicativo.
    - `authorized_users` – controle de acesso/autorização.
  - Tipos:
    - `UserProfile` (frontend).

- **Escolas**
  - Tabela `schools`.
  - Utilizadas para vincular usuários a instituições (campo `school_id` em `profiles`).

- **Componentes/Serviços principais**
  - `AdminPanel.tsx`:
    - Tabs: `users`, `feedback`.
    - Lista e edição de usuários (`UserList`).
    - Criação de usuário (`CreateUserModal`).
    - Adição de créditos (`AddCreditsModal`).
    - Widget de ingestão RAG (`RagIngestionWidget`).
  - `ProfileService`:
    - `getAllUsers()`
    - `updateUserProfileAdmin(id, updates)`.
  - `supabaseClient`:
    - Operações diretas em `profiles` e `authorized_users` (exclusão).

---

## 3. Fluxo – Gestão de Usuários

### 3.1 Carregamento de usuários

**Comportamento esperado:**

1. Ao montar:
   - `loadUsers` chama `getAllUsers()`.
   - Preenche `users` (array de `UserProfile`).
2. Campo de busca:
   - Filtra `users` client-side por e-mail (`searchTerm`).

**Contrato:**

- A listagem deve cobrir todos os perfis relevantes (`profiles`), com indicação clara de tiers, créditos, escolas e papéis.

---

### 3.2 Criação de usuário

**Comportamento esperado (`CreateUserModal`)**:

1. Admin preenche dados do usuário:
   - E-mail, nome, vínculo com escola (via `allSchools` e `cities`).
2. Ao salvar:
   - Cria entradas em `profiles`/`authorized_users` conforme fluxo definido em `CreateUserModal` e serviços associados.
3. `onUserCreated`:
   - Dispara `loadUsers` para refletir o novo usuário na tabela.

**Contrato:**

- Todo usuário criado deve ficar visível imediatamente na lista principal (após reload).
- Vínculo com escola (quando fornecido) deve respeitar IDs e não aceitar nomes soltos.

---

### 3.3 Atualização de perfil e créditos

**Atualização de perfil (`handleUpdateUser`)**:

1. Chama `updateUserProfileAdmin(id, updates)`:
   - Permite alterar campos de `UserProfile` (tier, role, school_id, etc.).
2. Após sucesso:
   - Recarrega lista (`loadUsers`) e limpa `editingUser`.

**Créditos (`AddCreditsModal`)**:

1. Admin seleciona usuário para crédito (`onAddCredits`).
2. Modal permite:
   - Ajustar créditos (soma/subtração) ou aplicar plano específico.
3. `onCreditsAdded`:
   - Recarrega usuários e fecha modal.

**Contrato:**

- Alterações administrativas devem ser auditáveis (idealmente logadas em backend).
- Nenhuma modificação deve deixar o usuário em estado inconsistente (ex.: tier GOLD com 0 créditos, se a regra de negócios não permitir).

---

### 3.4 Exclusão de usuário

**Comportamento esperado (`handleDeleteUser`)**:

1. Exibe confirmação explícita:
   - `EXCLUIR o usuário ${user.email}? Ação irreversível.`
2. Executa:
   - `supabase.from('profiles').delete().eq('id', user.id)`.
   - `supabase.from('authorized_users').delete().eq('id', user.id)`.
3. Recarrega usuários (`loadUsers`).

**Contrato:**

- Exclusão deve ser usada apenas em cenários controlados (incidentes, testes), nunca como fluxo principal de offboarding de escolas.
- Em ambiente de produção, é recomendável substituição por **desativação** em vez de exclusão física (nota para evolução futura).

---

## 4. Fluxo – Relatório IA (Feedback)

**Componente `FeedbackReport`**:

- Aba focada em:
  - Exibir reclamações/sugestões dos usuários sobre IA.
  - Destacar incidentes graves (alucinações, erros pedagógicos, etc.).

**Contrato:**

- Não deve expor dados sensíveis (nomes completos de alunos, PDIs, etc.) em logs de IA.
- Deve permitir ao admin identificar rapidamente padrões de erro para priorizar correções.

---

## 5. Fluxo – Ingestão RAG

**Widget `RagIngestionWidget`**:

- Responsável por:
  - Disparar ingestão/reingestão de fontes de conhecimento (currículos, BNCC, documentos).
  - Exibir status (fila, progresso, última execução).

**Contrato:**

- Apenas admins devem conseguir disparar ingestões.
- Ingestões devem ser **idempotentes** ou claramente versionadas.

---

## 6. Checklist de Validação (para agentes/QA)

1. **Permissão**
   - [ ] Aba Admin só é exibida para `isAdmin(userProfile)` ou `UserRole.ADMIN`.

2. **Gestão de usuários**
   - [ ] `getAllUsers` traz a lista esperada.
   - [ ] Atualizações via `updateUserProfileAdmin` refletem imediatamente na UI.
   - [ ] Exclusões removem corretamente de `profiles` e `authorized_users`.

3. **Créditos**
   - [ ] Adição/remoção de créditos atualiza o saldo do usuário.

4. **RAG e Feedback**
   - [ ] Widget de ingestão RAG está acessível e funcional para admins.
   - [ ] Aba de feedback mostra informações úteis sem violar privacidade.

