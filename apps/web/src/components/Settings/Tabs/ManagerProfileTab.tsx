import React, { useState } from 'react';
import { School, Users, Plus, X, Loader2, Save } from 'lucide-react';
import { supabase } from '../../../services/supabaseClient';

interface Supervisor {
    id?: string;
    masp: string;
    name: string;
    shift: 'Manhã' | 'Tarde' | 'Noite' | 'Integral';
}

interface ManagerProfileTabProps {
    userProfile: any;
    onSaveSuccess: () => Promise<void>;
    onClose: () => void;
}

export const ManagerProfileTab: React.FC<ManagerProfileTabProps> = ({
    userProfile,
    onSaveSuccess,
    onClose
}) => {
    // DADOS DA ESCOLA
    const [schoolData, setSchoolData] = useState({
        city: '',
        inep: '',
        name: ''
    });

    // SUPERVISORES (até 3)
    const [supervisors, setSupervisors] = useState<Supervisor[]>([
        { masp: '', name: '', shift: 'Integral' }
    ]);

    const [saveLoading, setSaveLoading] = useState(false);

    const handleAddSupervisor = () => {
        if (supervisors.length < 3) {
            setSupervisors([...supervisors, { masp: '', name: '', shift: 'Integral' }]);
        }
    };

    const handleRemoveSupervisor = (index: number) => {
        if (supervisors.length > 1) {
            setSupervisors(supervisors.filter((_, i) => i !== index));
        }
    };

    const handleSupervisorChange = (index: number, field: keyof Supervisor, value: string) => {
        const updated = [...supervisors];
        updated[index] = { ...updated[index], [field]: value };
        setSupervisors(updated);
    };

    const handleSaveProfile = async () => {
        setSaveLoading(true);

        try {
            if (!userProfile?.id) {
                alert('⚠️ Erro: Usuário não identificado');
                return;
            }

            // Atualizar perfil do manager sem vínculo automático com schools
            const { error: profileError } = await supabase
                .from('profiles')
                .update({
                    school_name: schoolData.name.trim(),
                    city: schoolData.city.trim(),
                    inep_code: schoolData.inep.trim(),
                    full_name: userProfile.full_name // Manter nome
                })
                .eq('id', userProfile.id);

            if (profileError) throw profileError;

            // 3. TODO: Salvar supervisores (criar tabela school_supervisors se necessário)
            console.log('[ManagerProfileTab] Supervisors to save:', supervisors);

            alert('✅ Dados da escola salvos com sucesso!');
            await onSaveSuccess();
            onClose();
        } catch (error: any) {
            console.error('[ManagerProfileTab] Save error:', error);
            alert('❌ Erro ao salvar: ' + error.message);
        } finally {
            setSaveLoading(false);
        }
    };

    return (
        <div className="space-y-8 animate-in fade-in duration-500">
            {/* DADOS DA ESCOLA */}
            <section className="space-y-4">
                <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                    <School className="w-4 h-4" /> Dados da Escola
                </div>

                <div className="bg-white border border-blue-100 rounded-3xl p-6 space-y-5 shadow-sm">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        {/* CIDADE */}
                        <div className="space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                Cidade
                            </label>
                            <input
                                type="text"
                                value={schoolData.city}
                                onChange={(e) => setSchoolData({ ...schoolData, city: e.target.value })}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                                placeholder="Ex: Capelinha"
                            />
                        </div>

                        {/* INEP */}
                        <div className="space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                Código INEP ⭐
                            </label>
                            <input
                                type="text"
                                value={schoolData.inep}
                                onChange={(e) => setSchoolData({ ...schoolData, inep: e.target.value })}
                                maxLength={8}
                                className="w-full px-5 py-3 bg-blue-50 border-2 border-blue-500 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-600 outline-none text-sm font-black transition-all"
                                placeholder="8 dígitos"
                            />
                            <p className="text-[10px] text-blue-600 font-bold ml-1">
                                🔑 Campo mais importante
                            </p>
                        </div>

                        {/* NOME DA ESCOLA */}
                        <div className="space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                Nome da Escola
                            </label>
                            <input
                                type="text"
                                value={schoolData.name}
                                onChange={(e) => setSchoolData({ ...schoolData, name: e.target.value })}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                                placeholder="Escreva o nome da escola livremente"
                            />
                        </div>
                    </div>
                </div>
            </section>

            {/* SUPERVISORES */}
            <section className="space-y-4">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-indigo-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                        <Users className="w-4 h-4" /> Supervisores da Escola
                    </div>
                    {supervisors.length < 3 && (
                        <button
                            type="button"
                            onClick={handleAddSupervisor}
                            className="flex items-center gap-2 px-4 py-2 bg-indigo-50 text-indigo-600 rounded-xl text-xs font-bold hover:bg-indigo-100 transition-all shadow-sm"
                        >
                            <Plus className="w-3 h-3" />
                            Adicionar Supervisor
                        </button>
                    )}
                </div>

                {supervisors.map((supervisor, index) => (
                    <div
                        key={index}
                        className="bg-white border border-indigo-100 rounded-3xl p-6 space-y-4 shadow-sm relative animate-in fade-in slide-in-from-top-2 duration-300"
                    >
                        {/* Botão remover */}
                        {supervisors.length > 1 && (
                            <button
                                type="button"
                                onClick={() => handleRemoveSupervisor(index)}
                                className="absolute top-4 right-4 p-2 bg-red-50 text-red-600 rounded-full hover:bg-red-100 transition-all"
                            >
                                <X className="w-4 h-4" />
                            </button>
                        )}

                        <h4 className="text-sm font-bold text-indigo-600 uppercase tracking-wider">
                            Supervisor {String.fromCharCode(65 + index)} {/* A, B, C */}
                        </h4>

                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                            {/* MASP */}
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                    MASP
                                </label>
                                <input
                                    type="text"
                                    value={supervisor.masp}
                                    onChange={(e) => handleSupervisorChange(index, 'masp', e.target.value)}
                                    maxLength={9}
                                    className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-indigo-100 focus:border-indigo-500 outline-none text-sm font-bold transition-all"
                                    placeholder="1234567-8"
                                />
                            </div>

                            {/* NOME */}
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                    Nome Completo
                                </label>
                                <input
                                    type="text"
                                    value={supervisor.name}
                                    onChange={(e) => handleSupervisorChange(index, 'name', e.target.value)}
                                    className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-indigo-100 focus:border-indigo-500 outline-none text-sm font-bold transition-all"
                                    placeholder="Ex: Maria Silva Santos"
                                />
                            </div>

                            {/* TURNO */}
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                    Turno
                                </label>
                                <select
                                    value={supervisor.shift}
                                    onChange={(e) => handleSupervisorChange(index, 'shift', e.target.value)}
                                    className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-indigo-100 focus:border-indigo-500 outline-none text-sm font-bold transition-all"
                                >
                                    <option value="Manhã">Manhã</option>
                                    <option value="Tarde">Tarde</option>
                                    <option value="Noite">Noite</option>
                                    <option value="Integral">Integral</option>
                                </select>
                            </div>
                        </div>
                    </div>
                ))}
            </section>

            {/* BOTÃO SALVAR */}
            <div className="flex justify-end gap-3 pt-4 border-t border-slate-100">
                <button
                    type="button"
                    onClick={onClose}
                    className="px-6 py-3 bg-slate-100 text-slate-600 rounded-xl font-bold hover:bg-slate-200 transition-all"
                >
                    Cancelar
                </button>
                <button
                    type="button"
                    onClick={handleSaveProfile}
                    disabled={saveLoading || !schoolData.inep}
                    className="px-6 py-3 bg-blue-600 text-white rounded-xl font-bold hover:bg-blue-700 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
                >
                    {saveLoading ? (
                        <>
                            <Loader2 className="w-4 h-4 animate-spin" />
                            Salvando...
                        </>
                    ) : (
                        <>
                            <Save className="w-4 h-4" />
                            Salvar Dados da Escola
                        </>
                    )}
                </button>
            </div>
        </div>
    );
};

export default ManagerProfileTab;
