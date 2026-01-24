import React, { useState, useEffect } from 'react';
import { School, Users, GraduationCap, BookOpen, Loader2, UserPlus, Upload } from 'lucide-react';
import { supabase } from '../services/supabaseClient';
import { UserProfile } from '../types';
import ClassManagement from '../components/School/ClassManagement';
import TeacherManagement from '../components/School/TeacherManagement';
import StudentManagement from '../components/School/StudentManagement';

interface SchoolDashboardProps {
    userProfile: UserProfile;
}

interface SchoolStats {
    totalTeachers: number;
    totalStudents: number;
    totalClasses: number;
    schoolName: string;
}

export const SchoolDashboard: React.FC<SchoolDashboardProps> = ({ userProfile }) => {
    const [stats, setStats] = useState<SchoolStats>({
        totalTeachers: 0,
        totalStudents: 0,
        totalClasses: 0,
        schoolName: userProfile.school_name || 'Escola'
    });
    const [teachers, setTeachers] = useState<any[]>([]);
    const [students, setStudents] = useState<any[]>([]);
    const [classes, setClasses] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<'teachers' | 'classes' | 'students'>('teachers');

    useEffect(() => {
        if (userProfile.school_id) {
            loadDashboardData();
        }
    }, [userProfile.school_id]);

    const loadDashboardData = async () => {
        setLoading(true);
        try {
            // Load teachers
            const { data: teachersData } = await supabase
                .from('profiles')
                .select('id, email, masp, full_name, created_at')
                .eq('school_id', userProfile.school_id)
                .eq('role', 'teacher');

            // Load students
            const { data: studentsData } = await supabase
                .from('students')
                .select('*')
                .eq('current_school_id', userProfile.school_id)
                .order('name');

            // Load classes
            const { data: classesData } = await supabase
                .from('classes')
                .select('*')
                .eq('school_id', userProfile.school_id)
                .order('name');

            setTeachers(teachersData || []);
            setStudents(studentsData || []);
            setClasses(classesData || []);
            setStats({
                totalTeachers: teachersData?.length || 0,
                totalStudents: studentsData?.length || 0,
                totalClasses: classesData?.length || 0,
                schoolName: userProfile.school_name || 'Escola'
            });
        } catch (error) {
            console.error('Error loading dashboard data:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center h-full">
                <Loader2 className="w-8 h-8 animate-spin text-indigo-600" />
            </div>
        );
    }

    return (
        <div className="flex flex-col h-full bg-slate-50 overflow-hidden">
            {/* Header */}
            <div className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-blue-100 rounded-lg text-blue-700">
                        <School size={24} />
                    </div>
                    <div>
                        <h1 className="text-lg font-bold text-slate-800">Painel de Gestão Escolar</h1>
                        <p className="text-xs text-slate-500">{stats.schoolName}</p>
                    </div>
                </div>
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
                <div className="flex space-x-1 bg-white rounded-lg p-1 shadow-sm border border-slate-200 mb-6">
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
                {activeTab === 'teachers' && (
                    <TeacherManagement
                        schoolId={userProfile.school_id || ''}
                        teachers={teachers}
                        onRefresh={loadDashboardData}
                    />
                )}

                {/* Classes Tab */}
                {activeTab === 'classes' && (
                    <ClassManagement
                        schoolId={userProfile.school_id || ''}
                        classes={classes}
                        onRefresh={loadDashboardData}
                    />
                )}

                {/* Students Tab */}
                {activeTab === 'students' && (
                    <StudentManagement
                        schoolId={userProfile.school_id || ''}
                        students={students}
                        onRefresh={loadDashboardData}
                    />
                )}
            </div>
        </div>
    );
};

export default SchoolDashboard;
