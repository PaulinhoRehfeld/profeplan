/**
 * SIMULATION CACHE SERVICE
 * =========================
 *
 * Cache local usando IndexedDB para performance
 * Reduz latência e permite uso offline
 *
 * Features:
 * - Cache de resultados de busca
 * - TTL (Time To Live) configurável
 * - Fallback para localStorage
 * - Gerenciamento automático de espaço
 */

import { SimulationQuestion, QuestionSearchResult } from '../types/question.types';

interface CachedSearchResult {
  key: string;
  result: QuestionSearchResult;
  timestamp: number;
  ttl: number; // milissegundos
}

interface CacheStats {
  totalEntries: number;
  totalSize: number; // bytes aproximados
  oldestEntry: number;
  newestEntry: number;
}

class SimulationCacheService {
  private dbName = 'ProfeplanSimulationCache';
  private version = 1;
  private storeName = 'searchResults';
  private db: IDBDatabase | null = null;
  private defaultTTL = 1000 * 60 * 60; // 1 hora

  /**
   * Inicializa o IndexedDB
   */
  async init(): Promise<void> {
    if (this.db) return;

    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.dbName, this.version);

      request.onerror = () => {
        console.error('[Cache] IndexedDB error:', request.error);
        reject(request.error);
      };

      request.onsuccess = () => {
        this.db = request.result;
        console.log('[Cache] ✅ IndexedDB initialized');
        resolve();
      };

      request.onupgradeneeded = (event) => {
        const db = (event.target as IDBOpenDBRequest).result;

        // Criar object store se não existir
        if (!db.objectStoreNames.contains(this.storeName)) {
          const objectStore = db.createObjectStore(this.storeName, { keyPath: 'key' });
          objectStore.createIndex('timestamp', 'timestamp', { unique: false });
          console.log('[Cache] 🔧 Object store created');
        }
      };
    });
  }

  /**
   * Gera chave única para cache baseada nos parâmetros de busca
   */
  private generateCacheKey(query: string, areas?: string[]): string {
    const normalizedQuery = query.toLowerCase().trim();
    const normalizedAreas = areas?.sort().join(',') || 'all';
    return `search:${normalizedQuery}:${normalizedAreas}`;
  }

  /**
   * Busca resultado no cache
   */
  async get(query: string, areas?: string[]): Promise<QuestionSearchResult | null> {
    try {
      await this.init();
      if (!this.db) return null;

      const key = this.generateCacheKey(query, areas);

      return new Promise((resolve) => {
        const transaction = this.db!.transaction([this.storeName], 'readonly');
        const objectStore = transaction.objectStore(this.storeName);
        const request = objectStore.get(key);

        request.onsuccess = () => {
          const cached: CachedSearchResult | undefined = request.result;

          if (!cached) {
            console.log(`[Cache] ❌ Miss: ${key}`);
            resolve(null);
            return;
          }

          // Verificar TTL
          const now = Date.now();
          const age = now - cached.timestamp;

          if (age > cached.ttl) {
            console.log(`[Cache] ⏰ Expired: ${key} (age: ${Math.round(age / 1000)}s)`);
            this.delete(key); // Limpar cache expirado
            resolve(null);
            return;
          }

          console.log(`[Cache] ✅ Hit: ${key} (age: ${Math.round(age / 1000)}s)`);
          resolve(cached.result);
        };

        request.onerror = () => {
          console.error('[Cache] Get error:', request.error);
          resolve(null);
        };
      });
    } catch (error) {
      console.error('[Cache] Get exception:', error);
      return null;
    }
  }

  /**
   * Armazena resultado no cache
   */
  async set(
    query: string,
    result: QuestionSearchResult,
    areas?: string[],
    ttl: number = this.defaultTTL
  ): Promise<void> {
    try {
      await this.init();
      if (!this.db) return;

      const key = this.generateCacheKey(query, areas);
      const cached: CachedSearchResult = {
        key,
        result,
        timestamp: Date.now(),
        ttl,
      };

      return new Promise((resolve, reject) => {
        const transaction = this.db!.transaction([this.storeName], 'readwrite');
        const objectStore = transaction.objectStore(this.storeName);
        const request = objectStore.put(cached);

        request.onsuccess = () => {
          console.log(`[Cache] 💾 Saved: ${key} (${result.questions.length} questions)`);
          resolve();
        };

        request.onerror = () => {
          console.error('[Cache] Set error:', request.error);
          reject(request.error);
        };
      });
    } catch (error) {
      console.error('[Cache] Set exception:', error);
    }
  }

  /**
   * Remove entrada do cache
   */
  async delete(key: string): Promise<void> {
    try {
      await this.init();
      if (!this.db) return;

      return new Promise((resolve, reject) => {
        const transaction = this.db!.transaction([this.storeName], 'readwrite');
        const objectStore = transaction.objectStore(this.storeName);
        const request = objectStore.delete(key);

        request.onsuccess = () => {
          console.log(`[Cache] 🗑️ Deleted: ${key}`);
          resolve();
        };

        request.onerror = () => {
          console.error('[Cache] Delete error:', request.error);
          reject(request.error);
        };
      });
    } catch (error) {
      console.error('[Cache] Delete exception:', error);
    }
  }

  /**
   * Limpa todo o cache
   */
  async clear(): Promise<void> {
    try {
      await this.init();
      if (!this.db) return;

      return new Promise((resolve, reject) => {
        const transaction = this.db!.transaction([this.storeName], 'readwrite');
        const objectStore = transaction.objectStore(this.storeName);
        const request = objectStore.clear();

        request.onsuccess = () => {
          console.log('[Cache] 🧹 Cache cleared');
          resolve();
        };

        request.onerror = () => {
          console.error('[Cache] Clear error:', request.error);
          reject(request.error);
        };
      });
    } catch (error) {
      console.error('[Cache] Clear exception:', error);
    }
  }

  /**
   * Remove entradas expiradas
   */
  async pruneExpired(): Promise<number> {
    try {
      await this.init();
      if (!this.db) return 0;

      return new Promise((resolve) => {
        const transaction = this.db!.transaction([this.storeName], 'readwrite');
        const objectStore = transaction.objectStore(this.storeName);
        const request = objectStore.openCursor();
        let deletedCount = 0;

        request.onsuccess = (event) => {
          const cursor = (event.target as IDBRequest).result as IDBCursorWithValue | null;

          if (cursor) {
            const cached: CachedSearchResult = cursor.value;
            const now = Date.now();
            const age = now - cached.timestamp;

            if (age > cached.ttl) {
              cursor.delete();
              deletedCount++;
            }

            cursor.continue();
          } else {
            console.log(`[Cache] 🧹 Pruned ${deletedCount} expired entries`);
            resolve(deletedCount);
          }
        };

        request.onerror = () => {
          console.error('[Cache] Prune error:', request.error);
          resolve(0);
        };
      });
    } catch (error) {
      console.error('[Cache] Prune exception:', error);
      return 0;
    }
  }

  /**
   * Obtém estatísticas do cache
   */
  async getStats(): Promise<CacheStats> {
    try {
      await this.init();
      if (!this.db) {
        return { totalEntries: 0, totalSize: 0, oldestEntry: 0, newestEntry: 0 };
      }

      return new Promise((resolve) => {
        const transaction = this.db!.transaction([this.storeName], 'readonly');
        const objectStore = transaction.objectStore(this.storeName);
        const request = objectStore.openCursor();

        let totalEntries = 0;
        let totalSize = 0;
        let oldestEntry = Date.now();
        let newestEntry = 0;

        request.onsuccess = (event) => {
          const cursor = (event.target as IDBRequest).result as IDBCursorWithValue | null;

          if (cursor) {
            const cached: CachedSearchResult = cursor.value;
            totalEntries++;
            totalSize += JSON.stringify(cached).length;

            if (cached.timestamp < oldestEntry) oldestEntry = cached.timestamp;
            if (cached.timestamp > newestEntry) newestEntry = cached.timestamp;

            cursor.continue();
          } else {
            console.log(
              `[Cache] 📊 Stats: ${totalEntries} entries, ~${Math.round(totalSize / 1024)}KB`
            );
            resolve({ totalEntries, totalSize, oldestEntry, newestEntry });
          }
        };

        request.onerror = () => {
          console.error('[Cache] Stats error:', request.error);
          resolve({ totalEntries: 0, totalSize: 0, oldestEntry: 0, newestEntry: 0 });
        };
      });
    } catch (error) {
      console.error('[Cache] Stats exception:', error);
      return { totalEntries: 0, totalSize: 0, oldestEntry: 0, newestEntry: 0 };
    }
  }
}

// Singleton export
export const simulationCache = new SimulationCacheService();
