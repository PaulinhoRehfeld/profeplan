import React, { useState, useRef, useEffect } from 'react';
import { User, BookOpen, ImageIcon, Trash2, FileText, Loader2 } from 'lucide-react';
import { UserSettings } from '../../../types';
import { supabase } from '../../../services/supabaseClient';

interface ProfileTabProps {
    userProfile: any;
    initialSettings: UserSettings;
    onSaveSuccess: () => Promise<void>; // Function to reload profile/close modal
    onClose: () => void;
}

export const ProfileTab: React.FC<ProfileTabProps> = ({ userProfile, initialSettings, onSaveSuccess, onClose }) => {

    // Local State handling Form Data
    const [settings, setSettings] = useState<UserSettings>(initialSettings);
    const [saveLoading, setSaveLoading] = useState(false);

    // School Search State
    const [schoolResults, setSchoolResults] = useState<any[]>([]);
    const [isSearchingSchool, setIsSearchingSchool] = useState(false);
    const [showSchoolResults, setShowSchoolResults] = useState(false);
    const logoInputRef = useRef<HTMLInputElement>(null);

    // Update local state when props change (if needed)
    useEffect(() => {
        setSettings(initialSettings);
    }, [initialSettings]);

    const handleChange = (field: keyof UserSettings, value: string) => {
        setSettings(prev => ({ ...prev, [field]: value }));
    };

    // --- Logic extracted from SettingsModal ---

    const searchSchools = async (term: string, cityContext?: string) => {
        if (term.length < 3) {
            setSchoolResults([]);
            return;
        }

        setIsSearchingSchool(true);
        try {
            let schoolsSource = (window as any).schoolsCache || [];

            // 1. Carregar JSON se cache estiver vazio
            if (schoolsSource.length === 0) {
                console.log("🔄 Carregando base de escolas estática...");
                const response = await fetch('/schools_data.json');
                if (!response.ok) throw new Error("Falha ao carregar escolas");
                const data = await response.json();

                schoolsSource = data;
                (window as any).schoolsCache = data;
            }

            // 2. Filtragem Client-Side
            const termNorm = term.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
            const cityNorm = (cityContext || '').toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

            const filtered = schoolsSource.filter((school: any) => {
                const nameEscola = school.name.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
                const cityEscola = school.city.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

                const matchesName = nameEscola.includes(termNorm);
                const matchesCity = cityNorm ? cityEscola.includes(cityNorm) : true;

                return matchesName && matchesCity;
            }).slice(0, 50);

            setSchoolResults(filtered);
            setShowSchoolResults(true);

        } catch (error) {
            console.error('Erro ao buscar escolas (JSON):', error);
            setSchoolResults([]);
        } finally {
            setIsSearchingSchool(false);
        }
    };

    const handleSchoolInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        handleChange('institution', value);

        const timeoutId = setTimeout(() => searchSchools(value, settings.city), 500);
        return () => clearTimeout(timeoutId);
    };

    const handleCityChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        handleChange('city', value);

        if (settings.institution && settings.institution.length >= 3) {
            const timeoutId = setTimeout(() => searchSchools(settings.institution, value), 500);
            return () => clearTimeout(timeoutId);
        }
    };

    const selectSchool = (school: any) => {
        handleChange('institution', school.name);
        handleChange('city', school.city);
        handleChange('schoolCode', school.id);
        setSchoolResults([]);
        setShowSchoolResults(false);
    };

    const handleMaspChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 8) value = value.slice(0, 8);
        if (value.length > 7) value = value.slice(0, 7) + '-' + value.slice(7);
        handleChange('masp', value);
    };

    const handleSchoolCodeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const code = e.target.value;
        handleChange('schoolCode', code);

        if (code.length >= 6) {
            setTimeout(async () => {
                try {
                    const { data } = await supabase
                        .from('schools')
                        .select('id, name, city, sre')
                        .eq('id', code)
                        .single();

                    if (data) {
                        handleChange('institution', data.name);
                        handleChange('city', data.city);
                    }
                } catch (error) {
                    console.error('Erro ao buscar escola por código:', error);
                }
            }, 500);
        }
    };

    const handleLogoUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setSettings(prev => ({ ...prev, logoBase64: reader.result as string }));
            };
            reader.readAsDataURL(file);
        }
    };

    const handleSaveProfile = async () => {
        setSaveLoading(true);
        try {
            if (userProfile?.id) {
                const updates: any = {
                    full_name: settings.userName,
                    email: settings.institutionalEmail,
                    masp: settings.masp,
                    city: settings.city,
                    updated_at: new Date()
                };

                if (settings.schoolCode) {
                    updates.school_id = settings.schoolCode;
                }

                const { error } = await supabase
                    .from('profiles')
                    .update(updates)
                    .eq('id', userProfile.id);

                if (error) throw error;

                // Persist Preferences to LocalStorage (conceptually)
                // In this app, preferences like 'favoriteMethodology' are often kept in LS or implicitly handled 
                // by the parent passing them back down. 
                // Since 'settings' prop in Parent is state, we must ensure Parent state is updated 
                // OR we just rely on the fact we might need to save these to DB if they were DB columns.
                // Assuming they are just local preferences for now or saved elsewhere?
                // The original code commented: "JSON.stringify handled by App.tsx useEffect..."
                // So we need to propagate these changes to the Parent so App.tsx can save them?
                // Yes. But we are replacing the parent logic. 
                // We should probably save them to LS here if they are not in DB.
                localStorage.setItem('userSettings', JSON.stringify(settings));

                await onSaveSuccess();
            }
            onClose();
        } catch (error: any) {
            alert('Erro ao salvar perfil: ' + error.message);
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
                            type="text" value={settings.userName}
                            onChange={(e) => handleChange('userName', e.target.value)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="Ex: Ricardo Silva Santos"
                        />
                    </div>

                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Email Institucional</label>
                        <input
                            type="email" value={settings.institutionalEmail || ''}
                            onChange={(e) => handleChange('institutionalEmail', e.target.value)}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="seu.nome@educacao.mg.gov.br"
                        />
                        <p className="text-xs text-slate-500 ml-1">Email para vinculação automática à escola</p>
                    </div>

                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">MASP</label>
                        <input
                            type="text"
                            value={settings.masp || ''}
                            onChange={handleMaspChange}
                            maxLength={8}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="1234567-8"
                        />
                        <p className="text-xs text-slate-500 ml-1">Matrícula SIAFI do Professor (7 dígitos + verificador)</p>
                    </div>

                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Cidade onde Atua</label>
                        <input
                            type="text"
                            value={settings.city || ''}
                            onChange={handleCityChange}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="Ex: Belo Horizonte"
                        />
                        <p className="text-xs text-slate-500 ml-1">Ajuda a filtrar as escolas disponíveis</p>
                    </div>

                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Código INEP da Escola</label>
                        <input
                            type="text"
                            value={settings.schoolCode || ''}
                            onChange={handleSchoolCodeChange}
                            className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="Digite o código INEP (ex: 31001234)"
                        />
                        <p className="text-xs text-slate-500 ml-1">Digite o código ou selecione a escola abaixo</p>
                    </div>

                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Nome Completo da Escola</label>
                        <div className="relative">
                            <input
                                type="text" value={settings.institution}
                                onChange={handleSchoolInputChange}
                                onFocus={() => settings.institution && settings.institution.length >= 3 && searchSchools(settings.institution, settings.city)}
                                onBlur={() => setTimeout(() => setShowSchoolResults(false), 200)}
                                className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                                placeholder="Digite pelo menos 3 letras (Ex: E.E. ou Escola Estadual...)"
                            />
                            {isSearchingSchool && (
                                <div className="absolute right-3 top-1/2 -translate-y-1/2">
                                    <Loader2 className="animate-spin text-blue-500 w-4 h-4" />
                                </div>
                            )}

                            {showSchoolResults && schoolResults.length > 0 && (
                                <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-slate-100 rounded-2xl shadow-xl z-50 max-h-64 overflow-y-auto">
                                    {schoolResults.map((school) => (
                                        <button
                                            key={school.id}
                                            onClick={() => selectSchool(school)}
                                            className="w-full text-left px-4 py-3 hover:bg-blue-50 border-b border-slate-50 last:border-0 transition-colors flex flex-col gap-1"
                                        >
                                            <span className="text-xs font-bold text-slate-700">{school.name}</span>
                                            <div className="flex items-center gap-3 text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                                                <span className="bg-slate-100 px-1.5 py-0.5 rounded text-slate-500">INEP: {school.id}</span>
                                                <span>{school.city}</span>
                                                <span>{school.sre}</span>
                                            </div>
                                        </button>
                                    ))}
                                </div>
                            )}
                        </div>
                        <p className="text-xs text-slate-500 ml-1">
                            {settings.schoolCode
                                ? `✅ Escola validada (INEP: ${settings.schoolCode})`
                                : 'Selecione da lista para validar'
                            }
                        </p>
                    </div>
                </div>
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
                                {settings.logoBase64 ? (
                                    <>
                                        <img src={settings.logoBase64} alt="Logo" className="w-full h-full object-contain p-2" />
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
                            {settings.logoBase64 && (
                                <button
                                    onClick={() => setSettings(prev => ({ ...prev, logoBase64: undefined }))}
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
                                    value={settings.headerText || ''}
                                    onChange={(e) => handleChange('headerText', e.target.value)}
                                    placeholder="Ex: Secretaria de Estado de Educação de MG&#10;Escola Estadual Machado de Assis"
                                    className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-xs font-bold transition-all min-h-[80px]"
                                />
                            </div>
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Rodapé Personalizado</label>
                                <input
                                    type="text"
                                    value={settings.footerText || ''}
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
                            value={settings.favoriteMethodology}
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
                            value={settings.teachingStyle}
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
                            value={settings.assessmentFocus}
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
                            value={settings.toneOfVoice}
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
