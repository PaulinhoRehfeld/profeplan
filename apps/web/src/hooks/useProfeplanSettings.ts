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
    theme: 'light',
  };

  const [settings, setSettings] = useState<UserSettings>(() => {
    try {
      const saved = localStorage.getItem('profeplan_settings');
      const parsed = saved ? JSON.parse(saved) : null;
      return parsed ? { ...defaultSettings, ...parsed } : defaultSettings;
    } catch (e) {
      return defaultSettings;
    }
  });

  // NOTE: Auto-save removed to prevent default values from overwriting real DB data during hydration.
  // Saving is now handled explicitly by Save buttons or via App.tsx sync after hydration.

  return { settings, setSettings };
};
