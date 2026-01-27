
import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from 'dotenv';
import path from 'path';

// Load env vars
dotenv.config({ path: path.resolve(__dirname, '../.env') });

const apiKey = process.env.VITE_GEMINI_API_KEY || '';
const MODEL_NAME = "gemini-2.0-flash";

if (!apiKey) {
    console.error('Missing VITE_GEMINI_API_KEY');
    process.exit(1);
}

async function testGemini() {
    console.log(`Testing Gemini API with model: ${MODEL_NAME}`);
    console.log(`Key: ${apiKey.substring(0, 5)}...`);

    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: MODEL_NAME });

    try {
        const result = await model.generateContent("Hello, are you working?");
        const response = await result.response;
        const text = response.text();
        console.log(`Success! Response: ${text}`);
    } catch (error: any) {
        console.error('Gemini Error:', error.message);

        if (error.message.includes('404')) {
            console.error('Analyze: 404 means the Model ID is not found or not available for this API Key.');
        }
    }
}

testGemini();
