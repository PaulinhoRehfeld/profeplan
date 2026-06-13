import React from 'react';
import { RouterProvider } from 'react-router-dom';
import { router } from './router/AppRouter';
import { ProfeplanAuthProvider } from './hooks/useProfeplanAuth';

const App: React.FC = () => {
  return (
    <ProfeplanAuthProvider>
      <RouterProvider router={router} />
    </ProfeplanAuthProvider>
  );
};

export default App;
