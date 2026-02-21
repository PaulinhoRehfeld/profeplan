/**
 * SERVICE WORKER REGISTRATION
 * ============================
 * 
 * Registra o service worker para suporte offline
 * Deve ser importado no main.tsx ou App.tsx
 */

export const registerServiceWorker = async (): Promise<ServiceWorkerRegistration | null> => {
    if ('serviceWorker' in navigator) {
        try {
            console.log('[SW Registration] Registering service worker...');

            const registration = await navigator.serviceWorker.register('/service-worker.js', {
                scope: '/'
            });

            console.log('[SW Registration] ✅ Service Worker registered successfully');
            console.log('[SW Registration] Scope:', registration.scope);

            // Verificar status
            if (registration.installing) {
                console.log('[SW Registration] Service Worker installing...');
            } else if (registration.waiting) {
                console.log('[SW Registration] Service Worker installed, waiting to activate');
            } else if (registration.active) {
                console.log('[SW Registration] Service Worker active');
            }

            // Listener para atualizações
            registration.addEventListener('updatefound', () => {
                const newWorker = registration.installing;
                console.log('[SW Registration] New service worker found, installing...');

                newWorker?.addEventListener('statechange', () => {
                    if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
                        console.log('[SW Registration] 🔄 New version available, reload to update');
                        // Opcional: notificar usuário sobre atualização
                        notifyUserAboutUpdate();
                    }
                });
            });

            return registration;
        } catch (error) {
            console.error('[SW Registration] ❌ Service Worker registration failed:', error);
            return null;
        }
    } else {
        console.warn('[SW Registration] ⚠️ Service Workers not supported in this browser');
        return null;
    }
};

/**
 * Desregistra o service worker
 */
export const unregisterServiceWorker = async (): Promise<boolean> => {
    if ('serviceWorker' in navigator) {
        const registration = await navigator.serviceWorker.ready;
        const success = await registration.unregister();
        console.log(success ? '[SW] ✅ Unregistered' : '[SW] ❌ Failed to unregister');
        return success;
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
 * Notifica usuário sobre atualização disponível
 */
function notifyUserAboutUpdate(): void {
    const shouldReload = confirm(
        '🔄 Nova versão disponível!\n\nDeseja recarregar para atualizar?'
    );

    if (shouldReload) {
        window.location.reload();
    }
}

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
