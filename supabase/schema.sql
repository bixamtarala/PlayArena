-- PlayArena Supabase schema: free-play virtual chips only.
-- Run this later in the Supabase SQL editor when the project is configured.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  phone text,
  display_name text not null default 'Player',
  role text not null default 'player' check (role in ('player','admin')),
  chip_balance bigint not null default 10000 check (chip_balance >= 0),
  is_suspended boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.chip_requests (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  requested_chips bigint not null check (requested_chips > 0),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  note text,
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.chip_ledger (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  delta bigint not null,
  balance_after bigint not null check (balance_after >= 0),
  reason text not null,
  created_by uuid references public.profiles(id),
  request_id bigint references public.chip_requests(id),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.chip_requests enable row level security;
alter table public.chip_ledger enable row level security;

create policy "players read own profile" on public.profiles for select using (auth.uid() = id);
create policy "players read own chip requests" on public.chip_requests for select using (auth.uid() = user_id);
create policy "players create own chip requests" on public.chip_requests for insert with check (auth.uid() = user_id and status = 'pending');
create policy "players read own chip ledger" on public.chip_ledger for select using (auth.uid() = user_id);

create or replace function public.create_profile_for_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, phone) values (new.id, new.phone)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.create_profile_for_new_user();

-- Admin balance changes should be performed only by a trusted server/Admin API
-- using the Supabase service role. Never ship the service-role key in Flutter.
