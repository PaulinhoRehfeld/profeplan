export function getOpenAIApiKey() {
  const apiKey = process.env.DEEPSEEK_API_KEY || process.env.OPENAI_API_KEY;

  if (!apiKey) {
    throw new Error('DEEPSEEK_API_KEY or OPENAI_API_KEY is required to use @profeplan/ai.');
  }

  return apiKey;
}

export function getOpenAIModel() {
  return process.env.OPENAI_MODEL ?? 'deepseek-reasoner';
}
