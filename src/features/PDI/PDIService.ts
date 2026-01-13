import { supabase } from '../../services/supabaseClient';

export interface PdiLog {
    id?: string;
    student_id: string; // Now refers to a string name or ID
    student_name: string;
    content: string; // The adaptation generated
    original_content?: string;
    created_at?: string;
    synced?: boolean;
}

const LOCAL_STORAGE_KEY = 'profeplan_pdi_logs';

export const savePdiLog = async (log: PdiLog): Promise<void> => {
    // 1. Save Locally
    const existingLogs = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
    const newLog = { ...log, created_at: new Date().toISOString(), synced: false };

    // Add to beginning of list
    const updatedLogs = [newLog, ...existingLogs];
    localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(updatedLogs));

    // 2. Try Sync Background
    try {
        const { error } = await supabase
            .from('pdi_logs')
            .insert([{
                student_name: log.student_name,
                content: log.content,
                original_content: log.original_content,
                teacher_id: (await supabase.auth.getUser()).data.user?.id,
                created_at: newLog.created_at
            }]);

        if (!error) {
            // Mark as synced locally
            newLog.synced = true;
            updatedLogs[0] = newLog; // Update the one we just added
            localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(updatedLogs));
        } else {
            console.warn("Background sync failed for PDI log, saved locally.");
        }
    } catch (e) {
        console.warn("Offline mode: PDI log saved locally only.");
    }
};

export const getPdiHistory = async (): Promise<PdiLog[]> => {
    // Return local logs immediately
    const localLogs = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
    return localLogs;
};
