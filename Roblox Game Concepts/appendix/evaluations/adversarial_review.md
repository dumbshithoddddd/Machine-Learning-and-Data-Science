# Adversarial Review: Top-10 Concept Slate (2026-11-13)

**Stance.** My job here is to find what kills each concept, so this review is deliberately one-sided. I used 15 web searches; tracker figures come from search snippets, not live pages. Labels: **[Found]** = this session's search, **[Research]** = the team's research files, **[Spec]** = my speculation.

## 0. Two problems with the slate as a whole

**A. The ranking is mostly noise.** The panel ranked each concept family by its *best* score. Families scored in three rounds therefore had three chances to draw a high number, while one-round families (Toybox, Critter) had one. Re-scoring the same idea moved it by up to ±0.9: Scribble went 6.20, then 7.02, then 6.10, and Grounded went 6.98, 7.04, 6.30. Averaging each family's versions gives a different picture:

| Family | Versions | Mean |
|---|---|---|
| Grounded! | 6.98 / 7.04 / 6.30 | **6.77** |
| Statue Shuffle | 6.54 / 6.60 / 6.20 | 6.45 |
| Scribble Spells | 6.20 / 7.02 / 6.10 | 6.44 |
| Paddle Panic | 6.58 / 6.52 / 6.14 | 6.41 |
| Toybox Knockout | 6.40 | 6.40 |
| Blaze Brigade | 6.42 / 6.36 | 6.39 |
| Critter | 6.22 / 5.80 (vetoed) | 6.01 |
| Fake/Forger | 6.20 / 5.68 | 5.94 |
| Ghost Vlog | 6.16 / 4.94 | 5.55 |
| Night Desk | 6.14 / 4.78 | 5.46 |

Ranks 2 to 6 fall within 0.06 of each other, so they are a statistical tie. The panel's 0.02 gap between #1 and #2 means nothing. The ranking should rest on risk, not on these scores.

**B. Several market signals are weaker than the concept docs say.**
- **Worst Class Ever** went on sale on Steam on **2026-11-09**, four days ago [Found][Research]. Its buyers are a PC, voice-chat, streamer audience. Its "#1" was by demo players, which says nothing yet about retention.
- **No Body No Problem!** is *unreleased*. It is listed for 2026-11-26, and its Steam page shows a playtest sign-up [Found]. The "top 5" claim comes from a gg.deals list, not from Valve's Next Fest ranking [Research].
- **Fart Together** shows a ~14K CCU spike followed by a takedown [Research]. That is evidence of moderation risk, not of a lasting raft or shared-control market.
- **Horror data is inflated by Halloween.** RoWatcher's weekly roundup reports post-Halloween losers such as a horror title down 62% [Found]. The "3x Halloween multiplier" claim has no stated method.
- **The trackers disagree.** Clean the House shows 870K vs ~4.5M visits and a 5K vs 8.2K peak. Boat Ride Together shows a 123 vs 2K peak. Draw Spells shows 440K vs 1.5M visits [Found]. Treat every CCU figure as accurate only to within about 2–5x.
- **The platform is shrinking and spending less.** DAU fell 9% year over year, monthly payers fell 16%, and impressions for under-13 games leaning on short-term monetization were cut [Research].
- **The +42% adult DevEx boost will mostly not apply.** R3 says "All use R15 (adult DevEx +42%)". But that rate covers only spend from age-verified US players aged 18+, and every theme on this slate (Mom, toys, critters, statues) skews toward children. Expect little uplift [Spec].
- **Clones arrive fast.** Roblox copied Fart Together within weeks. Gizmodo covered "Roblox vultures immediately steal his idea" [Found, headline only]. With 3–4 months to a first release, we will reach market **after** the clone wave for any concept taken directly from a Steam hit of Oct–Nov 2026.

---

## 1. Grounded! (R2-01, 7.04; family mean 6.77)

**Competitors.** I found **no Roblox game** where kids hide a mess from a parent who is played by another player. The search returned only itch.io jam games (Before Your Mom Gets Home, Tidy Hidey, House Party Hustle) [Found]. The nearest Roblox game is *Clean the House!* (Snowy Interactive): PvE, released Jul 2026, peak 5K–8.2K depending on the tracker [Found]. So the theme has modest demand and the asymmetric format is open. That is the strongest "no-competitor" result on the slate.

**What it really costs to build.**
- **Content.** Every house needs about 60 hotspots, 25–40 evidence objects with four states each, and scent and blacklight data. That makes each monthly house a level-design project, not a reskin.
- **The R3 redesign added scope and lost score.** It added a driving minigame, a radial menu, decoys, a naughty step, paper planes and bedrooms, and its score fell to 6.30 with DevSimp 3. Simplifying the concept would help it more than adding to it.

**Retention.** The fun depends on how novel the hiding spots are. Once players know a house, the hunt stops being a puzzle. Random subsets of open spots slow this down but do not stop it [Spec]. Under the 28-day discovery signal, a game with one house at launch is exposed.

**Mobile.** R2 is fine: one contextual button plus three gadget buttons. R3's swipe-driving plus radial gives the Parent three separate control schemes in five minutes, which is too much for one role.

**Monetization.**
- Parent costumes are good, but only one player per round is the Parent.
- The Snitch and Report Card features rely on calling a child out in front of the lobby. Watch for bullying and moderation problems with a young audience [Spec].

**Name.** "Grounded" collides with Obsidian/Xbox's *Grounded* franchise (known, not re-verified this session). That hurts searchability and carries trademark risk. **Rename it before any public test.**

**If it failed, the most likely cause would be content-bound retention: players solve the house in about a week and new houses cost too much to make monthly.**
- Secondary 1: role imbalance in 1vN with strangers. Kids AFK, or the Parent role is unpleasant for a young player, which makes queues lopsided.
- Secondary 2: scope creep, with R3-style additions delaying launch until "hide the evidence" clones from No Body No Problem! appear on Roblox.

**Kill risk: MEDIUM. Ranking: hold at #1**, on two conditions: build from the R2 spec rather than R3, and rename it.

## 2. Scribble Spells (R2-04, 7.02; family mean 6.44)

**Competitors and demand.**
- The only Roblox draw-spell game, *Draw Spells Magic Arena* (PvP), peaks at **615–639 CCU** [Found].
- It also got code-page coverage from Destructoid and ProGameGuides in Nov 2026 [Found].
- The press attention did not turn into players. That is the best available evidence that "draw to cast" is not a strong enough pull on Roblox.
- No co-op draw-spell game was found, so the lane is open, but it may be open because demand is weak.

**What it really costs to build.** The recognizer is cheap. The real problem is the timing:
- R3 moved trace classification to the server.
- Fusion needs two casts within a 1-second window.
- Mobile round trips of 150–300 ms make fusions feel random rather than intended [Spec].

**Mobile.**
- The concept is "finger-drawing", but phone players hold the device in landscape with both hands.
- Drawing a spiral or a heart with a thumb is imprecise, so expect a high misfire rate on phones and a good experience only on tablets [Spec].
- On console, "radial plus stick flick" is effectively a different game.

**Retention and monetization.**
- Roblox tower-defence players expect collection loops (units, gacha). Six runes and relic drafts are thin by comparison.
- Ink trails are a weak status item, since the runes vanish in 0.5 s.
- Monet is 6 and Comm is 5.

**Score stability.** Refining the concept dropped its score from 7.02 to 6.10. The 7.02 was probably an outlier.

**If it failed, the most likely cause would be acquisition: a static, fixed-balcony wave-defence game with a niche hook gets low click-through and stays under 1K CCU, like its only comparable.**
- Secondary 1: thumb-drawing accuracy and latency make fusions feel like luck.
- Secondary 2: the meta is too shallow next to collection-driven tower-defence games, so D7 falls off.

**Kill risk: MED-HIGH. Ranking: drop to #3.** It is still worth a prototype, because its main risk can be tested cheaply.

## 3. Statue Shuffle (R2-03, 6.60; family mean 6.45)

**Competitors.**
- *Prank the Teacher* already has 82M visits [Found].
- Hide-in-plain-sight is crowded: Be NPC or Die, DISGUISE, In Plain Sight [Research].
- No Roblox weeping-angel game with a flashlight beam surfaced [Found], so the beam-only tag rule is new.
- But its stated inspiration, Worst Class Ever, released four days ago. Clone studios will have "prank the teacher/guard" asymmetric games live before we finish [Spec, based on the Fart Together precedent].

**The core judgment depends on latency.** "Did you move while lit" is decided by the server with a 0.3–0.5 s ping grace window. On mobile, either the Guard sees obvious movers go untagged, or statues get tagged after they stopped. Both outcomes cause rage-quits [Spec].

**Mobile.** The Guard's look-drag aiming plus a TAG button is the hardest control scheme on the slate. Mobile 7 and Access 6 understate this.

**Monetization.** Monet is 5 or 6. Disguise packs are clever, but they are designed *never* to make the wearer stand out, which undercuts their value as a flex.

**If it failed, the most likely cause would be arriving late into a crowded lane: it launches into a wave of Worst-Class-Ever clones and an already saturated NPC-blend genre, and its new rule is not legible in a thumbnail.**
- Secondary 1: latency-judged freeze calls feel unfair.
- Secondary 2: the Guard role is miserable on phones, causing queue starvation for the 1-of-N role.

**Kill risk: HIGH. Ranking: drop to #5.** It is the most fun on paper, but its risk is a market risk that a prototype cannot resolve.

## 4. Paddle Panic (R2-02 6.52 / C03 6.58; family mean 6.41)

**Competitors.**
- *Boat Together [1–6 Player]* already does row-in-sync co-op on Roblox: 8.2M visits but only about a **2K all-time peak** [Found]. The format exists and hit a low ceiling.
- *Boat Ride Together* peaked at somewhere between 123 and 2K [Found].
- The Fart Together signal is crude humor followed by a takedown, not proof of retention [Research].

**Technical claim is overstated.** "Predicted on each client" does not work for a shared vehicle. No client knows the other five players' inputs in advance, so each one shows either input latency or rubber-banding corrections. The physics-ownership problem is replaced by a feel problem.

**Retention.** Replay scored 5, 5 and 4 across rounds. The panel kept marking this down and three redesigns did not fix it, so the ceiling is structural. Coordination comedy is a one-session joke.

**Playing with strangers.**
- Shared control with strangers invites griefing, and the "Saboteur Seat" mutator formalizes it.
- Bots in empty seats make the solo experience worse.

**Monetization.** The Captain rule means one buyer per raft, so spend per player is low.

**If it failed, the most likely cause would be a novelty burn: a fun first session, no reason to return, and failure on the 28-day signal.**
- Secondary 1: the shared raft feels laggy or rubber-bands on mobile.
- Secondary 2: random teammates grief, and solo players with bots churn.

**Kill risk: HIGH. Ranking: drop to #6.** Its best-ever score came from the unrefined R1 version, a sign that it has hit its ceiling.

## 5. Blaze Brigade: Critter Rescue (R2-12, 6.42; family mean 6.39)

**Competitors.**
- *Firefighting Sim* (Blackbox Express, Sep 2026) reached about **35K peak CCU** in Oct 2026 per one tracker [Found]. It is a dispatch and roleplay game in first person with ranks, so it validates the *theme* without occupying round-based co-op rescue.
- *Firefighters Together* (Steam, Apr 2025, $4.99) is the same core idea: 1–4 players rescuing kittens from fires. It barely registered, with 12–17 reviews [Found]. That is weak evidence; it was a small solo-developer PC game, not a Roblox title.
- No Roblox co-op fire game combined with creature collection surfaced.

**What it really costs to build.** DevSimp is 3 or 4, the worst in the top 5. The concept needs about ten systems:
- grid fire spread and smoke
- hose sweeping
- fire types
- critter AI (hide, flee, wriggle)
- two-player carry
- floor collapse
- dragging downed teammates
- procedural rooms
- companions
- particle budgets for low-end Android

**Mobile.** The thumbstick plus drag-to-sweep plus a contextual button keep both thumbs busy for the whole run. That is workable only with the fixed camera.

**Strengths.** Its retention and monetization fit is the best in the top 5. Companion pets that follow you are proven Roblox spend, and the deterministic, earned rares are policy-safe. These risks are about execution, which scoping can reduce, not about the market.

**Viral weakness.** Viral is 5 or 6. Firefighting looks generic in thumbnails.

**If it failed, the most likely cause would be scope: the team ships late, or ships with the satisfying hose feel undertuned, and the game reads as yet another firefighter simulator.**
- Secondary 1: smoke and particles hurt frame rate on low-end mobile.
- Secondary 2: pet-sim players expect eggs or gacha and find a deterministic critter log too slow [Spec].

**Kill risk: MEDIUM (execution). Ranking: raise to #2.**

---

## 6–10, briefly

- **Toybox Knockout (C15, 6.40).** No Roblox merge auto-battler showed any traction in search; Merge Toy is around 200 CCU [Found]. That is either an open gap or proof of no demand. Viral 4 and Access 5 are real problems, and an 8-player lobby needs bot backfill. Mobile 9 and Replay 8 suit the 28-day algorithm. **Kill risk: medium.**
- **Critter Lineage (C10, 6.22).** The panel's own merge (R2-09) was vetoed for fun, which is two strikes on the *core*. Mewgenics-style depth is a PC habit, and Access is 4. Monet and Replay are 8, but they are scores for a meta layer that is not attached to a fun game. **Kill risk: high.**
- **Fake or Fortune (C04, 6.20).** Its redesign fell to 5.68. Reading tells against a catalogue is hard for children and on phones (Access 4). Probably Stolen's audience is adult cyberpunk PC players. **Kill risk: high.**
- **Ghost Vlog (C08, 6.16).** No Roblox Content Warning clone surfaced [Found], so the lane may be open. But 10 Hz 3D replay recording is costly to build, the redesign collapsed to 4.94, and horror demand is cooling after Halloween. **Kill risk: med-high.**
- **Night Desk (C01, 6.14).** Demand is proven (Sell Fries ~112K, 7 Days Cat-Sitting, the licensed Exit 8), but this is the most crowded lane on the slate. Differentiation scored 4, and the redesign fell to 4.78. **Kill risk: high.**

## Recommended re-ranking

1. **Grounded!** (=). It is the only top-5 concept whose format no Roblox competitor occupies, and it has the highest viral score. Build from R2, not R3, and rename it.
2. **Blaze Brigade** (up 3). Its risks are execution risks, which can be scoped down. The theme is validated by Firefighting Sim's ~35K peak, and companions suit both retention and spend.
3. **Scribble Spells** (down 1). It is novel and mobile-native, but demand is unproven: its only comparable sits under 700 CCU, and its score fell 0.9 when refined.
4. **Toybox Knockout** (up 2). Its retention and mobile scores fit the algorithm, and no competitor was found. It needs a clip-worthy hook.
5. **Statue Shuffle** (down 2). It has the best fun, but it is a latecomer to a clone wave and its core judgment depends on latency.
6. **Paddle Panic** (down 2). Weak replay is structural across three rounds, and the existing format capped at about 2K CCU.
7. **Ghost Vlog** (up 2). It is the open lane among the horror concepts, but it is expensive to build and seasonal.
8. **Critter Lineage** (down 1). Strong meta scores, but the fun veto on its core stands.
9. **Night Desk** (up 1). Real demand, but the most saturated lane.
10. **Fake or Fortune** (down 2). Its accessibility ceiling is structural, and its redesign scored lower.

## Which three to prototype

Prototype the concepts whose biggest risk a 2–3-week grey-box can actually resolve:

1. **Grounded!** (R2 rules, one house, no cosmetics). Test whether the Panic-to-Hunt phase produces laughs with 5–7 strangers. Also test whether the Parent is fun for a 10-year-old on a phone, and whether a house is "solved" after ten rounds.
2. **Blaze Brigade** (one building, about 8 critters). Test hose feel and fire and smoke performance on a low-end Android device. Also test whether rescuing critters creates "one more run" pull before any meta is built. If the core feel does not land within 3 weeks, kill it.
3. **Scribble Spells** (6 runes, 3 fusions). This is the cheapest test. Measure classification accuracy with thumb-drawing on phones and the success rate of fusions at 200 ms ping. Then check with a clip test whether viewers find it compelling.

**Not prototyped: Statue Shuffle.** The likeliest cause of its failure is market timing and clone saturation, which a prototype cannot reveal. Revisit it in about eight weeks, after seeing how many Worst-Class-Ever-style games have launched on Roblox.

### Sources (this session)
- [rotrends: Clean the House](https://www.rotrends.com/game/10584047390/NEW-CH3-Clean-the-House)
- [rowatcher: Clean the House](https://rowatcher.com/games/10584047390/clean-the-house)
- [itch: Before Your Mom Gets Home](https://friesnosauce.itch.io/before-your-mom-gets-home)
- [Steam: No Body No Problem](https://store.steampowered.com/app/4954970)
- [DekuDeals: No Body No Problem](https://www.dekudeals.com/items/no-body-no-problem)
- [DekuDeals: Worst Class Ever](https://www.dekudeals.com/items/worst-class-ever)
- [Bloxodes: Prank the Teacher](https://bloxodes.com/stats/games/prank-the-teacher-6167577993)
- [rowatcher: Boat Together](https://rowatcher.com/games/9408992442/boat-together-1-6-player)
- [rowatcher: Boat Ride Together](https://rowatcher.com/games/8374575589/boat-ride-together)
- [rowatcher: Firefighting Sim](https://rowatcher.com/games/10767634248/firefighting-sim)
- [SteamSpy: Firefighters Together](https://www.steamspy.com/app/3444000)
- [rowatcher: Draw Spells Magic Arena](https://rowatcher.com/games/10767581765/draw-spells-magic-arena)
- [Destructoid: Draw Spells codes](https://www.destructoid.com/draw-spells-magic-arena-codes/)
- [rowatcher: Halloween spike](https://rowatcher.com/news/roblox-halloween-spike-hits-14-9m-ccu-winners-losers)
- [Gizmodo: Roblox clone story](https://gizmodo.com/man-teases-most-infuriating-game-ever-roblox-vultures-immediately-steal-his-idea-2000802874)
- [Bloxodes stats listing (Merge Toy)](https://bloxodes.com/stats/games?page=242)
