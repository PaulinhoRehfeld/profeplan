---
feature: "Meus Arquivos"
version: "v4.0.0"
owner: "PAULINHO"
last_updated: "2026-03-09"
status: "draft"
---

# Contrato de Comportamento – Meus Arquivos (PROFEPLAN v4.0.0)

## 1. Objetivo da Aba

Ser o **Drive pedagógico do professor dentro do PROFEPLAN**, reunindo em um só lugar:

- Todos os conteúdos gerados pela IA (planos, trimestrais, materiais, atividades, simulados, avaliações, apresentações).
- Com organização por **pastas lógicas** e tipos.
- Permitindo **editar, exportar (DOCX)** e excluir com segurança, sem quebrar vínculos pedagógicos.

---

## 2. Entidades e Contexto Técnico

- **Tabela `generated_contents` (Supabase)**
  - Campos principais:
    - `id`
    - `user_id`
    - `type` – categoria lógica usada pelo Drive:
      - `'trimestral'`, `'plano'`, `'material'`, `'exercicio'`, `'simulado'`, `'avaliacao'`, `'apresentacao'`, `'documento'` (livre).
    - `folder` – rótulo amigável (ex.: `TRIMESTRAIS`, `PLANOS DE AULA`, etc.).
    - `title`
    - `content` – corpo em Markdown.
    - `created_at`

- **Serviços**
  - `databaseService.ts`:
    - `saveGeneratedContent(userId, type, folder, title, content)`:
      - Escreve em `generated_contents`.
    - `getGeneratedContents(userId)`:
      - Lê todos os arquivos do usuário.
    - `updateGeneratedContent(id, { title, content })`:
      - Atualiza título e/ou conteúdo.
    - `deleteGeneratedContent(id)`:
      - Remove o arquivo.

- **UI / Aba Meus Arquivos**
  - `DriveExplorer.tsx`:
    - Props: `userId`, `userEmail`, `settings`.
    - Carrega todos os conteúdos via `getGeneratedContents`.
    - Organiza em pastas (folders) mapeando `type`:
      - `'trimestral'` → `TRIMESTRAIS`
      - `'plano'` → `PLANOS DE AULA`
      - `'material'` → `MATERIAIS ALUNOS`
      - `'exercicio'` → `ATIVIDADES`
      - `'simulado'` → `SIMULADOS`
      - `'avaliacao'` → `AVALIAÇÕES`
      - `'apresentacao'` → `APRESENTAÇÕES`
      - `'documento'` → `OUTROS`
    - Funções principais:
      - Visualizar lista por pasta.
      - Abrir editor (`editingFile`).
      - Salvar alterações (`updateGeneratedContent`).
      - Exportar para Word/DOCX (`exportToDocx`).
      - Excluir (`deleteGeneratedContent`).

---

## 3. Fluxos Principais

### 3.1 Listagem e Organização

**Comportamento esperado:**

1. Ao abrir a aba **Meus Arquivos** (`ToolMode.FILES`):
   - `DriveExplorer` chama `getGeneratedContents(userId)` e popula `allContents`.
2. Pastas (`folders`) são construídas client-side com base em `type`.
3. A lista da direita mostra:
   - Por padrão: os 10 arquivos mais recentes se nenhuma pasta estiver ativa.
   - Ao clicar em uma pasta:
     - Apenas arquivos com `file.type === folder.id`.

**Contrato:**

- Toda gravação feita pelas outras abas deve ser coerente com essa tipagem:
  - Planejamento Trimestral:
    - `type: 'trimestral'`, folder `TRIMESTRAIS`.
  - Planos de Aula:
    - `type: 'plano'`, folder `PLANOS DE AULA`.
  - Materiais Aluno:
    - `type: 'material'`, folder `MATERIAIS ALUNOS`.
  - Atividades/Exercícios:
    - `type: 'exercicio'`, folder `ATIVIDADES`.
  - Simulados:
    - `type: 'simulado'`, folder `SIMULADOS`.
  - Avaliações:
    - `type: 'avaliacao'`, folder `AVALIAÇÕES`.
  - Apresentações:
    - `type: 'apresentacao'`, folder `APRESENTAÇÕES`.
  - Outros documentos livres:
    - `type: 'documento'`, folder `OUTROS`.

---

### 3.2 Edição de Arquivo

**Entrada:**

- Professor clica em “Editar” em um arquivo.

**Comportamento esperado:**

1. `DriveExplorer.handleEdit(file)`:
   - Seta `editingFile`, `editTitle`, `editContent`.
2. UI entra em modo editor:
   - Campo de título editável.
   - Textarea de conteúdo em Markdown.
   - Preview em tempo real usando `MarkdownRenderer`.
3. `handleSave`:
   - Chama `updateGeneratedContent(id, { title: editTitle, content: editContent })`.
   - Atualiza lista (`fetchData`).
   - Mostra feedback de sucesso/erro.

**Contrato:**

- A edição **não pode** alterar o `type` do arquivo (isso quebraria a organização por pasta).
- `updateGeneratedContent` deve ser usado apenas para `title`/`content`.

---

### 3.3 Exportação para Word/DOCX

**Entrada:**

- Professor clica em “Baixar” em um arquivo (modo lista ou editor).

**Comportamento esperado:**

1. `DriveExplorer.handleExport(file)`:
   - Define `contentToExport`:
     - Se em edição, usa `editContent`.
     - Caso contrário, usa `file.content`.
   - Define `titleToExport` de forma semelhante.
   - Chama `exportToDocx(contentToExport, titleToExport, settings)`.
2. `exportToDocx` monta o arquivo DOCX com:
   - Título, corpo em Markdown convertido, cabeçalho/rodapé/logotipo do professor (via `UserSettings`).

**Contrato:**

- A exportação **não altera** o conteúdo na nuvem; é apenas leitura.

---

### 3.4 Exclusão de Arquivo

**Entrada:**

- Professor clica em “Excluir”.

**Comportamento esperado:**

1. Confirmação explícita (`confirm("Excluir permanentemente este documento da sua nuvem?")`).
2. `deleteGeneratedContent(id)`:
   - Remove o registro de `generated_contents`.
3. Lista é recarregada (`fetchData`).
4. Se o arquivo excluído estava em edição, o editor é fechado.

**Contrato:**

- Exclusão é definitiva para o usuário (não há lixeira neste módulo).
- Nunca deve apagar registros curriculares ou PDIs – apenas conteúdos gerados (`generated_contents`).

---

## 4. Integração com Outras Abas

- **Planejamento Trimestral / Planos de Aula / Materiais / Atividades / Simulados / Avaliações / Apresentações**
  - Todas essas features devem:
    - Utilizar `saveGeneratedContent` com `type` e `folder` corretos.
    - Assim, o arquivo aparece automaticamente organizado em **Meus Arquivos**.

- **Histórico de Chat / Auditor / PDI**
  - Quando gerarem documentos consolidados (relatórios, pareceres, etc.), devem:
    - Definir `type: 'documento'` e folder `OUTROS` (ou pasta especializada futura).

---

## 5. Erros, Estados e Mensagens

- **Falha ao carregar dados (`getGeneratedContents`)**
  - Mensagem em console + fallback para lista vazia.
  - UI deve mostrar “Carregando...” seguido de “Nenhum arquivo encontrado” se não houver dados.

- **Erro ao salvar edição**
  - `handleSave` mostra feedback visual (`feedback.type === 'error'`).
  - Não deve limpar o editor; o professor pode tentar novamente.

- **Erro ao excluir**
  - Alerta: “Erro ao excluir arquivo.”.

---

## 6. Checklist de Validação (para agentes/QA)

1. **Organização por tipo**
   - [ ] Todos os fluxos de geração usam `saveGeneratedContent` com o `type` correto.
   - [ ] Em `DriveExplorer`, cada pasta mostra apenas arquivos do tipo esperado.

2. **Integridade de edição**
   - [ ] `updateGeneratedContent` não muda `type` ou `user_id`.
   - [ ] As alterações aparecem corretamente na lista após salvar.

3. **Exportação**
   - [ ] `exportToDocx` funciona para todos os tipos (plano, trimestral, simulado, avaliação, apresentação, etc.).
   - [ ] Documentos exportados preservam títulos e estrutura básica do Markdown.

4. **Experiência de uso**
   - [ ] A aba é responsiva (pastas à esquerda, arquivos à direita).
   - [ ] Mensagens de estado/erro são claras e não bloqueiam o fluxo do professor.

