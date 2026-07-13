// ============================================================================
// PROFEPLAN — Format Validator Agent (Quality Gate)
// S3-01: Primeiro quality gate real — validação de formato do conteúdo gerado
// ============================================================================

import { BaseQualityGate } from './quality-gate-pipeline';
import type { GateResult } from './quality-gate-pipeline';
import { TipoGeracao, type GeracaoResultado } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

/**
 * Quality gate que valida a estrutura do conteúdo gerado por qualquer
 * agente de disciplina.
 *
 * Verifica:
 * - Se {@link GeracaoResultado.conteudo} existe e é um objeto.
 * - Campos recomendados por tipo de geração (tema, duração, eixos, questões).
 *
 * Este gate é **sempre aplicável** (`isApplicable` retorna `true` para
 * qualquer {@link TipoGeracao}), pois toda geração precisa ter um formato
 * mínimo válido.
 *
 * Severidades emitidas:
 * - `BLOCKER`: conteúdo ausente ou não é um objeto.
 * - `WARNING`: formato OK, mas campos recomendados ausentes.
 * - `INFO`: formato completamente validado.
 *
 * @example
 * ```ts
 * const gate = new FormatValidatorAgent();
 * const result = await gate.check(geracaoResultado, request);
 * if (!result.passed) {
 *   console.error(result.message, result.suggestion);
 * }
 * ```
 */
export class FormatValidatorAgent extends BaseQualityGate {
  /** @inheritdoc */
  public get name(): string {
    return 'Format Validator';
  }

  /**
   * O FormatValidator é sempre aplicável — toda geração precisa ter
   * um formato mínimo válido, independentemente do tipo.
   *
   * @param _tipo — Tipo de geração (não utilizado; sempre retorna `true`).
   * @returns `true` para qualquer tipo de geração.
   */
  public isApplicable(_tipo: TipoGeracao): boolean {
    return true;
  }

  /**
   * Executa a validação de formato sobre o conteúdo gerado.
   *
   * Algoritmo:
   * 1. Verifica se `conteudo` existe e é um objeto → senão, BLOCKER.
   * 2. Para cada tipo de geração, verifica campos recomendados:
   *    - `PLANO_AULA`: `tema`, `duracao`
   *    - `PLANEJAMENTO_TRIMESTRAL`: `eixos_tematicos` ou `eixosTematicos`
   *    - `AVALIACAO`: `questoes`
   * 3. Se houver warnings, retorna `WARNING` com score 0.9.
   * 4. Senão, retorna `INFO` com score 1.0.
   *
   * @param resultado — Resultado da geração produzida pelo agente de disciplina.
   * @param req       — Requisição original que originou a geração.
   * @returns Promise com o {@link GateResult} contendo score, passed, mensagem etc.
   */
  public async check(resultado: GeracaoResultado, req: GeracaoRequest): Promise<GateResult> {
    const conteudo = resultado.conteudo;

    // --- BLOCKER: conteúdo ausente ou não é um objeto ---
    if (!conteudo || typeof conteudo !== 'object') {
      return {
        gate: this.name,
        passed: false,
        severity: 'BLOCKER',
        score: 0,
        message: 'Conteúdo ausente ou não é um objeto.',
        suggestion: 'O agente deve retornar um Record<string, unknown> no campo conteudo.',
      };
    }

    const warnings: string[] = [];

    // --- Verifica campos esperados por tipo de geração ---
    if (req.tipo === TipoGeracao.PLANO_AULA) {
      if (!conteudo.tema) {
        warnings.push('Campo "tema" ausente (recomendado para PLANO_AULA).');
      }
      if (!conteudo.duracao) {
        warnings.push('Campo "duracao" ausente (recomendado para PLANO_AULA).');
      }
    }

    if (req.tipo === TipoGeracao.PLANEJAMENTO_TRIMESTRAL) {
      if (!conteudo.eixos_tematicos && !conteudo.eixosTematicos) {
        warnings.push(
          'Campo "eixos_tematicos" ausente (recomendado para PLANEJAMENTO_TRIMESTRAL).'
        );
      }
    }

    if (req.tipo === TipoGeracao.AVALIACAO) {
      if (!conteudo.questoes) {
        warnings.push('Campo "questoes" ausente (recomendado para AVALIACAO).');
      }
    }

    // --- WARNING: formato OK mas campos recomendados ausentes ---
    if (warnings.length > 0) {
      return {
        gate: this.name,
        passed: true,
        severity: 'WARNING',
        score: 0.9,
        message: `Formato OK, mas ${warnings.length} aviso(s): ${warnings.join('; ')}`,
        suggestion: 'Verifique os campos recomendados no template de saída.',
      };
    }

    // --- INFO: formato completamente validado ---
    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: 'Formato validado com sucesso.',
    };
  }
}
