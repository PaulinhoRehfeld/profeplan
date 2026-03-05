---
title: 'Estabilização do ciclo de vida do Service Worker (VitePWA)'
slug: 'estabilizar-service-worker-vitepwa'
created: '2026-02-28T00:00:00.000Z'
status: 'review'
stepsCompleted: [1, 2, 3]
tech_stack:
  - React
  - TypeScript
  - Vite
  - VitePWA (vite-plugin-pwa, generateSW, autoUpdate)
  - Workbox (generateSW)
  - Service Worker API
files_to_modify:
  - apps/web/src/utils/serviceWorkerRegistration.ts
  - apps/web/vite.config.ts
  - apps/web/src/App.tsx
  - apps/web/src/index.tsx
  - apps/web/public/service-worker.js
  - apps/web/public/rescue.html
code_patterns:
  - 'Registro manual de SW via navigator.serviceWorker.register(\"/service-worker.js\") em vez do wrapper padrão do VitePWA.'
  - 'Configuração VitePWA com generateSW + registerType:autoUpdate + injectRegister:false (uso potencial de ReloadPrompt).'
  - 'Padrões de kill-switch/nuclear reset que desregistram todos os service workers e limpam caches em App.tsx, index.tsx e rescue.html.'
  - 'Indicadores de conectividade desacoplados via hook useOnlineStatus (navigator.onLine) em OfflineIndicator.'
test_patterns:
  - 'Vitest configurado no projeto, sem testes específicos para Service Worker.'
  - 'Validação manual via DevTools (Application → Service Workers) e página de resgate public/rescue.html.'
---

# Tech-Spec: Estabilização do ciclo de vida do Service Worker (VitePWA)

**Created:** 2026-02-28

## Overview

### Problem Statement

No ambiente de desenvolvimento (localhost), o DevTools do Chrome reporta atualizações constantes do Service Worker com a mensagem "Service Worker was updated because 'Update on reload' was checked". Embora esta flag seja específica do DevTools, o comportamento observado inclui loops de recarregamento e ruído excessivo no console, indicando que a lógica atual de ciclo de vida (registro, atualização e recarregamento) do Service Worker não está bem isolada. Há histórico de uso de um Service Worker kill-switch (`public/service-worker.js`) e um registro manual (`serviceWorkerRegistration.ts`), enquanto o projeto também utiliza `vite-plugin-pwa` com estratégia `generateSW` e `registerType: 'autoUpdate'`, o que cria sobreposição de responsabilidades e aumenta o risco de estados inconsistentes entre cache antigo e código novo.

### Solution

Padronizar o ciclo de vida do Service Worker em torno do VitePWA, removendo o kill-switch legado e implementando um fluxo explícito de atualização baseado no padrão "Update Available". O registro do SW deve: (1) detectar quando um novo worker entra em estado `waiting` via `updatefound`; (2) sinalizar ao cliente que há uma nova versão disponível através de um componente de UI não bloqueante (snackbar/toast); (3) enviar uma mensagem `SKIP_WAITING` para o Service Worker quando o usuário clicar em "Atualizar agora"; e (4) escutar o evento `controllerchange` em `navigator.serviceWorker` para recarregar a página de forma segura apenas quando o novo worker assumir o controle. Em paralelo, garantir que o script do Service Worker seja servido com headers HTTP adequados (no-store / no-cache) e que o fluxo não dependa das flags manuais de DevTools para funcionar corretamente.

### Scope

**In Scope:**
- Analisar e refatorar o código de registro do Service Worker em `serviceWorkerRegistration.ts`, alinhando-o ao fluxo de atualização não bloqueante (updatefound → waiting → skipWaiting → controllerchange).
- Integrar o registro com a configuração atual do `vite-plugin-pwa` (`generateSW`, `registerType: 'autoUpdate'`, `injectRegister: false`), garantindo que haja uma única fonte de verdade para o ciclo de vida do SW.
- Aposentar o Service Worker kill-switch (`public/service-worker.js`) e documentar o fluxo de migração para novas versões utilizando apenas o SW gerado pelo VitePWA.
- Especificar um componente de UI dedicado (snackbar/toast) para notificar o usuário sobre novas versões e acionar a atualização.
- Definir requisitos mínimos de headers HTTP para o script do Service Worker, de modo a evitar cache agressivo do próprio arquivo de SW.

**Out of Scope:**
- Redesenhar em profundidade a estratégia de cache/offline (políticas detalhadas de Workbox, rotas de cache, pré-cache agressivo).
- Implementar testes de navegador automatizados remotos (ex.: Antigravity, Playwright em CI) além do que for necessário para validar o fluxo básico de atualização.
- Alterar o comportamento de cache de outros recursos da aplicação (APIs, assets não críticos) além do que for estritamente necessário para estabilizar o ciclo de vida do SW.

## Context for Development

### Codebase Patterns

- O projeto usa React + Vite e `vite-plugin-pwa` com `strategies: 'generateSW'`, `registerType: 'autoUpdate'` e `injectRegister: false`, o que significa que o SW principal é gerado pelo VitePWA e é responsável por cache e atualização automática.
- Existe um util dedicado `serviceWorkerRegistration.ts` que hoje registra manualmente `/service-worker.js`, loga estados (`installing`, `waiting`, `active`) e usa `confirm()` para pedir recarregamento, sem usar `skipWaiting` nem `controllerchange`.
- Há um Service Worker kill-switch simples em `public/service-worker.js` que faz `skipWaiting`, apaga todos os caches e se auto-desregistra, utilizado para quebrar ciclos de cache em versões antigas (v3.9.1).
- O arquivo `App.tsx` importa `registerServiceWorker` e também faz interações diretas com `navigator.serviceWorker.getRegistrations()`, o que indica sobreposição de responsabilidades entre o util de registro e a lógica de inicialização da aplicação.

### Files to Reference

| File | Purpose |
| ---- | ------- |
| `apps/web/src/utils/serviceWorkerRegistration.ts` | Ponto central (atual) de registro e unregistration do SW, além de helpers de conectividade. |
| `apps/web/vite.config.ts` | Configuração do `vite-plugin-pwa` (`generateSW`, `registerType: 'autoUpdate'`, `injectRegister: false`). |
| `apps/web/public/service-worker.js` | Service Worker kill-switch legado que faz cleanup e unregister. |
| `apps/web/src/App.tsx` | Inicialização da aplicação e possíveis chamadas adicionais a `navigator.serviceWorker`. |
| `apps/web/src/features/SimulationFactory/components/OfflineIndicator.tsx` | Componente que consome `useOnlineStatus` e expõe indicadores de conectividade (relacionado à percepção do SW). |

### Technical Decisions

- Adotar o padrão "Update Available" como fluxo oficial de atualização, evitando o uso de `confirm()` sincronizado e qualquer recarregamento automático sem confirmação explícita do usuário.
- Centralizar toda a lógica de `updatefound`, `waiting`, `skipWaiting` e `controllerchange` em um único módulo de registro (idealmente o util `serviceWorkerRegistration.ts` ou o wrapper gerado/recomendado pelo VitePWA).
- Remover o kill-switch `public/service-worker.js` do fluxo normal de build e registrar apenas o SW gerado por VitePWA, mantendo o kill-switch apenas como ferramenta emergencial documentada (se ainda necessário).
- Garantir que o script do Service Worker seja servido com headers HTTP que impeçam cache de longo prazo, delegando a lógica de cache para o próprio Workbox dentro do SW.

## Implementation Plan

### Tasks

- [ ] **Task 1: Remover kill-switch e registro manual conflituoso de Service Workers**
  - File: `apps/web/src/index.tsx`
  - Action: Remover o bloco que desregistra todos os Service Workers e limpa todos os caches em cada carregamento de página (linhas 14–20). Garantir que o bootstrap de React apenas registre o `EventBus` e renderize `<App />`, deixando a gestão de SW para o VitePWA/ReloadPrompt.
  - Notes: Manter a possibilidade de um caminho de “resgate” separado (`rescue.html`) em vez de executar reset nuclear sempre em `index.tsx`.
- [ ] **Task 2: Consolidar fluxo de reset nuclear em um único lugar controlado**
  - File: `apps/web/src/App.tsx`
  - Action: Revisar o efeito de “Nuclear Reset V2” (linhas 88–129) para que seja acionado apenas em cenários de migração/força maior (ex.: parâmetro de query ou flag de versão), documentando claramente quando deve ser usado. Garantir que esse fluxo não interfira no fluxo normal de atualização do SW (isto é, não rodar em cada boot de desenvolvimento).
  - Notes: Considerar delegar o reset manual ao `rescue.html` e a um botão explícito de “Limpeza Completa”, para evitar interações com DevTools em dev.
- [ ] **Task 3: Aposentar `public/service-worker.js` como worker ativo padrão**
  - File: `apps/web/public/service-worker.js`
  - Action: Documentar no cabeçalho que este arquivo é um kill-switch legado. Alterar o build/configuração (se necessário) para garantir que o SW efetivo usado pelo app em produção seja o gerado pelo VitePWA (`dist/sw-*.js` via `generateSW`), não este arquivo estático. Se o arquivo não for mais necessário, marcá-lo para remoção em fase posterior (ou movê-lo para pasta de scripts de migração).
  - Notes: Confirmar, na pipeline de deploy, qual SW está sendo servido em `/service-worker.js` e alinhar isso com o VitePWA.
- [ ] **Task 4: Implementar wrapper de registro alinhado ao VitePWA com padrão “Update Available”**
  - File: `apps/web/src/utils/serviceWorkerRegistration.ts`
  - Action:
    - Substituir o registro manual com `navigator.serviceWorker.register('/service-worker.js')` por um wrapper compatível com o VitePWA/ReloadPrompt (por exemplo, usando `registerSW` de `vite-plugin-pwa/client` ou padrão equivalente).
    - Implementar lógica de:
      - Escutar `updatefound` no `registration`.
      - Quando o novo worker chegar a `state === 'installed'` **e** houver um `registration.waiting`, disparar callback de “update available” para a UI (snackbar).
      - Implementar função `sendSkipWaiting()` que posta `message` `{type: 'SKIP_WAITING'}` para `registration.waiting`.
      - Registrar um listener global de `navigator.serviceWorker.addEventListener('controllerchange', ...)` que, após a primeira troca de controller, faz `window.location.reload()` uma única vez.
  - Notes: Evitar o uso de `confirm()`/`alert()`; expor em vez disso callbacks tipo `onUpdateAvailable`, `onUpdated`.
- [ ] **Task 5: Criar componente de UI de atualização (snackbar/toast)**
  - File: `apps/web/src/components/ReloadPrompt.tsx` (ou novo `UpdateSnackbar.tsx`, se preferir)
  - Action:
    - Implementar componente que recebe sinal do `serviceWorkerRegistration` (ex.: via hook, contexto ou callback) quando há atualização disponível.
    - Renderizar snackbar com mensagem “Nova versão do PROFEPLAN disponível” e botões “Atualizar agora” / “Depois”.
    - Ao clicar em “Atualizar agora”, chamar `sendSkipWaiting()` e aguardar `controllerchange` para recarregar a página.
  - Notes: Integrar componente na árvore principal (por exemplo, em `App.tsx` próximo a `<OfflineIndicator />`).
- [ ] **Task 6: Ajustar configuração do VitePWA se necessário**
  - File: `apps/web/vite.config.ts`
  - Action:
    - Revisar a configuração atual do `VitePWA` (`generateSW`, `registerType: 'autoUpdate'`, `injectRegister: false`, `swDest: 'sw-dummy.js'`).
    - Garantir que:
      - O SW gerado seja registrado via wrapper (`registerSW`) ou util equivalente.
      - `swDest` não conflite com o caminho usado na aplicação (`/service-worker.js` vs `sw-dummy.js`).
      - A estratégia de `autoUpdate` não conflite com o padrão “Update Available” implementado; se necessário, documentar a combinação (ex.: auto-fetch do novo SW + notificação via snackbar).
  - Notes: Este passo é mais de alinhamento e documentação; mudanças pesadas de cache ficam fora de escopo.
- [ ] **Task 7: Documentar e isolar caminho de resgate (`public/rescue.html`)**
  - File: `apps/web/public/rescue.html`
  - Action:
    - Revisar o script de resgate para garantir que: desregistra SWs, limpa caches, limpa storages e recarrega com cache-buster.
    - Documentar no cabeçalho em quais cenários este arquivo deve ser utilizado (ex.: instruções para suporte/QA).
  - Notes: Garantir que o uso de `rescue.html` seja totalmente manual e não interfira com o fluxo normal do app.

### Acceptance Criteria

- [ ] **AC 1: Nenhum loop de recarregamento em dev com DevTools aberto**
  - Given que estou rodando o app em `localhost` com o DevTools aberto (aba Application → Service Workers) e a flag “Update on reload” ativada,
  - When eu recarrego a página várias vezes,
  - Then a aplicação não entra em loop de recarregamento automático, e os logs de Service Worker não mostram reloads em cascata provocados pela lógica de `controllerchange`.

- [ ] **AC 2: Atualização controlada via snackbar**
  - Given que uma nova versão do bundle foi gerada e o SW baixou uma nova versão (estado `waiting`),
  - When eu abro o app e o novo SW entra em `waiting`,
  - Then vejo um snackbar/toast informando que há uma nova versão disponível, com opção clara de “Atualizar agora”.

- [ ] **AC 3: Comportamento de “Atualizar agora” com skipWaiting + controllerchange**
  - Given que o snackbar de atualização está visível,
  - When eu clico em “Atualizar agora”,
  - Then o cliente envia uma mensagem `SKIP_WAITING` para o SW em `waiting`, escuta o evento `controllerchange` **uma única vez** e recarrega a página após o novo Service Worker assumir o controle.

- [ ] **AC 4: Nenhuma confirmação bloqueante (confirm/alert) para atualização**
  - Given que um novo SW foi instalado e está em `waiting`,
  - When a interface oferece a atualização,
  - Then não vejo diálogos nativos bloqueantes como `alert()` ou `confirm()`, apenas a UI de snackbar/toast.

- [ ] **AC 5: Kill-switch e resets nucleares não interferem no fluxo normal**
  - Given que estou usando o app normalmente em dev ou produção, sem acessar `rescue.html` e sem parâmetros especiais de reset,
  - When o app é carregado e o SW é atualizado,
  - Then nenhum fluxo de “nuclear reset” (unregister + clear caches + hard reload) é disparado automaticamente; esses fluxos só são acionados explicitamente (ex.: via `rescue.html` ou ações de suporte).

- [ ] **AC 6: Headers adequados para o script do Service Worker**
  - Given que o app está rodando em produção,
  - When faço uma requisição HTTP para o script do Service Worker (ex.: `/sw-dummy.js` ou `/service-worker.js`, conforme configuração final),
  - Then os headers HTTP incluem diretivas de cache equivalentes a `Cache-Control: no-store, no-cache, must-revalidate, max-age=0`, garantindo que o navegador sempre valide o SW mais recente.

## Additional Context

### Dependencies

- `vite-plugin-pwa` devidamente configurado no `vite.config.ts`.
- Navegadores com suporte a Service Workers e API de mensagens entre cliente e SW.
- Eventual suporte de infraestrutura (servidor/hosting) para configurar headers HTTP do script do Service Worker.

### Testing Strategy

- **Testes manuais em desenvolvimento (localhost):**
  - Observar o comportamento do Service Worker na aba Application → Service Workers com “Update on reload” ligado e desligado, assegurando que não há loops.
  - Simular nova versão (alterando um arquivo e rodando build/dev) para verificar a aparição do snackbar de atualização e o fluxo `skipWaiting + controllerchange`.
- **Testes manuais em produção/staging:**
  - Verificar headers HTTP do SW via DevTools → Network.
  - Confirmar que uma nova versão do app dispara a notificação de atualização e que o fluxo é confiável.
- **Testes automatizados (quando viável):**
  - Criar testes de integração end-to-end (ex.: Playwright) em ambiente de CI que verifiquem:
    - Registro bem-sucedido do SW.
    - Presença do snackbar quando uma nova versão é detectada (pode ser simulado com mock do registro).

### Notes

- Os fluxos de reset nuclear existentes são valiosos como “último recurso”, mas devem ser cuidadosamente isolados para não mascarar problemas de ciclo de vida do Service Worker em ambiente de desenvolvimento.
- Esta refatoração prepara o terreno para, em uma fase futura, projetar uma política de cache offline robusta (Workbox) sem reintroduzir loops ou inconsistências de atualização.

## Additional Context

### Dependencies

- Navegadores modernos com suporte a Service Workers (Chrome, Edge, etc.).
- Configuração de build do Vite/VitePWA já funcional na aplicação atual.

### Testing Strategy

- Focada inicialmente em ambiente de desenvolvimento (localhost) com DevTools, observando logs de registro/atualização e verificando que não há loops de recarregamento ao alternar a flag "Update on reload".

### Notes

- O foco imediato é eliminar loops e ruídos de desenvolvimento, preparando a base para uma estratégia de cache offline mais robusta em fases posteriores.

