import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  FileText,
  Plus,
  Search,
  Filter,
  CheckCircle,
  AlertCircle,
  Clock,
  User,
  School,
} from 'lucide-react';
import { PdiDocumentService } from '../../services/pdi/PdiDocumentService';
import { ProfileService } from '../../services/ProfileService';
import { PdiDocumentSummary } from '../../types/pdi';

interface PdiListPageProps {
  userId: string;
}

const PdiListPage: React.FC<PdiListPageProps> = ({ userId }) => {
  const navigate = useNavigate();
  const [pdis, setPdis] = useState<PdiDocumentSummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [userRole, setUserRole] = useState<string>('');

  useEffect(() => {
    loadPdis();
  }, [userId]);

  const loadPdis = async () => {
    setLoading(true);
    try {
      const profile = await ProfileService.getProfile();
      if (!profile) return;

      setUserRole(profile.role || 'teacher');

      if (profile.school_id) {
        const data = await PdiDocumentService.getSchoolPdis(profile.school_id);
        // The service currently returns raw data, we need to map it
        const mappedPdis = (data as any[]).map((p) => PdiDocumentService.mapToCompatibility(p));
        setPdis(mappedPdis as unknown as PdiDocumentSummary[]);
      }
    } catch (error) {
      console.error('Error loading PDIs:', error);
    } finally {
      setLoading(false);
    }
  };

  const filteredPdis = pdis.filter((pdi) => {
    const matchesSearch = pdi.student_name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = filterStatus === 'all' || pdi.status === filterStatus;
    return matchesSearch && matchesStatus;
  });

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'finalizado':
        return 'bg-green-100 text-green-700 border-green-200';
      case 'em_andamento':
        return 'bg-blue-100 text-blue-700 border-blue-200';
      case 'arquivado':
        return 'bg-gray-100 text-gray-700 border-gray-200';
      default:
        return 'bg-slate-100 text-slate-700 border-slate-200';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'finalizado':
        return <CheckCircle size={16} />;
      case 'em_andamento':
        return <Clock size={16} />;
      case 'arquivado':
        return <AlertCircle size={16} />;
      default:
        return <FileText size={16} />;
    }
  };

  const getCompletenessColor = (percentage: number) => {
    if (percentage >= 75) return 'bg-green-500';
    if (percentage >= 50) return 'bg-yellow-500';
    if (percentage >= 25) return 'bg-orange-500';
    return 'bg-red-500';
  };

  const calculateCompletenessPercentage = (blocks: any) => {
    const total = 4;
    const completed = Object.values(blocks).filter(Boolean).length;
    return Math.round((completed / total) * 100);
  };

  const isSupervisor = ['school_manager', 'school_admin', 'admin'].includes(userRole);

  return (
    <div className="min-h-screen bg-slate-50 p-4 md:p-8">
      <div className="max-w-7xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <div>
            <h1 className="text-3xl font-black text-slate-900 flex items-center gap-3">
              <FileText className="text-blue-600" size={32} />
              PDI - Planos de Desenvolvimento Individual
            </h1>
            <p className="text-slate-600 mt-2">
              Gerencie os PDIs dos alunos com necessidades especiais
            </p>
          </div>

          {isSupervisor && (
            <button
              onClick={() => navigate('/pdi/new')}
              className="flex items-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg transition-all"
            >
              <Plus size={20} />
              Criar Novo PDI
            </button>
          )}
        </div>

        {/* Filters */}
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200">
          <div className="grid md:grid-cols-2 gap-4">
            {/* Search */}
            <div className="relative">
              <Search
                className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
                size={20}
              />
              <input
                type="text"
                placeholder="Buscar por nome do aluno..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            {/* Status Filter */}
            <div className="relative">
              <Filter
                className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
                size={20}
              />
              <select
                value={filterStatus}
                onChange={(e) => setFilterStatus(e.target.value)}
                className="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500 cursor-pointer"
              >
                <option value="all">Todos os Status</option>
                <option value="em_andamento">Em Andamento</option>
                <option value="finalizado">Finalizados</option>
                <option value="arquivado">Arquivados</option>
              </select>
            </div>
          </div>
        </div>

        {/* PDI List */}
        {loading ? (
          <div className="flex items-center justify-center py-20">
            <div className="animate-spin rounded-full h-12 w-12 border-4 border-blue-600 border-t-transparent"></div>
          </div>
        ) : filteredPdis.length === 0 ? (
          <div className="bg-white rounded-2xl p-12 text-center border border-slate-200">
            <div className="w-20 h-20 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <FileText size={32} className="text-slate-400" />
            </div>
            <h3 className="text-xl font-bold text-slate-900 mb-2">Nenhum PDI encontrado</h3>
            <p className="text-slate-600 mb-6">
              {isSupervisor
                ? 'Comece criando o primeiro PDI para um aluno com necessidades especiais.'
                : 'Não há PDIs disponíveis no momento.'}
            </p>
            {isSupervisor && (
              <button
                onClick={() => navigate('/pdi/new')}
                className="inline-flex items-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl transition-all"
              >
                <Plus size={20} />
                Criar Primeiro PDI
              </button>
            )}
          </div>
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredPdis.map((pdi) => {
              const completeness = calculateCompletenessPercentage(pdi.blocks_completed);

              return (
                <div
                  key={pdi.id}
                  onClick={() => navigate(`/pdi/${pdi.id}`)}
                  className="bg-white rounded-2xl p-6 border border-slate-200 hover:border-blue-400 hover:shadow-lg transition-all cursor-pointer group"
                >
                  {/* Header */}
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex items-center gap-3">
                      <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center group-hover:bg-blue-600 transition-colors">
                        <User
                          size={24}
                          className="text-blue-600 group-hover:text-white transition-colors"
                        />
                      </div>
                      <div>
                        <h3 className="font-bold text-slate-900">{pdi.student_name}</h3>
                        <p className="text-xs text-slate-500">{pdi.period}</p>
                      </div>
                    </div>

                    <div
                      className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold border ${getStatusColor(pdi.status)}`}
                    >
                      {getStatusIcon(pdi.status)}
                      <span className="capitalize">{pdi.status.replace('_', ' ')}</span>
                    </div>
                  </div>

                  {/* Completeness Bar */}
                  <div className="mb-4">
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-xs font-bold text-slate-600">Completude</span>
                      <span className="text-xs font-black text-slate-900">{completeness}%</span>
                    </div>
                    <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                      <div
                        className={`h-full ${getCompletenessColor(completeness)} transition-all duration-500`}
                        style={{ width: `${completeness}%` }}
                      ></div>
                    </div>
                  </div>

                  {/* Blocks Status */}
                  <div className="grid grid-cols-2 gap-2 text-xs">
                    <div
                      className={`flex items-center gap-2 px-3 py-2 rounded-lg ${pdi.blocks_completed.block_1_8 ? 'bg-green-50 text-green-700' : 'bg-slate-50 text-slate-500'}`}
                    >
                      {pdi.blocks_completed.block_1_8 ? (
                        <CheckCircle size={14} />
                      ) : (
                        <Clock size={14} />
                      )}
                      <span className="font-semibold">Base 1-8</span>
                    </div>
                    <div
                      className={`flex items-center gap-2 px-3 py-2 rounded-lg ${pdi.blocks_completed.block_9 ? 'bg-green-50 text-green-700' : 'bg-slate-50 text-slate-500'}`}
                    >
                      {pdi.blocks_completed.block_9 ? (
                        <CheckCircle size={14} />
                      ) : (
                        <Clock size={14} />
                      )}
                      <span className="font-semibold">Plano 9</span>
                    </div>
                    <div
                      className={`flex items-center gap-2 px-3 py-2 rounded-lg ${pdi.blocks_completed.block_10 ? 'bg-green-50 text-green-700' : 'bg-slate-50 text-slate-500'}`}
                    >
                      {pdi.blocks_completed.block_10 ? (
                        <CheckCircle size={14} />
                      ) : (
                        <Clock size={14} />
                      )}
                      <span className="font-semibold">Aval. 10</span>
                    </div>
                    <div
                      className={`flex items-center gap-2 px-3 py-2 rounded-lg ${pdi.blocks_completed.block_11 ? 'bg-green-50 text-green-700' : 'bg-slate-50 text-slate-500'}`}
                    >
                      {pdi.blocks_completed.block_11 ? (
                        <CheckCircle size={14} />
                      ) : (
                        <Clock size={14} />
                      )}
                      <span className="font-semibold">Relat. 11</span>
                    </div>
                  </div>

                  {/* Footer */}
                  <div className="mt-4 pt-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
                    <span>Atualizado {new Date(pdi.last_updated).toLocaleDateString('pt-BR')}</span>
                    <span className="text-blue-600 font-semibold group-hover:underline">
                      Ver Detalhes →
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
};

export default PdiListPage;
