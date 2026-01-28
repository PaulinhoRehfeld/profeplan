import { useState, useEffect } from 'react';
import { UserSettings } from '../types';

export const useProfeplanSettings = () => {
    const defaultSettings: UserSettings = {
        userName: 'Professor(a)',
        institution: '',
        network: 'Estadual',
        stateUF: 'MG',
        favoriteMethodology: 'Gamification',
        toneOfVoice: 'Prático e Inspiracional',
        detailLevel: 'Completo',
        theme: 'light'
    };

    const [settings, setSettings] = useState<UserSettings>(() => {
        try {
            const saved = localStorage.getItem('profeplan_settings');
            return saved ? JSON.parse(saved) : defaultSettings;
        } catch (e) {
            return defaultSettings;
        }
    });

    useEffect(() => {
        localStorage.setItem('profeplan_settings', JSON.stringify(settings));
    }, [settings]);

    return { settings, setSettings };
};
