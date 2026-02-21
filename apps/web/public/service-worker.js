/**
 * SERVICE WORKER - OFFLINE SUPPORT
 * ==================================
 * 
 * Service Worker para cache de assets e suporte offline
 * 
 * Features:
 * - Cache de assets estáticos (JS, CSS, imagens)
 * - Cache de questões para acesso offline
 * - Sincronização em background
 * - Notificações de status online/offline
 */

const CACHE_VERSION = 'profeplan-simulation-v2';
const STATIC_CACHE = `${CACHE_VERSION}-static`;
const DYNAMIC_CACHE = `${CACHE_VERSION}-dynamic`;
const QUESTIONS_CACHE = `${CACHE_VERSION}-questions`;

// Assets para pré-cache
const STATIC_ASSETS = [
    '/',
    '/index.html',
    '/manifest.json',
    // Adicionar mais assets conforme necessário
];

// Install Event - Pré-cache de assets estáticos
self.addEventListener('install', (event) => {
    console.log('[SW] Installing Service Worker');

    event.waitUntil(
        caches.open(STATIC_CACHE).then((cache) => {
            console.log('[SW] Caching static assets');
            return cache.addAll(STATIC_ASSETS);
        })
    );

    self.skipWaiting();
});

// Activate Event - Limpar caches antigos
self.addEventListener('activate', (event) => {
    console.log('[SW] Activating Service Worker');

    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames
                    .filter((name) => name.startsWith('profeplan-simulation-') && name !== STATIC_CACHE && name !== DYNAMIC_CACHE && name !== QUESTIONS_CACHE)
                    .map((name) => {
                        console.log('[SW] Deleting old cache:', name);
                        return caches.delete(name);
                    })
            );
        })
    );

    return self.clients.claim();
});

// Fetch Event - Estratégia de cache
self.addEventListener('fetch', (event) => {
    const { request } = event;
    const url = new URL(request.url);

    // Apenas interceptar requests do mesmo origin
    if (url.origin !== location.origin) {
        return;
    }

    // Estratégia: Cache First para assets estáticos
    if (isStaticAsset(url.pathname)) {
        event.respondWith(cacheFirst(request, STATIC_CACHE));
        return;
    }

    // Estratégia: Network First para API calls (com fallback para cache)
    if (isApiCall(url.pathname)) {
        event.respondWith(networkFirst(request, DYNAMIC_CACHE));
        return;
    }

    // Estratégia: Stale While Revalidate para questões
    if (isQuestionRequest(url.pathname)) {
        event.respondWith(staleWhileRevalidate(request, QUESTIONS_CACHE));
        return;
    }

    // Default: Network First
    event.respondWith(networkFirst(request, DYNAMIC_CACHE));
});

// ==================== CACHE STRATEGIES ====================

/**
 * Cache First - Busca cache primeiro, depois network
 */
async function cacheFirst(request, cacheName) {
    const cachedResponse = await caches.match(request);

    if (cachedResponse) {
        console.log('[SW] Cache hit:', request.url);
        return cachedResponse;
    }

    console.log('[SW] Cache miss, fetching:', request.url);
    const networkResponse = await fetch(request);

    // Cache a resposta para próxima vez
    const cache = await caches.open(cacheName);
    cache.put(request, networkResponse.clone());

    return networkResponse;
}

/**
 * Network First - Tenta network primeiro, fallback para cache
 */
async function networkFirst(request, cacheName) {
    try {
        const networkResponse = await fetch(request);

        // Cache a resposta bem-sucedida
        const cache = await caches.open(cacheName);
        cache.put(request, networkResponse.clone());

        return networkResponse;
    } catch (error) {
        console.log('[SW] Network failed, trying cache:', request.url);
        const cachedResponse = await caches.match(request);

        if (cachedResponse) {
            return cachedResponse;
        }

        // Se não tem cache, retornar erro
        return new Response('Offline - No cached data available', {
            status: 503,
            statusText: 'Service Unavailable'
        });
    }
}

/**
 * Stale While Revalidate - Retorna cache imediatamente, atualiza em background
 */
async function staleWhileRevalidate(request, cacheName) {
    const cachedResponse = await caches.match(request);

    const fetchPromise = fetch(request).then((networkResponse) => {
        const cache = caches.open(cacheName);
        cache.then((c) => c.put(request, networkResponse.clone()));
        return networkResponse;
    }).catch(() => {
        // Network falhou, mas já retornamos cache
        console.log('[SW] Network failed, using stale cache');
    });

    // Retorna cache imediatamente se disponível, senão aguarda network
    return cachedResponse || fetchPromise;
}

// ==================== HELPERS ====================

function isStaticAsset(pathname) {
    return (
        pathname.endsWith('.js') ||
        pathname.endsWith('.css') ||
        pathname.endsWith('.png') ||
        pathname.endsWith('.jpg') ||
        pathname.endsWith('.svg') ||
        pathname.endsWith('.woff') ||
        pathname.endsWith('.woff2')
    );
}

function isApiCall(pathname) {
    return pathname.includes('/api/') || pathname.includes('/rest/v1/');
}

function isQuestionRequest(pathname) {
    return pathname.includes('enem_questions');
}

// ==================== BACKGROUND SYNC ====================

// Registrar sync para quando voltar online
self.addEventListener('sync', (event) => {
    console.log('[SW] Background sync triggered:', event.tag);

    if (event.tag === 'sync-analytics') {
        event.waitUntil(syncAnalytics());
    }
});

async function syncAnalytics() {
    console.log('[SW] Syncing analytics...');
    // Lógica de sincronização de analytics pendentes
    // TODO: Implementar fila de eventos offline
}

// ==================== PUSH NOTIFICATIONS ====================

self.addEventListener('push', (event) => {
    console.log('[SW] Push notification received');

    const data = event.data ? event.data.json() : {};
    const title = data.title || 'Profeplan Simulados';
    const options = {
        body: data.body || 'Nova atualização disponível',
        icon: '/icon-192.png',
        badge: '/badge-72.png',
        data: data
    };

    event.waitUntil(
        self.registration.showNotification(title, options)
    );
});

self.addEventListener('notificationclick', (event) => {
    console.log('[SW] Notification clicked');
    event.notification.close();

    event.waitUntil(
        clients.openWindow(event.notification.data.url || '/')
    );
});
