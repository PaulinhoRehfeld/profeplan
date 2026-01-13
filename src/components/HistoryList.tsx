import React, { useEffect, useState } from 'react';
import { BookOpen, Calendar, Clock, Download, ExternalLink, FileText, LayoutDashboard, LibraryBig, Projector, Trash2, Search, FileType } from 'lucide-react';
import { supabase } from '../services/supabaseService';
import { getGeneratedContents, deleteGeneratedContent } from '../services/databaseService';
import { getLessons } from '../services/supabaseService';

interface HistoryItem {
    id: string;
    title: string;          // Unified: 'topic' (lessons) or 'title' (generated_contents)
    content: string;
    type: string;           // 'plano', 'aula', 'presentation', etc.
    canva_json?: any;       // Only for lessons
    created_at: string;
    source: 'generated' | 'memory';
}

const HistoryList: React.FC<{ userId: string; onSelectLesson: (content: string) => void }> = ({ userId, onSelectLesson }) => {
    const [items, setItems] = useState<HistoryItem[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        fetchHistory();
    }, [userId]);

    const fetchHistory = async () => {
        setLoading(true);
        try {
            // 1. Fetch "Written" contents (Plans, Activities, Docs)
            const genContents = await getGeneratedContents(userId);

            // 2. Fetch "Rich" memories (Presentations with JSON, etc)
            const { data: lessons, error } = await getLessons(userId);

            const combinedItems: HistoryItem[] = [];

            // Process Generated Contents (Source of Truth for Text)
            if (genContents) {
                genContents.forEach((item: any) => {
                    // Skip presentations here if we want to prefer the 'lessons' version with JSON
                    // But if 'lessons' failed, we keep this as backup? 
                    // Let's hide 'presentation' type from here IF it exists in lessons to avoid duplicates.
                    // For now, let's include everything but mark it.
                    if (item.type !== 'presentation') {
                        combinedItems.push({
                            id: item.id,
                            title: item.title,
                            content: item.content,
                            type: item.type || 'documento',
                            created_at: item.created_at,
                            source: 'generated'
                        });
                    }
                });
            }

            // Process Memory/Lessons (Source of Truth for Presentations)
            if (lessons) {
                lessons.forEach((l: any) => {
                    // We only want 'lessons' that are Presentations (have canva_json) 
                    // OR if they are somehow missing from generated_contents?
                    // For simplicity: If it has canva_json, it's a Presentation -> Add it.
                    if (l.canva_json) {
                        combinedItems.push({
                            id: l.id,
                            title: l.topic, // lessons table uses 'topic'
                            content: l.content,
                            type: 'presentation',
                            canva_json: l.canva_json,
                            created_at: l.created_at,
                            source: 'memory'
                        });
                    }
                });
            }

            // Sort by date desc
            combinedItems.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

            setItems(combinedItems);

        } catch (error) {
            console.error("Erro ao carregar histórico unified:", error);
        } finally {
            setLoading(false);
        }
    };

    const deleteItem = async (id: string, source: 'generated' | 'memory') => {
        if (confirm('Tem certeza que deseja remover este item do histórico?')) {
            let success = false;

            if (source === 'generated') {
                try {
                    await deleteGeneratedContent(id);
                    success = true;
                } catch (e) { console.error(e) }
            } else {
                const { error } = await supabase.from('lessons').delete().eq('id', id);
                if (!error) success = true;
            }

            if (success) {
                setItems(prev => prev.filter(i => i.id !== id));
            }
        }
    };

    const filteredItems = items.filter(i =>
        i.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        i.type.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const getTypeIcon = (type: string) => {
        switch (type.toLowerCase()) {
            case 'presentation': return <Projector size={18} />;
            case 'plano': return <LayoutDashboard size={18} />;
            case 'trimestral': return <Calendar size={18} />;
            case 'aula': return <BookOpen size={18} />;
            default: return <FileText size={18} />;
        }
    };

    const getTypeLabel = (type: string) => {
        switch (type.toLowerCase()) {
            case 'presentation': return 'Apresentação';
            case 'plano': return 'Plano de Aula';
            case 'trimestral': return 'Planej. Trimestral';
            case 'aula': return 'Atividade / Aula';
            case 'avaliacao': return 'Avaliação';
            default: return 'Documento';
        }
    };

    if (loading) {
        return (
            <div className="flex flex-col items-center justify-center h-64 animate-pulse text-slate-400">
                <Clock className="w-12 h-12 mb-4 animate-spin" />
                <p className="font-black uppercase tracking-widest text-[10px]">Sincronizando Memória...</p>
            </div>
        );
    }

    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div>
                    <h2 className="text-2xl font-black text-slate-900 tracking-tight uppercase italic">Memória do Professor</h2>
                    <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
                        {items.length} {items.length === 1 ? 'item salvo' : 'itens salvos'} no histórico
                    </p>
                </div>

                <div className="relative">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                    <input
                        type="text"
                        placeholder="Buscar por título ou tipo..."
                        className="pl-12 pr-6 py-3 bg-slate-50 border border-slate-100 rounded-2xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all w-full md:w-64"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
            </div>

            {filteredItems.length === 0 ? (
                <div className="bg-slate-50 border-2 border-dashed border-slate-100 rounded-[2.5rem] p-20 flex flex-col items-center text-center">
                    <div className="w-16 h-16 bg-white rounded-2xl flex items-center justify-center shadow-sm mb-6">
                        <LibraryBig className="text-slate-200" size={32} />
                    </div>
                    <p className="text-sm font-black text-slate-400 uppercase tracking-widest">Nenhum conteúdo encontrado.</p>
                    <p className="text-[10px] text-slate-300 font-bold uppercase mt-2">Gere planos, aulas ou slides para preencher sua memória.</p>
                </div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                    {filteredItems.map((item) => (
                        <div
                            key={item.id}
                            className="group bg-white border border-slate-100 rounded-[2rem] p-6 shadow-sm hover:shadow-2xl hover:border-blue-100 transition-all duration-300 relative overflow-hidden flex flex-col"
                        >
                            <div className={`absolute top-0 right-0 w-24 h-24 blur-3xl rounded-full -mr-12 -mt-12 transition-colors ${item.type === 'presentation' ? 'bg-purple-50/50 group-hover:bg-purple-100' : 'bg-blue-50/50 group-hover:bg-blue-100'
                                }`}></div>

                            <div className="flex items-start justify-between mb-4 relative z-10">
                                <div className={`w-10 h-10 rounded-xl flex items-center justify-center text-white shadow-lg ${item.type === 'presentation' ? 'bg-purple-600' : 'bg-slate-900'
                                    }`}>
                                    {getTypeIcon(item.type)}
                                </div>
                                <button
                                    onClick={() => deleteItem(item.id, item.source)}
                                    className="p-2 text-slate-300 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
                                    title="Remover permanentemente"
                                >
                                    <Trash2 size={16} />
                                </button>
                            </div>

                            <div className="mb-2">
                                <span className={`text-[9px] font-black uppercase tracking-widest py-1 px-2 rounded-lg ${item.type === 'presentation' ? 'bg-purple-50 text-purple-600' : 'bg-slate-50 text-slate-500'
                                    }`}>
                                    {getTypeLabel(item.type)}
                                </span>
                            </div>

                            <h3 className="font-black text-slate-900 text-sm mb-2 uppercase line-clamp-2 leading-tight tracking-tight flex-1">
                                {item.title}
                            </h3>

                            <div className="flex items-center gap-2 text-xs font-bold text-slate-400 uppercase tracking-widest mb-6">
                                <Calendar size={14} />
                                {new Date(item.created_at).toLocaleDateString('pt-BR')}
                                <span className="mx-1">•</span>
                                <Clock size={14} />
                                {new Date(item.created_at).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}
                            </div>

                            <div className="flex gap-2 relative z-10 mt-auto">
                                <button
                                    onClick={() => onSelectLesson(item.content)}
                                    className={`flex-1 py-4 rounded-xl font-black text-xs uppercase tracking-widest transition-colors flex items-center justify-center gap-2 ${item.type === 'presentation'
                                        ? 'bg-purple-50 text-purple-700 hover:bg-purple-100'
                                        : 'bg-blue-50 text-blue-700 hover:bg-blue-100'
                                        }`}
                                >
                                    <ExternalLink size={16} /> Abrir
                                </button>
                                {item.canva_json && (
                                    <button
                                        className="p-3 bg-fuchsia-50 text-fuchsia-600 rounded-xl hover:bg-fuchsia-100 transition-colors"
                                        title="Baixar Dados Canva (CSV)"
                                        onClick={() => alert("Para usar os dados no Canva, abra a apresentação no modo Estúdio!")}
                                    >
                                        <Download size={14} />
                                    </button>
                                )}
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default HistoryList;
