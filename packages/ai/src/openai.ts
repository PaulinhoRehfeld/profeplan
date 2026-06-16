import { OpenAI } from 'openai';

import { getOpenAIApiKey } from './env';

export function createOpenAIClient() {
  const apiKey = getOpenAIApiKey();
  const isDeepSeek = apiKey.startsWith('sk-f2a4') || !!process.env.DEEPSEEK_API_KEY;
  const baseURL = isDeepSeek ? (process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com') : undefined;

  return new OpenAI({
    apiKey,
    baseURL,
  });
}

