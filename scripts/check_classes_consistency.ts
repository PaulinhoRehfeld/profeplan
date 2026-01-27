
import { getLocalClasses } from '../src/services/localStorageService';

async function verifyClasses() {
    const userId = 'placeholder-user-id'; // This would be dynamic in real app
    console.log("--- Diagnostic Check: Class Consistency ---");

    const localClasses = getLocalClasses(userId);
    console.log(`Found ${localClasses.length} local classes.`);

    localClasses.forEach(cls => {
        console.log(`- Class: ${cls.name} (${cls.subject})`);
        console.log(`  Students: ${cls.students.length}`);

        // Check if structure matches what AssessmentManager expects
        const isValid = cls.id && cls.name && cls.subject && Array.isArray(cls.students);
        console.log(`  Structure Valid: ${isValid ? '✅' : '❌'}`);
    });
}

// verifyClasses(); // Running this would require a Node environment with DOM/LocalStorage mocks or running in browser console
console.log("Diagnostic script created. Run in browser console for best results.");
