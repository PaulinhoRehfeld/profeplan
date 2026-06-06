/**
 * QUERY EXPANSION SERVICE
 * ========================
 * 
 * Expande queries com sinônimos e termos relacionados
 * para busca conceitual/semântica sem necessidade de embeddings
 * 
 * Exemplo:
 * "filósofos gregos" → ["filósofos", "gregos", "Sócrates", "Platão", "Aristóteles", "filosofia grega"]
 */

import { supabase } from '../../../services/supabaseClient';
import { QuestionDatabaseRow } from '../types/question.types';

/**
 * Mapeamento de conceitos para termos relacionados
 * ✅ EXPANDIDO: 65+ conceitos cobrindo todas as disciplinas BNCC
 */
const CONCEPT_MAP: Record<string, string[]> = {
    // ==================== HISTÓRIA (11 conceitos) ====================
    'filósofos gregos': ['Sócrates', 'Platão', 'Aristóteles', 'filosofia grega', 'pré-socráticos', 'sofistas', 'maiêutica', 'dialética'],
    'segunda guerra': ['Hitler', 'Nazismo', 'Holocausto', 'Pearl Harbor', '1939', '1945', 'Aliados', 'Eixo', 'Mussolini', 'Stalin'],
    'primeira guerra': ['WWI', 'Versalhes', 'trincheiras', '1914', '1918', 'Tríplice Aliança', 'Entente'],
    'guerra fria': ['URSS', 'capitalismo', 'comunismo', 'Muro de Berlim', 'corrida armamentista', 'corrida espacial', 'Guerra do Vietnã', 'Cortina de Ferro'],
    'revolução francesa': ['1789', 'Bastilha', 'Napoleão', 'iluminismo', 'Robespierre', 'Declaração dos Direitos', 'jacobinos', 'girondinos', 'Terror'],
    'imperialismo': ['colonialismo', 'neocolonialismo', 'partilha da África', 'século XIX', 'expansão europeia', 'missão civilizatória'],
    'brasil colônia': ['colonização portuguesa', 'pau-brasil', 'cana-de-açúcar', 'engenhos', 'capitanias hereditárias', 'jesuítas', 'bandeirantes'],
    'brasil império': ['Dom Pedro I', 'Dom Pedro II', 'independência', '1822', 'monarquia', 'abolição', 'Lei Áurea', 'café'],
    'república velha': ['café com leite', 'coronelismo', 'oligarquias', 'voto de cabresto', '1889', '1930', 'Prudente de Morais'],
    'era vargas': ['Getúlio Vargas', 'Estado Novo', '1930', '1945', 'trabalhismo', 'CLT', 'populismo'],
    'ditadura militar': ['1964', '1985', 'AI-5', 'censura', 'repressão', 'guerrilha', 'abertura política'],

    // ==================== FILOSOFIA (8 conceitos) ====================
    'filosofia': ['pensamento', 'ética', 'lógica', 'metafísica', 'epistemologia', 'razão', 'verdade'],
    'iluminismo': ['Voltaire', 'Rousseau', 'Montesquieu', 'razão', 'século XVIII', 'Enciclopédia', 'luzes'],
    'existencialismo': ['Sartre', 'Camus', 'existência', 'liberdade', 'angústia', 'absurdo'],
    'marxismo': ['Marx', 'Engels', 'luta de classes', 'materialismo histórico', 'mais-valia', 'proletariado', 'burguesia'],
    'contratualismo': ['Hobbes', 'Locke', 'Rousseau', 'contrato social', 'estado de natureza', 'Leviatã'],
    'ética': ['moral', 'valores', 'virtude', 'dever', 'consequencialismo', 'deontologia', 'utilitarismo'],
    'teoria conhecimento': ['epistemologia', 'verdade', 'conhecimento', 'razão', 'empirismo', 'racionalismo'],
    'filosofia política': ['poder', 'Estado', 'justiça', 'democracia', 'república', 'tirania'],

    // ==================== CIÊNCIAS - BIOLOGIA (12 conceitos) ====================
    'fotossíntese': ['cloroplastos', 'clorofila', 'plantas', 'luz solar', 'glicose', 'oxigênio', 'CO2', 'água'],
    'célula': ['mitocôndria', 'núcleo', 'membrana', 'citoplasma', 'organelas', 'eucarionte', 'procarionte'],
    'evolução': ['Darwin', 'seleção natural', 'adaptação', 'espécies', 'mutação', 'ancestral comum', 'especiação'],
    'genética': ['DNA', 'genes', 'Mendel', 'hereditariedade', 'cromossomos', 'alelos', 'dominante', 'recessivo'],
    'dna rna': ['ácidos nucleicos', 'nucleotídeos', 'adenina', 'timina', 'citosina', 'guanina', 'uracila', 'replicação'],
    'ecologia': ['ecossistema', 'cadeia alimentar', 'habitat', 'nicho ecológico', 'produtores', 'consumidores', 'decompositores'],
    'cadeia alimentar': ['produtores', 'consumidores', 'decompositores', 'teia alimentar', 'pirâmide ecológica'],
    'biomas brasileiros': ['Amazônia', 'Cerrado', 'Caatinga', 'Mata Atlântica', 'Pampa', 'Pantanal', 'biodiversidade'],
    'sistema nervoso': ['neurônios', 'sinapses', 'cérebro', 'medula', 'impulso nervoso', 'neurotransmissores'],
    'sistema circulatório': ['coração', 'sangue', 'artérias', 'veias', 'capilares', 'circulação', 'hemácias'],
    'reprodução': ['gametas', 'fecundação', 'meiose', 'mitose', 'espermatozoide', 'óvulo', 'zigoto'],
    'vírus bactérias': ['microrganismos', 'patógenos', 'doenças', 'antibióticos', 'vacinas', 'infecções'],

    // ==================== CIÊNCIAS - FÍSICA (8 conceitos) ====================
    'newton': ['gravidade', 'leis de Newton', 'força', 'movimento', 'inércia', 'ação e reação', 'mecânica'],
    'eletricidade': ['corrente', 'voltagem', 'resistência', 'circuito', 'Ohm', 'potência', 'energia elétrica'],
    'mecânica': ['cinemática', 'dinâmica', 'velocidade', 'aceleração', 'força', 'trabalho', 'energia'],
    'termodinâmica': ['calor', 'temperatura', 'energia térmica', 'leis da termodinâmica', 'entropia'],
    'óptica': ['luz', 'reflexão', 'refração', 'lentes', 'espelhos', 'onda eletromagnética'],
    'ondas': ['frequência', 'amplitude', 'comprimento de onda', 'som', 'luz', 'propagação'],
    'relatividade': ['Einstein', 'espaço-tempo', 'velocidade da luz', 'E=mc²', 'teoria da relatividade'],
    'física quântica': ['átomo', 'elétrons', 'partículas', 'dualidade', 'Planck', 'incerteza'],

    // ==================== CIÊNCIAS - QUÍMICA (8 conceitos) ====================
    'tabela periódica': ['elementos', 'Mendeleev', 'grupos', 'períodos', 'metais', 'ametais', 'número atômico'],
    'ligações químicas': ['iônica', 'covalente', 'metálica', 'átomos', 'elétrons', 'moléculas'],
    'reações químicas': ['reagentes', 'produtos', 'equação química', 'balanceamento', 'combustão', 'síntese'],
    'ácidos bases': ['pH', 'neutralização', 'ácido', 'base', 'sal', 'indicadores'],
    'estequiometria': ['mol', 'massa molar', 'proporções', 'balanceamento', 'cálculos químicos'],
    'química orgânica': ['carbono', 'hidrocarbonetos', 'compostos orgânicos', 'cadeia carbônica'],
    'funções orgânicas': ['álcool', 'aldeído', 'cetona', 'ácido carboxílico', 'éster', 'amina'],
    'radioatividade': ['decaimento', 'radiação', 'isótopos', 'meia-vida', 'urânio', 'radioativo'],

    // ==================== MATEMÁTICA (10 conceitos) ====================
    'geometria': ['triângulo', 'ângulos', 'área', 'perímetro', 'Pitágoras', 'polígonos', 'círculo'],
    'álgebra': ['equação', 'variável', 'função', 'gráfico', 'expressão', 'incógnita'],
    'funções': ['domínio', 'imagem', 'gráfico', 'f(x)', 'linear', 'quadrática', 'exponencial'],
    'trigonometria': ['seno', 'cosseno', 'tangente', 'ângulos', 'triângulos', 'relações trigonométricas'],
    'probabilidade': ['chance', 'eventos', 'espaço amostral', 'combinações', 'permutações'],
    'estatística': ['média', 'mediana', 'moda', 'desvio padrão', 'variância', 'dados'],
    'matrizes': ['linhas', 'colunas', 'determinante', 'matriz quadrada', 'operações'],
    'análise combinatória': ['permutação', 'arranjo', 'combinação', 'princípio fundamental'],
    'progressões': ['PA', 'PG', 'termo geral', 'razão', 'soma'],
    'geometria espacial': ['volume', 'área', 'prisma', 'pirâmide', 'cilindro', 'esfera', 'cone'],

    // ==================== GEOGRAFIA (8 conceitos) ====================
    'brasil': ['América do Sul', 'Amazônia', 'cerrado', 'caatinga', 'Brasília', 'região', 'estados'],
    'clima': ['temperatura', 'precipitação', 'umidade', 'atmosfera', 'tropical', 'equatorial'],
    'geopolítica': ['fronteiras', 'território', 'soberania', 'conflitos', 'poder', 'Estado'],
    'urbanização': ['cidades', 'metrópoles', 'êxodo rural', 'crescimento urbano', 'infraestrutura'],
    'globalização': ['mundialização', 'economia global', 'interdependência', 'tecnologia', 'comunicação'],
    'meio ambiente': ['sustentabilidade', 'preservação', 'recursos naturais', 'ecologia', 'poluição'],
    'cartografia': ['mapas', 'coordenadas', 'latitude', 'longitude', 'escala', 'projeções'],
    'relevo': ['montanhas', 'planícies', 'planaltos', 'depressões', 'erosão', 'topografia'],

    // ==================== LITERATURA (8 conceitos) ====================
    'romantismo': ['Castro Alves', 'Gonçalves Dias', 'José de Alencar', 'emoção', 'natureza', 'indianismo', 'saudade'],
    'modernismo': ['Oswald de Andrade', 'Mário de Andrade', 'Semana de 22', 'vanguarda', 'verso livre'],
    'barroco': ['Gregório de Matos', 'cultismo', 'conceptismo', 'contraste', 'arte barroca'],
    'simbolismo': ['Cruz e Sousa', 'símbolos', 'misticismo', 'sinestesia', 'transcendência'],
    'parnasianismo': ['Olavo Bilac', 'arte pela arte', 'perfeição formal', 'objetividade'],
    'realismo': ['Machado de Assis', 'objetividade', 'crítica social', 'verossimilhança'],
    'literatura contemporânea': ['contemporâneo', 'atual', 'pós-modernismo', 'diversidade'],
    'gêneros literários': ['poesia', 'prosa', 'drama', 'épico', 'lírico', 'narrativo'],

    // ==================== SOCIOLOGIA (6 conceitos) ====================
    'classes sociais': ['burguesia', 'proletariado', 'estratificação', 'desigualdade', 'Marx'],
    'movimentos sociais': ['protesto', 'reivindicação', 'mobilização', 'mudança social', 'direitos'],
    'desigualdade': ['pobreza', 'renda', 'exclusão', 'injustiça', 'distribuição'],
    'cultura': ['valores', 'costumes', 'tradições', 'identidade', 'diversidade cultural'],
    'trabalho': ['emprego', 'capitalismo', 'divisão do trabalho', 'alienação', 'taylorismo'],
    'ideologia': ['crença', 'valores', 'dominação', 'hegemonia', 'consciência'],

    // ==================== PORTUGUÊS/GRAMÁTICA (6 conceitos) ====================
    'classes gramaticais': ['substantivo', 'adjetivo', 'verbo', 'advérbio', 'preposição', 'conjunção'],
    'sintaxe': ['sujeito', 'predicado', 'complemento', 'adjunto', 'oração', 'período'],
    'concordância': ['nominal', 'verbal', 'sujeito', 'verbo', 'regra'],
    'regência': ['verbal', 'nominal', 'complemento', 'preposição'],
    'colocação pronominal': ['próclise', 'mesóclise', 'ênclise', 'pronome'],
    'interpretação texto': ['compreensão', 'inferência', 'tema', 'tese', 'argumentação'],

    // ==================== SINÔNIMOS REGIONAIS (Fase 2) ====================
    // Variações brasileiras e termos coloquiais

    // Geografia/Lugares
    'estados unidos': ['EUA', 'USA', 'América', 'Estados Unidos da América', 'norte-americano'],
    'união soviética': ['URSS', 'Rússia', 'soviético', 'União das Repúblicas Socialistas'],
    'rio de janeiro': ['RJ', 'carioca', 'cidade maravilhosa'],
    'são paulo': ['SP', 'paulista', 'paulistano'],

    // Termos Científicos (formal → coloquial)
    'vírus': ['vírus', 'virose', 'infecção viral', 'agente infeccioso'],
    'bactéria': ['bactéria', 'microrganismo', 'germe', 'micro-organismo'],
    'doença': ['doença', 'enfermidade', 'patologia', 'mal'],

    // Matemática (formal → coloquial)
    'equação': ['equação', 'igualdade', 'sentença matemática'],
    'raiz': ['raiz', 'solução', 'resultado'],
    'fórmula': ['fórmula', 'expressão', 'relação matemática'],

    // História (eventos → nomes alternativos)
    'independência brasil': ['7 de setembro', '1822', 'grito do Ipiranga', 'Dom Pedro I'],
    'proclamação república': ['15 de novembro', '1889', 'queda da monarquia'],
    'abolição escravatura': ['13 de maio', '1888', 'Lei Áurea', 'libertação dos escravos'],

    // Termos de Estudante (como eles buscam)
    'segunda guerra mundial': ['2ª guerra', 'WWII', 'guerra mundial 2', 'segunda guerra'],
    'primeira guerra mundial': ['1ª guerra', 'WWI', 'guerra mundial 1', 'primeira guerra'],
    'guerra do paraguai': ['tríplice aliança', 'Paraguai'],
    'revolução industrial': ['revolução das máquinas', 'industrialização'],

    // Ciências (termos misturados)
    'aquecimento global': ['mudança climática', 'clima', 'efeito estufa', 'aquecimento'],
    'energia renovável': ['energia limpa', 'sustentabilidade', 'energia verde'],
    'tsunami': ['maremoto', 'onda gigante'],
};

/**
 * SEMANTIC SYNONYMS MAP (Fase 3 - Lite)
 * Mapeia conceitos similares para busca "quasi-semântica" sem embeddings
 */
const SEMANTIC_SYNONYMS: Record<string, string> = {
    // Mapeamento: termo buscado → conceito no CONCEPT_MAP
    'pensadores antigos': 'filósofos gregos',
    'sociedade grega': 'filósofos gregos',
    'filosofia antiga': 'filósofos gregos',
    'período clássico': 'filósofos gregos',

    'conflitos mundiais': 'segunda guerra',
    'guerras do século 20': 'segunda guerra',
    'nazifascismo': 'segunda guerra',

    'bipolarização': 'guerra fria',
    'capitalismo vs comunismo': 'guerra fria',

    'transformação de energia': 'fotossíntese',
    'processo de fotossíntese': 'fotossíntese',
    'plantas produzem energia': 'fotossíntese',

    'unidade básica da vida': 'célução',
    'estrutura celular': 'célula',

    'seleção das espécies': 'evolução',
    'teoria evolutiva': 'evolução',
    'darwinismo': 'evolução',

    'hereditariedade': 'genética',
    'herança biológica': 'genética',
    'leis de mendel': 'genética',

    'movimento dos corpos': 'mecânica',
    'física do movimento': 'mecânica',

    'corrente elétrica': 'eletricidade',
    'circuitos': 'eletricidade',

    'formas geométricas': 'geometria',
    'figuras planas': 'geometria',

    'resolução de equações': 'álgebra',
    'expressões algébricas': 'álgebra',

    'mudanças climáticas': 'aquecimento global',
    'efeito estufa': 'aquecimento global',

    'independência do brasil': 'independência brasil',
    'libertação dos escravos': 'abolição escravatura',
    'fim da monarquia': 'proclamação república',
};

class QueryExpansionService {
    /**
     * Expande uma query com termos relacionados
     */
    expandQuery(query: string): string[] {
        const normalizedQuery = query.toLowerCase().trim();
        const terms: Set<string> = new Set();

        // 1. Adicionar query original
        terms.add(query);

        // 2. NOVO! Verificar mapeamento semântico
        for (const [synonym, concept] of Object.entries(SEMANTIC_SYNONYMS)) {
            if (normalizedQuery.includes(synonym)) {
                console.log(`[QueryExpansion] 🧠 Semantic mapping: "${synonym}" → "${concept}"`);
                // Adicionar conceito mapeado
                const conceptWords = concept.split(/\s+/);
                conceptWords.forEach(word => {
                    if (word.length > 2) terms.add(word);
                });
            }
        }

        // 3. Palavras individuais da query
        const words = normalizedQuery.split(/\s+/);
        words.forEach(word => {
            if (word.length > 2) { // Ignorar palavras muito curtas
                terms.add(word);
            }
        });

        // 4. Buscar no mapa de conceitos
        for (const [concept, related] of Object.entries(CONCEPT_MAP)) {
            if (normalizedQuery.includes(concept)) {
                related.forEach(term => terms.add(term));
            }
        }

        // 5. Buscar por palavras individuais no mapa
        words.forEach(word => {
            for (const [concept, related] of Object.entries(CONCEPT_MAP)) {
                if (concept.includes(word)) {
                    related.forEach(term => terms.add(term));
                }
            }
        });

        const result = Array.from(terms);
        console.log(`[QueryExpansion] 🔍 "${query}" → ${result.length} termos:`, result);

        return result;
    }

    /**
     * Busca expandida (múltiplos termos com OR)
     */
    async searchExpanded(
        query: string,
        limit: number = 50
    ): Promise<QuestionDatabaseRow[]> {
        try {
            const expandedTerms = this.expandQuery(query);

            console.log(`[QueryExpansion] 🔍 Searching with ${expandedTerms.length} terms...`);

            // Construir query com OR para todos os termos
            let supabaseQuery = supabase
                .from('enem_questions')
                .select('id, content, metadata');

            // Aplicar OR filters
            const orFilters = expandedTerms.map(term =>
                `content.ilike.%${term}%`
            ).join(',');

            const { data, error } = await supabaseQuery
                .or(orFilters)
                .limit(limit);

            if (error) {
                console.error('[QueryExpansion] ❌ Search error:', error);
                throw error;
            }

            console.log(`[QueryExpansion] ✅ Found ${data?.length || 0} results`);

            return (data as QuestionDatabaseRow[]) || [];

        } catch (error) {
            console.error('[QueryExpansion] ❌ Exception:', error);
            throw error;
        }
    }

    /**
     * Adiciona conceito ao mapa (runtime)
     */
    addConcept(concept: string, relatedTerms: string[]): void {
        CONCEPT_MAP[concept.toLowerCase()] = relatedTerms;
        console.log(`[QueryExpansion] ✅ Added concept: "${concept}"`);
    }

    /**
     * Retorna total de conceitos mapeados
     */
    getTotalConcepts(): number {
        return Object.keys(CONCEPT_MAP).length;
    }
}

// Singleton export
export const queryExpansion = new QueryExpansionService();
