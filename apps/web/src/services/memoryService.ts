import { supabase } from './supabaseClient';

export interface UserMemory {
  id: string;
  content: string;
  tags: string[];
  created_at: string;
}

export const addMemory = async (userId: string, content: string, tags: string[] = []) => {
  const { data, error } = await supabase
    .from('user_memories')
    .insert({ user_id: userId, content, tags })
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const getRelevantMemories = async (userId: string, query: string): Promise<UserMemory[]> => {
  // Simple version: just get latest 5 memories.
  // Advanced version would use vector search.
  // Currently falling back to simple retrieval as 'learning' step.
  const { data, error } = await supabase
    .from('user_memories')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(5);

  if (error) {
    console.error('Error fetching memories:', error);
    return [];
  }
  return data || [];
};
