import { create } from 'zustand';
import { ReactNode } from 'react';
import { ToolMode } from '../types';

interface UIState {
  activeMode: ToolMode;
  isMobileNavOpen: boolean;
  isLeftNavExpanded: boolean;
  isSettingsOpen: boolean;
  isSubscriptionOpen: boolean;
  customSidebar: ReactNode | null;

  // Actions
  setActiveMode: (mode: ToolMode) => void;
  setIsMobileNavOpen: (isOpen: boolean) => void;
  setIsLeftNavExpanded: (isExpanded: boolean) => void;
  setIsSettingsOpen: (isOpen: boolean) => void;
  setIsSubscriptionOpen: (isOpen: boolean) => void;
  setCustomSidebar: (sidebar: ReactNode | null) => void;
  toggleMobileNav: () => void;
  toggleLeftNav: () => void;
}

export const useUIStore = create<UIState>((set) => ({
  activeMode: ToolMode.HOME,
  isMobileNavOpen: false,
  isLeftNavExpanded: true,
  isSettingsOpen: false,
  isSubscriptionOpen: false,
  customSidebar: null,

  setActiveMode: (mode) => set({ activeMode: mode, customSidebar: null }),
  setIsMobileNavOpen: (isOpen) => set({ isMobileNavOpen: isOpen }),
  setIsLeftNavExpanded: (isExpanded) => set({ isLeftNavExpanded: isExpanded }),
  setIsSettingsOpen: (isOpen) => set({ isSettingsOpen: isOpen }),
  setIsSubscriptionOpen: (isOpen) => set({ isSubscriptionOpen: isOpen }),
  setCustomSidebar: (sidebar) => set({ customSidebar: sidebar }),
  toggleMobileNav: () => set((state) => ({ isMobileNavOpen: !state.isMobileNavOpen })),
  toggleLeftNav: () => set((state) => ({ isLeftNavExpanded: !state.isLeftNavExpanded })),
}));
