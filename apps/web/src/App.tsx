import React from 'react';
import { RouterProvider } from 'react-router-dom';
import { router } from './router/AppRouter';
import { ProfeplanAuthProvider } from './hooks/useProfeplanAuth';
import { GlobalPlanningProvider } from './contexts/GlobalPlanningContext';
import ErrorBoundary from './components/ErrorBoundary';

const App: React.FC = () => {
  return (
    <ErrorBoundary>
      <ProfeplanAuthProvider>
        <GlobalPlanningProvider>
          <RouterProvider router={router} />
        </GlobalPlanningProvider>
      </ProfeplanAuthProvider>
    </ErrorBoundary>
  );
};

export default App;
