create table if not exists user_memories (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id) not null,
  content text not null, -- O que o usuário disse/preferiu
  tags text[], -- Ex: ['estilo', 'correção', 'feedback']
  created_at timestamp with time zone default now()
);

-- Enable RLS
alter table user_memories enable row level security;

-- Policy
create policy "Users can manage their own memories"
on user_memories for all
using (auth.uid() = user_id);
