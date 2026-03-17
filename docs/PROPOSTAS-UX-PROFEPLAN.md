# Ideias para transformar o PROFEPLAN em um app amigável (UX) e funcional

Documento de sugestões após a implantação da FREEDAY como agente de apoio ao professor.

---

## 1. FREEDAY como centro da experiência

### 1.1 Já feito
- FREEDAY integrada ao fluxo do app (botão flutuante + painel voz/texto).
- Persona e prompt voltados a dúvidas e dificuldades do professor.

### 1.2 Sugestões
- **Atalho por contexto:** Em telas pesadas (Planejamento Trimestral, PDI, Avaliações), mostrar um CTA discreto: “Com dúvida? Pergunte à FREEDAY” que abre o painel já com uma sugestão de pergunta (ex.: “Como organizar o trimestre?”).
- **Dicas contextuais:** Na primeira vez em cada modo (ex.: Simulados, PDI), a FREEDAY pode “oferecer ajuda” com 1–2 frases em texto (ex.: “Posso te ajudar a montar um simulado ou explicar como usar o banco de questões”).
- **Resumo por voz:** Opção “Resumir esta tela” que envia para a FREEDAY o contexto atual (nome do modo + dados mínimos) e ela responde em áudio com um resumo do que o professor está vendo e o que pode fazer.

---

## 2. Navegação e orientação

### 2.1 Sidebar e modo ativo
- **Indicador de “onde estou”:** Além do item ativo, mostrar um breadcrumb curto no header (ex.: “Início > Planos de Aula”) ou um subtítulo que mude por modo.
- **Agrupamento visual:** Agrupar itens do menu por categoria (Planejamento | Conteúdo | Gestão) com separadores ou títulos colapsáveis para reduzir ruído.
- **Atalhos de teclado:** Documentar (e exibir em ? ou Configurações) atalhos como `G then P` = Planos de Aula, `G then T` = Turmas, etc., para usuários avançados.

### 2.2 Primeira vez e onboarding
- **Tour opcional:** Após o primeiro login, oferta de um tour em 3–4 passos (Início, Planejamento, Turmas, FREEDAY) com possibilidade de pular.
- **Empty states úteis:** Em “Minhas Turmas”, “Meus Arquivos” ou “Planos” vazios, mostrar texto + ilustração + um botão de ação (ex.: “Criar primeira turma”, “Falar com a FREEDAY para começar”).

---

## 3. Consistência visual e feedback

### 3.1 Design system leve
- **Cores de estado:** Padronizar verde = sucesso/concluído, âmbar = em andamento/atenção, vermelho = erro/bloqueio em todo o app.
- **Tipografia:** Definir hierarquia clara (título da página, subtítulo, corpo, legenda) e usar de forma consistente em todas as features.
- **Espaçamento:** Usar uma escala (ex.: 4, 8, 12, 16, 24, 32 px) em padding/margin para ritmo visual uniforme.

### 3.2 Feedback imediato
- **Loading por ação:** Em toda ação que chama API (salvar plano, gerar simulado, etc.), mostrar loading no botão ou em um toast “Salvando…” / “Gerando…” e depois “Pronto” ou mensagem de erro clara.
- **Confirmações destrutivas:** Em “excluir”, “remover turma”, etc., usar modal com texto explícito e botões “Cancelar” e “Excluir”.
- **Toasts curtos:** Para sucesso (ex.: “Plano salvo”), toast de 2–3 s; para erro, toast com “Tentar novamente” se fizer sentido.

---

## 4. Funcionalidade por área

### 4.1 Início (Assistente / Chat)
- **Templates de início:** Botões ou cards “Começar planejamento”, “Ver minhas turmas”, “Dúvida sobre BNCC” que preenchem o chat com uma pergunta sugerida.
- **Histórico de conversas:** Lista lateral ou dropdown com últimas conversas (por sessão ou persistidas) para retomar contexto.
- **Integração com FREEDAY:** O chat de texto e a FREEDAY podem compartilhar o mesmo contexto (ex.: “continuar por voz” abrindo o painel da FREEDAY com o último assunto).

### 4.2 Planejamento (Trimestral + Planos de Aula)
- **Wizard em etapas:** Para plano de aula novo, guiar em passos (Disciplina/Série → Objetivos → Atividades → Avaliação) com “Voltar” e “Próximo” e indicador de progresso.
- **Preview antes de salvar:** Botão “Ver como ficou” que mostra o plano formatado (ou PDF preview) antes de confirmar.
- **Rascunhos:** Salvar automaticamente como rascunho a cada X segundos e indicar “Rascunho” no header até publicar.

### 4.3 PDI / Adaptações
- **Checklist por aluno:** Lista de alunos com indicador “Adaptação feita” / “Pendente” e link direto para o PDI do aluno.
- **Sugestões da FREEDAY:** Na tela de adaptação, botão “Sugestões da FREEDAY” que envia contexto (nome do aluno, disciplina, etapa) e traz ideias de adaptação em texto (e depois por voz se quiser).

### 4.4 Simulados e Avaliações
- **Filtros claros:** Disciplina, ano, BNCC, número de questões sempre visíveis e com contador “X questões encontradas”.
- **Preview de questão:** Ao clicar numa questão, modal com enunciado + alternativas + gabarito, sem sair da lista.
- **Exportação em um clique:** Botão “Exportar PDF” ou “Enviar para turma” com feedback imediato.

### 4.5 Minhas Turmas e Gestão Escolar
- **Busca e filtro:** Barra de busca por nome do aluno/turma e filtros por série/escola.
- **Cards de turma:** Cada turma como card com resumo (número de alunos, última atividade) e clique para detalhe.
- **Ações em lote:** Onde fizer sentido (ex.: exportar lista, enviar comunicado), seleção múltipla com “Aplicar em selecionados”.

### 4.6 Meus Arquivos
- **Pastas por tipo:** Agrupar por “Planos”, “Simulados”, “Avaliações”, “Apresentações” com ícones e contagem.
- **Busca por nome e data:** Campo de busca e ordenação por data de modificação.
- **Abrir em nova aba:** Links que abrem o arquivo (PDF, etc.) em nova aba quando possível.

---

## 5. Performance e confiança

### 5.1 Percepção de velocidade
- **Skeleton loaders:** Em listas (turmas, arquivos, questões), mostrar skeletons em vez de spinner genérico.
- **Lazy load de imagens:** Carregar imagens sob demanda e com placeholder.

### 5.2 Offline e resiliência
- **Indicador de conexão:** Ícone ou barra discreta quando estiver offline, com mensagem “Algumas ações podem ficar indisponíveis”.
- **Retry automático:** Em falhas de rede (ex.: 502), tentar novamente 1–2 vezes antes de mostrar erro ao usuário.
- **Salvamento local:** Para formulários longos (ex.: plano de aula), manter cópia em `localStorage` e oferecer “Restaurar rascunho?” ao voltar.

---

## 6. Acessibilidade e inclusão

- **Contraste e foco:** Garantir contraste mínimo (WCAG AA) e ordem de foco lógica (Tab) em modais e formulários.
- **Labels e aria:** Botões e ícones com `aria-label`; painel da FREEDAY já com papel de “assistente”.
- **Redução de movimento:** Respeitar `prefers-reduced-motion` em animações (ex.: desabilitar ou suavizar).

---

## 7. Status de implementação (2026)

### 7.1 Visão por épico

- **Épico 1 – FREEDAY como centro da experiência**
  - **Implementado**: FREEDAY global (provider + botão flutuante), `openWithPrompt` para abrir com pergunta pronta, CTAs “Perguntar à FREEDAY” em Planejamento, PDI e Avaliações.
  - **Backlog fino**: “Resumo por voz” da tela (exige camada de áudio).

- **Épico 2 – Navegação e orientação**
  - **Implementado**: menu lateral agrupado (Planejamento / Conteúdo & Avaliação / Gestão), empty states úteis em Turmas, Arquivos e Planejamento.
  - **Backlog**: tour guiado de primeiro uso e atalhos de teclado globais.

- **Épico 3 – Consistência visual e feedback**
  - **Implementado**: sistema de toasts globais, loadings claros em ações críticas, modais de confirmação em pontos sensíveis.
  - **Backlog**: formalizar design system em documento único (cores/tipografia/espaçamento).

- **Épico 4 – Funcionalidade por área**
  - **Início / Assistente**: templates de início no `CleanChat` (planejamento, trimestre, BNCC, turmas).
  - **Planejamento**: cockpit com wizard leve de plano de aula (`LessonPlanWizard`), preview do plano e indicador de rascunho salvo.
  - **PDI**: checklist visual por aluno (status pendente/gerado/validado), resumo por turma e CTA FREEDAY contextual.
  - **Simulados**: filtros com contador de questões, modal de preview completo e fluxo de exportação em um clique.
  - **Arquivos & Turmas**: Drive com busca/ordenação e cards de turma ricos.
  - **Backlog**: histórico enxuto de intenções no assistente e métricas de “última atividade” nas turmas.

- **Épico 5 – Performance e confiança**
  - **Implementado**: skeleton loaders em listas (turmas, arquivos, questões), retry automático em operações críticas (salvar plano, buscar/gerar simulados), indicador de conexão global (`OfflineIndicator`).
  - **Backlog**: salvamento local extra para formulários muito longos além do que já existe em Planejamento.

- **Épico 6 – Acessibilidade e inclusão**
  - **Implementado**: `aria-label` em botões de ícone principais, `role="dialog"`/`aria-modal`/`aria-labelledby` em modais relevantes, uso de `motion-safe` para respeitar `prefers-reduced-motion`.
  - **Backlog**: rodada de QA específica com leitor de tela e verificação sistemática de contraste (WCAG).

### 7.2 Foco recomendado para próximos ciclos

- Consolidar um **tour de primeiro uso** leve (Épico 2).
- Evoluir o **wizard de plano de aula** para mais formatos e séries (Épico 4.1).
- Planejar uma rodada de **QA de acessibilidade** com usuários reais (Épico 6).

---

*Documento gerado com base na estrutura atual do PROFEPLAN e na integração da FREEDAY. Atualizado com o status de implementação para servir como backlog vivo de UX e funcionalidade.*
