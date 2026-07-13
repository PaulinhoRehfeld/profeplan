// ============================================================================
// PROFEPLAN — Context Builder Agent
// S2-01: Agente RAG hierárquico (Níveis 1–4) para montagem de contexto
// ============================================================================

import { DisciplinaNome, NivelEnsino, type DisciplinaContext } from '../base/discipline-agent-base';
import type { GeracaoRequest } from './orchestrator-agent';

// ---------------------------------------------------------------------------
// Interfaces públicas
// ---------------------------------------------------------------------------

/**
 * Fragmento de contexto recuperado do pipeline RAG hierárquico.
 *
 * Cada chunk provém de um dos 4 níveis do pipeline e carrega um peso
 * proporcional à sua relevância para a geração final.
 */
export interface RAGChunk {
  /** Conteúdo textual do fragmento. */
  readonly texto: string;
  /** Nível hierárquico (1 = mais relevante, 4 = menos relevante). */
  readonly nivel: 1 | 2 | 3 | 4;
  /** Peso do chunk no contexto agregado. */
  readonly peso: number;
  /** Origem do fragmento (ex: 'plano_curso', 'pnld', 'bncc'). */
  readonly fonte: string;
}

/**
 * Pacote completo de contexto RAG pronto para ser injetado
 * no prompt de um agente de disciplina.
 *
 * Estende {@link DisciplinaContext} adicionando os chunks
 * recuperados dos 4 níveis do pipeline.
 */
export interface RAGPackage extends DisciplinaContext {
  /** Fragmentos recuperados, ordenados por nível (N1 → N4). */
  readonly chunks: readonly RAGChunk[];
}

// ---------------------------------------------------------------------------
// ContextBuilderAgent
// ---------------------------------------------------------------------------

/**
 * Agente responsável por construir o pacote de contexto RAG
 * para uma requisição de geração.
 *
 * ## Pipeline hierárquico (4 níveis)
 *
 * | Nível | Fonte                  | Peso | Descrição                              |
 * |-------|------------------------|------|----------------------------------------|
 * | N1    | Plano de Curso         | 100  | Curadoria pessoal do professor         |
 * | N2    | Livros PNLD            | 50   | Material didático oficial              |
 * | N3    | Materiais Extras       | 30   | Slides, vídeos, listas do professor    |
 * | N4    | Base BNCC / Currículo  | 10   | Habilidades e competências gerais      |
 *
 * ## Estado atual
 *
 * Todos os métodos de busca são **mocks** que simulam o comportamento
 * real. A integração com Supabase/embeddings será implementada nas
 * próximas sprints (ver TODOs nos métodos privados).
 *
 * @example
 * ```ts
 * const builder = new ContextBuilderAgent();
 * const pkg = await builder.build(
 *   DisciplinaNome.MATEMATICA,
 *   NivelEnsino.EM_1,
 *   { disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EM_1,
 *     tipo: TipoGeracao.PLANO_AULA, professorId: 'prof-1', turmaId: 'turma-1',
 *     params: {} },
 * );
 * console.log(pkg.chunks.length); // 4 (um por nível)
 * ```
 */
export class ContextBuilderAgent {
  /** Peso do Nível 1 — Plano de Curso do Professor. */
  static readonly PESO_N1 = 100;

  /** Peso do Nível 2 — Livros PNLD. */
  static readonly PESO_N2 = 50;

  /** Peso do Nível 3 — Materiais Extras. */
  static readonly PESO_N3 = 30;

  /** Peso do Nível 4 — Base BNCC / Currículo MG. */
  static readonly PESO_N4 = 10;

  // -----------------------------------------------------------------------
  // Método público principal
  // -----------------------------------------------------------------------

  /**
   * Monta o pacote RAG completo para a requisição informada.
   *
   * Executa as 4 buscas em sequência (N1 → N4), combina os chunks
   * e retorna o {@link RAGPackage} pronto para consumo.
   *
   * @param disciplina — Disciplina alvo.
   * @param nivel      — Nível de ensino.
   * @param req        — Requisição de geração original.
   * @returns Pacote RAG com todos os chunks recuperados.
   */
  async build(
    disciplina: DisciplinaNome,
    nivel: NivelEnsino,
    req: GeracaoRequest
  ): Promise<RAGPackage> {
    const chunks: RAGChunk[] = [];

    // N1: Plano de Curso do Professor (peso 100)
    const n1 = await this._buscarPlanoCurso(req.professorId, disciplina, nivel);
    chunks.push(...n1);

    // N2: Livros PNLD (peso 50)
    const n2 = await this._buscarLivrosPNLD(disciplina, nivel);
    chunks.push(...n2);

    // N3: Materiais extras (peso 30)
    const n3 = await this._buscarMateriaisExtras(req.professorId, disciplina);
    chunks.push(...n3);

    // N4: Base BNCC geral (peso 10)
    const n4 = await this._buscarBNCCGeral(disciplina, nivel);
    chunks.push(...n4);

    return {
      disciplina,
      nivel,
      professorId: req.professorId,
      turmaId: req.turmaId,
      chunks,
    };
  }

  // -----------------------------------------------------------------------
  // Métodos privados de busca (mock)
  // -----------------------------------------------------------------------

  /**
   * N1 — Busca o plano de curso personalizado do professor.
   *
   * @remarks Mock — retorna chunk sintético com marcação `[MOCK N1]`.
   * TODO: Integrar com Supabase (`planos_curso` → embedding search).
   */
  private async _buscarPlanoCurso(
    _professorId: string,
    disciplina: DisciplinaNome,
    nivel: NivelEnsino
  ): Promise<RAGChunk[]> {
    // TODO: Integrar com Supabase para buscar plano de curso real
    const nomeDisciplina = disciplina.replace(/_/g, ' ').toLowerCase();
    return [
      {
        texto: `[MOCK N1] Plano de Curso de ${nomeDisciplina} para ${nivel}. Conteúdo programático com habilidades priorizadas pelo professor.`,
        nivel: 1,
        peso: ContextBuilderAgent.PESO_N1,
        fonte: 'plano_curso',
      },
    ];
  }

  /**
   * N2 — Busca livros didáticos do PNLD alinhados à disciplina e nível.
   *
   * @remarks Mock — retorna chunk sintético com marcação `[MOCK N2]`.
   * TODO: Integrar com índice PNLD (Supabase ou arquivo estático).
   */
  private async _buscarLivrosPNLD(
    disciplina: DisciplinaNome,
    nivel: NivelEnsino
  ): Promise<RAGChunk[]> {
    // TODO: Integrar com índice PNLD
    const nomeDisciplina = disciplina.replace(/_/g, ' ').toLowerCase();
    return [
      {
        texto: `[MOCK N2] Livro didático PNLD de ${nomeDisciplina} — ${nivel}. Capítulos e exercícios alinhados à BNCC.`,
        nivel: 2,
        peso: ContextBuilderAgent.PESO_N2,
        fonte: 'pnld',
      },
    ];
  }

  /**
   * N3 — Busca materiais complementares do professor
   * (slides, vídeos, listas de exercícios).
   *
   * @remarks Mock — retorna chunk sintético com marcação `[MOCK N3]`.
   * TODO: Integrar com storage de materiais do professor (Supabase Storage).
   */
  private async _buscarMateriaisExtras(
    _professorId: string,
    disciplina: DisciplinaNome
  ): Promise<RAGChunk[]> {
    // TODO: Integrar com materiais do professor
    const nomeDisciplina = disciplina.replace(/_/g, ' ').toLowerCase();
    return [
      {
        texto: `[MOCK N3] Materiais complementares de ${nomeDisciplina}: slides, vídeos, listas de exercícios.`,
        nivel: 3,
        peso: ContextBuilderAgent.PESO_N3,
        fonte: 'materiais_extras',
      },
    ];
  }

  /**
   * N4 — Busca a base curricular geral (BNCC / Currículo MG).
   *
   * @remarks Mock — retorna chunk sintético com marcação `[MOCK N4]`.
   * TODO: Integrar com `curriculo_mg.json` (busca por habilidades).
   */
  private async _buscarBNCCGeral(
    disciplina: DisciplinaNome,
    nivel: NivelEnsino
  ): Promise<RAGChunk[]> {
    // TODO: Integrar com curriculo_mg.json
    const nomeDisciplina = disciplina.replace(/_/g, ' ').toLowerCase();
    return [
      {
        texto: `[MOCK N4] Base BNCC de ${nomeDisciplina} para ${nivel}. Habilidades e competências gerais da área.`,
        nivel: 4,
        peso: ContextBuilderAgent.PESO_N4,
        fonte: 'bncc',
      },
    ];
  }
}
