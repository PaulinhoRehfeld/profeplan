// ============================================================================
// PROFEPLAN — Privacy Guard Agent
// S3-03: Detecta exposição de dados sensíveis de alunos em conteúdo gerado
// ============================================================================

import { BaseQualityGate, type GateResult } from './quality-gate-pipeline';
import { TipoGeracao, type GeracaoResultado } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

/**
 * Agente de qualidade que audita conteúdos gerados em busca de exposição
 * indevida de dados pessoais (PII) e termos clínicos/diagnósticos sensíveis.
 *
 * Política de severidade:
 * - **BLOCKER**: dados pessoais identificáveis (CPF, CNPJ, data de nascimento).
 *   O pipeline é interrompido imediatamente.
 * - **WARNING**: termos clínicos, diagnósticos, nomes de profissionais de saúde.
 *   O conteúdo é liberado, mas um alerta é emitido.
 * - **INFO**: nenhuma violação detectada — conteúdo aprovado.
 *
 * @example
 * ```ts
 * const guard = new PrivacyGuardAgent();
 * const result = await guard.check(geracaoResultado, request);
 * // result.severity === 'BLOCKER' se CPF/CNPJ detectado
 * ```
 */
export class PrivacyGuardAgent extends BaseQualityGate {
  /**
   * Padrões de termos sensíveis — laudos, diagnósticos, termos clínicos.
   *
   * Detecta menções a condições médicas, transtornos, deficiências,
   * medicamentos e profissionais de saúde que possam identificar
   * ou estigmatizar estudantes.
   */
  private static readonly PADROES_SENSIVEIS: RegExp[] = [
    /\b(TDAH|TEA|TOD|DISLEXIA|DISCALCULIA|SÍNDROME DE DOWN|SÍNDROME DE ASPERGER)\b/gi,
    /\b(LAUDO|DIAGNÓSTICO|CID-?\d{2}|CID\s*10|CID\s*11|DSM-?5|DSM\s*V)\b/gi,
    /\b(DEFICIÊNCIA INTELECTUAL|DEFICIÊNCIA FÍSICA|DEFICIÊNCIA AUDITIVA|DEFICIÊNCIA VISUAL)\b/gi,
    /\b(MEDICAÇÃO|MEDICAMENTO|REMÉDIO|DOSAGEM|MG\/DIA|COMPRIMIDO)\b/gi,
    /\b(PSICÓLOGO|PSIQUIATRA|FONOAUDIÓLOGO|TERAPEUTA|NEUROLOGISTA)\s+(?:DR\.?|DR[Aa]\.?)\s+\w+/gi,
    /\b(TRANSTORNO|DISTÚRBIO|COMPROMETIMENTO)\s+(?:DO|DA|DE)\s+\w+/gi,
  ];

  /**
   * Padrões de identificação pessoal (PII — Personally Identifiable Information).
   *
   * Detecta CPF, CNPJ e datas de nascimento no formato brasileiro.
   * Qualquer match nesta categoria resulta em bloqueio imediato (BLOCKER).
   */
  private static readonly PADROES_PII: RegExp[] = [
    /\b\d{3}\.?\d{3}\.?\d{3}-?\d{2}\b/g,       // CPF
    /\b\d{2}\.?\d{3}\.?\d{3}\/\d{4}-?\d{2}\b/g, // CNPJ
    /\b\d{2}\/\d{2}\/\d{4}\b/g,                 // Data de nascimento
  ];

  /** @inheritdoc */
  public get name(): string {
    return 'Privacy Guard';
  }

  /**
   * O Privacy Guard é sempre aplicável, independentemente do tipo de geração.
   *
   * @param _tipo — Tipo de geração (não utilizado — sempre `true`).
   * @returns Sempre `true`.
   */
  public isApplicable(_tipo: TipoGeracao): boolean {
    return true;
  }

  /**
   * Executa a auditoria de privacidade sobre o conteúdo gerado.
   *
   * Estratégia de verificação em duas fases:
   * 1. **PII (BLOCKER)**: varre CPF, CNPJ e datas de nascimento.
   *    Se encontrado, retorna imediatamente com `passed: false`.
   * 2. **Termos sensíveis (WARNING)**: varre diagnósticos, medicamentos,
   *    profissionais de saúde. Se encontrado, retorna com `passed: true`
   *    mas emite alerta com sugestão de linguagem pedagógica.
   *
   * @param resultado — Resultado da geração a ser auditado.
   * @param _req      — Requisição original (não utilizado diretamente).
   * @returns Promise com o {@link GateResult} da auditoria.
   */
  public async check(
    resultado: GeracaoResultado,
    _req: GeracaoRequest,
  ): Promise<GateResult> {
    const texto = JSON.stringify(resultado.conteudo).toLowerCase();
    const violacoes: string[] = [];
    const bloqueios: string[] = [];

    // Fase 1: Verifica PII (BLOCKER)
    for (const regex of PrivacyGuardAgent.PADROES_PII) {
      const matches = texto.match(regex);
      if (matches) {
        for (const m of matches) {
          bloqueios.push(`Dado pessoal detectado: "${m}"`);
        }
      }
    }

    if (bloqueios.length > 0) {
      return {
        gate: this.name,
        passed: false,
        severity: 'BLOCKER',
        score: 0,
        message: `VIOLAÇÃO DE PRIVACIDADE: ${bloqueios.join('; ')}`,
        suggestion:
          'Remova imediatamente dados pessoais (CPF, RG, data de nascimento) do conteúdo.',
      };
    }

    // Fase 2: Verifica termos sensíveis (WARNING)
    for (const regex of PrivacyGuardAgent.PADROES_SENSIVEIS) {
      const matches = texto.match(regex);
      if (matches) {
        for (const m of matches) {
          violacoes.push(`Termo sensível: "${m}"`);
        }
      }
    }

    if (violacoes.length > 0) {
      return {
        gate: this.name,
        passed: true,
        severity: 'WARNING',
        score: 0.7,
        message: `${violacoes.length} termo(s) sensível(is) detectado(s).`,
        suggestion:
          'Evite termos clínicos/diagnósticos. Use linguagem pedagógica: "estudante com necessidades específicas" em vez de diagnósticos.',
      };
    }

    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: 'Nenhuma violação de privacidade detectada.',
    };
  }
}
