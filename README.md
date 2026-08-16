# PlayArena

PlayArena is a mobile-first free-to-play game platform.

## MVP
- Shared mobile-number account foundation
- Cricket game module
- Teen Patti free-play module
- Shared virtual chips/points (no cash value, withdrawal, sale, or redemption)
- Admin chip adjustments with immutable audit history
- Game history and leaderboards
- Push-notification-ready architecture

## Planned stack
- Flutter mobile application
- Supabase Auth (phone OTP) + PostgreSQL
- FastAPI game/backend services
- Redis for ephemeral realtime game state
- Firebase Cloud Messaging for push notifications
- Web admin dashboard

## Repository layout
- `mobile/` Flutter client
- `backend/` API and authoritative game services
- `supabase/` database migrations and RLS policies
- `admin/` admin dashboard (later phase)
- `docs/` architecture and product rules

## Product boundary
All chips/points in the MVP are virtual entertainment credits only. They cannot be purchased for cash, withdrawn, transferred for value, sold, or redeemed for money/prizes.
