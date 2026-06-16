import React from 'react';
import { GlobalPlanningProvider } from '../contexts/GlobalPlanningContext';
import { ToastProvider } from '../contexts/ToastContext';
import ErrorBoundary from '../components/ErrorBoundary';

export const AppProviders: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return (
    <ErrorBoundary>
      <ToastProvider>
        <GlobalPlanningProvider>
          {children}
        </GlobalPlanningProvider>
      </ToastProvider>
    </ErrorBoundary>
  );
};
