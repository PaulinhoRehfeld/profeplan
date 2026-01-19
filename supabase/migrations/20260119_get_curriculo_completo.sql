-- Função SQL para pegar o Texto Completo do Trimestre
create or replace function get_curriculo_completo(
  p_disciplina text,
  p_periodo text,
  p_ano_escolar text default null
)
returns text
language plpgsql
as $$
declare
  contexto_completo text;
begin
  -- Concatena todas as habilidades encontradas num único texto gigante
  -- Como mudamos a estratégia de chunking, agora cada linha já DEVE ser o trimestre inteiro.
  -- Mas por garantia usamos string_agg caso haja duplicatas ou restos.
  select string_agg(content, E'\n---\n') 
  into contexto_completo
  from curriculos_mg
  where 
    -- Comparação case-insensitive e trimada para robustez
    trim(lower(metadata->>'disciplina')) = trim(lower(p_disciplina))
    and trim(lower(metadata->>'periodo')) = trim(lower(p_periodo))
    and (
        p_ano_escolar is null 
        or trim(lower(metadata->>'ano_escolar')) = trim(lower(p_ano_escolar))
    );
    
  return contexto_completo;
end;
$$;
