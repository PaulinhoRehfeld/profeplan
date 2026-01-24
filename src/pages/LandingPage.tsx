import React from 'react';
import { Link } from 'react-router-dom';
import {
    Check, X, Sparkles, Smartphone, Heart, Layout,
    ArrowRight, Play, Star, ShieldCheck, Users, Crown
} from 'lucide-react';

const LandingPage: React.FC = () => {
    return (
        <div className="min-h-screen bg-slate-50 font-sans text-slate-900 overflow-x-hidden">

            {/* 1. Navbar (Sticky/Fixa) */}
            <nav className="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-md border-b border-slate-100 transition-all duration-300">
                <div className="max-w-7xl mx-auto px-4 md:px-6 h-20 flex items-center justify-between">

                    {/* Logo */}
                    <div className="flex items-center gap-3">
                        <img src="/logo-blue.png" alt="Profeplan" className="h-12 w-auto" />
                    </div>

                    {/* Links (Desktop) */}
                    <div className="hidden md:flex items-center gap-8 font-medium text-slate-600">
                        <a href="#features" className="hover:text-blue-600 transition-colors">Funcionalidades</a>
                        <a href="#pricing" className="hover:text-amber-500 transition-colors font-bold text-amber-600">Planos</a>
                        <a href="#benefits" className="hover:text-blue-600 transition-colors">Benefícios</a>
                        <a href="#schools" className="hover:text-blue-600 transition-colors">Para Escolas</a>
                    </div>

                    {/* Buttons */}
                    <div className="flex items-center gap-3">
                        <Link
                            to="/login"
                            className="hidden md:flex px-5 py-2.5 text-slate-700 font-bold hover:text-blue-600 hover:bg-slate-50 rounded-xl transition-all"
                        >
                            Entrar
                        </Link>
                        <Link
                            to="/signup"
                            className="px-6 py-2.5 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-xl shadow-lg shadow-blue-600/30 transition-all hover:-translate-y-0.5 active:translate-y-0 text-sm md:text-base"
                        >
                            Começar Grátis
                        </Link>
                    </div>
                </div>
            </nav>

            {/* 2. Hero Section */}
            <section className="pt-32 pb-20 md:pt-40 md:pb-32 px-4 relative overflow-hidden">
                {/* Background Gradients */}
                <div className="absolute top-0 right-0 w-[50%] h-[50%] bg-blue-600/5 rounded-full blur-3xl -translate-y-1/4 translate-x-1/4"></div>
                <div className="absolute bottom-0 left-0 w-[50%] h-[50%] bg-emerald-500/5 rounded-full blur-3xl translate-y-1/4 -translate-x-1/4"></div>

                <div className="max-w-7xl mx-auto grid md:grid-cols-2 gap-12 md:gap-20 items-center relative z-10">

                    {/* Content */}
                    <div className="text-center md:text-left space-y-8 animate-in slide-in-from-bottom-10 fade-in duration-700">
                        <div className="inline-flex items-center gap-2 px-3 py-1 bg-blue-50 text-blue-700 rounded-full text-xs font-bold uppercase tracking-wider mb-2">
                            <Star size={12} fill="currentColor" /> Nova Versão 3.5
                        </div>
                        <h1 className="text-4xl md:text-6xl lg:text-7xl font-black text-slate-900 leading-[1.1] tracking-tight">
                            Planeje aulas <br />
                            <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600">incríveis</span> em minutos.
                        </h1>
                        <p className="text-lg md:text-xl text-slate-600 leading-relaxed max-w-lg mx-auto md:mx-0">
                            A plataforma completa com Inteligência Artificial que automatiza seu planejamento, alinha tudo à BNCC e cuida da burocracia para você focar no que ama:
                            <span className="font-bold text-slate-900"> ensinar.</span>
                        </p>

                        <div className="flex flex-col sm:flex-row items-center gap-4 justify-center md:justify-start">
                            <Link
                                to="/signup"
                                className="w-full sm:w-auto px-8 py-4 bg-blue-600 hover:bg-blue-50 text-white font-black rounded-2xl shadow-xl shadow-blue-600/20 text-lg flex items-center justify-center gap-3 transition-all hover:scale-105"
                            >
                                TESTAR GRÁTIS AGORA <ArrowRight size={20} />
                            </Link>
                            <a
                                href="#demo"
                                className="w-full sm:w-auto px-8 py-4 bg-white border-2 border-slate-200 hover:border-blue-200 hover:bg-blue-50 text-slate-700 font-bold rounded-2xl flex items-center justify-center gap-3 transition-all"
                            >
                                <Play size={18} fill="currentColor" className="text-slate-400" /> Ver Demo
                            </a>
                        </div>


                    </div>

                    {/* Visual Placeholder */}
                    <div className="relative animate-in slide-in-from-right-10 fade-in duration-1000 delay-200">
                        <div className="relative z-10 bg-white rounded-3xl shadow-2xl shadow-blue-900/20 p-2 md:p-3 border border-slate-100 rotate-2 hover:rotate-0 transition-transform duration-500">
                            <div className="aspect-[4/3] bg-gradient-to-br from-slate-100 to-blue-50 rounded-2xl overflow-hidden flex items-center justify-center relative group">
                                {/* Simulated UI */}
                                <div className="absolute inset-0 flex flex-col p-6 opacity-80">
                                    <div className="h-8 w-1/3 bg-slate-200 rounded-lg mb-6"></div>
                                    <div className="space-y-3">
                                        <div className="h-4 w-full bg-slate-200 rounded-md"></div>
                                        <div className="h-4 w-5/6 bg-slate-200 rounded-md"></div>
                                        <div className="h-4 w-4/6 bg-slate-200 rounded-md"></div>
                                    </div>
                                    <div className="mt-8 grid grid-cols-2 gap-4">
                                        <div className="h-24 bg-blue-100 rounded-xl"></div>
                                        <div className="h-24 bg-emerald-100 rounded-xl"></div>
                                    </div>

                                    {/* Floating Elements */}
                                    <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white px-6 py-4 rounded-2xl shadow-xl flex items-center gap-3 animate-bounce">
                                        <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center text-green-600">
                                            <Check size={20} />
                                        </div>
                                        <div>
                                            <p className="text-xs text-slate-500 font-bold uppercase">Planejamento</p>
                                            <p className="font-bold text-slate-900">Concluído!</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Decorative Elements around image */}
                        <div className="absolute -top-10 -right-10 w-24 h-24 bg-yellow-400 rounded-full blur-2xl opacity-20"></div>
                        <div className="absolute -bottom-10 -left-10 w-32 h-32 bg-blue-600 rounded-full blur-2xl opacity-20"></div>
                    </div>
                </div>
            </section>

            {/* 3. Problems vs Solutions */}
            <section id="benefits" className="py-24 bg-white relative">
                <div className="max-w-7xl mx-auto px-4 md:px-6">
                    <div className="text-center max-w-3xl mx-auto mb-16">
                        <h2 className="text-3xl md:text-4xl font-black text-slate-900 mb-6">Por que mudar para o Profeplan?</h2>
                        <p className="text-slate-600 text-lg">Deixe para trás a burocracia e abrace a inovação.</p>
                    </div>

                    <div className="grid md:grid-cols-2 gap-8 md:gap-12 max-w-5xl mx-auto">

                        {/* O Jeito Antigo */}
                        <div className="bg-red-50/50 rounded-3xl p-8 md:p-10 border border-red-100">
                            <h3 className="text-xl font-bold text-slate-900 mb-6 flex items-center gap-3">
                                <span className="w-8 h-8 rounded-full bg-red-100 flex items-center justify-center text-red-600">
                                    <X size={16} strokeWidth={3} />
                                </span>
                                O Jeito Antigo
                            </h3>
                            <ul className="space-y-4">
                                {[
                                    "Horas formatando documentos no Word",
                                    "Caos para encontrar códigos da BNCC",
                                    "Arquivos espalhados em várias pastas",
                                    "Dificuldade em adaptar para todos os alunos",
                                    "Fim de semana perdidos planejando"
                                ].map((item, i) => (
                                    <li key={i} className="flex items-start gap-3 text-slate-600">
                                        <X size={20} className="text-red-400 shrink-0 mt-0.5" />
                                        <span>{item}</span>
                                    </li>
                                ))}
                            </ul>
                        </div>

                        {/* O Jeito Profeplan */}
                        <div className="bg-emerald-50/50 rounded-3xl p-8 md:p-10 border border-emerald-100 relative overflow-hidden">
                            <div className="absolute top-0 right-0 w-32 h-32 bg-emerald-400/10 rounded-full blur-3xl"></div>

                            <h3 className="text-xl font-bold text-slate-900 mb-6 flex items-center gap-3">
                                <span className="w-8 h-8 rounded-full bg-emerald-100 flex items-center justify-center text-emerald-600">
                                    <Check size={16} strokeWidth={3} />
                                </span>
                                O Jeito Profeplan
                            </h3>
                            <ul className="space-y-4">
                                {[
                                    "IA que cria planos completos em segundos",
                                    "Gestão completa de escola: professores, alunos e turmas",
                                    "16.712 escolas de MG com autocomplete inteligente",
                                    "Pré-cadastro e match automático de professores",
                                    "Adaptação curricular (PDI) e documentos personalizados",
                                    "Mais tempo livre para você e sua família"
                                ].map((item, i) => (
                                    <li key={i} className="flex items-start gap-3 text-slate-800 font-medium">
                                        <Check size={20} className="text-emerald-500 shrink-0 mt-0.5" />
                                        <span>{item}</span>
                                    </li>
                                ))}
                            </ul>
                        </div>

                    </div>
                </div>
            </section>

            {/* 4. Funcionalidades */}
            <section id="features" className="py-24 bg-slate-50">
                <div className="max-w-7xl mx-auto px-4 md:px-6">
                    <div className="text-center max-w-3xl mx-auto mb-16">
                        <span className="text-blue-600 font-bold tracking-widest uppercase text-xs mb-3 block">Funcionalidades Poderosas</span>
                        <h2 className="text-3xl md:text-4xl font-black text-slate-900">Tudo o que você precisa</h2>
                    </div>

                    <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                        {[
                            {
                                icon: <Sparkles size={24} />,
                                color: "bg-blue-500",
                                title: "IA Especialista",
                                desc: "Converse com nossa IA para criar planos de aula, provas e dinâmicas criativas."
                            },
                            {
                                icon: <Users size={24} />,
                                color: "bg-emerald-500",
                                title: "Gestão Escolar",
                                desc: "Sistema completo para cadastro de professores, alunos e turmas. 16.712 escolas de MG integradas."
                            },
                            {
                                icon: <Heart size={24} />,
                                color: "bg-pink-500",
                                title: "Inclusão (PDI)",
                                desc: "Adaptação curricular automática para alunos com necessidades específicas."
                            },
                            {
                                icon: <Layout size={24} />,
                                color: "bg-purple-500",
                                title: "Planejamento Visual",
                                desc: "Arraste e solte conteúdos no planejamento trimestral de forma intuitiva."
                            }
                        ].map((feature, i) => (
                            <div key={i} className="bg-white p-8 rounded-3xl shadow-lg shadow-slate-200/50 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 border border-slate-100">
                                <div className={`w-12 h-12 ${feature.color} rounded-2xl flex items-center justify-center text-white mb-6 shadow-lg shadow-gray-200`}>
                                    {feature.icon}
                                </div>
                                <h3 className="text-xl font-bold text-slate-900 mb-3">{feature.title}</h3>
                                <p className="text-slate-500 leading-relaxed text-sm">
                                    {feature.desc}
                                </p>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* 4.b Planos (Pricing) - NOVO */}
            <section id="pricing" className="py-24 bg-white relative overflow-hidden">
                <div className="absolute top-0 right-0 w-[50%] h-[50%] bg-blue-600/5 rounded-full blur-3xl"></div>

                <div className="max-w-7xl mx-auto px-4 md:px-6 relative z-10">
                    <div className="text-center max-w-3xl mx-auto mb-16">
                        <span className="text-emerald-600 font-bold tracking-widest uppercase text-xs mb-3 block">Investimento no seu Tempo</span>
                        <h2 className="text-3xl md:text-4xl font-black text-slate-900">Escolha o Plano Ideal</h2>
                        <p className="text-slate-500 mt-4 text-lg">Comece grátis e evolua conforme sua necessidade.</p>
                    </div>

                    <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">

                        {/* PLANO SILVER */}
                        <div className="bg-white rounded-3xl p-8 border border-slate-200 shadow-xl flex flex-col relative group hover:border-blue-400 transition-colors">
                            <div className="absolute top-0 w-full h-1 bg-blue-500 left-0 rounded-t-3xl"></div>
                            <img src="/profeplan-silver.jpg" alt="Profeplan Silver" className="w-32 h-32 object-contain mx-auto mb-4" />
                            <h3 className="text-2xl font-black text-slate-900 mb-2">Profeplan Silver</h3>
                            <p className="text-slate-500 text-sm mb-6 min-h-[40px]">O plano ideal para quem busca flexibilidade e produtividade sob medida.</p>

                            <div className="mb-6">
                                <span className="text-4xl font-black text-slate-900">R$ 30,00</span>
                                <span className="text-slate-400 text-sm"> / recarga</span>
                            </div>

                            <ul className="space-y-4 mb-8 flex-1">
                                <li className="flex items-start gap-3 text-slate-700 text-sm">
                                    <Check size={18} className="text-blue-500 shrink-0 mt-0.5" />
                                    <span><b>40 Créditos</b> para usar como quiser</span>
                                </li>
                                <li className="flex items-start gap-3 text-slate-700 text-sm">
                                    <Check size={18} className="text-blue-500 shrink-0 mt-0.5" />
                                    <span>Gere planos de aula, materiais e simulados</span>
                                </li>
                                <li className="flex items-start gap-3 text-slate-700 text-sm">
                                    <Check size={18} className="text-blue-500 shrink-0 mt-0.5" />
                                    <span>Sem mensalidade fixa (Pague o que usar)</span>
                                </li>
                            </ul>

                            <Link to="/signup" className="w-full py-4 bg-white border-2 border-slate-200 text-slate-700 hover:border-blue-500 hover:text-blue-600 font-bold rounded-xl transition-all flex items-center justify-center gap-2">
                                Começar com Silver
                            </Link>
                        </div>

                        {/* PLANO GOLD */}
                        <div className="bg-slate-900 rounded-3xl p-8 border border-amber-500 shadow-2xl flex flex-col relative overflow-hidden transform md:-translate-y-4">
                            <div className="absolute top-0 right-0 w-32 h-32 bg-amber-500/20 blur-3xl rounded-full"></div>
                            <div className="flex justify-between items-center mb-2">
                                <img src="/profeplan-gold.jpg" alt="Profeplan Gold" className="w-24 h-24 object-contain" />
                                <div className="px-3 py-1 bg-amber-500 text-amber-950 font-bold text-[10px] uppercase tracking-wide rounded-full">Recomendado</div>
                            </div>
                            <h3 className="text-2xl font-black text-white mb-2">Profeplan Gold</h3>
                            <p className="text-slate-400 text-sm mb-6 min-h-[40px]">O plano definitivo para o professor que exige produtividade sem limites.</p>

                            <div className="mb-6">
                                <span className="text-4xl font-black text-white">R$ 50</span>
                                <span className="text-slate-400 text-sm"> / mês</span>
                            </div>

                            <ul className="space-y-4 mb-8 flex-1">
                                <li className="flex items-start gap-3 text-slate-300 text-sm">
                                    <Check size={18} className="text-amber-500 shrink-0 mt-0.5" />
                                    <span><b>Acesso Ilimitado</b> a todas as ferramentas</span>
                                </li>
                                <li className="flex items-start gap-3 text-slate-300 text-sm">
                                    <Check size={18} className="text-amber-500 shrink-0 mt-0.5" />
                                    <span>Gere planejamentos sem se preocupar com créditos</span>
                                </li>
                                <li className="flex items-start gap-3 text-slate-300 text-sm">
                                    <Check size={18} className="text-amber-500 shrink-0 mt-0.5" />
                                    <span>Prioridade nas atualizações</span>
                                </li>
                            </ul>

                            <Link to="/signup" className="w-full py-4 bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-400 hover:to-amber-500 text-white font-black rounded-xl transition-all flex items-center justify-center gap-2 shadow-lg shadow-amber-500/20 hover:scale-105">
                                <Crown size={18} />
                                Quero Ser Gold
                            </Link>
                        </div>

                    </div>

                    <div className="mt-12 text-center bg-blue-50/50 rounded-2xl p-6 max-w-2xl mx-auto border border-blue-100">
                        <p className="text-blue-900 font-bold mb-2 flex items-center justify-center gap-2">
                            <Sparkles size={18} className="text-blue-500" /> Promoção Especial de Lançamento
                        </p>
                        <p className="text-slate-600 text-sm">
                            Crie sua conta agora e ganhe automaticamente <b>10 Créditos Grátis</b> no plano Silver para testar a plataforma.
                        </p>
                    </div>

                </div>
            </section>

            {/* 5. Para Escolas - NOVA SEÇÃO */}
            <section id="schools" className="py-24 bg-gradient-to-br from-blue-900 via-blue-800 to-slate-900 text-white relative overflow-hidden">
                <div className="absolute top-0 left-0 w-full h-full opacity-10" style={{ backgroundImage: 'radial-gradient(circle, white 1px, transparent 1px)', backgroundSize: '50px 50px' }}></div>
                <div className="absolute top-20 right-20 w-64 h-64 bg-blue-400/10 rounded-full blur-3xl"></div>
                <div className="absolute bottom-20 left-20 w-96 h-96 bg-emerald-400/10 rounded-full blur-3xl"></div>

                <div className="max-w-7xl mx-auto px-4 md:px-6 relative z-10">
                    <div className="text-center max-w-3xl mx-auto mb-16">
                        <span className="text-blue-300 font-bold tracking-widest uppercase text-xs mb-3 block">Transformação Educacional</span>
                        <h2 className="text-4xl md:text-5xl font-black mb-6">Sistema Completo para Gestão Escolar</h2>
                        <p className="text-blue-100 text-lg">Integre sua escola e professores em uma plataforma moderna. Acompanhe planejamentos, gere PDIs automaticamente e tenha total controle pedagógico.</p>
                    </div>

                    <div className="grid md:grid-cols-3 gap-8 mb-16">
                        {[
                            {
                                icon: <Users size={32} />,
                                title: "Integração Total",
                                desc: "Conecte gestores, professores e alunos em uma única plataforma. Cadastro centralizado com 16.712 escolas de MG integradas."
                            },
                            {
                                icon: <Layout size={32} />,
                                title: "Planejamentos Automáticos",
                                desc: "Professores criam planejamentos trimestrais que ficam automaticamente disponíveis para a equipe gestora acompanhar e validar."
                            },
                            {
                                icon: <Heart size={32} />,
                                title: "PDI Inteligente",
                                desc: "Sistema gera adaptações curriculares (PDI) automaticamente para cada aluno com necessidades específicas, com base nos planejamentos."
                            }
                        ].map((item, i) => (
                            <div key={i} className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20 hover:bg-white/15 transition-all group">
                                <div className="w-16 h-16 bg-blue-500/20 rounded-xl flex items-center justify-center text-blue-300 mb-6 group-hover:scale-110 transition-transform">
                                    {item.icon}
                                </div>
                                <h3 className="text-xl font-bold mb-3">{item.title}</h3>
                                <p className="text-blue-100 leading-relaxed text-sm">{item.desc}</p>
                            </div>
                        ))}
                    </div>

                    <div className="bg-white/5 backdrop-blur-md rounded-3xl p-8 md:p-12 border border-white/10">
                        <div className="grid md:grid-cols-2 gap-12 items-center">
                            <div>
                                <h3 className="text-3xl font-black mb-6">Pré-Cadastro e Match Automático</h3>
                                <ul className="space-y-4">
                                    <li className="flex items-start gap-3">
                                        <Check size={20} className="text-emerald-400 shrink-0 mt-1" />
                                        <span className="text-blue-100">Gestor cadastra professores com <b className="text-white">email institucional e MASP</b></span>
                                    </li>
                                    <li className="flex items-start gap-3">
                                        <Check size={20} className="text-emerald-400 shrink-0 mt-1" />
                                        <span className="text-blue-100">Professor preenche dados no primeiro login</span>
                                    </li>
                                    <li className="flex items-start gap-3">
                                        <Check size={20} className="text-emerald-400 shrink-0 mt-1" />
                                        <span className="text-blue-100"><b className="text-white">Match automático</b> vincula professor à escola</span>
                                    </li>
                                    <li className="flex items-start gap-3">
                                        <Check size={20} className="text-emerald-400 shrink-0 mt-1" />
                                        <span className="text-blue-100">Acompanhamento em tempo real de pendentes e ativos</span>
                                    </li>
                                </ul>
                            </div>
                            <div className="bg-gradient-to-br from-blue-500/20 to-emerald-500/20 rounded-2xl p-8 border border-white/20">
                                <div className="bg-white/10 rounded-xl p-4 mb-4">
                                    <div className="flex items-center justify-between mb-2">
                                        <span className="text-xs text-blue-200 font-bold">AGUARDANDO LOGIN</span>
                                        <span className="px-2 py-1 bg-yellow-500/20 text-yellow-300 text-xs rounded-full font-bold">Pendente</span>
                                    </div>
                                    <p className="text-sm text-white font-semibold">Prof. João Silva</p>
                                    <p className="text-xs text-blue-200">joao.silva@educacao.mg.gov.br</p>
                                </div>
                                <div className="bg-white/10 rounded-xl p-4">
                                    <div className="flex items-center justify-between mb-2">
                                        <span className="text-xs text-blue-200 font-bold">ATIVO</span>
                                        <span className="px-2 py-1 bg-green-500/20 text-green-300 text-xs rounded-full font-bold">Vinculado</span>
                                    </div>
                                    <p className="text-sm text-white font-semibold">Prof. Maria Santos</p>
                                    <p className="text-xs text-blue-200">EE Dom Pedro II • 12 planos criados</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="mt-12 text-center">
                        <Link to="/signup" className="inline-flex items-center gap-3 px-10 py-5 bg-white hover:bg-blue-50 text-blue-900 font-black rounded-2xl shadow-2xl text-lg transition-all hover:scale-105">
                            <Users size={24} />
                            Integrar Minha Escola Agora
                        </Link>
                        <p className="mt-4 text-blue-300 text-sm">Sistema gratuito para gestores • Sem limite de professores</p>
                    </div>
                </div>
            </section>

            {/* 6. CTA & Footer */}
            <footer className="bg-slate-900 text-white pt-24 pb-10 overflow-hidden relative">
                <div className="absolute top-0 right-0 w-full h-full bg-[url('/grid-pattern.svg')] opacity-5"></div>
                <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[400px] bg-blue-600/20 blur-[120px] rounded-full pointer-events-none"></div>

                <div className="max-w-7xl mx-auto px-4 md:px-6 relative z-10">
                    <div className="text-center max-w-3xl mx-auto mb-20">
                        <h2 className="text-4xl md:text-5xl font-black mb-8 tracking-tight">Pronto para transformar suas aulas?</h2>
                        <p className="text-blue-200 text-lg mb-10">
                            Professores inovadores já estão economizando tempo e encantando seus alunos.
                        </p>
                        <Link
                            to="/signup"
                            className="inline-flex items-center gap-3 px-10 py-5 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-2xl shadow-2xl shadow-blue-900/50 text-xl transition-all hover:scale-105"
                        >
                            Criar Conta Grátis <ArrowRight size={24} />
                        </Link>
                        <p className="mt-6 text-slate-500 text-sm">Não requer cartão de crédito • Plano gratuito disponível</p>
                    </div>

                    <div className="border-t border-white/10 pt-10 flex flex-col md:flex-row items-center justify-between gap-6">
                        <div className="flex items-center gap-3 opacity-80">
                            <Sparkles size={20} className="text-blue-400" />
                            <span className="font-bold text-lg">Profeplan</span>
                        </div>
                        <div className="text-slate-500 text-sm">
                            &copy; 2026 Profeplan Tecnologia Educacional.
                        </div>
                        <div className="flex gap-6">
                            <a href="#" className="text-slate-400 hover:text-white transition-colors"><ShieldCheck size={20} /></a>
                            <a href="#" className="text-slate-400 hover:text-white transition-colors"><Heart size={20} /></a>
                        </div>
                    </div>
                </div>
            </footer>

        </div>
    );
};

export default LandingPage;
