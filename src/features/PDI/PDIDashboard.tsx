import React, { useEffect, useState } from 'react';
import {
    BarChart3, Users, CheckCircle, Clock, AlertCircle,
    TrendingUp, FileText, Award, Calendar, ArrowRight,
    Filter, Search
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../../../services/supabaseClient';
import { PdiDocumentService } from '../../../services/PdiDocumentService';

interface PDIAnalytics {
    total_pdis: number;
    em_andamento: number;
    finalizados: number;
    arquivados: number;
    media_completude: number;
    total_students: number;
    pdis_by_status: Array<{ status: string; count: number }>;
    recent_pdis: Array<any>;
}

interface PDIDashboardProps {
    schoolId: string;
    userId: string;
}

const PDIDashboard: React.FC<PDIDashboardProps> = ({ schoolId, userId }) => {
    const navigate = useNavigate();
    const [analytics, setAnalytics] = useState<PDIAnalytics | null>(null);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [statusFilter, setStatusFilter] = useState<string>('all');

    useEffect(() => {
        loadAnalytics();
    }, [schoolId]);

    const loadAnalytics = async () => {
        setLoading(true);
        try {
            // Get all PDIs for this school
            const pdis = await PdiDocumentService.getSchoolPdis(schoolId);

            // Calculate analytics
            const em_andamento = pdis.filter(p => p.status === 'em_andamento').length;
            const finalizados = pdis.filter(p => p.status === 'finalizado').length;
            const arquivados = pdis.filter(p => p.status === 'arquivado').length;

            // Calculate average completeness
            const completenesses = pdis.map(p =>
                PdiDocumentService.calculateCompleteness(p).overall_percentage
            );
            const media_completude = completenesses.length > 0
                ? Math.round(completenesses.reduce((sum, val) => sum + val, 0) / completenesses.length)
                : 0;

            // Get unique students
            const uniqueStudents = new Set(pdis.map(p => p.student_id));

            // Recent PDIs (last 5 updated)
            const recent_pdis = pdis
                .sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime())
                .slice(0, 5);

            setAnalytics({
                total_pdis: pdis.length,
                em_andamento,
                finalizados,
                arquivados,
                media_completude,
                total_students: uniqueStudents.size,
                pdis_by_status: [
                    { status: 'em_andamento', count: em_andamento },
                    { status: 'finalizado', count: finalizados },
                    { status: 'arquivado', count: arquivados },
                ],
                recent_pdis,
            });

        } catch (error) {
            console.error('Error loading PDI analytics:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="animate-spin rounded-full h-12 w-12 border-4 border-blue-600 border-t-transparent"></div>
            </div>
        );
    }

    if (!analytics) {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="text-center">
                    <h2 className="text-2xl font-bold text-slate-900 mb-2">Erro ao carregar analytics</h2>
                    <button
                        onClick={loadAnalytics}
                        className="px-6 py-2 bg-blue-600 text-white rounded-xl"
                    >
                        Tentar Novamente
                    </button>
                </div>
            </div>
        );
    }

    const filteredPdis = analytics.recent_pdis.filter(pdi => {
        const matchesSearch = searchTerm === '' ||
            (pdi.school_students?.name || '').toLowerCase().includes(searchTerm.toLowerCase());
        const matchesStatus = statusFilter === 'all' || pdi.status === statusFilter;
        return matchesSearch && matchesStatus;
    });

    return (
        <div className="min-h-screen bg-slate-50 p-6">
            <div className="max-w-7xl mx-auto space-y-8">

                {/* Header */}
                <div className="flex items-center justify-between">
                    <div>
                        <h1 className="text-4xl font-black text-slate-900 mb-2">
                            Dashboard PDI
                        </h1>
                        <p className="text-slate-600">
                            Visão geral e acompanhamento de Planos de Desenvolvimento Individual
                        </p>
                    </div>
                    <button
                        onClick={() => navigate('/pdi/novo')}
                        className="flex items-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg transition-all"
                    >
                        <FileText size={20} />
                        Criar Novo PDI
                    </button>
                </div>

                {/* KPI Cards */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">

                    {/* Total PDIs */}
                    <div className="bg-white rounded-2xl border border-slate-200 p-6 hover:shadow-lg transition-shadow">
                        <div className="flex items-center justify-between mb-4">
                            <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                                <FileText size={24} className="text-blue-600" />
                            </div>
                            <TrendingUp size={20} className="text-green-600" />
                        </div>
                        <div className="text-4xl font-black text-slate-900 mb-1">
                            {analytics.total_pdis}
                        </div>
                        <div className="text-sm text-slate-600">PDIs Totais</div>
                    </div>

                    {/* Em Andamento */}
                    <div className="bg-white rounded-2xl border border-slate-200 p-6 hover:shadow-lg transition-shadow">
                        <div className="flex items-center justify-between mb-4">
                            <div className="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                                <Clock size={24} className="text-yellow-600" />
                            </div>
                        </div>
                        <div className="text-4xl font-black text-slate-900 mb-1">
                            {analytics.em_andamento}
                        </div>
                        <div className="text-sm text-slate-600">Em Andamento</div>
                    </div>

                    {/* Finalizados */}
                    <div className="bg-white rounded-2xl border border-slate-200 p-6 hover:shadow-lg transition-shadow">
                        <div className="flex items-center justify-between mb-4">
                            <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                                <CheckCircle size={24} className="text-green-600" />
                            </div>
                        </div>
                        <div className="text-4xl font-black text-slate-900 mb-1">
                            {analytics.finalizados}
                        </div>
                        <div className="text-sm text-slate-600">Finalizados</div>
                    </div>

                    {/* Média de Completude */}
                    <div className="bg-gradient-to-br from-purple-600 to-blue-600 rounded-2xl p-6 text-white hover:shadow-lg transition-shadow">
                        <div className="flex items-center justify-between mb-4">
                            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
                                <BarChart3 size={24} />
                            </div>
                        </div>
                        <div className="text-4xl font-black mb-1">
                            {analytics.media_completude}%
                        </div>
                        <div className="text-sm text-purple-100">Média de Completude</div>
                    </div>
                </div>

                {/* Charts Row */}
                <div className="grid lg:grid-cols-2 gap-6">

                    {/* Status Distribution */}
                    <div className="bg-white rounded-2xl border border-slate-200 p-6">
                        <h3 className="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                            <BarChart3 size={20} className="text-blue-600" />
                            Distribuição por Status
                        </h3>
                        <div className="space-y-4">
                            {analytics.pdis_by_status.map(item => {
                                const percentage = analytics.total_pdis > 0
                                    ? ((item.count / analytics.total_pdis) * 100).toFixed(0)
                                    : 0;

                                const colors = {
                                    em_andamento: { bg: 'bg-yellow-500', text: 'text-yellow-700', label: 'Em Andamento' },
                                    finalizado: { bg: 'bg-green-500', text: 'text-green-700', label: 'Finalizado' },
                                    arquivado: { bg: 'bg-slate-500', text: 'text-slate-700', label: 'Arquivado' },
                                };

                                const color = colors[item.status as keyof typeof colors];

                                return (
                                    <div key={item.status}>
                                        <div className="flex items-center justify-between mb-2">
                                            <span className="font-semibold text-slate-700">{color.label}</span>
                                            <span className={`font-bold ${color.text}`}>
                                                {item.count} ({percentage}%)
                                            </span>
                                        </div>
                                        <div className="w-full h-3 bg-slate-100 rounded-full overflow-hidden">
                                            <div
                                                className={`h-full ${color.bg} transition-all duration-500`}
                                                style={{ width: `${percentage}%` }}
                                            ></div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </div>

                    {/* Student Coverage */}
                    <div className="bg-white rounded-2xl border border-slate-200 p-6">
                        <h3 className="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                            <Users size={20} className="text-purple-600" />
                            Cobertura de Alunos
                        </h3>
                        <div className="space-y-6">
                            <div className="text-center">
                                <div className="text-6xl font-black text-slate-900 mb-2">
                                    {analytics.total_students}
                                </div>
                                <div className="text-slate-600">Alunos com PDI Ativo</div>
                            </div>
                            <div className="p-4 bg-blue-50 rounded-xl">
                                <div className="flex items-start gap-3">
                                    <AlertCircle size={20} className="text-blue-600 shrink-0 mt-0.5" />
                                    <div className="text-sm text-blue-900">
                                        <strong>Lembrete:</strong> Acompanhe regularmente o progresso dos PDIs
                                        e mantenha os registros atualizados para garantir o melhor suporte aos estudantes.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Recent PDIs Table */}
                <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden">
                    <div className="p-6 border-b border-slate-200">
                        <div className="flex items-center justify-between mb-4">
                            <h3 className="text-xl font-bold text-slate-900 flex items-center gap-2">
                                <Calendar size={20} className="text-green-600" />
                                PDIs Recentes
                            </h3>
                            <button
                                onClick={() => navigate('/pdi')}
                                className="flex items-center gap-2 px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-xl transition-colors"
                            >
                                Ver Todos
                                <ArrowRight size={16} />
                            </button>
                        </div>

                        {/* Filters */}
                        <div className="flex gap-4">
                            <div className="flex-1 relative">
                                <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                                <input
                                    type="text"
                                    placeholder="Buscar por nome do aluno..."
                                    value={searchTerm}
                                    onChange={(e) => setSearchTerm(e.target.value)}
                                    className="w-full pl-10 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                                />
                            </div>
                            <select
                                value={statusFilter}
                                onChange={(e) => setStatusFilter(e.target.value)}
                                className="px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
                            >
                                <option value="all">Todos Status</option>
                                <option value="em_andamento">Em Andamento</option>
                                <option value="finalizado">Finalizado</option>
                                <option value="arquivado">Arquivado</option>
                            </select>
                        </div>
                    </div>

                    {/* Table */}
                    <div className="overflow-x-auto">
                        <table className="w-full">
                            <thead className="bg-slate-50">
                                <tr>
                                    <th className="px-6 py-3 text-left text-xs font-bold text-slate-600 uppercase tracking-wider">
                                        Aluno
                                    </th>
                                    <th className="px-6 py-3 text-left text-xs font-bold text-slate-600 uppercase tracking-wider">
                                        Período
                                    </th>
                                    <th className="px-6 py-3 text-left text-xs font-bold text-slate-600 uppercase tracking-wider">
                                        Status
                                    </th>
                                    <th className="px-6 py-3 text-left text-xs font-bold text-slate-600 uppercase tracking-wider">
                                        Completude
                                    </th>
                                    <th className="px-6 py-3 text-left text-xs font-bold text-slate-600 uppercase tracking-wider">
                                        Última Atualização
                                    </th>
                                    <th className="px-6 py-3 text-right text-xs font-bold text-slate-600 uppercase tracking-wider">
                                        Ações
                                    </th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-200">
                                {filteredPdis.map((pdi) => {
                                    const completeness = PdiDocumentService.calculateCompleteness(pdi);
                                    const studentName = pdi.school_students?.name || 'Aluno';

                                    return (
                                        <tr key={pdi.id} className="hover:bg-slate-50 transition-colors">
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="font-semibold text-slate-900">{studentName}</div>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-slate-600">
                                                {pdi.period}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <span className={`px-3 py-1 rounded-full text-xs font-bold ${pdi.status === 'em_andamento' ? 'bg-yellow-100 text-yellow-700' :
                                                        pdi.status === 'finalizado' ? 'bg-green-100 text-green-700' :
                                                            'bg-slate-100 text-slate-700'
                                                    }`}>
                                                    {pdi.status === 'em_andamento' ? 'Em Andamento' :
                                                        pdi.status === 'finalizado' ? 'Finalizado' :
                                                            'Arquivado'}
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="flex items-center gap-2">
                                                    <div className="w-24 h-2 bg-slate-200 rounded-full overflow-hidden">
                                                        <div
                                                            className="h-full bg-blue-600 transition-all"
                                                            style={{ width: `${completeness.overall_percentage}%` }}
                                                        ></div>
                                                    </div>
                                                    <span className="text-sm font-semibold text-slate-700">
                                                        {completeness.overall_percentage}%
                                                    </span>
                                                </div>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-slate-600">
                                                {new Date(pdi.updated_at).toLocaleDateString('pt-BR')}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-right">
                                                <button
                                                    onClick={() => navigate(`/pdi/${pdi.id}`)}
                                                    className="text-blue-600 hover:text-blue-700 font-semibold text-sm"
                                                >
                                                    Ver Detalhes →
                                                </button>
                                            </td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>

                        {filteredPdis.length === 0 && (
                            <div className="text-center py-12">
                                <p className="text-slate-500">Nenhum PDI encontrado com os filtros aplicados</p>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default PDIDashboard;
