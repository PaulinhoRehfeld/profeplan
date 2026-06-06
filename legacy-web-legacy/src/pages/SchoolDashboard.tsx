import React, { useState, useEffect } from 'react';
import { School, Users, GraduationCap, BookOpen, Loader2, UserPlus, Upload, Shield, MapPin, Building2, Search } from 'lucide-react';
import { UserProfile, SchoolStats } from '../types';
import ClassManagement from '../components/School/ClassManagement';
import TeacherManagement from '../components/School/TeacherManagement';
import StudentManagement from '../components/School/StudentManagement';
import { getStudentsBySchool } from '../services/studentService';
import { getClassesBySchool } from '../services/classService';
import { getPendingTeachersBySchool } from '../services/teacherService';
import { getActiveTeachersBySchool } from '../services/teacherSchoolService';
import { SchoolService } from '../services/SchoolService';

interface SchoolDashboardProps {
    userProfile: UserProfile;
    onOpenSettings: () => void;
}

export const SchoolDashboard: React.FC<SchoolDashboardProps> = ({ userProfile, onOpenSettings }) => {
    // Determine active school ID (Admin override or User's school)
    const [activeSchoolId, setActiveSchoolId] = useState<string | null>(userProfile.school_id || null);

    // Stats State
    const [stats, setStats] = useState<SchoolStats>({
        totalTeachers: 0,
        totalStudents: 0,
        totalClasses: 0,
        schoolName: userProfile.school_name || 'Escola'
    });

    // Content State
    const [teachers, setTeachers] = useState<any[]>([]);
    const [students, setStudents] = useState<any[]>([]);
    const [classes, setClasses] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<'teachers' | 'classes' | 'students'>('teachers');

    // Admin Selector State
    const isAdmin = userProfile.role === 'admin' || userProfile.is_admin === true;
    const [cities, setCities] = useState<string[]>([]);
    const [selectedCity, setSelectedCity] = useState('');
    const [citySchools, setCitySchools] = useState<any[]>([]);
    const [selectedAdminSchool, setSelectedAdminSchool] = useState<string>('');
    const [isSearchingSchools, setIsSearchingSchools] = useState(false);

    // Initial Load & Admin Setup
    useEffect(() => {
        if (isAdmin) {
            loadCities();
        }

        if (userProfile.school_id) {
            setActiveSchoolId(userProfile.school_id);
        } else if (!isAdmin) {
            setLoading(false); // Stop loading if regular user has no school
        }
    }, [userProfile, isAdmin]);

    // React to Active School Change
    useEffect(() => {
        if (activeSchoolId) {
            loadDashboardData(activeSchoolId.trim());
        }
    }, [activeSchoolId]);

    // Admin: Load Cities
    // Admin: Load Cities
    const loadCities = async () => {
        try {
            const citiesList = await SchoolService.getCities();
            setCities(citiesList);
        } catch (err) {
            console.error("Error loading cities:", err);
        }
    };

    // Admin: Load Schools when City Selected
    useEffect(() => {
        if (selectedCity) {
            const loadSchools = async () => {
                setIsSearchingSchools(true);
                const schools = await SchoolService.getSchoolsByCity(selectedCity);
                setCitySchools(schools || []);
                setIsSearchingSchools(false);
            };
            loadSchools();
        } else {
            setCitySchools([]);
        }
    }, [selectedCity]);

    const handleAdminConnect = () => {
        if (selectedAdminSchool) {
            const school = citySchools.find(s => s.id === selectedAdminSchool);
            if (school) {
                setActiveSchoolId(school.id);
                // Fake the update for UI immediate feedback
                setStats(prev => ({ ...prev, schoolName: school.name }));
            }
        }
    };

    const loadDashboardData = async (schoolId: string) => {
        setLoading(true);
        try {
            // IMPORTANTE: Resolver schoolId para UUID
            // O schoolId pode vir como INEP (ex: "23299") ou UUID
            let resolvedSchoolId = schoolId.trim();
            let schoolName = stats.schoolName;

            // Tentar buscar escola - primeiro por ID (UUID), depois por INEP
            const schoolData = await SchoolService.resolveSchoolByIdOrInep(resolvedSchoolId);

            if (schoolData) {
                resolvedSchoolId = schoolData.id;
            }

            if (schoolData) {
                schoolName = schoolData.name;
                setStats(prev => ({ ...prev, schoolName }));
            }

            // Load teachers via teacher_schools (usando UUID resolvido)
            console.log('[SchoolDashboard] 🔍 Loading teachers from teacher_schools for school:', resolvedSchoolId);
            const teachersData = await getActiveTeachersBySchool(resolvedSchoolId);

            console.log('[SchoolDashboard] ✅ Found', teachersData.length, 'active teachers via teacher_schools');

            // Load pending teachers (usando UUID resolvido)
            const pendingTeachersData = await getPendingTeachersBySchool(resolvedSchoolId);

            // Load students using StudentService
            const studentsData = await getStudentsBySchool(resolvedSchoolId);

            // Load classes (usando UUID resolvido)
            const classesData = await getClassesBySchool(resolvedSchoolId);

            setTeachers(teachersData || []);
            setStudents(studentsData || []);

            // Calculate student counts locally
            const classesWithCounts = (classesData || []).map((cls: any) => {
                const count = (studentsData || []).filter((s: any) => s.class_id === cls.id).length;
                return { ...cls, student_count: count };
            });
            setClasses(classesWithCounts);
            setStats(prev => ({
                ...prev,
                totalTeachers: (teachersData?.length || 0) + (pendingTeachersData?.length || 0),
                totalStudents: studentsData?.length || 0,
                totalClasses: classesData?.length || 0,
            }));
        } catch (error) {
            console.error('Error loading dashboard data:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading && !activeSchoolId && !isAdmin) {
        return (
            <div className="flex items-center justify-center h-full">
                <Loader2 className="w-8 h-8 animate-spin text-indigo-600" />
            </div>
        );
    }

    // STATE: No School Linked & Not Admin
    if (!activeSchoolId && !isAdmin) {
        return (
            <div className="flex flex-col items-center justify-center h-full p-8 text-center bg-slate-50">
                <div className="bg-orange-100 p-6 rounded-full mb-6">
                    <School className="w-12 h-12 text-orange-600" />
                </div>
                <h2 className="text-2xl font-bold text-slate-800 mb-2">Nenhuma Escola Vinculada</h2>
                <p className="text-slate-500 max-w-md mb-8">
                    Você está acessando como <strong>Gestor Escolar</strong>, mas sua conta ainda não está vinculada a uma instituição.
                </p>
                <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm max-w-md w-full text-left">
                    <h3 className="font-bold text-slate-800 mb-2 flex items-center gap-2">
                        <UserPlus className="w-5 h-5 text-blue-500" /> Como resolver?
                    </h3>
                    <ul className="space-y-3 text-sm text-slate-600 mb-6">
                        <li className="flex items-start gap-2">
                            <span className="w-5 h-5 bg-slate-100 rounded-full flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">1</span>
                            Acesse <strong>Configurações</strong> no menu lateral ou clique abaixo.
                        </li>
                        <li className="flex items-start gap-2">
                            <span className="w-5 h-5 bg-slate-100 rounded-full flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">2</span>
                            Preencha o <strong>Código INEP</strong> e selecione sua escola.
                        </li>
                    </ul>
                    <button
                        onClick={onOpenSettings}
                        className="w-full py-3 bg-blue-600 text-white rounded-xl font-bold hover:bg-blue-700 transition flex items-center justify-center gap-2"
                    >
                        Abrir Configurações
                    </button>
                </div>
            </div>
        );
    }

    // STATE: Admin Selector (If no school active OR explicit toggle)
    if (!activeSchoolId && isAdmin) {
        return (
            <div className="flex flex-col items-center justify-center h-full p-8 bg-slate-900">
                <div className="w-full max-w-lg bg-white rounded-3xl p-10 shadow-2xl relative overflow-hidden">
                    <div className="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500"></div>

                    <div className="flex items-center gap-3 mb-6">
                        <div className="p-3 bg-slate-900 text-white rounded-xl">
                            <Shield size={24} />
                        </div>
                        <div>
                            <h2 className="text-xl font-black text-slate-800 uppercase italic tracking-tight">Suporte à Escola</h2>
                            <p className="text-xs font-bold text-slate-400 uppercase tracking-widest">Acesso Administrativo</p>
                        </div>
                    </div>

                    <div className="space-y-6">
                        <div className="space-y-2">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 flex items-center gap-1">
                                <MapPin size={12} /> Cidade
                            </label>
                            <select
                                value={selectedCity}
                                onChange={e => setSelectedCity(e.target.value)}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-xl font-bold text-slate-800 outline-none focus:ring-2 focus:ring-blue-500 transition-all custom-select"
                            >
                                <option value="">Selecione a Cidade...</option>
                                {cities.map(city => (
                                    <option key={city} value={city}>{city}</option>
                                ))}
                            </select>
                        </div>

                        <div className="space-y-2">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 flex items-center gap-1">
                                <Building2 size={12} /> Escola
                            </label>
                            <div className="relative">
                                <select
                                    value={selectedAdminSchool}
                                    onChange={e => setSelectedAdminSchool(e.target.value)}
                                    disabled={!selectedCity || isSearchingSchools}
                                    className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-xl font-bold text-slate-800 outline-none focus:ring-2 focus:ring-blue-500 transition-all disabled:opacity-50"
                                >
                                    <option value="">{isSearchingSchools ? "Carregando..." : "Selecione a Escola..."}</option>
                                    {citySchools.map(school => (
                                        <option key={school.id} value={school.id}>{school.name}</option>
                                    ))}
                                </select>
                            </div>
                        </div>

                        <button
                            onClick={handleAdminConnect}
                            disabled={!selectedAdminSchool}
                            className="w-full py-4 bg-slate-900 text-white rounded-xl font-black text-xs uppercase tracking-widest shadow-xl shadow-slate-900/20 hover:bg-slate-800 active:scale-95 transition-all disabled:opacity-50 flex items-center justify-center gap-2"
                        >
                            <Search size={16} /> Acessar Painel
                        </button>
                    </div>
                </div>
            </div>
        );
    }

    // MAIN DASHBOARD VIEW
    return (
        <div className="flex flex-col h-full bg-slate-50 overflow-hidden">
            {/* Header */}
            <div className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm relative z-20">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-blue-100 rounded-lg text-blue-700">
                        <School size={24} />
                    </div>
                    <div>
                        <h1 className="text-lg font-bold text-slate-800">Painel de Gestão Escolar</h1>
                        <p className="text-xs text-slate-500 font-medium flex items-center gap-1">
                            {isAdmin && <Shield size={10} className="text-red-500" />}
                            {stats.schoolName}
                        </p>
                    </div>
                </div>

                {isAdmin && (
                    <button
                        onClick={() => setActiveSchoolId(null)}
                        className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg text-xs font-bold uppercase tracking-wide transition-colors"
                    >
                        Trocar Escola
                    </button>
                )}
            </div>

            {/* Content */}
            <div className="flex-1 overflow-y-auto p-4 md:p-8">
                {/* Statistics Cards */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
                    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm text-slate-500 font-medium">Professores</p>
                                <p className="text-3xl font-bold text-slate-900 mt-1">{stats.totalTeachers}</p>
                            </div>
                            <div className="p-3 bg-blue-100 rounded-lg">
                                <GraduationCap className="w-6 h-6 text-blue-600" />
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-sm text-slate-500 font-medium">Alunos</p>
                                <p className="text-3xl font-bold text-slate-900 mt-1">{stats.totalStudents}</p>
                            </div>
                            <div className="p-3 bg-green-100 rounded-lg">
                                <Users className="w-6 h-6 text-green-600" />
                            </div>
                        </div>
                    </div>
                </div>

                {/* Tabs Navigation */}
                <div className="flex space-x-1 bg-white rounded-lg p-1 shadow-sm border border-slate-200 mb-6 w-full max-w-md mx-auto md:mx-0">
                    <button
                        onClick={() => setActiveTab('teachers')}
                        className={`flex-1 px-4 py-2.5 rounded-md text-sm font-bold transition ${activeTab === 'teachers'
                            ? 'bg-blue-600 text-white shadow-sm'
                            : 'text-slate-600 hover:bg-slate-50'
                            }`}
                    >
                        👨‍🏫 Professores ({stats.totalTeachers})
                    </button>
                    <button
                        onClick={() => setActiveTab('classes')}
                        className={`flex-1 px-4 py-2.5 rounded-md text-sm font-bold transition ${activeTab === 'classes'
                            ? 'bg-purple-600 text-white shadow-sm'
                            : 'text-slate-600 hover:bg-slate-50'
                            }`}
                    >
                        📚 Turmas ({stats.totalClasses})
                    </button>
                    <button
                        onClick={() => setActiveTab('students')}
                        className={`flex-1 px-4 py-2.5 rounded-md text-sm font-bold transition ${activeTab === 'students'
                            ? 'bg-green-600 text-white shadow-sm'
                            : 'text-slate-600 hover:bg-slate-50'
                            }`}
                    >
                        🎓 Alunos ({stats.totalStudents})
                    </button>
                </div>

                {/* Tab Content */}
                <div className="bg-white rounded-[2rem] border border-slate-100 shadow-sm p-2">
                    {activeTab === 'teachers' && activeSchoolId && (
                        <TeacherManagement
                            schoolId={activeSchoolId}
                            teachers={teachers}
                            onRefresh={() => loadDashboardData(activeSchoolId)}
                        />
                    )}

                    {activeTab === 'classes' && activeSchoolId && (
                        <ClassManagement
                            schoolId={activeSchoolId}
                            userId={userProfile.id}
                            classes={classes}
                            onRefresh={() => loadDashboardData(activeSchoolId)}
                        />
                    )}

                    {activeTab === 'students' && activeSchoolId && (
                        <StudentManagement
                            schoolId={activeSchoolId}
                            students={students}
                            onRefresh={() => loadDashboardData(activeSchoolId)}
                        />
                    )}
                </div>
            </div>
        </div>
    );
};

export default SchoolDashboard;
