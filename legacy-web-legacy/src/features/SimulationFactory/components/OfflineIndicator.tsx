/**
 * OFFLINE INDICATOR COMPONENT
 * ============================
 * 
 * Indicador visual de status online/offline
 * Mostra banner quando usuário está offline
 */

import React from 'react';
import { Wifi, WifiOff } from 'lucide-react';
import { useOnlineStatus } from '../../../utils/serviceWorkerRegistration';

interface OfflineIndicatorProps {
    compact?: boolean;
}

export const OfflineIndicator: React.FC<OfflineIndicatorProps> = ({ compact = false }) => {
    const isOnline = useOnlineStatus();
    const [showBanner, setShowBanner] = React.useState(false);
    const [wasOffline, setWasOffline] = React.useState(false);

    React.useEffect(() => {
        if (!isOnline) {
            setShowBanner(true);
            setWasOffline(true);
        } else if (wasOffline) {
            // Mostrar mensagem de "Voltou online" temporariamente
            setShowBanner(true);
            setTimeout(() => setShowBanner(false), 3000);
        }
    }, [isOnline, wasOffline]);

    if (!showBanner) return null;

    if (compact) {
        return (
            <div
                className={`
          fixed top-4 right-4 z-50 px-4 py-2 rounded-lg shadow-lg
          flex items-center gap-2 text-sm font-semibold
          ${isOnline
                        ? 'bg-green-500 text-white'
                        : 'bg-red-500 text-white'
                    }
        `}
            >
                {isOnline ? <Wifi size={16} /> : <WifiOff size={16} />}
                {isOnline ? 'Online' : 'Offline'}
            </div>
        );
    }

    return (
        <div
            className={`
        fixed top-0 left-0 right-0 z-50 py-3 px-6
        flex items-center justify-center gap-3
        text-white font-semibold shadow-lg
        ${isOnline
                    ? 'bg-gradient-to-r from-green-500 to-emerald-600'
                    : 'bg-gradient-to-r from-red-500 to-rose-600'
                }
      `}
        >
            {isOnline ? <Wifi size={20} /> : <WifiOff size={20} />}
            {isOnline ? (
                <>
                    ✅ Conexão restaurada! Sincronizando dados...
                </>
            ) : (
                <>
                    ⚠️ Você está offline. Algumas funcionalidades podem estar limitadas.
                </>
            )}
        </div>
    );
};

/**
 * Badge de status (para usar em outros componentes)
 */
export const OnlineStatusBadge: React.FC<{ className?: string }> = ({ className = '' }) => {
    const isOnline = useOnlineStatus();

    return (
        <div
            className={`
        inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-bold
        ${isOnline
                    ? 'bg-green-100 text-green-700'
                    : 'bg-red-100 text-red-700'
                }
        ${className}
      `}
            title={isOnline ? 'Conectado' : 'Offline'}
        >
            <div
                className={`
          w-2 h-2 rounded-full
          ${isOnline ? 'bg-green-500 animate-pulse' : 'bg-red-500'}
        `}
            />
            {isOnline ? 'Online' : 'Offline'}
        </div>
    );
};
