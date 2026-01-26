import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Paths
const PROJECT_ROOT = path.resolve(__dirname, '..');
const MIGRATION_FILE = path.join(PROJECT_ROOT, 'supabase', 'migration_feedback_system.sql');

console.log('\n🚀 PROFEPLAN - SETUP DO SISTEMA DE FEEDBACK\n');

try {
    if (!fs.existsSync(MIGRATION_FILE)) {
        throw new Error(`Arquivo de migração não encontrado em: ${MIGRATION_FILE}`);
    }

    const sqlContent = fs.readFileSync(MIGRATION_FILE, 'utf-8');

    console.log('✅ Arquivo SQL encontrado com sucesso.');
    console.log('⚠️  ATENÇÃO: O cliente Supabase (Frontend) não tem permissão para criar tabelas por segurança.');
    console.log('\n📋 SIGA ESTES PASSOS PARA FINALIZAR A INSTALAÇÃO:');
    console.log('1. Acesse o Dashboard do Supabase: https://supabase.com/dashboard/project/_/sql');
    console.log('2. Clique em "New Query"');
    console.log('3. Cole o código SQL abaixo e clique em Run:\n');

    console.log('------------------ COPIE DAQUI ------------------');
    console.log(sqlContent);
    console.log('------------------ ATÉ AQUI ------------------\n');

    console.log('✅ Após rodar o SQL, o sistema de feedback estará 100% funcional.');

} catch (error) {
    console.error('❌ Erro:', error.message);
}
