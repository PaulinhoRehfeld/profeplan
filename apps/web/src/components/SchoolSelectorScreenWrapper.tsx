import React from 'react';
import SchoolSelectorScreen from './SchoolSelectorScreen';
import { useActiveSchool } from '../hooks/useActiveSchool';
import { useProfeplanAuth } from '../hooks/useProfeplanAuth';
import { Navigate } from 'react-router-dom';

export const SchoolSelectorScreenWrapper: React.FC = () => {
  const { session } = useProfeplanAuth();
  const userId = (session as any)?.userId || (session as any)?.user_id || (session as any)?.id;
  const { availableSchools, setActiveSchool, loading } = useActiveSchool(userId);

  if (!session?.isLoggedIn) return <Navigate to="/login" replace />;

  return (
    <SchoolSelectorScreen
      availableSchools={availableSchools}
      onSelectSchool={setActiveSchool}
      loading={loading}
    />
  );
};

export default SchoolSelectorScreenWrapper;
