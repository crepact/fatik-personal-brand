-- Supabase setup for the contact form on fatik-personal-brand
-- Run this once in: Supabase Dashboard -> SQL Editor -> New query -> Run

create table if not exists public.enquiries (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  name        text not null,
  email       text not null,
  phone       text,
  topic       text,
  message     text not null,
  page        text
);

-- (if the table already exists without phone:)
-- alter table public.enquiries add column if not exists phone text;

alter table public.enquiries enable row level security;

-- Visitors (anon key) may ONLY insert. No select/update/delete policies exist,
-- so submissions are write-only from the website and readable only from the
-- dashboard or with the service-role key.
create policy "anyone can submit an enquiry"
  on public.enquiries
  for insert
  to anon
  with check (true);
