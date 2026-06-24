export interface AIGuardrailsConfig {
    methodology: string;
    pedagogicalStyle: string;
    assessmentFocus: string;
    writingTone: string;
    context?: string;
}

export function generateGuardrailsPrompt(
    config: AIGuardrailsConfig,
    allowOverride: boolean = true
): string {
    return `
[🛡️ GUARDRAILS PEDAGÓGICOS - OBRIGATÓRIOS]

Você DEVE seguir RIGOROSAMENTE as preferências pedagógicas configuradas pelo professor:

**📚 METODOLOGIA PADRÃO: ${config.methodology}**
${getMethodologyDescription(config.methodology)}

**🎓 ESTILO PEDAGÓGICO: ${config.pedagogicalStyle}**
${getPedagogicalStyleDescription(config.pedagogicalStyle)}

**📊 FOCO AVALIATIVO: ${config.assessmentFocus}**
${getAssessmentFocusDescription(config.assessmentFocus)}

**✍️ TOM DE ESCRITA: ${config.writingTone}**
${getWritingToneDescription(config.writingTone)}

${config.context ? `\n**🎯 CONTEXTO DO PERÍODO:**\n${config.context}\n` : ''}

${allowOverride ? `
⚠️ EXCEÇÃO: Se o professor fornecer feedback explícito que conflite com estas preferências,
o feedback do professor SEMPRE prevalece. As preferências acima são o PADRÃO, mas não são
absolutas quando há instrução contrária do usuário.
` : `
🔒 MODO ESTRITO: Estas preferências são MANDATÓRIAS e não podem ser sobrescritas.
Qualquer tentativa de desvio deve retornar erro explicando a configuração ativa.
`}

---
`;
}

function getMethodologyDescription(methodology: string): string {
    const descriptions: Record<string, string> = {
        'Gamification': `
- Utilize elementos de jogos (pontuação, níveis, desafios)
- Crie narrativas envolventes e progressão clara
- Incentive competição saudável e colaboração
- Use recompensas simbólicas e feedback imediato
- Exemplo: "Missão 1: Desbrave o Mundo dos Números"`,

        'Problem Based': `
- Inicie SEMPRE com um problema real ou situação-problema
- Estimule investigação, pesquisa e descoberta autônoma
- Conecte teoria com aplicação prática imediata
- Organize em: Problema → Investigação → Solução → Reflexão
- Exemplo: "Como calcularíamos o tempo de viagem a Marte?"`,

        'Traditional': `
- Estrutura clara: Introdução → Desenvolvimento → Exercícios
- Explique conceitos de forma expositiva e organizada
- Use exemplos didáticos e progressão linear
- Inclua exercícios de fixação e repetição
- Foco em domínio de conteúdo antes de aplicação`
    };

    return descriptions[methodology] || descriptions['Gamification'];
}

function getPedagogicalStyleDescription(style: string): string {
    const descriptions: Record<string, string> = {
        'Tradicional': `
- Professor como autoridade central do conhecimento
- Transmissão direta de conteúdo
- Disciplina e organização rigorosas
- Avaliação focada em memorização e reprodução`,

        'Construtivista': `
- Aluno como protagonista na construção do conhecimento
- Aprendizagem através de experimentação e reflexão
- Professor como mediador e facilitador
- Valorização do erro como parte do processo
- Construção gradual de conceitos`,

        'Sociointeracionista': `
- Aprendizagem através da interação social
- Zona de Desenvolvimento Proximal (Vygotsky)
- Trabalho colaborativo e diálogo constante
- Contextualização cultural e social do conhecimento
- Linguagem como ferramenta de construção cognitiva`
    };

    return descriptions[style] || descriptions['Construtivista'];
}

function getAssessmentFocusDescription(focus: string): string {
    const descriptions: Record<string, string> = {
        'Somativa': `
- Avaliação ao FINAL do processo (provas, trabalhos finais)
- Foco em mensuração quantitativa do aprendizado
- Comparação com objetivos pré-estabelecidos
- Feedback classificatório (nota/conceito)`,

        'Formativa': `
- Avaliação DURANTE o processo de ensino
- Feedback contínuo para ajuste de estratégias
- Foco no desenvolvimento e progresso individual
- Identificação de dificuldades em tempo real
- Avaliação como ferramenta de ensino`,

        'Diagnóstica': `
- Avaliação ANTES do início do conteúdo
- Mapeamento de conhecimentos prévios
- Identificação de lacunas e pré-requisitos
- Planejamento baseado no nível real da turma
- Personalização do ensino`
    };

    return descriptions[focus] || descriptions['Formativa'];
}

function getWritingToneDescription(tone: string): string {
    const descriptions: Record<string, string> = {
        'Prático e Inspiracional': `
- Use linguagem acessível e motivadora
- Inclua exemplos do cotidiano e aplicações reais
- Tom encorajador e positivo
- Verbos de ação e frases curtas
- Inspire curiosidade e protagonismo`,

        'Técnico e Formal': `
- Use terminologia pedagógica precisa
- Estrutura formal e acadêmica
- Citações de autores e teorias quando relevante
- Linguagem objetiva e profissional
- Referências à BNCC e documentos oficiais`
    };

    return descriptions[tone] || descriptions['Prático e Inspiracional'];
}
