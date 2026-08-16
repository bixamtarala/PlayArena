# PlayArena — Live Cricket Prediction & Social Competition Plan

## Status
Future roadmap / reference document. Do not connect to production until the current offline app, authentication, backend and compliance review are complete.

## Product Direction

PlayArena can evolve from Cricket mini-games + Teen Patti into a live cricket prediction and social competition platform.

Core positioning:

**PlayArena = Cricket + Live Predictions + Friends + Leaderboards + Virtual Chips + Teen Patti**

The cricket prediction experience is intended as free-play entertainment and skill/knowledge competition, not cash wagering.

## Core Principles

- No cash betting.
- No cash withdrawal.
- Virtual chips have no cash value.
- Chips cannot be sold or redeemed for money.
- Players should not transfer/sell chips to one another.
- Admin controls the virtual-chip ledger.
- Prefer free/non-purchasable prediction entries until legal and app-store review is complete.
- If money, purchasable chips, prizes, or anything of monetary value is ever introduced, perform a fresh legal/regulatory and app-store-policy review before implementation.

## Live Match Experience

Suggested flow:

**Live Match → Prediction Rooms → Select Prediction → Lock Before Cutoff → Live Cricket Feed Resolves Event → Correct Prediction Earns XP/Virtual Chips → Leaderboard → Friends/Public Rooms**

A live cricket data provider will eventually supply fixtures, teams, squads, toss, scorecard, innings, overs, balls, wickets, player statistics and match status.

The PlayArena prediction engine should:

1. Detect scheduled/live matches.
2. Generate or load prediction questions.
3. Define prediction options and cutoff times.
4. Accept users' selections before the cutoff.
5. Lock predictions automatically.
6. Read the actual outcome from the cricket data feed.
7. Settle the prediction automatically.
8. Award free-play XP/virtual chips according to configured rules.
9. Update match and global leaderboards.
10. Store prediction history and accuracy.

## T20 Prediction Ideas

### Match checkpoints
- Powerplay / 6-over score.
- 10-over score.
- 15-over score.
- 20-over/final innings score.
- Wickets after 6 overs.
- Wickets after 10 overs.
- Wickets after 15 overs.
- Final wickets.

### Batter predictions
- Batter runs at a checkpoint.
- Batter to reach 25/50/100.
- Highest-scoring batter.
- Number of fours/sixes.
- Next batter milestone.

### Bowler predictions
- Wickets by a bowler.
- Runs conceded.
- Best bowler.
- Next wicket window.

### Match predictions
- Toss-related questions after toss data is available.
- Powerplay outcome.
- Partnership milestone.
- Innings total range.
- Match winner.

## ODI Prediction Ideas

- 10-over score.
- 20-over score.
- 30-over score.
- 40-over score.
- 50-over/final score.
- Wickets at each checkpoint.
- Batter milestones.
- Partnership milestones.
- Bowler wickets/economy ranges.
- Innings total range.
- Match winner.

## Test Match Prediction Ideas

Test cricket requires session/day/innings-based predictions rather than only over checkpoints.

- First-session score.
- Lunch score/wickets.
- Tea score/wickets.
- End-of-day score/wickets.
- First-innings total.
- Second-innings total.
- Lead/deficit range.
- Batter century/half-century milestone.
- Bowler wicket milestones.
- Session winner/performance challenge.
- Match result.

## Prediction Types

### Exact / range
Example: What will the score be after 10 overs?

Options could be ranges such as 60–69, 70–79, 80–89, 90+ rather than requiring an exact score.

### Yes / No
Example: Will the batting side score 50 during the powerplay?

### Multiple choice
Example: Who will be the highest-scoring batter?

### Event window
Example: When will the next wicket fall? Overs 7–8, 9–10, 11–12, 13+.

### Social challenge
Friends answer the same prediction set and compete by prediction accuracy/XP.

## Virtual Chip Model

Virtual chips are entertainment credits only.

Possible free-play mechanics:

- Daily free chip allocation.
- Admin-issued chips.
- Chips/XP earned for correct predictions.
- Streak bonuses.
- Achievement bonuses.
- Free tournament entries.
- Friend challenge rewards.

Do not implement cash withdrawal, cash redemption, chip resale or player-to-player chip markets.

## Leaderboards & Retention

Possible leaderboards:

- Match leaderboard.
- Daily leaderboard.
- Weekly leaderboard.
- Tournament/series leaderboard.
- Friends leaderboard.
- Cricket-format leaderboard (T20/ODI/Test).
- Prediction accuracy leaderboard.

Player profile metrics:

- Predictions made.
- Correct predictions.
- Prediction accuracy percentage.
- Current streak.
- Best streak.
- XP/level.
- Match participation.
- Cricket knowledge badges.

## Friends / Multiplayer

Future social features:

- Create private prediction room.
- Invite friends.
- Join by room code/link.
- Public match rooms.
- Same questions for everyone in a room.
- Live room leaderboard.
- Reactions/chat with moderation controls.
- End-of-match winner screen.

## Suggested Technical Architecture

### Flutter app
Screens/modules:

- Live Matches.
- Match Detail.
- Prediction Lobby.
- Prediction Question.
- My Predictions.
- Live Score/Timeline.
- Prediction Result.
- Leaderboards.
- Friends/Rooms.
- Prediction History.

### Backend
Server responsibilities:

- Live cricket feed ingestion.
- Match synchronization.
- Prediction creation.
- Cutoff enforcement.
- Server-authoritative submissions.
- Outcome settlement.
- XP/chip rewards.
- Leaderboards.
- Abuse/rate-limit controls.
- Audit logs.

Never trust the mobile client to determine whether a prediction is correct or to modify chip balances.

### Database concepts
Potential future tables:

- matches
- teams
- players
- match_events
- prediction_questions
- prediction_options
- user_predictions
- prediction_results
- prediction_rooms
- room_members
- leaderboard_entries
- game_history
- profiles
- chip_ledger

## Live Cricket API Requirements

Before choosing a provider, compare:

- T20, ODI and Test coverage.
- International and domestic coverage.
- Ball-by-ball latency.
- Fixtures and match status.
- Squads/playing XI.
- Toss data.
- Scorecards.
- Over/ball events.
- Batter/bowler statistics.
- Webhooks versus polling.
- API rate limits.
- Commercial/mobile-app licensing rights.
- Reliability and pricing.

Do not hard-code a provider until current pricing, licensing and coverage have been reviewed.

## Fairness & Integrity

- Prediction cutoff must be server-side.
- Do not allow edits after cutoff.
- Account for live-feed latency.
- Keep settlement/audit records.
- Handle abandoned/no-result/delayed matches explicitly.
- Void affected questions when the underlying event cannot be fairly resolved.
- Protect against duplicate submissions and replay requests.
- Use server timestamps, not device timestamps, for deadlines.

## Compliance / Store Review Gate

Before public release of live real-world prediction mechanics, review the exact product against applicable Indian laws/regulations and Google Play policies in the jurisdictions where PlayArena will operate.

The initial target architecture should remain **free-to-play, non-cash, non-redeemable entertainment**. Product wording alone does not determine regulatory treatment; mechanics such as consideration, staking, purchasable chips, prizes and transferability matter.

## Implementation Sequence — Later

1. Finish current PlayArena offline UI and gameplay.
2. Configure authentication/database/backend.
3. Implement secure server-side virtual-chip ledger.
4. Add live cricket fixtures and score feed.
5. Build Live Matches screen.
6. Build prediction question engine.
7. Add T20 checkpoint predictions first.
8. Implement server-side cutoff and settlement.
9. Add prediction history and accuracy.
10. Add match leaderboards.
11. Add friend/private rooms.
12. Expand to ODI predictions.
13. Expand to Test match sessions/days.
14. Complete compliance/app-store review before public launch.

## MVP Recommendation

Start live prediction with T20 because it is easier to understand and test.

Initial prediction set:

- Powerplay score range.
- Powerplay wickets.
- 10-over score range.
- 10-over wickets.
- 15-over score range.
- Final innings score range.
- Highest-scoring batter.
- Match winner.

This is enough to validate whether users enjoy predicting throughout a live match before building dozens of prediction types.
