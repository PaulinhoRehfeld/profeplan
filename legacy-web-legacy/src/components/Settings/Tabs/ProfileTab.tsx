import React, { useState, useRef, useEffect } from 'react';
import { User, BookOpen, ImageIcon, Trash2, FileText, Loader2, Plus, X, Mail } from 'lucide-react';
import { UserSettings } from '../../../types';
import { updateUserProfile } from '../../../services/ProfileService';

interface ProfileTabProps {
    userProfile: any;
    initialSettings: UserSettings;
    setSettings: (settings: UserSettings) => void;
    onSaveSuccess: () => Promise<void>; // Function to reload profile/close modal
    onClose: () => void;
}

export const ProfileTab: React.FC<ProfileTabProps> = ({ userProfile, initialSettings, setSettings, onSaveSuccess, onClose }) => {
    console.log("[ProfileTab] Incoming Profile Data:", userProfile?.full_name, userProfile?.school_name);

    // Local State handling Form Data
    const [localSettings, setLocalSettings] = useState<UserSettings>(initialSettings);
    const [saveLoading, setSaveLoading] = useState(false);
    const logoInputRef = useRef<HTMLInputElement>(null);

    // Segunda Escola (Cargo Adicional)
    const [showSecondSchool, setShowSecondSchool] = useState(false);
    const [secondSchool, setSecondSchool] = useState({
        city: '',
        inep: '',
        name: ''
    });

    // Update local state when props change
    useEffect(() => {
        setLocalSettings(initialSettings);
    }, [initialSettings]);

    const handleChange = (field: keyof UserSettings, value: string) => {
        setLocalSettings(prev => ({ ...prev, [field]: value }));
    };

    const handleMaspChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 8) value = value.slice(0, 8);
        if (value.length > 7) value = value.slice(0, 7) + '-' + value.slice(7);
        handleChange('masp', value);
    };

    const handleLogoUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setLocalSettings(prev => ({ ...prev, logoBase64: reader.result as string }));
            };
            reader.readAsDataURL(file);
        }
    };

    const handleSaveProfile = async () => {
        setSaveLoading(true);

        try {
            // Try to get userId from userProfile first, fallback to session from localStorage
            let userId = userProfile?.id;

            if (!userId) {
                console.warn('[ProfileTab] userProfile.id not available, attempting fallback to session...');
                try {
                    const sessionData = localStorage.getItem('profeplan_session');
                    const session = sessionData ? JSON.parse(sessionData) : null;
                    userId = session?.id;
                } catch (e) {
                    console.error('[ProfileTab] Failed to parse session from localStorage:', e);
                }
            }

            if (!userId) {
                alert('⚠️ Não foi possível identificar seu usuário. Por favor, saia e entre novamente.\n\nSe o problema persistir, limpe o cache do navegador.');
                setSaveLoading(false);
                return;
            }


            console.log('[ProfileTab] 💾 Saving profile for user:', userId);

            const result = await updateUserProfile(userId, {
                ...localSettings
            });

            if (result.error) throw new Error(result.error);

            const newSettings = { ...localSettings };
            setLocalSettings(newSettings);
            setSettings(newSettings);
            localStorage.setItem('profeplan_settings', JSON.stringify(newSettings));

            if (result.message) {
                alert('✅ ' + result.message);
            } else {
                alert('✅ Perfil atualizado com sucesso!');
            }

            await onSaveSuccess();
            onClose();
        } catch (error: any) {
            console.error("[ProfileTab] Save error:", error);
            alert('❌ Erro ao salvar perfil:\n' + (error.message || 'Erro desconhecido'));
        } finally {
            setSaveLoading(false);
        }
    };

    return (
            <div className="space-y-8 animate-in fade-in duration-500">

            {/* Perfil Profissional */}
            <section className="space-y-4">
                <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                    <User className="w-4 h-4" /> Perfil Profissional
                </div>
                <div className="grid grid-cols-1 gap-5">
                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Nome Completo</label>
                        <input
                            type="text" value={localSettings.userName}
                            onChange={(e) => handleChange('userName', e.target.value)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="Ex: Ricardo Silva Santos"
                        />
                    </div>

                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Email Institucional</label>
                        <input
                            type="email" value={localSettings.institutionalEmail || ''}
                            onChange={(e) => handleChange('institutionalEmail', e.target.value)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="seu.nome@educacao.mg.gov.br"
                        />
                        <p className="text-xs text-slate-500 ml-1">Email para fins de registro oficial</p>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div className="space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">MASP (Professor)</label>
                            <input
                                type="text"
                                value={localSettings.masp || ''}
                                onChange={handleMaspChange}
                                maxLength={9}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                                placeholder="1234567-8"
                            />
                            <p className="text-[10px] text-slate-500 ml-1">Matrícula SIAFI (7 dígitos + verificador)</p>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-start">
                        <div className="md:col-span-1 space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Cidade</label>
                            <input
                                type="text"
                                value={localSettings.city || ''}
                                onChange={(e) => handleChange('city', e.target.value)}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                                placeholder="Cidade"
                            />
                        </div>

                        <div className="md:col-span-1 space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Código INEP</label>
                            <input
                                type="text"
                                value={localSettings.schoolCode || ''}
                                onChange={(e) => handleChange('schoolCode', e.target.value)}
                                maxLength={8}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                                placeholder="8 dígitos"
                            />
                        </div>

                        <div className="md:col-span-2 space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Nome da Escola</label>
                            <input
                                type="text"
                                value={localSettings.institution || ''}
                                onChange={(e) => handleChange('institution', e.target.value)}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                                placeholder="Escreva o nome da escola livremente"
                            />
                        </div>
                    </div>
                </div>
            </section>

            {/* Segundo Cargo (Opcional) */}
            <section className="space-y-4">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-indigo-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                        <BookOpen className="w-4 h-4" /> Segundo Cargo (Opcional)
                    </div>
                    {!showSecondSchool ? (
                        <button
                            type="button"
                            onClick={() => setShowSecondSchool(true)}
                            className="flex items-center gap-2 px-4 py-2 bg-indigo-50 text-indigo-600 rounded-xl text-xs font-bold hover:bg-indigo-100 transition-all shadow-sm"
                        >
                            <Plus className="w-3 h-3" />
                            Adicionar 2ª Escola
                        </button>
                    ) : (
                        <button
                            type="button"
                            onClick={() => {
                                setShowSecondSchool(false);
                                setSecondSchool({ city: '', inep: '', name: '' });
                            }}
                            className="flex items-center gap-2 px-4 py-2 bg-red-50 text-red-600 rounded-xl text-xs font-bold hover:bg-red-100 transition-all shadow-sm"
                        >
                            <X className="w-3 h-3" />
                            Remover 2ª Escola
                        </button>
                    )}
                </div>

                {showSecondSchool && (
                    <div className="bg-white border border-indigo-100 rounded-3xl p-6 space-y-5 animate-in slide-in-from-top-4 duration-300 shadow-sm shadow-indigo-100">
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-start">
                            <div className="md:col-span-1 space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                    Cidade
                                </label>
                                <input
                                    type="text"
                                    value={secondSchool.city}
                                    onChange={(e) => setSecondSchool(prev => ({ ...prev, city: e.target.value }))}
                                    className="w-full px-5 py-3 bg-slate-50 border border-indigo-100 rounded-2xl focus:ring-4 focus:ring-indigo-100 focus:border-indigo-500 outline-none text-sm font-bold transition-all"
                                    placeholder="Cidade"
                                />
                            </div>

                            <div className="md:col-span-1 space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                    Código INEP
                                </label>
                                <input
                                    type="text"
                                    value={secondSchool.inep}
                                    onChange={(e) => setSecondSchool(prev => ({ ...prev, inep: e.target.value }))}
                                    maxLength={8}
                                    className="w-full px-5 py-3 bg-slate-50 border border-indigo-100 rounded-2xl focus:ring-4 focus:ring-indigo-100 focus:border-indigo-500 outline-none text-sm font-bold transition-all"
                                    placeholder="8 dígitos"
                                />
                            </div>

                            <div className="md:col-span-2 space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">
                                    Nome da Escola
                                </label>
                                <input
                                    type="text"
                                    value={secondSchool.name}
                                    onChange={(e) => setSecondSchool(prev => ({ ...prev, name: e.target.value }))}
                                    className="w-full px-5 py-3 bg-slate-50 border border-indigo-100 rounded-2xl focus:ring-4 focus:ring-indigo-100 focus:border-indigo-500 outline-none text-sm font-bold transition-all"
                                    placeholder="Escreva o nome da 2ª escola livremente"
                                />
                            </div>
                        </div>
                    </div>
                )}
            </section>

            {/* Documentos */}
            <section className="space-y-4">
                <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                    <FileText className="w-4 h-4" /> Personalização de Documentos (Exportação)
                </div>
                <div className="bg-slate-50 border border-slate-200 rounded-3xl p-6 space-y-6">
                    <div className="flex flex-col md:flex-row gap-6">
                        <div className="space-y-2">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Logo da Instituição</label>
                            <div
                                onClick={() => logoInputRef.current?.click()}
                                className="w-32 h-32 bg-white border-2 border-dashed border-slate-200 rounded-2xl flex flex-col items-center justify-center cursor-pointer hover:border-blue-400 hover:bg-blue-50 transition-all relative group overflow-hidden"
                            >
                                {localSettings.logoBase64 ? (
                                    <>
                                        <img src={localSettings.logoBase64} alt="Logo" className="w-full h-full object-contain p-2" />
                                        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                            <ImageIcon className="text-white w-6 h-6" />
                                        </div>
                                    </>
                                ) : (
                                    <>
                                        <ImageIcon className="w-8 h-8 text-slate-300 mb-2" />
                                        <span className="text-[8px] font-black text-slate-400 uppercase text-center px-2">Subir Logo (PNG/JPG)</span>
                                    </>
                                )}
                            </div>
                            <input type="file" ref={logoInputRef} className="hidden" accept="image/*" onChange={handleLogoUpload} />
                            {localSettings.logoBase64 && (
                                <button
                                    onClick={() => setLocalSettings(prev => ({ ...prev, logoBase64: undefined }))}
                                    className="text-[9px] font-bold text-red-500 flex items-center gap-1 mt-1 hover:underline"
                                >
                                    <Trash2 className="w-3 h-3" /> Remover Logo
                                </button>
                            )}
                        </div>

                        <div className="flex-1 space-y-4">
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Cabeçalho Personalizado</label>
                                <textarea
                                    value={localSettings.headerText || ''}
                                    onChange={(e) => handleChange('headerText', e.target.value)}
                                    placeholder="Ex: Secretaria de Estado de Educação de MG&#10;Escola Estadual Machado de Assis"
                                    className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-xs font-bold transition-all min-h-[80px]"
                                />
                            </div>
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Rodapé Personalizado</label>
                                <input
                                    type="text"
                                    value={localSettings.footerText || ''}
                                    onChange={(e) => handleChange('footerText', e.target.value)}
                                    placeholder="Ex: Av. Brasil, 1000 - Centro | (31) 3333-4444"
                                    className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-xs font-bold transition-all"
                                />
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* Inteligência e Metodologia */}
            <section className="space-y-4">
                <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                    <BookOpen className="w-4 h-4" /> Preferências de IA
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Metodologia Padrão</label>
                        <select
                            value={localSettings.favoriteMethodology}
                            onChange={(e) => handleChange('favoriteMethodology', e.target.value)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 outline-none text-sm font-bold appearance-none cursor-pointer"
                        >
                            <option value="Gamification">Gamificação</option>
                            <option value="Problem Based">ABP (Problemas)</option>
                            <option value="Traditional">Tradicional</option>
                        </select>
                    </div>
                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Estilo Pedagógico</label>
                        <select
                            value={localSettings.teachingStyle}
                            onChange={(e) => handleChange('teachingStyle', e.target.value as any)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 outline-none text-sm font-bold appearance-none cursor-pointer"
                        >
                            <option value="">Selecione...</option>
                            <option value="Tradicional">Tradicional</option>
                            <option value="Construtivista">Construtivista</option>
                            <option value="Sociointeracionista">Sociointeracionista</option>
                        </select>
                    </div>
                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Foco Avaliativo</label>
                        <select
                            value={localSettings.assessmentFocus}
                            onChange={(e) => handleChange('assessmentFocus', e.target.value as any)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 outline-none text-sm font-bold appearance-none cursor-pointer"
                        >
                            <option value="">Selecione...</option>
                            <option value="Somativa">Somativa</option>
                            <option value="Formativa">Formativa</option>
                            <option value="Diagnóstica">Diagnóstica</option>
                        </select>
                    </div>
                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Tom de Escrita</label>
                        <select
                            value={localSettings.toneOfVoice}
                            onChange={(e) => handleChange('toneOfVoice', e.target.value as any)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 outline-none text-sm font-bold appearance-none cursor-pointer"
                        >
                            <option value="Prático e Inspiracional">Prático e Inspiracional</option>
                            <option value="Técnico e Formal">Técnico e Formal</option>
                        </select>
                    </div>
                </div>
            </section>

            <div className="pt-4 border-t border-slate-100 flex justify-end gap-3">
                <button
                    onClick={handleSaveProfile}
                    disabled={saveLoading}
                    className="px-8 py-3 bg-slate-900 text-white rounded-2xl font-black text-[11px] uppercase tracking-widest shadow-xl shadow-slate-900/20 hover:bg-slate-800 transition-all active:scale-95 disabled:opacity-50 flex items-center gap-2"
                >
                    {saveLoading && <Loader2 className="w-3 h-3 animate-spin" />}
                    {saveLoading ? 'Salvando...' : 'Confirmar Alterações'}
                </button>
            </div>
        </div>
    );
};
