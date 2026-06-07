'use client';

import { useState, type FormEvent } from 'react';

export function FeedbackForm() {
  const [rating, setRating] = useState<number>(5);
  const [comment, setComment] = useState<string>('');
  const [isLoading, setIsLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsLoading(true);
    setError(null);
    setSuccess(false);

    try {
      const response = await fetch('/api/feedback', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ rating, comment }),
      });

      const resData = await response.json();

      if (!response.ok) {
        throw new Error(resData.error?.message || 'Falha ao enviar feedback.');
      }

      setSuccess(true);
      setComment('');
      setRating(5);
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <article className="card stack">
      <h3 style={{ fontSize: '16px', fontWeight: '700' }}>Enviar Feedback (Beta)</h3>
      <p className="muted" style={{ fontSize: '13px' }}>
        Ajude-nos a melhorar o PROFEPLAN V2. Deixe sua avaliação e comentários sobre sua
        experiência.
      </p>

      {success ? (
        <div
          className="badge badge-published"
          style={{ padding: '12px', borderRadius: 'var(--radius-sm)', justifyContent: 'center' }}
        >
          ✓ Feedback enviado com sucesso! Obrigado pela contribuição.
        </div>
      ) : null}

      {error ? (
        <p className="error" style={{ fontSize: '13px' }}>
          {error}
        </p>
      ) : null}

      <form className="stack" onSubmit={handleSubmit} style={{ gap: '12px' }}>
        <div className="field">
          <label htmlFor="rating">Avaliação</label>
          <div style={{ display: 'flex', gap: '8px', alignItems: 'center', margin: '4px 0' }}>
            {[1, 2, 3, 4, 5].map((star) => (
              <button
                key={star}
                type="button"
                onClick={() => setRating(star)}
                style={{
                  background: 'none',
                  border: 'none',
                  fontSize: '24px',
                  cursor: 'pointer',
                  padding: 0,
                  color: star <= rating ? '#fbbf24' : '#d1d5db',
                  transition: 'transform 0.1s ease',
                }}
                title={`${star} estrelas`}
              >
                ★
              </button>
            ))}
            <span className="muted" style={{ fontSize: '13px', marginLeft: '8px' }}>
              ({rating} de 5)
            </span>
          </div>
        </div>

        <div className="field">
          <label htmlFor="comment">Comentário / Sugestões</label>
          <textarea
            id="comment"
            name="comment"
            rows={3}
            required
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            placeholder="O que você achou do enriquecimento por IA? Há algo que possamos melhorar?"
            style={{
              width: '100%',
              border: '1px solid var(--border)',
              borderRadius: 'var(--radius-sm)',
              padding: '10px 12px',
              backgroundColor: 'var(--surface-secondary)',
              outline: 'none',
              fontSize: '14px',
              resize: 'none',
            }}
          />
        </div>

        <button
          className="button button-primary"
          disabled={isLoading}
          type="submit"
          style={{ padding: '10px' }}
        >
          {isLoading ? 'Enviando...' : 'Enviar Avaliação'}
        </button>
      </form>
    </article>
  );
}
