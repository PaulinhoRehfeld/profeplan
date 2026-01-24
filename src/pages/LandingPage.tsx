import React from 'react';
import { Link } from 'react-router-dom';
import {
    Check, Brain, Clock, FileCheck, BookOpen, Users,
    Target, BarChart, FileText, ArrowRight
} from 'lucide-react';

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

                    {/* Visual Placeholder */}
                    <div className="pt-12 max-w-4xl mx-auto">
                        <div className="bg-slate-100 border-2 border-slate-200 rounded-2xl shadow-2xl p-8 md:p-12 flex items-center justify-center min-h-[300px]">
                            <div className="text-center space-y-3">
                                <div className="w-16 h-16 mx-auto bg-blue-100 rounded-full flex items-center justify-center">
                                    <FileCheck size={32} className="text-blue-600" />
                                </div>
                                <p className="text-slate-500 font-medium text-sm md:text-base italic">
                                    [Aqui entrará um GIF da plataforma gerando um plano de aula]
                                </p>
                            </div>
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

            {/* 6. FOOTER */}
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
                    <div className="grid md:grid-cols-3 gap-8 mb-12">
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
                            © 2024 ProfePlan - Engenharia Pedagógica. Todos os direitos reservados.
                        </p>
                    </div>
                </div>
            </footer>

        </div>
    );
};

export default LandingPage;
