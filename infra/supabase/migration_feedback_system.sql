-- Create Feedbacks Table for Continuous Improvement Reports

create table if not exists public.feedbacks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) not null,
  feature text not null, -- 'term_planning' or 'lesson_planning'
  feedback_text text not null,
  original_content_summary text, -- Brief summary of what was being generated
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS Policies
alter table public.feedbacks enable row level security;

create policy "Users can insert their own feedbacks"
  on public.feedbacks for insert
  with check (auth.uid() = user_id);

create policy "Admins can view all feedbacks"
  on public.feedbacks for select
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and profiles.role = 'admin'
    )
  );
