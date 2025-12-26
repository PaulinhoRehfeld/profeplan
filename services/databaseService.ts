import { supabase } from './supabaseClient';

/**
 * Salva o conteúdo gerado pela IA no banco de dados.
 */
export const saveGeneratedContent = async (
  userId: string,
  type: 'plano' | 'aula' | 'avaliacao' | 'documento',
  title: string,
  content: string
) => {
  const { data, error } = await supabase
    .from('generated_contents')
    .insert([
      { 
        user_id: userId, 
        type: type, 
        title: title, 
        content: content 
      }
    ])
    .select();

  if (error) {
    console.error("Erro ao salvar conteúdo gerado:", error.message);
    return null;
  }

  return data[0];
};

/**
 * Busca todos os conteúdos gerados por um usuário.
 */
export const getGeneratedContents = async (userId: string) => {
  const { data, error } = await supabase
    .from('generated_contents')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false });

  if (error) {
    console.error("Erro ao buscar conteúdos:", error.message);
    return [];
  }

  return data;
};

/**
 * Atualiza um conteúdo existente.
 */
export const updateGeneratedContent = async (id: string, updates: { title?: string, content?: string }) => {
  const { data, error } = await supabase
    .from('generated_contents')
    .update(updates)
    .eq('id', id)
    .select();

  if (error) {
    console.error("Erro ao atualizar conteúdo:", error.message);
    throw error;
  }

  return data[0];
};

/**
 * Remove um conteúdo.
 */
export const deleteGeneratedContent = async (id: string) => {
  const { error } = await supabase
    .from('generated_contents')
    .delete()
    .eq('id', id);

  if (error) {
    console.error("Erro ao deletar conteúdo:", error.message);
    throw error;
  }
};

/**
 * Atualiza as preferências e o perfil de aprendizado do professor.
 */
export const updateLearningProfile = async (userId: string, preferences: object) => {
  const { error } = await supabase
    .from('user_learning_profile')
    .upsert({ 
      user_id: userId, 
      preferences: preferences,
      last_updated: new Date().toISOString()
    });

  if (error) {
    console.error("Erro ao atualizar perfil de aprendizado:", error.message);
  }
};