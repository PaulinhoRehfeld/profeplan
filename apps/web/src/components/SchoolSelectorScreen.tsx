import React from 'react';
import { useNavigate } from 'react-router-dom';
import { MapPin, BookOpen, CheckCircle2, Loader2 } from 'lucide-react';
import { ActiveSchool } from '../hooks/useActiveSchool';

interface SchoolSelectorScreenProps {
  availableSchools: ActiveSchool[];
  onSelectSchool: (school: ActiveSchool) => void;
  loading?: boolean;
}

export const SchoolSelectorScreen: React.FC<SchoolSelectorScreenProps> = ({
  availableSchools,
  onSelectSchool,
  loading = false,
}) => {
  const navigate = useNavigate();

  const handleSelectSchool = (school: ActiveSchool) => {
    onSelectSchool(school);
    // Redirecionar para o dashboard
    setTimeout(() => navigate('/app'), 300);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 flex items-center justify-center p-6">
        <div className="text-center">
          <Loader2 className="w-12 h-12 animate-spin text-blue-500 mx-auto mb-4" />
          <p className="text-slate-600 font-bold">Carregando suas escolas...</p>
        </div>
      </div>
    );
  }

  if (availableSchools.length === 0) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 flex items-center justify-center p-6">
        <div className="max-w-md w-full bg-white rounded-3xl shadow-xl p-8 text-center">
          <BookOpen className="w-16 h-16 text-amber-500 mx-auto mb-4" />
          <h2 className="text-2xl font-black text-slate-800 mb-2">Nenhuma Escola Vinculada</h2>
          <p className="text-slate-600 mb-6">
            Você ainda não possui escolas vinculadas ao seu perfil. Configure seu perfil para
            começar.
          </p>
          <button
            onClick={() => navigate('/app')}
            className="px-6 py-3 bg-blue-600 text-white rounded-xl font-bold hover:bg-blue-700 transition-all"
          >
            Configurar Perfil
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 flex items-center justify-center p-6">
      <div className="max-w-2xl w-full">
        {/* Header */}
        <div className="text-center mb-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
          <h1 className="text-4xl font-black text-slate-800 mb-2 tracking-tight">
            Selecione sua Escola
          </h1>
          <p className="text-slate-600">
            Você possui vínculo com múltiplas instituições. Escolha qual escola deseja acessar
            agora.
          </p>
        </div>

        {/* School Cards */}
        <div className="space-y-4">
          {availableSchools.map((school, index) => (
            <button
              key={school.id}
              onClick={() => handleSelectSchool(school)}
              className="w-full bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 group hover:scale-[1.02] border-2 border-transparent hover:border-blue-500 animate-in fade-in slide-in-from-bottom-2"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              <div className="flex items-start gap-4">
                {/* Icon */}
                <div className="flex-shrink-0">
                  <div className="w-14 h-14 bg-blue-100 rounded-xl flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                    <BookOpen className="w-7 h-7 text-blue-600" />
                  </div>
                </div>

                {/* Info */}
                <div className="flex-1 text-left">
                  <h3 className="text-lg font-black text-slate-800 mb-1 group-hover:text-blue-600 transition-colors">
                    {school.name}
                  </h3>
                  <div className="flex flex-wrap gap-3 text-sm text-slate-500">
                    <span className="flex items-center gap-1">
                      <span className="font-bold">INEP:</span> {school.inep_code}
                    </span>
                    {school.city && (
                      <span className="flex items-center gap-1">
                        <MapPin className="w-3 h-3" />
                        {school.city}
                      </span>
                    )}
                  </div>
                </div>

                {/* Check Icon */}
                <div className="flex-shrink-0">
                  <CheckCircle2 className="w-6 h-6 text-slate-300 group-hover:text-blue-600 transition-colors" />
                </div>
              </div>
            </button>
          ))}
        </div>

        {/* Footer Info */}
        <div className="mt-8 text-center">
          <p className="text-xs text-slate-500">
            💡 Você poderá trocar de escola a qualquer momento nas configurações
          </p>
        </div>
      </div>
    </div>
  );
};

export default SchoolSelectorScreen;
