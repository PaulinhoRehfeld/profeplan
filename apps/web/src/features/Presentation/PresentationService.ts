import { isGovernedCreditConsumerEnabled } from '../../services/credits/creditConsumerFlags';
import { saveGeneratedContent } from '../../services/databaseService';
import type { PresentationScript } from '../../services/ai/AiPresentationService';
import { saveLessonToMemory } from '../../services/supabaseService';
import { supabase } from '../../services/supabaseClient';

type GovernedSaveResult = {
  saved?: boolean;
  outcome?: string;
  charged?: boolean;
  reason?: string;
  artifact_id?: string;
};

export const presentationToMarkdown = (presentation: PresentationScript): string =>
  presentation.slides
    .map((slide) => {
      const bullets = 'contentBulletPoints' in slide ? slide.contentBulletPoints?.join('\n') : '';
      const infographic =
        'infographicDescription' in slide && slide.infographicDescription
          ? `\n${slide.infographicDescription}`
          : '';
      return `## ${slide.title}\n${bullets || ''}${infographic}`.trimEnd();
    })
    .join('\n\n');

const persistAuxiliaryPresentationMemory = async (
  userId: string,
  presentation: PresentationScript,
  contentMarkdown: string
) => {
  try {
    const { error } = await saveLessonToMemory(
      userId,
      presentation.title,
      contentMarkdown,
      presentation,
      undefined
    );

    if (error) {
      console.warn('Erro ao salvar memória auxiliar da apresentação:', error);
    }
  } catch (error) {
    console.warn('Erro ao salvar memória auxiliar da apresentação:', error);
  }
};

/**
 * Lote 1.3C.4C — Presentation Save boundary.
 *
 * Flag OFF preserves the historical sequence: lessons memory first, followed by
 * a direct generated_contents insert.
 *
 * Flag ON makes generated_contents canonical through
 * credit_save_generated_content. The artifactId created when generation
 * completes becomes generated_contents.id and remains stable for retries/edits.
 * Auxiliary lessons memory runs only after the canonical Save commits and can
 * never change the economic outcome.
 */
export const savePresentation = async (userId: string, presentation: PresentationScript) => {
  const contentMarkdown = presentationToMarkdown(presentation);

  if (!isGovernedCreditConsumerEnabled()) {
    await saveLessonToMemory(userId, presentation.title, contentMarkdown, presentation, undefined);
    await saveGeneratedContent(
      userId,
      'apresentacao',
      'APRESENTAÇÕES',
      presentation.title,
      contentMarkdown
    );
    return true;
  }

  const { data, error } = await supabase.rpc('credit_save_generated_content', {
    p_artifact_id: presentation.artifactId,
    p_type: 'apresentacao',
    p_folder: 'APRESENTAÇÕES',
    p_title: presentation.title,
    p_content: contentMarkdown,
  });

  if (error) throw error;

  const result = data as GovernedSaveResult | null;
  if (!result?.saved) {
    if (result?.reason === 'INSUFFICIENT_CREDITS') {
      throw new Error('Créditos insuficientes para salvar esta apresentação.');
    }
    throw new Error(result?.reason || 'Não foi possível salvar a apresentação.');
  }

  await persistAuxiliaryPresentationMemory(userId, presentation, contentMarkdown);
  return true;
};
