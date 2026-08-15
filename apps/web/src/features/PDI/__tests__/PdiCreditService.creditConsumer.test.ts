import { beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  rpc: vi.fn(),
}));

vi.mock('../../../services/supabaseClient', () => ({
  supabase: {
    rpc: mocks.rpc,
  },
}));

import {
  savePdiFinalReportGoverned,
  savePdiGeneratedReportGoverned,
  validatePdiAdaptationGoverned,
} from '../PdiCreditService';

describe('PdiCreditService - governed consumer saves', () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it('envia a identidade estável da adaptação para a fronteira especializada', async () => {
    mocks.rpc.mockResolvedValueOnce({
      data: {
        saved: true,
        outcome: 'APPLIED',
        charged: true,
        pdi_record_id: 'artifact-4d-adaptation',
      },
      error: null,
    });

    await expect(
      validatePdiAdaptationGoverned({
        artifactId: 'artifact-4d-adaptation',
        pdiDocumentId: 'pdi-document-4d',
        studentId: 'school-student-4d',
        lessonId: 'lesson-4d',
        lessonTitle: 'Sociologia e inclusão',
        subject: 'Sociologia',
        content: 'Conteúdo adaptado',
        block9Payload: {
          lesson_id: 'lesson-4d',
          adaptacao_metodologica: 'Estratégia adaptada',
        },
      })
    ).resolves.toMatchObject({ saved: true, charged: true });

    expect(mocks.rpc).toHaveBeenCalledWith('credit_validate_pdi_adaptation', {
      p_artifact_id: 'artifact-4d-adaptation',
      p_pdi_document_id: 'pdi-document-4d',
      p_student_id: 'school-student-4d',
      p_lesson_id: 'lesson-4d',
      p_lesson_title: 'Sociologia e inclusão',
      p_subject: 'Sociologia',
      p_content: 'Conteúdo adaptado',
      p_block9_payload: {
        lesson_id: 'lesson-4d',
        adaptacao_metodologica: 'Estratégia adaptada',
      },
    });
  });

  it('mantém a mesma identidade disponível para retry e edição sem fallback legado', async () => {
    mocks.rpc
      .mockResolvedValueOnce({ data: null, error: new Error('rpc unavailable') })
      .mockResolvedValueOnce({
        data: {
          saved: true,
          outcome: 'NO_CHARGE',
          charged: false,
          reason: 'EXISTING_ARTIFACT_EDIT',
        },
        error: null,
      });

    const input = {
      artifactId: 'artifact-4d-retry',
      pdiDocumentId: 'pdi-document-4d',
      studentId: 'school-student-4d',
      lessonId: 'lesson-4d',
      lessonTitle: 'Aula 4D',
      subject: 'Filosofia',
      content: 'Mesmo artefato',
      block9Payload: { lesson_id: 'lesson-4d' },
    };

    await expect(validatePdiAdaptationGoverned(input)).rejects.toThrow('rpc unavailable');
    await expect(validatePdiAdaptationGoverned(input)).resolves.toMatchObject({
      saved: true,
      charged: false,
    });

    expect(mocks.rpc).toHaveBeenCalledTimes(2);
    expect(mocks.rpc.mock.calls[0][1].p_artifact_id).toBe('artifact-4d-retry');
    expect(mocks.rpc.mock.calls[1][1].p_artifact_id).toBe('artifact-4d-retry');
  });

  it('não confirma Save quando a decisão econômica é insuficiente', async () => {
    mocks.rpc.mockResolvedValueOnce({
      data: {
        saved: false,
        outcome: 'REJECTED',
        charged: false,
        reason: 'INSUFFICIENT_CREDITS',
      },
      error: null,
    });

    await expect(
      validatePdiAdaptationGoverned({
        artifactId: 'artifact-insufficient',
        pdiDocumentId: 'pdi-document-4d',
        studentId: 'school-student-4d',
        lessonId: 'lesson-4d',
        lessonTitle: 'Aula 4D',
        subject: 'Sociologia',
        content: 'Conteúdo',
        block9Payload: { lesson_id: 'lesson-4d' },
      })
    ).rejects.toThrow('Créditos insuficientes');
  });

  it('usa fronteira especializada para relatório pedagógico gerado', async () => {
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'APPLIED', charged: true },
      error: null,
    });

    await savePdiGeneratedReportGoverned({
      artifactId: 'report-4d',
      title: 'Relatório PDI',
      content: 'Relatório pedagógico',
    });

    expect(mocks.rpc).toHaveBeenCalledWith('credit_save_pdi_generated_report', {
      p_artifact_id: 'report-4d',
      p_title: 'Relatório PDI',
      p_content: 'Relatório pedagógico',
    });
  });

  it('deriva a identidade do relatório final no servidor a partir do PDI', async () => {
    mocks.rpc.mockResolvedValueOnce({
      data: {
        saved: true,
        outcome: 'NO_CHARGE',
        charged: false,
        artifact_id: 'pdi-final-report-v1:pdi-document-4d',
      },
      error: null,
    });

    await savePdiFinalReportGoverned('pdi-document-4d', 'Parecer final revisado');

    expect(mocks.rpc).toHaveBeenCalledWith('credit_save_pdi_final_report', {
      p_pdi_document_id: 'pdi-document-4d',
      p_content: 'Parecer final revisado',
    });
  });
});
