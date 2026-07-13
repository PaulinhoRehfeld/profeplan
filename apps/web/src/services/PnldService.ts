import { supabase } from './supabaseClient';
import { PnldBook } from '../types';

type PnldTitleRow = {
  livro_titulo?: string;
};

export const PnldService = {
  /**
   * Fetches all available PNLD books from the metadata table.
   * Fallbacks to unique titles from content table if metadata is empty.
   */
  async getAvailableBooks(): Promise<PnldBook[]> {
    try {
      // 1. Try metadata table (Skipped: Table pnld_livros does not exist)
      // const { data: metadata, error: metaError } = await supabase
      //    .from('pnld_livros')
      //    .select('*')
      //    .order('title', { ascending: true });

      // if (!metaError && metadata && metadata.length > 0) {
      //    return metadata;
      // }

      // 2. Fallback: Identify unique books from content table
      const { data: content, error: contentError } = await supabase
        .from('pnld_livros_conteudo')
        .select('metadata->livro_titulo')
        .limit(1000); // Sample enough to find all books

      if (contentError) throw contentError;

      const titles = ((content as PnldTitleRow[] | null) || [])
        .map((c) => c.livro_titulo)
        .filter(Boolean) as string[];
      const uniqueTitles = Array.from(new Set(titles));

      return uniqueTitles.map((title) => ({
        id: title as string,
        title: title as string,
        discipline: 'Educação Digital', // Defaulting for now
      }));
    } catch (error) {
      console.error('Error fetching PNLD books:', error);
      return [];
    }
  },

  /**
   * Fetches books filtered by discipline.
   */
  async getBooksByDiscipline(discipline: string): Promise<PnldBook[]> {
    const all = await this.getAvailableBooks();
    return all.filter((b) => b.discipline?.toLowerCase().includes(discipline.toLowerCase()));
  },
};
