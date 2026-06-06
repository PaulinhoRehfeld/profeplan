/**
 * SERVICE WORKER REGISTRATION (LEGACY HELPERS)
 * ============================================
 *
 * O ciclo de vida oficial do Service Worker é gerenciado pelo VitePWA
 * via `useRegisterSW` (ver `ReloadPrompt`). Estas funções permanecem
 * apenas como utilitários auxiliares para módulos que queiram inspecionar
 * ou limpar SWs manualmente.
 */

/**
 * @deprecated
 * O registro global do Service Worker é feito pelo VitePWA.
 * Esta função hoje é um no-op seguro para evitar duplo registro.
 */
export const registerServiceWorker = async (): Promise<ServiceWorkerRegistration | null> => {
    console.warn('[SW Registration] registerServiceWorker é legado – o SW é gerenciado pelo VitePWA/ReloadPrompt. Nenhuma ação realizada.');
    return null;
};

export const unregisterServiceWorker = async (): Promise<boolean> => {
    if ('serviceWorker' in navigator) {
        try {
            const registrations = await navigator.serviceWorker.getRegistrations();
            await Promise.all(registrations.map(r => r.unregister()));
            console.log('[SW] ✅ All service workers unregistered via helper');
            return true;
        } catch (err) {
            console.error('[SW] ❌ Failed to unregister all service workers:', err);
            return false;
        }
    }
    return false;
};

/**
 * Verifica se está online/offline
 */
export const checkOnlineStatus = (): boolean => {
    return navigator.onLine;
};

/**
 * Listener para mudanças de status online/offline
 */
export const setupOnlineStatusListeners = (
    onOnline?: () => void,
    onOffline?: () => void
): void => {
    window.addEventListener('online', () => {
        console.log('[Connectivity] 🟢 Back online');
        onOnline?.();
    });

    window.addEventListener('offline', () => {
        console.log('[Connectivity] 🔴 Gone offline');
        onOffline?.();
    });
};

/**
 * Hook React para status online/offline
 */
export const useOnlineStatus = (): boolean => {
    const [isOnline, setIsOnline] = React.useState(navigator.onLine);

    React.useEffect(() => {
        const handleOnline = () => setIsOnline(true);
        const handleOffline = () => setIsOnline(false);

        window.addEventListener('online', handleOnline);
        window.addEventListener('offline', handleOffline);

        return () => {
            window.removeEventListener('online', handleOnline);
            window.removeEventListener('offline', handleOffline);
        };
    }, []);

    return isOnline;
};

// TypeScript fix for React
import * as React from 'react';
