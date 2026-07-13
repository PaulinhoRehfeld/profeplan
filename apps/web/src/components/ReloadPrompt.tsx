import React from 'react';
import { useRegisterSW } from 'virtual:pwa-register/react';
import { Sparkle, RefreshCcw } from 'lucide-react';

export function ReloadPrompt() {
  const {
    offlineReady: [offlineReady, setOfflineReady],
    needRefresh: [needRefresh, setNeedRefresh],
    updateServiceWorker,
  } = useRegisterSW({
    onRegistered(r) {
      console.log('SW Registered: ' + r);
    },
    onRegisterError(error) {
      console.log('SW registration error', error);
    },
  });

  const dismissKey = 'pwa-update-dismissed';

  const close = () => {
    sessionStorage.setItem(dismissKey, 'true');
    setOfflineReady(false);
    setNeedRefresh(false);
  };

  const onUpdate = async () => {
    console.log('[ReloadPrompt] Clearing all caches before update...');
    try {
      const cacheNames = await caches.keys();
      await Promise.all(cacheNames.map((name) => caches.delete(name)));
      console.log('[ReloadPrompt] Caches cleared successfully.');
    } catch (err) {
      console.error('[ReloadPrompt] Error clearing caches:', err);
    }

    // Ativar o novo service worker
    await updateServiceWorker(true);

    // Forçar reload limpo para buscar nova versão
    window.location.reload();
  };

  // Não mostrar se o usuário já dispensou nesta sessão
  const isDismissed = sessionStorage.getItem(dismissKey) === 'true';

  if (isDismissed && needRefresh) return null;

  return (
    <div className="ReloadPrompt-container">
      {(offlineReady || (needRefresh && !isDismissed)) && (
        <div className="fixed bottom-4 right-4 z-50 p-4 bg-slate-900 text-white rounded-xl shadow-2xl flex flex-col gap-2 max-w-sm border border-slate-700 animate-in slide-in-from-bottom duration-500">
          <div className="flex items-center gap-2 mb-1">
            <Sparkle className="text-emerald-400" size={16} />
            <span className="font-bold text-sm">
              {offlineReady ? 'App pronto para uso offline' : 'Nova versão disponível!'}
            </span>
          </div>
          <div className="text-xs text-slate-300 mb-2">
            {offlineReady
              ? 'O Profeplan agora funciona sem internet.'
              : 'Uma atualização crítica foi lançada. Religar para aplicar correções.'}
          </div>
          <div className="flex gap-2">
            {needRefresh && (
              <button
                className="flex-1 bg-emerald-500 hover:bg-emerald-600 text-white px-3 py-1.5 rounded-lg text-xs font-bold transition-colors flex items-center justify-center gap-1"
                onClick={onUpdate}
              >
                <RefreshCcw size={12} />
                Atualizar Agora
              </button>
            )}
            <button
              className="flex-1 bg-slate-800 hover:bg-slate-700 text-slate-300 px-3 py-1.5 rounded-lg text-xs font-bold transition-colors"
              onClick={close}
            >
              Fechar
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
