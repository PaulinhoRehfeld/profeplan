import { OpenAI } from 'openai';

import { getOpenAIApiKey } from './env';

export function createOpenAIClient() {
  return new OpenAI({
    apiKey: getOpenAIApiKey(),
  });
}
