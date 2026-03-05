
/// <reference types="vite-plugin-pwa/client" />

// ====== Web Speech API Types (not yet in standard lib) ======
interface SpeechRecognitionEvent extends Event {
    readonly results: SpeechRecognitionResultList;
    readonly resultIndex: number;
}
interface SpeechRecognitionResultList {
    readonly length: number;
    item(index: number): SpeechRecognitionResult;
    [index: number]: SpeechRecognitionResult;
}
interface SpeechRecognitionResult {
    readonly length: number;
    item(alterIndex: number): SpeechRecognitionAlternative;
    [index: number]: SpeechRecognitionAlternative;
    readonly isFinal: boolean;
}
interface SpeechRecognitionAlternative {
    readonly transcript: string;
    readonly confidence: number;
}
interface SpeechRecognition extends EventTarget {
    lang: string;
    interimResults: boolean;
    maxAlternatives: number;
    continuous: boolean;
    onresult: ((event: SpeechRecognitionEvent) => void) | null;
    onerror: ((event: Event) => void) | null;
    onend: (() => void) | null;
    onstart: (() => void) | null;
    start(): void;
    stop(): void;
    abort(): void;
}
interface SpeechRecognitionConstructor {
    new(): SpeechRecognition;
}
declare global {
    interface Window {
        SpeechRecognition: SpeechRecognitionConstructor | undefined;
        webkitSpeechRecognition: SpeechRecognitionConstructor | undefined;
    }
}

declare module 'virtual:pwa-register/react' {
    import type { RegisterSWOptions } from 'vite-plugin-pwa/types'

    export type { RegisterSWOptions }

    export function useRegisterSW(options?: RegisterSWOptions): {
        needRefresh: [boolean, (needRefresh: boolean) => void]
        offlineReady: [boolean, (offlineReady: boolean) => void]
        updateServiceWorker: (reloadPage?: boolean) => Promise<void>
    }
}
