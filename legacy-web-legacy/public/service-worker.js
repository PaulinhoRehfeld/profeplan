/**
 * LEGACY KILL-SWITCH SERVICE WORKER (Vanilla JS)
 * ------------------------------------------------
 * Este arquivo foi usado como solução emergencial para quebrar ciclos
 * de cache em versões antigas (ex.: v3.9.1). O Service Worker oficial
 * da aplicação agora é gerado e gerenciado pelo VitePWA (generateSW).
 *
 * NÃO registre este arquivo manualmente no código de produção.
 * Use apenas em cenários de migração/emergência documentados.
 */

self.addEventListener('install', (event) => {
    console.log('[SW-Kill] Installing and skipping wait...');
    self.skipWaiting();
});

self.addEventListener('activate', (event) => {
    console.log('[SW-Kill] Activating and purging all caches...');
    event.waitUntil(
        caches.keys().then((names) => {
            return Promise.all(names.map(name => {
                console.log('[SW-Kill] Deleting cache:', name);
                return caches.delete(name);
            }));
        }).then(() => {
            console.log('[SW-Kill] Caches purged. Unregistering self...');
            return self.registration.unregister();
        }).then(() => {
            console.log('[SW-Kill] Unregistered. Relaying to clients...');
            return self.clients.matchAll();
        }).then((clients) => {
            clients.forEach(client => {
                if (client.url) {
                    console.log('[SW-Kill] Notifying client to reload:', client.url);
                    client.navigate(client.url);
                }
            });
        })
    );
});

// No fetch listener to allow direct network access
