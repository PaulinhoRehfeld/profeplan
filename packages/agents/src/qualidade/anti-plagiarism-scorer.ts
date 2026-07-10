// ============================================================================
// PROFEPLAN — Anti-Plagiarism Scorer Agent
// S4-04: Detecta repetição excessiva de conteúdo entre aulas do mesmo planejamento
// ============================================================================

import { BaseQualityGate, type GateResult } from './quality-gate-pipeline';
import { TipoGeracao, type GeracaoResultado } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

/**
 * Detecta repetição excessiva de conteúdo entre aulas do mesmo planejamento.
 *
 * Utiliza similaridade de Jaccard em nível de palavras para comparar o conteúdo
 * gerado com um histórico de aulas anteriores da mesma turma/disciplina.
 *
 * TODO: Integrar com SessionAgent.getHistorico() para comparação real entre aulas.
 * TODO: Substituir similaridade de Jaccard por embeddings (Supabase pgvector).
 */
export class AntiPlagiarismScorerAgent extends BaseQualityGate {
  /** Histórico mock de aulas anteriores para comparação. */
  private historicoAulas: string[] = [];

  /** Limiar de similaridade acima do qual o conteúdo é considerado repetido. */
  private static readonly LIMIAR_SIMILARIDADE = 0.6;

  /** Tamanho mínimo do texto para comparação (caracteres). */
  private static readonly TEXTO_MINIMO = 100;

  public get name(): string {
    return 'Anti-Plagiarism Scorer';
  }

  public isApplicable(tipo: TipoGeracao): boolean {
    return tipo === TipoGeracao.PLANO_AULA;
  }

  /**
   * Adiciona uma aula ao histórico para comparações futuras.
   * TODO: Integrar com SessionAgent para histórico persistente.
   */
  public addAulaHistorico(texto: string): void {
    this.historicoAulas.push(texto);
  }

  /**
   * Calcula a similaridade de Jaccard entre dois textos, em nível de palavras.
   *
   * Jaccard(A, B) = |A ∩ B| / |A ∪ B|
   *
   * @returns Valor entre 0 (totalmente diferente) e 1 (idêntico).
   */
  private _jaccardSimilarity(a: string, b: string): number {
    const palavrasA = new Set(a.toLowerCase().split(/\s+/).filter((w) => w.length > 2));
    const palavrasB = new Set(b.toLowerCase().split(/\s+/).filter((w) => w.length > 2));

    if (palavrasA.size === 0 || palavrasB.size === 0) return 0;

    const intersecao = new Set([...palavrasA].filter((w) => palavrasB.has(w)));
    const uniao = new Set([...palavrasA, ...palavrasB]);

    return intersecao.size / uniao.size;
  }

  public async check(
    resultado: GeracaoResultado,
    req: GeracaoRequest,
  ): Promise<GateResult> {
    const textoAtual = JSON.stringify(resultado.conteudo).toLowerCase();

    // Texto muito curto — não comparável
    if (textoAtual.length < AntiPlagiarismScorerAgent.TEXTO_MINIMO) {
      return {
        gate: this.name,
        passed: true,
        severity: 'INFO',
        score: 1.0,
        message: 'Texto muito curto para verificação de originalidade.',
      };
    }

    // Sem histórico para comparar
    if (this.historicoAulas.length === 0) {
      return {
        gate: this.name,
        passed: true,
        severity: 'INFO',
        score: 1.0,
        message: 'Nenhuma aula anterior no histórico para comparação.',
      };
    }

    // Compara com cada aula do histórico
    const similaridades = this.historicoAulas.map((aula, idx) => ({
      idx,
      similaridade: this._jaccardSimilarity(textoAtual, aula),
    }));

    const maxSimilaridade = Math.max(...similaridades.map((s) => s.similaridade));
    const altaSimilaridade = similaridades.filter(
      (s) => s.similaridade >= AntiPlagiarismScorerAgent.LIMIAR_SIMILARIDADE,
    );

    if (altaSimilaridade.length > 0) {
      const originalityScore = 1 - maxSimilaridade;
      return {
        gate: this.name,
        passed: true,
        severity: 'WARNING',
        score: originalityScore,
        message: `${altaSimilaridade.length} aula(s) com similaridade >= ${(AntiPlagiarismScorerAgent.LIMIAR_SIMILARIDADE * 100).toFixed(0)}%. Similaridade máxima: ${(maxSimilaridade * 100).toFixed(1)}%.`,
        suggestion: 'O conteúdo está muito similar a aulas anteriores. Varie os exemplos e abordagens.',
      };
    }

    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: `Originalidade verificada. Similaridade máxima: ${(maxSimilaridade * 100).toFixed(1)}% com ${this.historicoAulas.length} aula(s) no histórico.`,
    };
  }
}
