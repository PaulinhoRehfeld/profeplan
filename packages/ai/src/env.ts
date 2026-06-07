export function getOpenAIApiKey() {
  const apiKey = process.env.OPENAI_API_KEY;

  if (!apiKey) {
    throw new Error('OPENAI_API_KEY is required to use @profeplan/ai.');
  }

  return apiKey;
}

export function getOpenAIModel() {
  return process.env.OPENAI_MODEL ?? 'gpt-5.4-mini';
}
