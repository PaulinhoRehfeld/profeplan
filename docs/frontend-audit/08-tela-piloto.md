# Tela-piloto recomendada

## Escolha: Início (`/app`, modo `HOME`)

Arquivo principal: `apps/web/src/features/Home/HomePage.tsx`, dentro de `MainLayout` e `Sidebar`.

## Por que esta tela

- É a primeira referência após login e impacta descoberta diária.
- Exercita shell, menu, cabeçalho, cards, botões, ícones, hierarquia e responsividade.
- Permite testar personalização por perfil e atalhos sem editar autenticação, banco, Stripe ou geração de IA.
- Tem 231 linhas: representativa, mas muito menos arriscada que `PlanningManager`, PDI ou assinatura.
- Seus padrões podem ser reaproveitados em dashboards, listas e empty states.

## Reorganização proposta

1. **Cabeçalho útil:** “Olá, {nome}” + escola/turma ativa em texto secundário; remover versão como protagonista.
2. **Continuar de onde parou:** último planejamento/documento com data e CTA “Continuar”.
3. **Ações principais:** no máximo três cards — Criar plano de aula, Planejamento trimestral, Criar avaliação.
4. **Inclusão em destaque contextual:** acesso claro a PDI/DUA, sem competir visualmente com todas as ações.
5. **Recentes:** lista curta de materiais, com tipo, turma, atualizado em e ação contextual.
6. **Ajuda e plano:** links discretos; plano/créditos legíveis, sem banner promocional permanente.

No mobile: uma coluna, CTA principal acima da dobra, cards inteiros clicáveis com nome acessível e nenhum texto menor que 14 px. Loading usa skeleton estável; vazio explica o primeiro passo; erro preserva atalhos e oferece “Tentar novamente”.

## Critérios de sucesso

- Professor identifica como criar um plano em até 5 segundos.
- Fluxo completo por teclado; foco visível e ordem lógica.
- Contraste AA, zoom 200% e 320 px sem rolagem horizontal.
- Nenhum evento, payload, permissão ou chamada de serviço alterado.
- Componentes aprovados: PageHeader, ActionCard, RecentItem, EmptyState, Skeleton e Badge.

## O que não fazer no piloto

Não alterar `RootLayout`, guards, Supabase, plano, créditos, assinatura ou regras de visibilidade. A navegação continua chamando `setActiveMode` até a fase específica de rotas.
