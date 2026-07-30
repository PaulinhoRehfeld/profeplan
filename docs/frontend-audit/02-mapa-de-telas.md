# Mapa de telas

## Como ler as rotas

As rotas reais abaixo são URLs. Os itens `/app#modo` são estados internos de `ToolMode`, não hashes implementados; são usados aqui apenas para identificar telas. Recarregar/copiar a URL não preserva o modo atual.

| Grupo | Rota/estado | Arquivo principal e componentes | Função | Complexidade | Prioridade | Risco |
|---|---|---|---|---|---|---|
| Landing | `/landing` | `pages/LandingPage.tsx` | aquisição, benefícios, planos e FAQ | alta | média | baixo |
| Autenticação | `/login`, `/signup` | `components/LoginScreen.tsx` | acesso e cadastro | média | alta | alto |
| Autenticação | `/verify-email` | `pages/VerifyEmail.tsx` | confirmação de e-mail | baixa | média | alto |
| Legal | `/privacy`, `/terms` | `pages/PrivacyPolicy.tsx`, `TermsOfService.tsx` | documentos legais | baixa | baixa | baixo |
| Comparação | `/road` | `pages/ComparativoPage.tsx` | comparação/apresentação comercial | média | baixa | baixo |
| Onboarding | `/profile-setup` | `pages/UserProfileSetup.tsx` | completar perfil profissional | média | alta | alto |
| Onboarding | `/select-school` | `SchoolSelectorScreenWrapper`, `SchoolSelectorScreen` | escolher escola ativa | média | alta | alto |
| Dashboard | `/app#home` | `features/Home/HomePage.tsx` | atalhos e orientação inicial | média | **alta/piloto** | baixo |
| IA | `/app#chat` | `PlanningManager`, `CleanChat` | assistente pedagógico | alta | alta | médio |
| Planejamento | `/app#quarterly` | `TermPlanningList`, `TermPlanningManager` | listar/criar planejamento trimestral | alta | alta | médio |
| Planejamento | `/app#planning` | `PlanningManager`, `PlanningCockpit`, `LessonPlanWizard`, `CurriculumMatcher` | plano de aula e currículo | muito alta | alta | médio/alto |
| Inclusão | `/app#inclusion` | `PDIManager`, formulários e viewers PDI | PDI, DUA e adaptações | muito alta | alta | alto |
| PDI oficial | `/pdi/official/:studentId` | `PdiOfficialLayout`, `PdiSidebar`, seções 1–7 | prontuário oficial por estudante | alta | alta | alto |
| Simulados | `/app#simulation` | `PlanningManager`, `SimulationWorkspace` | buscar questões e montar simulado | alta | média | médio |
| Avaliações | `/app#assessment` | `AssessmentManager`, `AssessmentSetup`, `AssessmentPreview` | criar e revisar avaliações | alta | alta | médio |
| Conteúdo | `/app#presentations` | `PresentationCreator`, `PresentationModal`, `CanvaExportModal` | criar/exportar slides | alta | média | médio |
| Arquivos | `/app#files` | `DriveExplorer`, `MarkdownRenderer` | documentos persistidos | alta | média | alto |
| Documentos | `/app#my_documents` | `MyDocumentsManager`, upload, revisão e comparação | biblioteca e versões | alta | média | alto |
| Histórico | `/app#history` | `HistoryList` | recuperar conteúdo anterior | média | média | médio |
| Turmas | `/app#classes` | `ClassManager`, lista, detalhe, importação e PDI drawer | gerir turmas e estudantes | muito alta | alta | alto |
| Gestão | `/app#school_manager` | `pages/SchoolDashboard`, Teacher/Student/ClassManagement | gestão escolar | muito alta | média | alto |
| Perfil | modal em `/app` | `SettingsModal`, Profile/Security/Subscription tabs | perfil, preferências e segurança | alta | alta | alto |
| Assinatura | modal em `/app` | `SubscriptionModal`, `SubscriptionTab`, `LowCreditModal` | plano, créditos e upgrade | média | média | crítico |
| Administração | `/app#admin` | `components/Admin/AdminPanel` | usuários, créditos e ingestão | alta | baixa | crítico |
| Administração | `/admin/simulations` | SimulationFactory `AdminPanel` | banco de questões, cache e métricas | alta | baixa | crítico |

## Modos definidos mas sem destino independente claro

`ACTIVITIES`, `ENEM_BANK`, `AUDITOR` e `SPECIALIST` existem no enum, mas não aparecem no menu e caem no renderer genérico. Isso sugere código planejado, legado ou funcionalidade parcialmente integrada. Deve ser confirmado antes de remover ou expor.

## Componentes transversais

`MainLayout`, `Sidebar`, `SchoolSwitcher`, `SettingsModal`, `SubscriptionModal`, `FirstRunTour`, `ToastContext`, `ErrorBoundary`, `AppErrorPage`, `ReloadPrompt`, `OfflineIndicator` e `MarkdownRenderer` atravessam vários fluxos.

## Prioridade recomendada

1. Shell + Home; 2. planejamento e avaliações; 3. PDI/inclusão; 4. turmas/documentos; 5. gestão/admin; 6. landing e páginas legais. Autenticação e assinatura devem receber correções de acessibilidade, mas mudanças estruturais só após testes específicos.
