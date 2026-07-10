// ============================================================================
// PROFEPLAN — Base Discipline Agent
// S1-02: Classe abstrata para agentes de disciplina
// ============================================================================

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/** Tipos de geração suportados pelos agentes de disciplina. */
export enum TipoGeracao {
  PLANEJAMENTO_TRIMESTRAL = 'PLANEJAMENTO_TRIMESTRAL',
  PLANO_AULA = 'PLANO_AULA',
  AVALIACAO = 'AVALIACAO',
  PDI_ADAPTACAO = 'PDI_ADAPTACAO',
  SIMULADO = 'SIMULADO',
}

/** Níveis de ensino cobertos pelo PROFEPLAN. */
export enum NivelEnsino {
  EF_6 = 'EF_6',
  EF_7 = 'EF_7',
  EF_8 = 'EF_8',
  EF_9 = 'EF_9',
  EM_1 = 'EM_1',
  EM_2 = 'EM_2',
  EM_3 = 'EM_3',
}

/** Disciplinas suportadas — naming convention para agentes. */
export enum DisciplinaNome {
  LINGUA_PORTUGUESA = 'LINGUA_PORTUGUESA',
  MATEMATICA = 'MATEMATICA',
  CIENCIAS = 'CIENCIAS',
  BIOLOGIA = 'BIOLOGIA',
  GEOGRAFIA = 'GEOGRAFIA',
  HISTORIA = 'HISTORIA',
  ARTES = 'ARTES',
  EDUCACAO_FISICA = 'EDUCACAO_FISICA',
  ENSINO_RELIGIOSO = 'ENSINO_RELIGIOSO',
  LINGUA_INGLESA = 'LINGUA_INGLESA',
  FISICA = 'FISICA',
  QUIMICA = 'QUIMICA',
  FILOSOFIA = 'FILOSOFIA',
  SOCIOLOGIA = 'SOCIOLOGIA',
}

// ---------------------------------------------------------------------------
// Interfaces
// ---------------------------------------------------------------------------

/** Contexto de execução de um agente de disciplina. */
export interface DisciplinaContext {
  /** Disciplina alvo da geração. */
  disciplina: DisciplinaNome;
  /** Nível de ensino. */
  nivel: NivelEnsino;
  /** Identificador do professor solicitante. */
  professorId: string;
  /** Identificador da turma. */
  turmaId: string;
  /** Plano de curso em Markdown (opcional). */
  planoCursoMd?: string;
  /** Identificador do livro PNLD (opcional). */
  livroPnldId?: string;
  /** Lista de materiais extras (URLs, textos, etc). */
  materiaisExtras?: string[];
}

/** Resultado padronizado de uma geração realizada por um agente. */
export interface GeracaoResultado {
  /** Indica se a geração foi bem-sucedida. */
  sucesso: boolean;
  /** Conteúdo gerado como mapa chave-valor. */
  conteudo: Record<string, unknown>;
  /** Metadados da geração (opcional). */
  metadados?: {
    /** Nome icônico do agente (displayName). */
    agente: string;
    /** Disciplina (valor do enum). */
    disciplina: string;
    /** Nível de ensino (valor do enum). */
    nivel: string;
    /** Tipo de geração. */
    tipo: string;
    /** Timestamp ISO-8601 da geração. */
    timestamp: string;
  };
}

// ---------------------------------------------------------------------------
// Constantes
// ---------------------------------------------------------------------------

/** Mapa de nomes icônicos por disciplina. */
export const AGENT_DISPLAY_NAMES: Record<DisciplinaNome, string> = {
  [DisciplinaNome.LINGUA_PORTUGUESA]: 'Machado',
  [DisciplinaNome.MATEMATICA]: 'Pitágoras',
  [DisciplinaNome.CIENCIAS]: 'Darwin',
  [DisciplinaNome.BIOLOGIA]: 'Darwin',
  [DisciplinaNome.GEOGRAFIA]: 'Milton',
  [DisciplinaNome.HISTORIA]: 'Heródoto',
  [DisciplinaNome.ARTES]: 'Tarsila',
  [DisciplinaNome.EDUCACAO_FISICA]: 'Pelé',
  [DisciplinaNome.ENSINO_RELIGIOSO]: 'Francisco',
  [DisciplinaNome.LINGUA_INGLESA]: 'Shakespeare',
  [DisciplinaNome.FISICA]: 'Einstein',
  [DisciplinaNome.QUIMICA]: 'Lavoisier',
  [DisciplinaNome.FILOSOFIA]: 'Sócrates',
  [DisciplinaNome.SOCIOLOGIA]: 'Durkheim',
};

// ---------------------------------------------------------------------------
// Classe Abstrata
// ---------------------------------------------------------------------------

/**
 * Classe base abstrata para todos os agentes de disciplina do PROFEPLAN.
 *
 * Cada agente concreto (Matemática → Pitágoras, Física → Einstein, etc.)
 * estende esta classe e implementa os métodos abstratos obrigatórios.
 *
 * O pipeline de geração segue 4 etapas encadeadas:
 *   1. `_buildRagContext`  — recupera contexto RAG da disciplina
 *   2. `_selectPromptTemplate` — seleciona o template de prompt adequado
 *   3. `_callLLM`          — invoca o LLM com o prompt e contexto
 *   4. `_postProcess`      — pós-processa a saída bruta para o formato final
 */
export abstract class BaseDisciplineAgent {
  /** Contexto imutável da disciplina/turma/professor. */
  public readonly context: DisciplinaContext;

  /** System prompt montado no construtor via {@link buildSystemPrompt}. */
  protected systemPrompt: string;

  /**
   * @param context — Contexto de execução (disciplina, nível, turma, etc.)
   */
  public constructor(context: DisciplinaContext) {
    this.context = context;
    this.systemPrompt = this.buildSystemPrompt();
  }

  // --- Abstratos (devem ser implementados pelas subclasses) ---

  /**
   * Nome icônico do agente.
   * @example "Machado", "Einstein", "Pitágoras"
   */
  public abstract get displayName(): string;

  /**
   * Constrói o system prompt específico da disciplina.
   * Chamado automaticamente no construtor.
   */
  protected abstract buildSystemPrompt(): string;

  /**
   * Retorna a disciplina associada a este agente.
   */
  public abstract getDisciplina(): DisciplinaNome;

  /**
   * Retorna a lista de habilidades prioritárias (códigos BNCC) para esta disciplina.
   */
  public abstract getHabilidadesPrioritarias(): string[];

  // --- Pipeline de geração (método público) ---

  /**
   * Pipeline completo de geração de conteúdo.
   *
   * @param tipo        — Tipo de geração desejada (planejamento, aula, etc.)
   * @param parametros  — Parâmetros adicionais específicos da geração
   * @returns Resultado padronizado com conteúdo e metadados
   */
  public async gerar(
    tipo: TipoGeracao,
    parametros: Record<string, unknown>,
  ): Promise<GeracaoResultado> {
    // Etapa 1: Construir contexto RAG
    const ragContext = await this._buildRagContext(tipo);

    // Etapa 2: Selecionar template de prompt
    const prompt = this._selectPromptTemplate(tipo);

    // Etapa 3: Chamar LLM
    const raw = await this._callLLM(prompt, ragContext, parametros);

    // Etapa 4: Pós-processar resultado
    return this._postProcess(raw, tipo);
  }

  // --- Métodos protegidos (placeholder — subclasses devem sobrescrever) ---

  /**
   * Constrói o contexto RAG para enriquecer o prompt.
   * @throws Error('Not implemented') se a subclasse não sobrescrever.
   */
  protected async _buildRagContext(_tipo: TipoGeracao): Promise<string> {
    throw new Error('Not implemented: _buildRagContext');
  }

  /**
   * Seleciona o template de prompt adequado ao tipo de geração.
   * @throws Error('Not implemented') se a subclasse não sobrescrever.
   */
  protected _selectPromptTemplate(_tipo: TipoGeracao): string {
    throw new Error('Not implemented: _selectPromptTemplate');
  }

  /**
   * Invoca o modelo de linguagem com prompt, contexto RAG e parâmetros.
   * @throws Error('Not implemented') se a subclasse não sobrescrever.
   */
  protected async _callLLM(
    _prompt: string,
    _ragContext: string,
    _params: Record<string, unknown>,
  ): Promise<string> {
    throw new Error('Not implemented: _callLLM');
  }

  /**
   * Pós-processa a saída bruta do LLM no formato {@link GeracaoResultado}.
   * @throws Error('Not implemented') se a subclasse não sobrescrever.
   */
  protected async _postProcess(
    _raw: string,
    _tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    throw new Error('Not implemented: _postProcess');
  }
}
