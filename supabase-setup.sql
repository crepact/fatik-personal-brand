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

-- Visitors (anon key) may ONLY insert. Reading and updating requires signing
-- in on /admin.html as the admin account (email locked in the policies below).
create policy "anyone can submit an enquiry"
  on public.enquiries
  for insert
  to anon
  with check (true);

-- Lead status workflow used by the admin dashboard (new / contacted / closed)
alter table public.enquiries add column if not exists status text not null default 'new';

-- Admin-only read/update for the dashboard (replace the email if it changes)
create policy "admin can read enquiries"
  on public.enquiries for select to authenticated
  using ((auth.jwt()->>'email') = 'magnolia.ads2025@gmail.com');

create policy "admin can update enquiries"
  on public.enquiries for update to authenticated
  using ((auth.jwt()->>'email') = 'magnolia.ads2025@gmail.com')
  with check ((auth.jwt()->>'email') = 'magnolia.ads2025@gmail.com');
