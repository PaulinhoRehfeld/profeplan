
/// <reference types="vite-plugin-pwa/client" />
declare module 'virtual:pwa-register/react' {
    import type { RegisterSWOptions } from 'vite-plugin-pwa/types'

    export type { RegisterSWOptions }

    export function useRegisterSW(options?: RegisterSWOptions): {
        needRefresh: [boolean, (needRefresh: boolean) => void]
        offlineReady: [boolean, (offlineReady: boolean) => void]
        updateServiceWorker: (reloadPage?: boolean) => Promise<void>
    }
}
