# Auditoria de experiência do usuário

## Achados priorizados

| Tela/componente | Arquivo | Problema e impacto | Gravidade | Recomendação | Risco | Esforço |
|---|---|---|---|---|---|---|
| Aplicação inteira | `src/index.css` | Fonte-base de 11 px reduz legibilidade, especialmente para baixa visão e uso prolongado | crítica | base 16 px; escala semântica mínima de 14 px para apoio | médio | médio |
| Navegação | `Sidebar.tsx`, `FeatureRenderer.tsx` | Funcionalidades internas não têm URL; voltar, atualizar, favorito e compartilhamento não preservam contexto | alta | rotas filhas ou sincronização URL↔ToolMode incremental | médio | grande |
| Cabeçalho | `MainLayout.tsx` | versão técnica e labels de 9 px/caixa alta ocupam destaque maior que tarefa/estado | alta | título de tarefa claro, breadcrumb simples e status discreto | baixo | pequeno |
| Menu | `Sidebar.tsx` | 11–12 itens com nomes longos e sobreposição (“Meus Arquivos”/“Meus Documentos”) | alta | pesquisa com professores; unificar taxonomia e explicar diferenças | médio | médio |
| Home | `HomePage.tsx` | deve orientar “o que fazer agora”, mas compete com muitos destinos | alta | 3 ações primárias, recentes e continuidade de trabalho | baixo | médio |
| IA | `PlanningManager.tsx`, `CleanChat.tsx` | geração mistura chat, configurações e resultados; risco de incerteza em espera longa | alta | etapas, progresso textual, tempo esperado, cancelar/repetir e preservar entrada | médio | médio |
| Planejamento | `PlanningCockpit.tsx` | painel de 908 linhas e múltiplas áreas simultâneas elevam carga cognitiva | alta | fluxo progressivo: contexto → geração → revisão → exportação | médio | grande |
| PDI | `PDIManager.tsx` e blocos | muitos formulários e estados com alta sensibilidade; perda de orientação é provável | alta | índice persistente, “salvo agora”, progresso e resumo antes de concluir | alto | grande |
| Configurações | `SettingsModal.tsx` | conteúdo complexo em modal; navegação, foco e mobile ficam frágeis | alta | rota/página dedicada ou modal full-screen acessível | médio | médio |
| Mobile | `MainLayout.tsx`, `Sidebar.tsx` | drawer ocupa 85vw e não há navegação de ações frequentes; cabeçalho fica congestionado | alta | drawer mais simples + barra contextual/bottom nav testada | médio | médio |
| Ações icônicas | vários | 344 botões e só 34 ocorrências ARIA; ícones podem não ter nome acessível | alta | componente `IconButton` exigindo `aria-label` e tooltip | baixo | médio |
| Formulários | vários | 212 controles e 184 labels encontrados; associação/ajuda/erro não é uniforme | alta | `Field` com label, hint, erro, required e ids determinísticos | médio | médio |
| Modais | vários | sem padrão único de `role=dialog`, foco inicial, trap e retorno de foco | alta | primitive Modal/Dialog e checklist WAI-ARIA | médio | médio |
| Feedback | Toast + mensagens locais | sucesso/erro/loading variam e podem desaparecer sem anúncio | média | padrão com `aria-live`, ação corretiva e mensagem não técnica | baixo | médio |
| Plano/créditos | header, assinatura | plano não fica claramente visível no shell; limites aparecem sobretudo em bloqueios | média | badge discreto com plano/créditos e link “Entenda seu plano” | médio | pequeno |
| Vazios | listas/documentos/turmas | tratamentos são locais e nem sempre ensinam o primeiro passo | média | empty state com motivo, CTA único e exemplo | baixo | pequeno |
| Erros | serviços/componentes | muitos `console` e tratamento disperso podem expor mensagens técnicas ou falhar silenciosamente | alta | mapa de erros amigáveis + log técnico separado | médio | médio |
| Retorno | fluxos internos | voltar depende de botões locais/estado e não de navegação consistente | média | breadcrumb/“Voltar” contextual e rotas preserváveis | médio | médio |
| Escolha de escola | `SchoolSelector*`, `SchoolSwitcher` | etapa crítica pode parecer bloqueio se não explicar por que uma escola é necessária | média | contexto, escola atual e consequência da troca | alto | pequeno |
| Onboarding | `FirstRunTour.tsx` | tour isolado não substitui orientação contextual e pode ser ignorado | baixa | dicas sob demanda e checklist de primeiros resultados | baixo | médio |

## Jornada do professor

O produto oferece grande valor, mas apresenta sua arquitetura interna (“modos”, “workspace”, versões e nomes técnicos) antes da intenção do professor. A organização deveria começar por objetivos: **Planejar**, **Criar atividade/avaliação**, **Adaptar para inclusão**, **Organizar turmas e materiais**. Em cada tela, o CTA primário deve responder “qual é o próximo passo?”.

## Acessibilidade

Pontos positivos: idioma `pt-BR` na árvore histórica, uso pontual de `aria-label`, dialogs rotulados em alguns fluxos, labels numerosos e tamanho 16 px em campos mobile. Lacunas: texto pequeno, estados por cor, foco não padronizado, ausência aparente de skip link, botões icônicos sem nome uniforme, animações sem `prefers-reduced-motion`, modais heterogêneos e feedback sem anúncio consistente.

Meta: WCAG 2.2 AA, teclado completo, foco visível, alvos mínimos 44×44 px em mobile, contraste 4,5:1 para texto normal e zoom a 200% sem perda funcional.
