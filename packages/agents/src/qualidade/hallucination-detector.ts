// ============================================================================
// PROFEPLAN — Hallucination Detector Agent (Quality Gate)
// S4-01: Detecta conteúdo alucinado via heurísticas de padrões suspeitos
// ============================================================================

import { BaseQualityGate } from './quality-gate-pipeline';
import type { GateResult } from './quality-gate-pipeline';
import { TipoGeracao, type GeracaoResultado } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/** Ano atual usado como referência para detecção de datas futuras suspeitas. */
const ANO_ATUAL = 2026;

/** Limiar de ano a partir do qual uma data é considerada "futura suspeita". */
const ANO_SUSPEITO_MINIMO = 2100;

/** Comprimento mínimo de texto (em caracteres) para evitar falsos positivos em textos curtos. */
const TAMANHO_MINIMO_TEXTO = 50;

/** Proporção máxima aceitável de afirmações em relação ao tamanho do texto (limiar de warning). */
const PROPORCAO_AFIRMACOES_WARNING = 0.15;

// ---------------------------------------------------------------------------
// Regex Patterns
// ---------------------------------------------------------------------------

/**
 * Detecta menções a datas em formatos como "em 2145", "no ano de 3000",
 * "no século 2500".
 *
 * Grupo 1: o valor numérico do ano/século.
 */
const RE_DATA_FUTURA = /\b(?:em|no ano de|no século)\s+(\d{4,5})\b/gi;

/**
 * Detecta citações no padrão "segundo Fulano de Tal (2024)",
 * "de acordo com Ciclano (1998)", "conforme Beltrano (2020)".
 *
 * Grupo 1: nome do autor citado (2 a 4 palavras iniciadas por maiúscula).
 * Grupo 2: ano da citação entre parênteses (opcional).
 */
const RE_CITACAO = /\b(?:segundo|de acordo com|conforme)\s+([A-ZÀ-Ú][a-zà-ú]+(?:\s+[A-ZÀ-Ú][a-zà-ú]+){1,3})\s*(?:\((\d{4})\))?/g;

/**
 * Detecta entidades nominais com títulos acadêmicos/profissionais:
 * "Dr. João da Silva", "Prof. Maria Souza", "Dra. Ana Cardoso".
 */
const RE_ENTIDADE_NOMINAL = /\b(?:Dr\.?|Prof\.?|Dra\.?)\s+[A-ZÀ-Ú][a-zà-ú]+/g;

/**
 * Detecta frases com verbos no indicativo que expressam afirmações factuais.
 *
 * Captura verbos comuns no presente do indicativo em português:
 * "é", "são", "está", "possui", "apresenta", "consiste", "define", etc.
 */
const RE_AFIRMACAO_INDICATIVO =
  /\b(?:é|são|está|estão|possui|possuem|apresenta|apresentam|consiste|consistem|define|definem|compõe|compõem|constitui|constituem|caracteriza|caracterizam|resulta|resultam|ocorre|ocorrem|acontece|acontecem|existe|existem|trata-se|refere-se|diz respeito)\b/gi;

// ============================================================================
// HallucinationDetectorAgent
// ============================================================================

/**
 * Quality gate que detecta conteúdo potencialmente alucinado via heurísticas
 * de padrões suspeitos.
 *
 * **Estratégia de detecção (MOCK — sem integração RAG real):**
 *
 * 1. **Datas futuras/impossíveis**: varre o texto em busca de referências
 *    a anos posteriores a {@link ANO_SUSPITO_MINIMO} (2100). Ex: "em 2145..."
 *    → `WARNING`.
 * 2. **Texto curto com afirmações categóricas**: se o conteúdo tiver menos
 *    de {@link TAMANHO_MINIMO_TEXTO} caracteres e contiver frases no
 *    indicativo, é suspeito → `WARNING`.
 * 3. **Entidades nominais sem fonte**: se o texto contiver múltiplas
 *    menções a "Dr.", "Prof.", "Dra." sem contexto de citação → `INFO`
 *    com score reduzido (0.85).
 * 4. **Proporção de afirmações**: se a densidade de verbos no indicativo
 *    for maior que {@link PROPORCAO_AFIRMACOES_WARNING} → `WARNING`.
 * 5. **Padrão normal**: nenhum dos anteriores → `INFO`, score 1.0.
 *
 * **Aplicabilidade:**
 * Este gate é sempre aplicável (`isApplicable` retorna `true` para
 * qualquer {@link TipoGeracao}), pois alucinação pode ocorrer em
 * qualquer tipo de geração de conteúdo.
 *
 * @example
 * ```ts
 * const detector = new HallucinationDetectorAgent();
 * const result = await detector.check(geracaoResultado, request);
 * // Se detectar "em 2145 os alunos..." → WARNING
 * ```
 */
export class HallucinationDetectorAgent extends BaseQualityGate {
  /** @inheritdoc */
  public get name(): string {
    return 'Hallucination Detector';
  }

  /**
   * O detector de alucinação é sempre aplicável — qualquer geração
   * de conteúdo textual está sujeita a alucinações do modelo.
   *
   * @param _tipo — Tipo de geração (não utilizado — sempre `true`).
   * @returns Sempre `true`.
   */
  public isApplicable(_tipo: TipoGeracao): boolean {
    return true;
  }

  /**
   * Executa a detecção de alucinações via heurísticas de padrões suspeitos.
   *
   * **Algoritmo de detecção:**
   * 1. Serializa o conteúdo para texto plano.
   * 2. Verifica padrões de data futura (>2100) → `WARNING`.
   * 3. Verifica texto curto com afirmações categóricas → `WARNING`.
   * 4. Conta entidades nominais (Dr./Prof./Dra.) → `INFO` com score 0.85
   *    se >= 2 entidades.
   * 5. Calcula proporção de afirmações → `WARNING` se > 15%.
   * 6. Padrão normal → `INFO`, score 1.0.
   *
   * @param resultado — Resultado da geração a ser auditado.
   * @param _req      — Requisição original (não utilizado diretamente).
   * @returns Promise com o {@link GateResult} da auditoria.
   */
  public async check(
    resultado: GeracaoResultado,
    _req: GeracaoRequest,
  ): Promise<GateResult> {
    // TODO: Integrar com Supabase RAG para cruzamento real de afirmações
    const texto = JSON.stringify(resultado.conteudo);
    const textoTamanho = texto.length;

    // ------------------------------------------------------------------
    // 1. Verifica datas futuras suspeitas (>2100)
    // ------------------------------------------------------------------
    const datasFuturas = this._extrairDatasFuturas(texto);
    if (datasFuturas.length > 0) {
      return {
        gate: this.name,
        passed: true,
        severity: 'WARNING',
        score: 0.7,
        message: `Data(s) futura(s) suspeita(s) detectada(s): ${datasFuturas.join(', ')}`,
        suggestion:
          'Verifique se as datas mencionadas são intencionais. Datas posteriores a 2100 são suspeitas de alucinação.',
      };
    }

    // ------------------------------------------------------------------
    // 2. Texto curto com afirmações categóricas
    // ------------------------------------------------------------------
    if (textoTamanho < TAMANHO_MINIMO_TEXTO) {
      const temAfirmacao = this._contarAfirmacoesIndicativo(texto) > 0;
      if (temAfirmacao) {
        return {
          gate: this.name,
          passed: true,
          severity: 'WARNING',
          score: 0.75,
          message: `Texto muito curto (${textoTamanho} caracteres) com afirmações categóricas — suspeito de alucinação concisa.`,
          suggestion:
            'Textos muito curtos com afirmações factuais são mais propensos a conter informações imprecisas. Expanda o conteúdo com fontes verificáveis.',
        };
      }
    }

    // ------------------------------------------------------------------
    // 3. Entidades nominais sem fonte
    // ------------------------------------------------------------------
    const entidades = this._extrairEntidadesNominais(texto);
    if (entidades.length >= 2) {
      return {
        gate: this.name,
        passed: true,
        severity: 'INFO',
        score: 0.85,
        message: `${entidades.length} entidade(s) nominal(is) detectada(s) sem fonte verificável: ${entidades.join(', ')}`,
        suggestion:
          'Considere verificar se as pessoas citadas existem e são relevantes para o contexto pedagógico.',
      };
    }

    // ------------------------------------------------------------------
    // 4. Proporção de afirmações em relação ao tamanho do texto
    // ------------------------------------------------------------------
    const numAfirmacoes = this._contarAfirmacoesIndicativo(texto);
    const proporcaoAfirmacoes = numAfirmacoes / Math.max(textoTamanho, 1);
    if (proporcaoAfirmacoes > PROPORCAO_AFIRMACOES_WARNING) {
      return {
        gate: this.name,
        passed: true,
        severity: 'WARNING',
        score: 0.8,
        message: `Alta densidade de afirmações factuais (${(proporcaoAfirmacoes * 100).toFixed(1)}% do texto) — risco de alucinação.`,
        suggestion:
          'Alta concentração de afirmações pode indicar conteúdo gerado sem lastro em fontes reais. Verifique a factualidade das informações.',
      };
    }

    // ------------------------------------------------------------------
    // 5. Padrão normal — sem indicadores de alucinação
    // ------------------------------------------------------------------
    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: 'Nenhum padrão suspeito de alucinação detectado.',
    };
  }

  // -----------------------------------------------------------------------
  // Private Helpers
  // -----------------------------------------------------------------------

  /**
   * Extrai anos futuros suspeitos do texto.
   *
   * Varre o texto com {@link RE_DATA_FUTURA} e coleta anos
   * numericamente maiores que {@link ANO_SUSPEITO_MINIMO}.
   *
   * @param texto — Texto a ser analisado.
   * @returns Array de strings no formato `"em 2145"`, `"no ano de 3000"`, etc.
   */
  private _extrairDatasFuturas(texto: string): string[] {
    const encontradas: string[] = [];
    const regex = new RegExp(RE_DATA_FUTURA.source, 'gi');

    let match: RegExpExecArray | null;
    while ((match = regex.exec(texto)) !== null) {
      const ano = parseInt(match[1], 10);
      if (ano > ANO_SUSPEITO_MINIMO) {
        encontradas.push(match[0].trim());
      }
    }

    return encontradas;
  }

  /**
   * Conta o número de verbos no presente do indicativo no texto.
   *
   * Utiliza {@link RE_AFIRMACAO_INDICATIVO} para identificar
   * afirmações factuais expressas por verbos como "é", "possui",
   * "apresenta", "define", etc.
   *
   * @param texto — Texto a ser analisado.
   * @returns Número de ocorrências de verbos no indicativo.
   */
  private _contarAfirmacoesIndicativo(texto: string): number {
    const matches = texto.match(RE_AFIRMACAO_INDICATIVO);
    return matches ? matches.length : 0;
  }

  /**
   * Extrai entidades nominais com títulos profissionais/acadêmicos.
   *
   * Utiliza {@link RE_ENTIDADE_NOMINAL} para detectar menções como
   * "Dr. João", "Prof. Maria Souza", "Dra. Ana Cardoso".
   *
   * @param texto — Texto a ser analisado.
   * @returns Array de strings com as entidades encontradas (deduplicadas).
   */
  private _extrairEntidadesNominais(texto: string): string[] {
    const matches = texto.match(RE_ENTIDADE_NOMINAL);
    if (!matches) return [];
    // Deduplica preservando a ordem de primeira ocorrência
    return [...new Set(matches.map((m) => m.trim()))];
  }
}
