
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://uatejrgmbzgoeayfascf.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MTQ2MzgsImV4cCI6MjA4MjA5MDYzOH0.X3h2HCnMgw7dzVSF3ctAm_MCnCDZoBwaxaN-TGWXul4';

const supabase = createClient(supabaseUrl, supabaseKey);

async function check() {
    console.log('--- Checking term_plans ---');
    const { data: plans, error: plansError } = await supabase
        .from('term_plans')
        .select('*')
        .limit(5);

    if (plansError) {
        console.error('Error fetching term_plans:', plansError);
    } else {
        console.log(`Found ${plans.length} plans.`);
        if (plans.length > 0) {
            console.log('Sample Plan Keys:', Object.keys(plans[0]));
            console.log('Sample Plan Level:', plans[0].level);
        }
    }

    console.log('\n--- Checking generated_contents (trimestral) ---');
    const { data: gen, error: genError } = await supabase
        .from('generated_contents')
        .select('*')
        .eq('type', 'trimestral')
        .limit(5);

    if (genError) {
        console.error('Error fetching generated_contents:', genError);
    } else {
        console.log(`Found ${gen.length} trimestral contents.`);
    }
}

check();
