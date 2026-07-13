// ============================================================================
// PROFEPLAN — Content Scorer Agent (Quality Gate)
// S4-02: Avalia qualidade pedagógica do conteúdo gerado com heurísticas
// ============================================================================

import { BaseQualityGate } from './quality-gate-pipeline';
import type { GateResult, GateSeverity } from './quality-gate-pipeline';
import { TipoGeracao, type GeracaoResultado } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

// ---------------------------------------------------------------------------
// Constantes
// ---------------------------------------------------------------------------

/** Tamanho mínimo de caracteres para conteúdo considerado adequado. */
const TAMANHO_MINIMO_CHARS = 200;

/** Regex para detectar códigos BNCC nos formatos EF e EM. */
const REGEX_CODIGO_BNCC = /\bEF\d{2}[A-Z]{2}\d{2}\b|\bEM\d{2}[A-Z]{3}\d{3}\b/gi;

/**
 * Termos discriminatórios básicos a serem verificados.
 * Match case-insensitive, palavra inteira.
 */
const REGEX_TERMOS_DISCRIMINATORIOS = /\b(?:burro|idiota|incapaz|retardado|anormal|defeituoso)\b/gi;

/** Campos considerados indicadores de boa estrutura pedagógica. */
const CAMPOS_ESTRUTURA = new Set([
  'objetivos',
  'objetivo',
  'desenvolvimento',
  'habilidades_bncc',
  'habilidadesBncc',
  'recursos',
  'avaliacao',
  'metodologia',
  'competencia_geral',
  'competencia_especifica',
]);

// ---------------------------------------------------------------------------
// ContentScorerAgent
// ---------------------------------------------------------------------------

/**
 * Quality gate que avalia a qualidade pedagógica do conteúdo gerado
 * por meio de heurísticas objetivas e verificáveis.
 *
 * **Critérios de pontuação (score acumulativo, max 1.0):**
 *
 * | # | Critério                          | Peso  | Detalhe                                              |
 * |---|-----------------------------------|-------|------------------------------------------------------|
 * | 1 | Tamanho adequado                  | +0.30 | `JSON.stringify(conteudo).length >= 200`             |
 * | 2 | Estrutura pedagógica              | +0.30 | Presença de campos como objetivos, desenvolvimento,  |
 * |   |                                   |       | habilidades_bncc, metodologia, etc.                  |
 * | 3 | BNCC presente                     | +0.20 | Códigos BNCC no formato EF/EM detectados no conteúdo |
 * | 4 | Linguagem inclusiva               | +0.20 | Ausência de termos discriminatórios                  |
 *
 * **Classificação por faixa de score:**
 * - `score < 0.3` → **BLOCKER** (conteúdo muito pobre).
 * - `score < 0.5` → **WARNING** (qualidade insuficiente).
 * - `score >= 0.7` → **INFO** (boa qualidade).
 * - Demais casos → **INFO** (qualidade aceitável).
 *
 * @example
 * ```ts
 * const scorer = new ContentScorerAgent();
 * const result = await scorer.check(geracaoResultado, request);
 * // result.score → 0.0–1.0; result.severity → BLOCKER | WARNING | INFO
 * ```
 *
 * @todo Integrar com avaliação por IA no futuro (modelo de linguagem
 *       para análise semântica mais profunda de qualidade pedagógica).
 */
export class ContentScorerAgent extends BaseQualityGate {
  /** @inheritdoc */
  public get name(): string {
    return 'Content Scorer';
  }

  /**
   * O Content Scorer é sempre aplicável — toda geração merece
   * avaliação de qualidade pedagógica.
   *
   * @param _tipo — Tipo de geração (não utilizado; sempre `true`).
   * @returns `true` para qualquer {@link TipoGeracao}.
   */
  public isApplicable(_tipo: TipoGeracao): boolean {
    return true;
  }

  /**
   * Executa a avaliação heurística de qualidade pedagógica.
   *
   * Algoritmo de scoring em 4 dimensões:
   * 1. Serializa `conteudo` para string e verifica tamanho.
   * 2. Verifica presença de campos de estrutura pedagógica.
   * 3. Varre o texto em busca de códigos BNCC (EF/EM).
   * 4. Verifica ausência de termos discriminatórios.
   *
   * @param resultado — Resultado da geração a ser avaliado.
   * @param _req      — Requisição original (não utilizado diretamente).
   * @returns Promise com {@link GateResult} contendo score e severidade.
   */
  public async check(resultado: GeracaoResultado, _req: GeracaoRequest): Promise<GateResult> {
    let score = 0;
    const detalhes: string[] = [];
    const falhas: string[] = [];

    // Validação inicial: conteúdo ausente
    if (!resultado.conteudo || typeof resultado.conteudo !== 'object') {
      return {
        gate: this.name,
        passed: false,
        severity: 'BLOCKER',
        score: 0,
        message: 'Conteúdo ausente ou inválido — impossível avaliar qualidade pedagógica.',
        suggestion: 'O agente deve retornar um Record<string, unknown> no campo conteudo.',
      };
    }

    const texto = JSON.stringify(resultado.conteudo);
    const chaves = Object.keys(resultado.conteudo);

    // ----- Critério 1: Tamanho adequado (+0.30) -----
    const tamanhoOk = texto.length >= TAMANHO_MINIMO_CHARS;
    if (tamanhoOk) {
      score += 0.3;
      detalhes.push(
        `Tamanho adequado: ${texto.length} caracteres (mínimo ${TAMANHO_MINIMO_CHARS}).`
      );
    } else {
      falhas.push(
        `Conteúdo muito curto: ${texto.length} caracteres (mínimo esperado: ${TAMANHO_MINIMO_CHARS}).`
      );
    }

    // ----- Critério 2: Estrutura pedagógica (+0.30) -----
    const temEstrutura = chaves.some((k) => CAMPOS_ESTRUTURA.has(k));
    if (temEstrutura) {
      score += 0.3;
      const camposEncontrados = chaves.filter((k) => CAMPOS_ESTRUTURA.has(k));
      detalhes.push(`Estrutura pedagógica presente: campos [${camposEncontrados.join(', ')}].`);
    } else {
      falhas.push(
        'Estrutura pedagógica ausente — nenhum campo esperado encontrado ' +
          `(ex: ${[...CAMPOS_ESTRUTURA].slice(0, 5).join(', ')}, ...).`
      );
    }

    // ----- Critério 3: BNCC presente (+0.20) -----
    const codigosBncc = texto.match(REGEX_CODIGO_BNCC);
    const temBncc = codigosBncc !== null && codigosBncc.length > 0;
    if (temBncc) {
      score += 0.2;
      detalhes.push(
        `BNCC presente: ${codigosBncc!.length} código(s) detectado(s) — [${codigosBncc!.join(', ')}].`
      );
    } else {
      falhas.push('BNCC ausente — nenhum código no formato EF/EM detectado no conteúdo.');
    }

    // ----- Critério 4: Linguagem inclusiva (+0.20) -----
    const matchDiscriminatorio = texto.match(REGEX_TERMOS_DISCRIMINATORIOS);
    const linguagemInclusiva = matchDiscriminatorio === null || matchDiscriminatorio.length === 0;
    if (linguagemInclusiva) {
      score += 0.2;
      detalhes.push('Linguagem inclusiva: sem termos discriminatórios detectados.');
    } else {
      falhas.push(
        `Linguagem não inclusiva — ${matchDiscriminatorio!.length} termo(s) discriminatório(s) detectado(s): [${matchDiscriminatorio!.join(', ')}].`
      );
    }

    // ----- Arredondamento e clamp -----
    const scoreFinal = Math.min(1.0, Math.max(0.0, Math.round(score * 100) / 100));

    // ----- Determinação de severidade -----
    let severity: GateSeverity;
    let passed: boolean;

    if (scoreFinal < 0.3) {
      severity = 'BLOCKER';
      passed = false;
    } else if (scoreFinal < 0.5) {
      severity = 'WARNING';
      passed = true;
    } else {
      // score >= 0.5: aceitável; >= 0.7 explicitamente "boa qualidade"
      severity = 'INFO';
      passed = true;
    }

    // ----- Mensagem agregada -----
    const partes: string[] = [];
    partes.push(...detalhes);
    if (falhas.length > 0) {
      partes.push(...falhas);
    }
    const qualificador =
      scoreFinal >= 0.7
        ? ' [boa qualidade]'
        : scoreFinal < 0.3
          ? ' [conteúdo muito pobre — BLOCKER]'
          : '';
    const mensagem =
      `Score de qualidade pedagógica: ${scoreFinal.toFixed(2)}/1.00${qualificador}. ` +
      partes.join(' ');

    let suggestion: string | undefined;
    if (falhas.length > 0) {
      suggestion = `Melhorias sugeridas: ${falhas.join(' ')}`;
    }

    return {
      gate: this.name,
      passed,
      severity,
      score: scoreFinal,
      message: mensagem,
      suggestion,
    };
  }
}
