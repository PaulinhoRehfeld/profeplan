# Story: Implement FREEDAY Voice Assistant

**Status:** In Progress
**Agent:** Dev (Amelia)
**User:** PAULINHO

## Mission 1: Arquitetura Global (Frontend)
- [ ] Criar `FreedayProvider` (React Context) em `apps/web/src/contexts/FreedayContext.tsx` para gerenciar o estado global da IA (isListening, isSpeaking, messages).
- [ ] Injetar o provider no `apps/web/src/index.tsx` (ou ponto de entrada similar) para que a FREEDAY envolva todo o CRM.
- [ ] Criar componente `GlobalFreedayUI.tsx` em `apps/web/src/components/GlobalFreedayUI.tsx`. Deve ser um widget flutuante persistente (z-index alto, bottom-right). Usar framer-motion ou CSS Tailwind para animar 3 estados visuais: 'Dormindo', 'Ouvindo' (onda sonora) e 'Falando'.

## Mission 2: Captura e Síntese de Voz (Ouvidos e Boca)
- [ ] Integrar Web Speech API (SpeechRecognition) dentro do contexto para capturar voz e transformar em texto.
- [ ] Ao detectar fim da fala, enviar para `/api/freeday` (ou equivalente adaptado para esta stack).
- [ ] Usar SpeechSynthesis API para ler resposta em voz alta (voz pt-BR).

## Mission 3: O Cérebro na Azure (Backend)
- [ ] Implementar integração com Azure OpenAI via Vercel AI SDK.
- [ ] Configurar system prompt da FREEDAY (direta, executiva, sem markdown).
- [ ] Configurar tools (mocks): `consultarFichaCliente`, `verResumoDoDia`, `verificarRiscosDeChurn`.

## Dev Agent Record
- **2025-03-04**: Inicialização do agente Dev. Carregamento de config.yaml para o usuário PAULINHO.
- **2025-03-04**: Criação deste arquivo de story para rastrear progresso. Adaptação de caminhos de Next.js para Vite/React.
