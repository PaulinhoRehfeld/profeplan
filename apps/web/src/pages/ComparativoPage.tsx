import React, { useState } from 'react';
import { 
  GitCompare, 
  Database, 
  Cpu, 
  Shield, 
  ArrowRight, 
  Clock, 
  Layers, 
  Globe, 
  Sparkles, 
  Info,
  ChevronRight,
  TrendingUp,
  FileCheck
} from 'lucide-react';

interface CompareDimension {
  id: string;
  title: string;
  icon: React.ReactNode;
  v4Content: string;
  v5Content: string;
  impact: string;
  category: 'arquitetura' | 'negocio' | 'ia' | 'produto';
}

export default function ComparativoPage() {
  const [selectedArchTab, setSelectedArchTab] = useState<'v4' | 'v5'>('v4');
  const [activeCardId, setActiveCardId] = useState<string | null>(null);
  const [hoveredNode, setHoveredNode] = useState<string | null>(null);
  const [selectedTimelinePhase, setSelectedTimelinePhase] = useState<number>(2); // Default to Phase 3 (index 2)

  const dimensions: CompareDimension[] = [
    {
      id: 'natureza',
      title: 'Natureza do Repositório',
      icon: <Layers className="w-8 h-8 text-blue-400" />,
      v4Content: 'Repositório de documentação, especificações de produto, modelos de dados e arquitetura. Sem código operacional direto.',
      v5Content: 'Repositório operacional consolidado da versão 5.0 contendo o código executável dos novos microsserviços e apps.',
      impact: 'Separação clara entre a base conceitual/histórica (V4) e a evolução do código em produção (V5).',
      category: 'produto'
    },
    {
      id: 'negocio',
      title: 'Foco do Negócio & Mercado',
      icon: <Globe className="w-8 h-8 text-blue-400" />,
      v4Content: 'Validação de MVP focado principalmente nos professores da rede pública de Minas Gerais (SEE/MG).',
      v5Content: 'Arquitetura modularizada escalável B2G preparada para adoção nacional (qualquer secretaria de educação do Brasil).',
      impact: 'Escalabilidade comercial e capacidade de plugar regras curriculares de outros estados dinamicamente.',
      category: 'negocio'
    },
    {
      id: 'arquitetura',
      title: 'Arquitetura de Software',
      icon: <Database className="w-8 h-8 text-blue-400" />,
      v4Content: 'Monorepo Industrial dividido entre a Loja (React/Vite Frontend) e Indústrias offline (pipelines batch em Python).',
      v5Content: 'Evolução para microsserviços integrados de forma síncrona/assíncrona, simplificando o monorepo local.',
      impact: 'Redução drástica no tempo de resposta e facilidade para implantar melhorias pontuais sem afetar o app inteiro.',
      category: 'arquitetura'
    },
    {
      id: 'ia',
      title: 'Inteligência Artificial & Agentes',
      icon: <Cpu className="w-8 h-8 text-blue-400" />,
      v4Content: 'Uso de Azure OpenAI (geração de texto) e Google Gemini (embeddings de 768 dimensões) operando isoladamente.',
      v5Content: 'Orquestração de agentes autônomos (Agente Planejador + Didático + Avaliador) trabalhando em cadeia via Azure.',
      impact: 'Gerações com fidelidade curricular absoluta, zero alucinação da BNCC e otimização do custo por token.',
      category: 'ia'
    },
    {
      id: 'pdi',
      title: 'Educação Inclusiva (PDI / DUA)',
      icon: <FileCheck className="w-8 h-8 text-blue-400" />,
      v4Content: 'Adaptação reativa baseada nas observações do perfil de alunos laudados ou com dificuldades anotadas.',
      v5Content: 'Motor de PDI automatizado integrado ao planejamento macro, sugerindo adaptações metodológicas no fluxo diário.',
      impact: 'Atendimento aos requisitos legais e forte apelo pedagógico-social em licitações públicas.',
      category: 'produto'
    },
    {
      id: 'seguranca',
      title: 'Segurança & Contorno de Firewall',
      icon: <Shield className="w-8 h-8 text-blue-400" />,
      v4Content: 'OAuth secundário e Supabase Auth isolado para contornar bloqueios das redes de internet governamentais.',
      v5Content: 'Arquitetura de segurança federada reforçada, com políticas rígidas de RLS e autenticação adaptativa.',
      impact: 'Blindagem de dados dos alunos e professores contra vulnerabilidades comuns e auditoria B2G facilitada.',
      category: 'arquitetura'
    }
  ];

  const timelinePhases = [
    {
      phase: 1,
      title: 'Fase 1 a 3: Fundação & MVP',
      status: 'Concluído (V4)',
      color: 'bg-emerald-500',
      description: 'Modelagem do banco de dados inicial, processamento dos currículos locais e testes iniciais de aceitação dos professores.'
    },
    {
      phase: 2,
      title: 'Fase 4: Holding Industrial',
      status: 'Operacional (V4)',
      color: 'bg-emerald-500',
      description: 'Estruturação do monorepo operacional separando Frontend (Loja) e pipelines Python (Indústrias BNCC/PNLD).'
    },
    {
      phase: 3,
      title: 'Fase 5: Estabilização de Rotas',
      status: 'Fase Atual (V4.3.1)',
      color: 'bg-amber-500 animate-pulse',
      description: 'Consolidação das rotas de PDI, importador de turmas do SIMADE e testes automatizados de ponta a ponta.'
    },
    {
      phase: 4,
      title: 'Fase 6: Alvo V5 & Escala',
      status: 'Planejado (V5)',
      color: 'bg-blue-500',
      description: 'Migração completa de infraestrutura para ambiente de alta disponibilidade e lançamento do motor multi-agente nacional.'
    }
  ];

  return (
    <div className="lp-root min-h-screen bg-[#070b14] text-[#f1f5f9] p-6 md:p-12 selection:bg-blue-600 selection:text-white relative overflow-hidden">
      
      {/* Background orbs (Estilo Landing Page) */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 left-1/2 -translate-x-1/2 w-[900px] h-[700px] bg-radial from-blue-900/20 to-transparent opacity-60 rounded-full blur-3xl" />
        <div className="absolute top-1/4 -right-40 w-[500px] h-[500px] bg-radial from-indigo-900/10 to-transparent opacity-40 rounded-full blur-3xl" />
        <div className="absolute bottom-10 -left-40 w-[400px] h-[400px] bg-radial from-violet-900/10 to-transparent opacity-30 rounded-full blur-3xl" />
        {/* Grid lines */}
        <div
          className="absolute inset-0 opacity-[0.03]"
          style={{
            backgroundImage: 'linear-gradient(rgba(59,130,246,0.5) 1px, transparent 1px), linear-gradient(90deg, rgba(59,130,246,0.5) 1px, transparent 1px)',
            backgroundSize: '80px 80px',
          }}
        />
      </div>

      <div className="relative z-10 max-w-7xl mx-auto space-y-10">

        {/* Header (Estilo Landing Page Premium) */}
        <header className="bg-white/5 border border-white/10 backdrop-blur-xl p-8 md:p-12 rounded-3xl relative overflow-hidden shadow-2xl">
          <div className="absolute right-6 top-6 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold px-4 py-2 rounded-full text-xs md:text-sm shadow-lg shadow-blue-500/20 flex items-center gap-2">
            <Sparkles className="w-4 h-4 animate-spin-slow" /> REUNIÃO DE ALINHAMENTO
          </div>
          <div className="flex items-center gap-3 mb-4">
            <GitCompare className="w-8 h-8 text-blue-400" />
            <span className="text-xs font-bold uppercase tracking-widest text-blue-400 bg-blue-500/10 px-3 py-1 rounded-full border border-blue-500/20">
              Evolução e Engenharia
            </span>
          </div>
          <h1 className="text-4xl md:text-6xl font-black tracking-tight text-white mb-6 leading-tight">
            PROFEPLAN: <span className="bg-gradient-to-r from-blue-400 via-indigo-300 to-white bg-clip-text text-transparent">Evolução Tecnológica</span>
          </h1>
          <p className="text-base md:text-xl text-slate-400 max-w-4xl leading-relaxed border-t border-white/10 pt-6">
            Comparativo de alto nível entre os repositórios **V4** (Estado Atual Operacional) e **V5** (Nova Geração de Escala Nacional). Preparado para integração rápida de membros da equipe e apresentação para stakeholders.
          </p>
        </header>

        {/* SEÇÃO 1: DIAGRAMA DE ARQUITETURA INTERATIVO (Largura Total) */}
        <section className="w-full">
          <div className="bg-white/5 border border-white/10 backdrop-blur-xl rounded-3xl shadow-2xl flex flex-col overflow-hidden">
            {/* Abas Estilo Glassmorphism */}
            <div className="flex border-b border-white/10 bg-black/20 p-2 gap-2">
              <button 
                onClick={() => setSelectedArchTab('v4')}
                className={`flex-1 py-5 text-md md:text-xl text-center font-bold uppercase tracking-wider rounded-2xl transition-all cursor-pointer ${
                  selectedArchTab === 'v4' 
                    ? 'bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-lg shadow-blue-600/20 border border-blue-500/30' 
                    : 'text-slate-400 hover:text-white hover:bg-white/5'
                }`}
              >
                Estrutura V4 (Matriz Atual)
              </button>
              <button 
                onClick={() => setSelectedArchTab('v5')}
                className={`flex-1 py-5 text-md md:text-xl text-center font-bold uppercase tracking-wider rounded-2xl transition-all cursor-pointer ${
                  selectedArchTab === 'v5' 
                    ? 'bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-lg shadow-blue-600/20 border border-blue-500/30' 
                    : 'text-slate-400 hover:text-white hover:bg-white/5'
                }`}
              >
                Meta V5 (Orquestração Futura)
              </button>
            </div>

            {/* Conteúdo do Diagrama */}
            <div className="p-8 md:p-14 min-h-[500px] flex flex-col justify-between relative overflow-hidden bg-slate-950/40">
              {selectedArchTab === 'v4' ? (
                /* DIAGRAMA V4 */
                <div className="flex flex-col gap-10 relative z-10">
                  <div className="text-center mb-2">
                    <span className="text-xs bg-slate-800 text-slate-300 border border-slate-700 px-4 py-1.5 rounded-full font-bold uppercase tracking-wider">
                      Modelo: Holding Industrial Separado
                    </span>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    {/* Linha de Produção Offline */}
                    <div 
                      onMouseEnter={() => setHoveredNode('industrias')}
                      onMouseLeave={() => setHoveredNode(null)}
                      className={`bg-white/5 border rounded-2xl p-6 transition-all duration-300 ${
                        hoveredNode === 'industrias' 
                          ? 'bg-white/10 border-blue-500 -translate-y-1.5 shadow-xl shadow-blue-500/10' 
                          : 'border-white/10'
                      }`}
                    >
                      <div className="flex items-center gap-3 mb-4 border-b border-white/10 pb-3">
                        <Cpu className="w-8 h-8 text-amber-400" />
                        <span className="font-bold text-sm md:text-lg text-white uppercase">1. Indústrias (Offline)</span>
                      </div>
                      <p className="text-sm md:text-base text-slate-400 mb-4 leading-relaxed">
                        Pipelines Python que processam BNCC e PNLD em lotes offline de forma noturna.
                      </p>
                      <span className="inline-block text-xs bg-white/10 text-slate-300 border border-white/10 px-3 py-1 rounded-md font-bold uppercase">Python / Gemini</span>
                    </div>

                    {/* Central DB */}
                    <div 
                      onMouseEnter={() => setHoveredNode('supabase')}
                      onMouseLeave={() => setHoveredNode(null)}
                      className={`bg-white/5 border rounded-2xl p-6 transition-all duration-300 ${
                        hoveredNode === 'supabase' 
                          ? 'bg-white/10 border-blue-500 -translate-y-1.5 shadow-xl shadow-blue-500/10' 
                          : 'border-white/10'
                      }`}
                    >
                      <div className="flex items-center gap-3 mb-4 border-b border-white/10 pb-3">
                        <Database className="w-8 h-8 text-sky-400" />
                        <span className="font-bold text-sm md:text-lg text-white uppercase">2. Armazém (Supabase)</span>
                      </div>
                      <p className="text-sm md:text-base text-slate-400 mb-4 leading-relaxed">
                        Armazena os dados consolidados, embeddings vetoriais (768d) e planos salvos.
                      </p>
                      <span className="inline-block text-xs bg-white/10 text-slate-300 border border-white/10 px-3 py-1 rounded-md font-bold uppercase">PostgreSQL + Vector</span>
                    </div>

                    {/* Frontend */}
                    <div 
                      onMouseEnter={() => setHoveredNode('loja')}
                      onMouseLeave={() => setHoveredNode(null)}
                      className={`bg-white/5 border rounded-2xl p-6 transition-all duration-300 ${
                        hoveredNode === 'loja' 
                          ? 'bg-white/10 border-blue-500 -translate-y-1.5 shadow-xl shadow-blue-500/10' 
                          : 'border-white/10'
                      }`}
                    >
                      <div className="flex items-center gap-3 mb-4 border-b border-white/10 pb-3">
                        <Globe className="w-8 h-8 text-emerald-400" />
                        <span className="font-bold text-sm md:text-lg text-white uppercase">3. A Loja (Web/App)</span>
                      </div>
                      <p className="text-sm md:text-base text-slate-400 mb-4 leading-relaxed">
                        Interface React/Vite. Consome dados limpos do banco para máxima velocidade.
                      </p>
                      <span className="inline-block text-xs bg-white/10 text-slate-300 border border-white/10 px-3 py-1 rounded-md font-bold uppercase">React / Capacitor</span>
                    </div>
                  </div>

                  {/* Setas de Fluxo */}
                  <div className="bg-white/[0.02] border border-white/10 rounded-2xl p-6 flex flex-col md:flex-row justify-around items-center gap-6 text-sm md:text-base font-bold">
                    <span className="flex items-center gap-2 text-amber-400">
                      Indústrias <ArrowRight className="w-5 h-5" /> Envia Dados Limpos <ArrowRight className="w-5 h-5" /> Supabase
                    </span>
                    <span className="flex items-center gap-2 text-emerald-400">
                      Supabase <ArrowRight className="w-5 h-5" /> Consumo Rápido JIT <ArrowRight className="w-5 h-5" /> Frontend Loja
                    </span>
                  </div>

                  {/* Informações Auxiliares */}
                  <div className="bg-blue-500/5 border border-blue-500/20 rounded-2xl p-6 flex gap-4 items-start">
                    <Info className="w-8 h-8 text-blue-400 flex-shrink-0 mt-1" />
                    <div className="text-sm md:text-lg leading-relaxed text-slate-300">
                      <strong>Funcionamento Hoje:</strong> O processamento dos dados educacionais pesados acontece fora do servidor de aplicação principal. O professor interage com uma aplicação leve que consome os dados já estruturados e validados no banco de dados.
                    </div>
                  </div>
                </div>
              ) : (
                /* DIAGRAMA V5 */
                <div className="flex flex-col gap-10 relative z-10">
                  <div className="text-center mb-2">
                    <span className="text-xs bg-slate-800 text-slate-300 border border-slate-700 px-4 py-1.5 rounded-full font-bold uppercase tracking-wider">
                      Modelo: Agentes Orquestrados em Rede
                    </span>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    {/* Multi-Agent Orchestrator */}
                    <div className="bg-white/5 border border-white/10 rounded-2xl p-6 flex flex-col justify-between min-h-[220px]">
                      <div>
                        <div className="flex items-center gap-3 mb-4 border-b border-white/10 pb-3">
                          <Cpu className="w-8 h-8 text-emerald-400" />
                          <span className="font-bold text-sm md:text-lg text-white uppercase">Orquestrador de IA</span>
                        </div>
                        <p className="text-sm md:text-base text-slate-400 leading-relaxed mb-6">
                          Agentes integrados (Planejador + Avaliador) gerando planejamentos didáticos síncronos e integrados.
                        </p>
                      </div>
                      <div className="flex flex-wrap gap-2">
                        <span className="text-xs bg-emerald-500/10 text-emerald-300 border border-emerald-500/20 px-3 py-1 rounded-md font-bold uppercase">Azure OpenAI</span>
                        <span className="text-xs bg-emerald-500/10 text-emerald-300 border border-emerald-500/20 px-3 py-1 rounded-md font-bold uppercase">Multi-Agente</span>
                      </div>
                    </div>

                    {/* Unified Microservices */}
                    <div className="bg-white/5 border border-white/10 rounded-2xl p-6 flex flex-col justify-between min-h-[220px]">
                      <div>
                        <div className="flex items-center gap-3 mb-4 border-b border-white/10 pb-3">
                          <Layers className="w-8 h-8 text-orange-400" />
                          <span className="font-bold text-sm md:text-lg text-white uppercase">Módulos Integrados</span>
                        </div>
                        <p className="text-sm md:text-base text-slate-400 leading-relaxed mb-6">
                          Infraestrutura unificada. O módulo de Inclusão (PDI/DUA) é parte nativa do fluxo principal de planejamento.
                        </p>
                      </div>
                      <div className="flex flex-wrap gap-2">
                        <span className="text-xs bg-orange-500/10 text-orange-300 border border-orange-500/20 px-3 py-1 rounded-md font-bold uppercase">Node/Go API</span>
                        <span className="text-xs bg-orange-500/10 text-orange-300 border border-orange-500/20 px-3 py-1 rounded-md font-bold uppercase">Sincronismo</span>
                      </div>
                    </div>

                    {/* Scale National */}
                    <div className="bg-white/5 border border-white/10 rounded-2xl p-6 flex flex-col justify-between min-h-[220px]">
                      <div>
                        <div className="flex items-center gap-3 mb-4 border-b border-white/10 pb-3">
                          <Globe className="w-8 h-8 text-blue-400" />
                          <span className="font-bold text-sm md:text-lg text-white uppercase">Portal Multitenant</span>
                        </div>
                        <p className="text-sm md:text-base text-slate-400 leading-relaxed mb-6">
                          Carregamento dinâmico de diretrizes curriculares estaduais ou municipais para todo o Brasil.
                        </p>
                      </div>
                      <div className="flex flex-wrap gap-2">
                        <span className="text-xs bg-blue-500/10 text-blue-300 border border-blue-500/20 px-3 py-1 rounded-md font-bold uppercase">B2G Escala</span>
                        <span className="text-xs bg-blue-500/10 text-blue-300 border border-blue-500/20 px-3 py-1 rounded-md font-bold uppercase">Nacional</span>
                      </div>
                    </div>
                  </div>

                  {/* Fluxo e Integração */}
                  <div className="bg-emerald-500/5 border border-emerald-500/20 rounded-2xl p-6 flex items-start gap-4">
                    <Sparkles className="w-8 h-8 text-emerald-400 flex-shrink-0 mt-1" />
                    <div className="text-sm md:text-lg leading-relaxed text-slate-300">
                      <strong>Meta da Versão 5:</strong> A plataforma deixa de ser regional para atender redes educacionais nacionais. O fluxo de geração de planos agora incorpora inteligência adaptativa de acessibilidade (DUA) de ponta a ponta sem delays.
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </section>

        {/* SEÇÃO 2: LINHA DO TEMPO (Largura Total, Estilo Landing Page) */}
        <section className="w-full">
          <div className="bg-white/5 border border-white/10 backdrop-blur-xl p-8 rounded-3xl shadow-2xl">
            <h3 className="font-black text-2xl uppercase mb-6 border-b border-white/10 pb-3 flex items-center gap-3 text-white">
              <Clock className="w-8 h-8 text-blue-400" /> Linha do Tempo e Roadmap do Projeto
            </h3>
            
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6 relative">
              {timelinePhases.map((phase, idx) => (
                <button
                  key={phase.phase}
                  onClick={() => setSelectedTimelinePhase(idx)}
                  className={`border rounded-2xl p-6 text-left cursor-pointer transition-all duration-300 flex flex-col justify-between min-h-[160px] ${
                    selectedTimelinePhase === idx 
                      ? 'bg-gradient-to-b from-blue-950/50 to-blue-900/30 border-blue-500 shadow-xl shadow-blue-500/10 scale-[1.02]' 
                      : 'bg-white/5 border-white/10 hover:bg-white/10'
                  }`}
                >
                  <div>
                    <div className="flex justify-between items-center mb-4">
                      <span className={`w-3.5 h-3.5 rounded-full ${phase.color} shadow-lg`} />
                      <span className="text-xs font-bold tracking-wider text-slate-400 uppercase">{phase.status}</span>
                    </div>
                    <h4 className="font-bold text-sm md:text-lg text-white uppercase leading-tight">{phase.title}</h4>
                  </div>
                  <span className="text-xs font-bold text-blue-400 mt-6 border-t border-white/5 pt-3 block">VER DETALHES →</span>
                </button>
              ))}
            </div>

            {/* Detalhe da Fase */}
            <div className="mt-8 bg-white/[0.02] border border-white/10 rounded-2xl p-6">
              <h4 className="font-bold text-lg md:text-xl text-white uppercase mb-2 flex items-center gap-3">
                <span className="bg-blue-600 text-white text-xs md:text-sm px-3 py-1 rounded-full">FASE {timelinePhases[selectedTimelinePhase].phase}</span>
                {timelinePhases[selectedTimelinePhase].title}
              </h4>
              <p className="text-sm md:text-lg text-slate-300 leading-relaxed mt-4">
                {timelinePhases[selectedTimelinePhase].description}
              </p>
            </div>
          </div>
        </section>

        {/* SEÇÃO 3: DIMENSÕES DE IMPACTO (Largura Total, Estilo Landing Page Accordion) */}
        <section className="w-full">
          <div className="bg-white/5 border border-white/10 backdrop-blur-xl p-8 rounded-3xl shadow-2xl">
            <h3 className="font-black text-2xl uppercase mb-4 border-b border-white/10 pb-3 flex items-center gap-3 text-white">
              <TrendingUp className="w-8 h-8 text-blue-400" /> Dimensões de Impacto
            </h3>
            <p className="text-sm md:text-lg text-slate-400 mb-6 leading-relaxed">
              Selecione uma dimensão abaixo para inspecionar e comparar as mudanças conceituais detalhadas:
            </p>

            {/* Accordion com visual de Cartões de Vidro */}
            <div className="flex flex-col gap-4">
              {dimensions.map((dim) => (
                <div key={dim.id} className="flex flex-col">
                  <button 
                    onClick={() => setActiveCardId(activeCardId === dim.id ? null : dim.id)}
                    className={`w-full border rounded-2xl p-5 text-left transition-all duration-300 font-bold text-sm md:text-xl uppercase flex items-center justify-between cursor-pointer ${
                      activeCardId === dim.id 
                        ? 'bg-gradient-to-r from-blue-950/60 to-indigo-950/40 border-blue-500 text-white shadow-xl shadow-blue-500/10' 
                        : 'bg-white/5 border-white/10 text-slate-300 hover:text-white hover:bg-white/10'
                    }`}
                  >
                    <span className="flex items-center gap-3">
                      {dim.icon}
                      {dim.title}
                    </span>
                    <ChevronRight className={`w-6 h-6 text-slate-400 transition-transform ${activeCardId === dim.id ? 'rotate-90 text-white' : ''}`} />
                  </button>

                  {/* Detalhe Expandido */}
                  {activeCardId === dim.id && (
                    <div className="border-x border-b border-white/10 rounded-b-2xl p-6 bg-slate-950/40 flex flex-col md:flex-row gap-6 text-sm md:text-lg leading-relaxed animate-fadeIn">
                      <div className="flex-1 border-b md:border-b-0 md:border-r border-white/10 pb-4 md:pb-0 md:pr-6">
                        <strong className="text-xs md:text-sm text-slate-500 uppercase block tracking-wider mb-2">Estado Atual (V4)</strong>
                        <p className="text-slate-300">{dim.v4Content}</p>
                      </div>
                      <div className="flex-1 border-b md:border-b-0 md:border-r border-white/10 pb-4 md:pb-0 md:pr-6">
                        <strong className="text-xs md:text-sm text-blue-400 uppercase block tracking-wider mb-2">Alvo Planejado (V5)</strong>
                        <p className="text-white font-bold">{dim.v5Content}</p>
                      </div>
                      <div className="flex-1">
                        <strong className="text-xs md:text-sm text-amber-400 uppercase block tracking-wider mb-2">Impacto no Alinhamento</strong>
                        <p className="text-slate-300 italic">{dim.impact}</p>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* SEÇÃO 4: STATUS DO SISTEMA (Largura Total, Estilo Landing Mockup) */}
        <section className="w-full">
          <div className="bg-white/5 border border-white/10 backdrop-blur-xl p-8 rounded-3xl shadow-2xl relative overflow-hidden">
            <div className="absolute top-0 right-0 w-80 h-80 bg-radial from-emerald-900/10 to-transparent opacity-30 rounded-full blur-2xl" />
            
            <h3 className="font-black text-xl md:text-2xl uppercase mb-4 text-emerald-400 flex items-center gap-2">
              <span className="w-3.5 h-3.5 rounded-full bg-emerald-500 animate-ping"></span>
              Status do Sistema
            </h3>
            <div className="text-sm md:text-lg space-y-3 font-mono text-slate-300 leading-relaxed border-t border-white/10 pt-4">
              <p>📍 <strong>Localização:</strong> apps/web</p>
              <p>⚙️ <strong>Serviço:</strong> Vite Dev Server</p>
              <p>🛡️ <strong>Ambiente:</strong> Monorepo V4.3.1 Rodando Localmente</p>
              <p className="text-blue-400">🔗 <strong>Próximo Passo:</strong> Utilize este painel interativo durante a reunião para guiar a equipe e demonstrar visualmente onde o PROFEPLAN está e onde ele irá pousar na versão 5.</p>
            </div>
          </div>
        </section>

      </div>

      {/* Rodapé Premium */}
      <footer className="mt-16 border-t border-white/10 pt-6 flex flex-col md:flex-row justify-between items-center gap-6 text-sm text-slate-500">
        <span>© 2026 PROFEPLAN. Holding Industrial de Software. Todos os direitos reservados.</span>
        <span className="bg-white/10 text-slate-300 border border-white/10 px-3 py-1.5 rounded-full font-bold uppercase tracking-widest text-[10px] md:text-xs">
          Design System Profeplan Integrado
        </span>
      </footer>
    </div>
  );
}
