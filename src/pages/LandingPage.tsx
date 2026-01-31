import React from 'react';
import { Link } from 'react-router-dom';
import {
    Check, Brain, Clock, FileCheck, BookOpen, Users,
    Target, BarChart, FileText, ArrowRight, Building2, Sparkles, Gift
} from 'lucide-react';
import ContactSection from '../components/ContactSection';

const LandingPage: React.FC = () => {
    return (
        <div className="min-h-screen bg-white font-sans text-slate-900 overflow-x-hidden">

            {/* 1. NAVBAR */}
            <nav className="fixed top-0 w-full z-50 bg-white/95 backdrop-blur-sm border-b border-slate-100">
                <div className="max-w-7xl mx-auto px-4 md:px-6 h-20 flex items-center justify-between">
                    {/* Logo */}
                    <div className="flex items-center gap-2">
                        <img src="/logo-blue.png" alt="ProfePlan" className="h-10 w-auto" />
                        <span className="text-xl font-bold text-slate-900">ProfePlan</span>
                    </div>

                    {/* Menu (Desktop) */}
                    <div className="hidden md:flex items-center gap-8 font-medium text-slate-700">
                        <a href="#professores" className="hover:text-blue-600 transition-colors">Para Professores</a>
                        <a href="#escolas" className="hover:text-blue-600 transition-colors">Para Escolas</a>
                        <a href="#funcionalidades" className="hover:text-blue-600 transition-colors">Funcionalidades</a>
                        <a href="#contato" className="hover:text-blue-600 transition-colors">Contato</a>
                    </div>

                    {/* Buttons */}
                    <div className="flex items-center gap-3">
                        <Link
                            to="/login"
                            className="hidden md:flex px-5 py-2.5 text-slate-700 font-semibold border border-slate-200 hover:border-blue-600 hover:text-blue-600 rounded-lg transition-all"
                        >
                            Entrar
                        </Link>
                        <Link
                            to="/signup"
                            className="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-lg shadow-md hover:shadow-lg transition-all"
                        >
                            Testar Grátis
                        </Link>
                    </div>
                </div>
            </nav>

            {/* 2. HERO SECTION */}
            <section className="pt-32 pb-20 md:pt-40 md:pb-28 px-4 bg-gradient-to-b from-slate-50 to-white">
                <div className="max-w-6xl mx-auto text-center space-y-8">
                    {/* Headline */}
                    <h1 className="text-4xl md:text-6xl lg:text-7xl font-black text-slate-900 leading-tight tracking-tight">
                        A Engenharia Pedagógica<br />que Trabalha por Você.
                    </h1>

                    {/* Subheadline */}
                    <p className="text-lg md:text-xl text-slate-600 leading-relaxed max-w-4xl mx-auto">
                        A única plataforma que conecta <strong>Professores</strong> e <strong>Gestores</strong> para criar Planejamentos, Avaliações e PDIs personalizados automaticamente.
                        Não copiamos conteúdo; <strong>criamos inteligência para sua escola.</strong>
                    </p>

                    {/* CTAs */}
                    <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
                        <Link
                            to="/signup?role=professor"
                            className="w-full sm:w-auto px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg hover:shadow-xl transition-all text-lg flex items-center justify-center gap-2"
                        >
                            <BookOpen size={20} />
                            Sou Professor
                        </Link>
                        <Link
                            to="/signup?role=gestor"
                            className="w-full sm:w-auto px-8 py-4 bg-white border-2 border-slate-300 hover:border-blue-600 hover:bg-blue-50 text-slate-700 font-bold rounded-xl transition-all text-lg flex items-center justify-center gap-2"
                        >
                            <Users size={20} />
                            Sou Gestor Escolar
                        </Link>
                    </div>

                    {/* Hero Animation Video */}
                    <div className="pt-12 max-w-4xl mx-auto">
                        <div className="relative bg-slate-100 border-2 border-slate-200 rounded-2xl shadow-2xl overflow-hidden">
                            {/* Wrapper para fazer crop do vídeo - oculta barra superior */}
                            <div className="relative w-full overflow-hidden" style={{ paddingBottom: '56.25%' /* 16:9 aspect ratio */ }}>
                                <video
                                    className="absolute top-0 left-0 w-full h-auto"
                                    style={{
                                        transform: 'scale(1.15) translateY(-8%) translateX(8%)',
                                        transformOrigin: 'center center'
                                    }}
                                    autoPlay
                                    loop
                                    muted
                                    playsInline
                                    preload="metadata"
                                    aria-label="Demonstração da plataforma ProfePlan gerando planejamento de aula"
                                >
                                    <source src="/videos/hero-animation.mp4" type="video/mp4" />
                                    {/* Fallback para navegadores que não suportam vídeo */}
                                    <div className="bg-slate-100 p-8 md:p-12 flex items-center justify-center min-h-[300px]">
                                        <div className="text-center space-y-3">
                                            <div className="w-16 h-16 mx-auto bg-blue-100 rounded-full flex items-center justify-center">
                                                <FileCheck size={32} className="text-blue-600" />
                                            </div>
                                            <p className="text-slate-500 font-medium text-sm md:text-base">
                                                Demonstração: Plataforma gerando planejamento pedagógico
                                            </p>
                                        </div>
                                    </div>
                                </video>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* 2.5 BANNER DE PROMOÇÃO - INÍCIO DE ANO */}
            <section className="py-6 px-4 bg-gradient-to-r from-blue-600 via-blue-700 to-indigo-600">
                <div className="max-w-6xl mx-auto">
                    <div className="flex flex-col md:flex-row items-center justify-between gap-6 text-white">
                        <div className="flex items-center gap-4">
                            <div className="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
                                <Gift size={32} className="text-white" />
                            </div>
                            <div>
                                <div className="flex items-center gap-2 mb-1">
                                    <Sparkles size={16} className="text-yellow-300" />
                                    <span className="text-xs font-black uppercase tracking-wider text-yellow-300">Promoção Início de Ano</span>
                                </div>
                                <h3 className="text-2xl md:text-3xl font-black">
                                    10 Créditos de Boas-Vindas!
                                </h3>
                                <p className="text-sm text-blue-100 mt-1">
                                    Faça login com seu <strong>email institucional</strong> e ganhe 10 créditos para conhecer a plataforma.
                                </p>
                            </div>
                        </div>
                        <Link
                            to="/signup"
                            className="whitespace-nowrap px-8 py-4 bg-white text-blue-600 font-bold rounded-xl shadow-lg hover:shadow-xl hover:scale-105 transition-all"
                        >
                            Resgatar Agora
                        </Link>
                    </div>
                </div>
            </section>

            {/* 2.6 NOVIDADES 2026 */}
            <section className="py-16 md:py-20 px-4 bg-white border-y border-slate-100">
                <div className="max-w-6xl mx-auto">
                    <div className="text-center mb-12">
                        <div className="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-full text-sm font-black uppercase text-blue-600 mb-4">
                            <Sparkles size={16} />
                            Novidades 2026
                        </div>
                        <h2 className="text-3xl md:text-4xl font-black text-slate-900 mb-3">
                            O que há de novo?
                        </h2>
                        <p className="text-lg text-slate-600">
                            Recursos exclusivos para facilitar ainda mais sua rotina pedagógica.
                        </p>
                    </div>

                    <div className="grid md:grid-cols-2 gap-8">
                        {/* Cartão 1: Link Escola-Professor */}
                        <div className="bg-gradient-to-br from-blue-50 via-white to-indigo-50 border-2 border-blue-200 rounded-3xl p-8 hover:shadow-2xl transition-all">
                            <div className="w-16 h-16 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-2xl flex items-center justify-center mb-6 shadow-lg">
                                <Building2 size={32} className="text-white" />
                            </div>
                            <h3 className="text-2xl font-black text-slate-900 mb-3">
                                Link Direto Escola→Professor
                            </h3>
                            <p className="text-slate-600 leading-relaxed mb-4">
                                Gestores podem integrar professores diretamente ao sistema da escola.
                                Acabou a confusão de criar contas separadas!
                            </p>
                            <ul className="space-y-2">
                                <li className="flex items-start gap-2 text-sm text-slate-700">
                                    <Check size={18} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span>Sincronização automática de turmas</span>
                                </li>
                                <li className="flex items-start gap-2 text-sm text-slate-700">
                                    <Check size={18} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span>Visibilidade total dos planejamentos</span>
                                </li>
                                <li className="flex items-start gap-2 text-sm text-slate-700">
                                    <Check size={18} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span>Dados centralizados em tempo real</span>
                                </li>
                            </ul>
                        </div>

                        {/* Cartão 2: Modo Multi-Escolas */}
                        <div className="bg-gradient-to-br from-purple-50 via-white to-pink-50 border-2 border-purple-200 rounded-3xl p-8 hover:shadow-2xl transition-all">
                            <div className="w-16 h-16 bg-gradient-to-br from-purple-600 to-pink-600 rounded-2xl flex items-center justify-center mb-6 shadow-lg">
                                <Users size={32} className="text-white" />
                            </div>
                            <div className="flex items-center gap-2 mb-3">
                                <h3 className="text-2xl font-black text-slate-900">
                                    Modo Multi-Escolas
                                </h3>
                                <span className="px-2 py-1 bg-purple-100 text-purple-700 text-[10px] font-black uppercase rounded-full">
                                    2º Cargo
                                </span>
                            </div>
                            <p className="text-slate-600 leading-relaxed mb-4">
                                Trabalha em mais de uma escola? Agora você pode alternar entre escolas
                                com um clique, sem precisar fazer logout!
                            </p>
                            <ul className="space-y-2">
                                <li className="flex items-start gap-2 text-sm text-slate-700">
                                    <Check size={18} className="text-purple-600 shrink-0 mt-0.5" />
                                    <span>Seletor de escola no header</span>
                                </li>
                                <li className="flex items-start gap-2 text-sm text-slate-700">
                                    <Check size={18} className="text-purple-600 shrink-0 mt-0.5" />
                                    <span>Dados separados por instituição</span>
                                </li>
                                <li className="flex items-start gap-2 text-sm text-slate-700">
                                    <Check size={18} className="text-purple-600 shrink-0 mt-0.5" />
                                    <span>Troca instantânea de contexto</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>

            {/* 3. SEÇÃO DE VALOR - O Diferencial */}
            <section id="funcionalidades" className="py-20 md:py-28 px-4 bg-white">
                <div className="max-w-6xl mx-auto">
                    {/* Título */}
                    <div className="text-center mb-16 space-y-3">
                        <h2 className="text-3xl md:text-5xl font-black text-slate-900">
                            Não somos um banco de atividades.
                        </h2>
                        <p className="text-xl md:text-2xl text-slate-600 font-semibold">
                            Somos o seu Assistente Pedagógico Pessoal.
                        </p>
                    </div>

                    {/* Cards (3 colunas) */}
                    <div className="grid md:grid-cols-3 gap-8">
                        {/* Card 1: Inteligência Real */}
                        <div className="bg-white border border-slate-200 rounded-2xl p-8 hover:shadow-xl transition-all">
                            <div className="w-14 h-14 bg-blue-100 rounded-xl flex items-center justify-center mb-6">
                                <Brain size={28} className="text-blue-600" />
                            </div>
                            <h3 className="text-xl font-bold text-slate-900 mb-3">Inteligência Real</h3>
                            <p className="text-slate-600 leading-relaxed">
                                O sistema aprende com o perfil da sua turma e suas preferências.
                            </p>
                        </div>

                        {/* Card 2: Fim da Burocracia */}
                        <div className="bg-white border border-slate-200 rounded-2xl p-8 hover:shadow-xl transition-all">
                            <div className="w-14 h-14 bg-emerald-100 rounded-xl flex items-center justify-center mb-6">
                                <Clock size={28} className="text-emerald-600" />
                            </div>
                            <h3 className="text-xl font-bold text-slate-900 mb-3">Fim da Burocracia</h3>
                            <p className="text-slate-600 leading-relaxed">
                                Deixe a parte chata de formatação e BNCC com a gente. Foque em ensinar.
                            </p>
                        </div>

                        {/* Card 3: Documentação Oficial */}
                        <div className="bg-white border border-slate-200 rounded-2xl p-8 hover:shadow-xl transition-all">
                            <div className="w-14 h-14 bg-purple-100 rounded-xl flex items-center justify-center mb-6">
                                <FileCheck size={28} className="text-purple-600" />
                            </div>
                            <h3 className="text-xl font-bold text-slate-900 mb-3">Documentação Oficial</h3>
                            <p className="text-slate-600 leading-relaxed">
                                Tudo já sai formatado nas normas da SEE-MG e BNCC.
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            {/* 4. SEÇÃO "QUEM É VOCÊ?" - Split Section */}
            <section className="py-20 md:py-28 px-4 bg-slate-50">
                <div className="max-w-6xl mx-auto">
                    <div className="grid md:grid-cols-2 gap-8">

                        {/* LADO A: PARA O PROFESSOR */}
                        <div id="professores" className="bg-white border-2 border-blue-200 rounded-3xl p-8 md:p-10 space-y-6">
                            <div className="flex items-center gap-3 mb-2">
                                <div className="text-4xl">🍎</div>
                                <div className="px-3 py-1 bg-blue-100 text-blue-700 text-xs font-bold uppercase rounded-full">
                                    Para Professores
                                </div>
                            </div>

                            <h3 className="text-3xl md:text-4xl font-black text-slate-900">
                                Recupere seus fins de semana.
                            </h3>

                            <ul className="space-y-4">
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        Planejamentos de Aula em segundos.
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        Sequências Didáticas alinhadas à BNCC.
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        Relatórios de desempenho automáticos.
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        "Adeus ao Ctrl+C / Ctrl+V".
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-blue-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        <strong className="text-blue-600">Novo:</strong> Modo Multi-Escolas para 2º cargo.
                                    </span>
                                </li>
                            </ul>

                            <div className="pt-4">
                                <Link
                                    to="/signup?role=professor"
                                    className="w-full flex items-center justify-center gap-2 px-6 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl transition-all"
                                >
                                    Começar Agora <ArrowRight size={20} />
                                </Link>
                            </div>
                        </div>

                        {/* LADO B: PARA A ESCOLA (GESTÃO) */}
                        <div id="escolas" className="bg-white border-2 border-emerald-200 rounded-3xl p-8 md:p-10 space-y-6">
                            <div className="flex items-center gap-3 mb-2">
                                <div className="text-4xl">🏫</div>
                                <div className="px-3 py-1 bg-emerald-100 text-emerald-700 text-xs font-bold uppercase rounded-full">
                                    Para Escolas
                                </div>
                            </div>

                            <h3 className="text-3xl md:text-4xl font-black text-slate-900">
                                Gestão Pedagógica de Verdade.
                            </h3>

                            <ul className="space-y-4">
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-emerald-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        Padronização dos documentos da escola.
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-emerald-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        Acompanhamento em tempo real dos planejamentos.
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-emerald-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        <strong>Novo:</strong> Gestão Integrada de PDI (Plano de Desenvolvimento Individual).
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-emerald-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        <strong className="text-emerald-600">Novo:</strong> Link direto escola→professor.
                                    </span>
                                </li>
                                <li className="flex items-start gap-3">
                                    <Check size={24} className="text-emerald-600 shrink-0 mt-0.5" />
                                    <span className="text-slate-700 font-medium">
                                        Vínculo automático de turmas e professores.
                                    </span>
                                </li>
                            </ul>

                            <div className="pt-4">
                                <Link
                                    to="/signup?role=gestor"
                                    className="w-full flex items-center justify-center gap-2 px-6 py-4 bg-emerald-600 hover:bg-emerald-700 text-white font-bold rounded-xl transition-all"
                                >
                                    Integrar Escola <ArrowRight size={20} />
                                </Link>
                            </div>
                        </div>

                    </div>
                </div>
            </section>

            {/* 5. SEÇÃO DESTAQUE: O PDI */}
            <section className="py-20 md:py-28 px-4 bg-blue-50">
                <div className="max-w-5xl mx-auto">
                    <div className="bg-white border border-blue-200 rounded-3xl p-8 md:p-12 shadow-xl">
                        <div className="text-center md:text-left space-y-6">
                            {/* Badge */}
                            <div className="inline-flex items-center gap-2 px-4 py-2 bg-blue-100 text-blue-700 rounded-full text-sm font-bold">
                                <Target size={16} />
                                Novidade
                            </div>

                            {/* Título */}
                            <h2 className="text-3xl md:text-5xl font-black text-slate-900">
                                PDI Automático: Da Burocracia à Inclusão Real
                            </h2>

                            {/* Texto */}
                            <p className="text-lg md:text-xl text-slate-600 leading-relaxed">
                                Conectamos os registros diários do professor diretamente ao documento do PDI.
                                O relatório se escreve sozinho enquanto a equipe trabalha, garantindo um histórico
                                rico e detalhado do aluno.
                            </p>

                            {/* Botão */}
                            <div className="pt-4">
                                <Link
                                    to="/signup"
                                    className="inline-flex items-center gap-2 px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg transition-all"
                                >
                                    <BarChart size={20} />
                                    Conhecer o Painel de Gestão
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* 6. SECTION CONTATO */}
            <ContactSection />

            {/* 7. FOOTER */}
            <footer className="bg-slate-900 text-white py-16 px-4">
                <div className="max-w-6xl mx-auto">
                    {/* CTA Final */}
                    <div className="text-center mb-12 pb-12 border-b border-slate-700">
                        <h3 className="text-3xl md:text-4xl font-black mb-6">
                            Pronto para transformar sua prática pedagógica?
                        </h3>
                        <Link
                            to="/signup"
                            className="inline-flex items-center gap-2 px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg transition-all"
                        >
                            Começar Gratuitamente <ArrowRight size={20} />
                        </Link>
                        <p className="mt-4 text-slate-400 text-sm">Sem cartão de crédito • 10 créditos grátis</p>
                    </div>

                    {/* Footer Links */}
                    <div className="grid md:grid-cols-4 gap-8 mb-12">
                        <div>
                            <h4 className="font-bold text-lg mb-4">ProfePlan</h4>
                            <p className="text-slate-400 text-sm leading-relaxed">
                                A primeira plataforma de Engenharia Pedagógica com IA para professores e gestores escolares.
                            </p>
                        </div>
                        <div>
                            <h4 className="font-bold text-lg mb-4">Links Rápidos</h4>
                            <ul className="space-y-2 text-slate-400 text-sm">
                                <li><a href="#professores" className="hover:text-white transition-colors">Para Professores</a></li>
                                <li><a href="#escolas" className="hover:text-white transition-colors">Para Escolas</a></li>
                                <li><a href="#funcionalidades" className="hover:text-white transition-colors">Funcionalidades</a></li>
                            </ul>
                        </div>
                        <div>
                            <h4 className="font-bold text-lg mb-4">Legal</h4>
                            <ul className="space-y-2 text-slate-400 text-sm">
                                <li><Link to="/privacy" className="hover:text-white transition-colors">Política de Privacidade</Link></li>
                                <li><Link to="/terms" className="hover:text-white transition-colors">Termos de Serviço</Link></li>
                            </ul>
                        </div>
                        <div>
                            <h4 className="font-bold text-lg mb-4">Suporte</h4>
                            <ul className="space-y-2 text-slate-400 text-sm">
                                <li><Link to="/login" className="hover:text-white transition-colors">Entrar</Link></li>
                                <li><Link to="/signup" className="hover:text-white transition-colors">Criar Conta</Link></li>
                            </ul>
                        </div>
                    </div>

                    {/* Copyright */}
                    <div className="text-center pt-8 border-t border-slate-700">
                        <p className="text-slate-500 text-sm">
                            © 2025 ProfePlan - Engenharia Pedagógica. Todos os direitos reservados. v3.8
                        </p>
                    </div>
                </div>
            </footer>

        </div>
    );
};

export default LandingPage;
