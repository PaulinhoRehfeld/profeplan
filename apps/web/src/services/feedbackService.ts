import { supabase } from './supabaseClient';

export interface FeedbackData {
  userId: string;
  feature: 'term_planning' | 'lesson_planning';
  feedbackText: string;
  originalContentSummary?: string;
}

export const feedbackService = {
  async saveFeedback(data: FeedbackData) {
    const { userId, feature, feedbackText, originalContentSummary } = data;

    // Log intent to console for debugging
    console.log('[FeedbackService] Saving feedback:', data);

    const { error } = await supabase
      .from('feedbacks')
      .insert({
        user_id: userId,
        feature,
        feedback_text: feedbackText,
        original_content_summary: originalContentSummary
      });

    if (error) {
      console.error('[FeedbackService] Error saving feedback:', error);
      throw error;
    }
  },

  async getFeedbacks() {
    const { data, error } = await supabase
      .from('feedbacks')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data;
  }
};
