-- PlayArena MVP core schema
-- Virtual entertainment chips only: no cash value/redemption.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  phone text,
  display_name text,
  avatar_url text,
  status text not null default 'active' check (status in ('active','suspended')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.wallets (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  balance bigint not null default 0 check (balance >= 0),
  updated_at timestamptz not null default now()
);

create table if not exists public.chip_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  delta bigint not null check (delta <> 0),
  balance_before bigint not null check (balance_before >= 0),
  balance_after bigint not null check (balance_after >= 0),
  reason text not null,
  source_type text not null check (source_type in ('welcome_bonus','daily_bonus','game','admin_adjustment','system')),
  source_id text,
  actor_user_id uuid references auth.users(id),
  created_at timestamptz not null default now(),
  check (balance_after = balance_before + delta)
);

create table if not exists public.game_sessions (
  id uuid primary key default gen_random_uuid(),
  game_type text not null check (game_type in ('cricket','teen_patti')),
  status text not null default 'created' check (status in ('created','active','completed','cancelled')),
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

create table if not exists public.game_participants (
  session_id uuid not null references public.game_sessions(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  score bigint not null default 0,
  chip_delta bigint not null default 0,
  joined_at timestamptz not null default now(),
  primary key (session_id, user_id)
);

create table if not exists public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  token text not null unique,
  platform text not null check (platform in ('android','ios')),
  enabled boolean not null default true,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.wallets enable row level security;
alter table public.chip_ledger enable row level security;
alter table public.game_sessions enable row level security;
alter table public.game_participants enable row level security;
alter table public.device_tokens enable row level security;

create policy "profile_read_self" on public.profiles for select using (auth.uid() = id);
create policy "profile_update_self" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
create policy "wallet_read_self" on public.wallets for select using (auth.uid() = user_id);
create policy "ledger_read_self" on public.chip_ledger for select using (auth.uid() = user_id);
create policy "participants_read_self" on public.game_participants for select using (auth.uid() = user_id);
create policy "device_tokens_self" on public.device_tokens for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Wallet and ledger writes intentionally have no client RLS write policy.
-- They must be performed by trusted backend/admin service logic only.
