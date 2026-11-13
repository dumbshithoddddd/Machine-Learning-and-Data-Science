# Roblox Breakout Game Concept Engine — Results (November 2026)

*Research, ideation, independent multi-agent evaluation, refinement, adversarial review and prototype validation plans.*

## 0. The honest headline

**None of the concepts met the qualifying bar.** We generated 44 concepts, shortlisted 20, and refined the leaders through three independently scored rounds (37 evaluations). The bar was a weighted average of at least 8.0, with Accessibility, Mobile, Monetization, Replayability and Fun each at least 8 and everything else at least 7. The best weighted average any concept reached was **7.04**. The standard was not lowered.

What this report delivers instead:
- **The 10 strongest concepts**, ranked after an adversarial review, each with the full 20-field breakdown and its real scores.
- **Three prototypes** whose biggest risks a 2–3-week greybox can actually test (Section 8). That is where real evidence will come from.

**Why we stopped after 3 rounds rather than 5:**
1. **Round 3 made every finalist worse.** Average 6.23, against 6.72 for the same five in round 2. The panel's criteria pull against each other:
   - Adding depth to raise Replay and Monetization lowered Accessibility and DevSimplicity.
   - Adding assists to raise Accessibility lowered Fun.
2. **The scoring noise was as large as the remaining gap.** A fresh panel scoring the same concept moved individual criteria by about ±1 and averages by up to ±0.9. A paper concept that crossed 8.0 in round 4 or 5 would have done so inside that noise, which is not credible evidence.

The scores are model judgements, not market data. Rounds 4–5 can still be run on request.

| | |
|---|---|
| **Best overall** | **Party's Over!** (working title; formerly *Mom's Home!* / *Grounded!*) — throw a house party, hide the evidence, and survive a Parent played by another player |
| **Prototype these three** | Party's Over! · Blaze Brigade: Critter Rescue · Scribble Spells |
| **Qualifying concepts** | **0 of 10** (shortfall: 10) |

---

## Method in one paragraph

**Phase 1 (research).** The 38-page November 2026 market report was combined with three parallel research agents covering Roblox signals, Steam indie games and cross-platform mechanics. Their notes are in `appendix/research/`.

**Phase 2 (ideation).** We wrote 44 concepts and pre-screened them to 20 (`appendix/concepts/00_longlist_44.md`).

**Phases 3–5 (evaluation and refinement).** Ten independent specialist agents scored every concept in each round. A **fresh** panel ran each round and was told not to read earlier scores. Each agent scored one criterion with a justification, a confidence level and a fix. Agent 8 held veto power over boring concepts; Agents 9 (Steam adaptation) and 10 (commercial) were advisory and not in the weighted formula. Weighted averages and gates were computed by `appendix/evaluations/score.py`.

| Round | Concepts | Result |
|---|---|---|
| 1 | 20 | 0 passed; 2 vetoed |
| 2 | 12 (10 redesigns, 1 merge, 1 new) | 0 passed; 1 vetoed |
| 3 | 5 deep redesigns | 0 passed |

**Phase 6 (adversarial review).** A separate agent with web search tried to disprove the leaders (`appendix/evaluations/adversarial_review.md`).

All raw scores are in `appendix/evaluations/raw_eval*/`.

## 1. Research summary (Phase 1)

**Sources used:** the November 2026 market report supplied with the brief (38 pp), plus three independent research agents covering Roblox signals, Steam indie games and cross-platform mechanics. Their full notes are in `appendix/research/`, with every claim cited and labelled. **Caveats:** the agents could only use web-search summaries. GGRecon, Studiokrew, PC Gamer, GamesRadar, SEC filings and Reddit pages were blocked or unreachable. Tracker sites (RoWatcher, Rotrends, Bloxodes) often disagree with each other by 2–5x. Figures below are what those sources report, not numbers we checked ourselves.

Labels: **[V]** = Roblox primary source or established press. **[T]** = third-party tracker. **[S]** = our speculation or inference.

### 10 emerging trends
1. **Friend-sized co-op horror and survival** (99 Nights, Dandy's World, Forsaken, DONT SPLASH) is the most durable "new" genre [T]. Caveat: 99 Nights is now well past its peak, and October data is inflated by Halloween [T].
2. **Anomaly horror built into a job sim** (Sell Fries! ~112K peak, 7 Days Cat-Sitting +825% in a week, licensed *Exit 8* with 8-player co-op) [T]. This is also the most crowded and fastest-cloned lane.
3. **Role-split co-op**, where communication is the game: *Backseat Rally*, 28–55K peak, 92% likes [T].
4. **Vehicles, sports and physics driving** are growing from a low base (Turbo Soccer ~38K peak) [T].
5. **The steal mechanic survives inside new themes** even as brainrot clones fade: Steal an Egg was #1 at ~713K on Oct 29, and Grow a Garden 2 added stealing at night [T]. This corrects the supplied report.
6. **Discovery that rewards retention.** The 28-day signal was officially announced in June 2026 [V], and Roblox deliberately cut impressions for spend-heavy games aimed at under-13s [V].
7. **An older audience.** 18+ is 29% of age-checked DAU globally and 37% in the US [V], and spend by verified US adults in R15 games earns a 42% higher DevEx rate [V].
8. **Cheap PC co-op games ("friendslop") dominate Steam.** Cheap co-op games with friends took 4 of Steam's 10 best-selling premium slots in 2025 [V]. The 2026 breakouts include How to Fish (~374K peak), Meccha Chameleon (~340K) and BOMBANANA! (675K+ demo players) [V/T].
9. **Gating for under-16s.** Reaching Kids/Select costs 1,000 Robux or a Plus subscription held for 2+ months, plus 500 engaged plays from age-checked users within 60 days [V]. Chat requires an age check, so designs must work with pings and emotes alone.
10. **AI clone floods.** In one week, 1.37M games were published [T], and Roblox games now get cloned within days [V]. Production cost is no longer a competitive moat.

### 10 interesting mechanics (design principles, not clones)
1. **Information split across roles, shared only through gestures and stamps** (BOMBANANA!, Keep Talking).
2. **One shared vehicle, one thruster per player** (Fart Together, RV There Yet?).
3. **Hide among NPCs while filling a shared team meter, on a phase rhythm** (Worst Class Ever, #1 at Oct 2026 Next Fest).
4. **Physics evidence plus bluffing:** hide it, then act innocent (No Body No Problem!, top 5 at Oct Next Fest).
5. **Spot the fake through inspection:** appraise items and catch counterfeits (Probably Stolen, 660K+ demo players; Papers, Please).
6. **Performative input:** casting by voice in YAPYAP, adapted to drawn runes on touchscreens.
7. **Trait inheritance between runs** (Mewgenics, 115K peak).
8. **The payout is a physics object you can show off with** before banking it (How to Fish trick-shot multiplier).
9. **A value meter on fragile physics loot** (R.E.P.O.).
10. **Score by spectacle:** your footage is your score (Content Warning).

### 10 potential market gaps (state after competitor checks)
1. **A player-run Parent "hunts the party mess" game in 1vN format.** Only a PvE chore game exists (Clean the House!, ~5–8K peak) [T].
2. **Co-op spell fusion drawn on the touchscreen.** Only a small PvP game exists (Draw Spells Magic Arena, ~615 CCU) [T].
3. **Red-light-green-light tagging by flashlight beam in a museum.** No match found, but Worst Class Ever clones are likely to arrive soon [S].
4. **Co-op fire rescue combined with creature collection.** Each half has competitors (firefighting sims; Rescue Animals! ~20K peak), but none combines them [T].
5. **An Overcooked-style station co-op game.** Thin on Roblox [T].
6. **Counterfeit appraisal and a forger-deduction game.** Nearly empty: Fake a Masterpiece peaked at about 1 player [T].
7. **Auto-battlers that use a shared pool.** Thin (Units Battlegrounds, Merge a Mini Army) [T].
8. **A Content Warning-style "film it" horror game.** Several small attempts, none dominant [T].
9. **2D, turn-based and async social games** ahead of Roblox's own tooling [V for the tooling; S for the opportunity].
10. **Territory strategy.** Less open than the supplied report implied: Borders RTS, RoFront and PixelFront already exist [T].

Gaps that turned out **not** to be open: Keep Talking-style defusal (Monobombo, ~10K peak), airplane-crisis co-op (Land or Die!), chained climbing (Chained [2 Player Obby], ~431M visits), boat co-op (Boat Together, 8.2M visits), volleyball (Volleyball Legends), fragile carrying (Carry the Glass Together!, ~13K peak).

### 10 games worth studying
| Game | Platform | Why it matters |
|---|---|---|
| BOMBANANA! | Steam | Info split across 3 roles; 675K+ demo players; already cloned on Roblox as Monobombo |
| Worst Class Ever | Steam | Hide among NPCs plus a shared mischief meter; #1 at Oct 2026 Next Fest |
| No Body No Problem! | Steam | Physics evidence plus bluffing, in a 3v1 |
| Probably Stolen | Steam | Inspection and authenticity risk; ~40K peak during its demo |
| How to Fish | Steam | Physics payout as a skill moment; ~374K peak |
| Mewgenics | Steam | Inheritance as meta-progression; 115K peak |
| Backseat Rally | Roblox | Role-split co-op works without chat |
| Sell Fries! | Roblox | Anomaly job sim released in chapters |
| Fart Together (Roblox copy) | Roblox | 13M+ visits for a shared-thruster vehicle, then taken down; proves the hook and the content risk |
| Squad Busters | Mobile | 75M installs but failed: easy, short matches are not enough without depth |

### 5 promising genre combinations
1. **Party chaos + panic hiding + 1vN hunt** (→ Grounded!)
2. **Gesture input + co-op roguelite + spell fusion** (→ Scribble Spells)
3. **Red Light Green Light + hiding among NPCs + shared mischief meter** (→ Statue Shuffle)
4. **Overcooked chaos + creature collection** (→ Blaze Brigade)
5. **Merge auto-battler + Fall Guys elimination** (→ Toybox Knockout)

## 2. Phases 2–6 in brief

**Score trajectory** (weighted average; full tables in `appendix/evaluations/score_history.md`):

| Family | R1 | R2 | R3 | Mean | Best version |
|---|---|---|---|---|---|
| Party's Over! (Mom's Home → Grounded!) | 6.98 | **7.04** | 6.30 | 6.77 | R2-01 |
| Scribble Spells | 6.20 | **7.02** | 6.10 | 6.44 | R2-04 |
| Statue Shuffle | 6.54 | **6.60** | 6.20 | 6.45 | R2-03 |
| Paddle Panic (Raft Rush) | **6.58** | 6.52 | 6.14 | 6.41 | R2-02 (R1 nominally higher) |
| Blaze Brigade (new in R2) | – | **6.42** | 6.36 | 6.39 | R2-12 |
| Toybox Knockout | **6.40** | merged → Critter Clash 5.80 (**vetoed**) | – | 6.40 | C15 |
| Critter Lineage | **6.22** | merged → Critter Clash (**vetoed**) | – | 6.22 | C10 |
| Fake or Fortune → Forger Night | **6.20** | 5.68 | – | 5.94 | C04 |
| Ghost Vlog | **6.16** | 4.94 | – | 5.55 | C08 |
| Night Desk | **6.14** | 4.78 | – | 5.46 | C01 |
| *Cut along the way (best score):* Lost Signal 5.90 · Wobble Tower 5.86 · Mayday Crew 5.86 (Land or Die! already exists) · Fragile Express / Handle With Care 5.80 · Fuse Friends 5.76 (Monobombo, a near-copy of BOMBANANA!, already exists) · Tap Volley 5.58 (Volleyball Legends) · Tied Together: Summit 5.46 (Chained, ~431M visits) · The Haystack 5.08 (**veto**) · Pet Sitters 4.98 · Frontline Fifty 4.94 (Borders RTS etc.) · Kaiju Keepers 4.46 (**veto**) | | | | | |

**What the panel consistently rewarded:**
- a premise a child gets in one second
- one or two touch verbs
- a human opponent or partner who makes every round different
- purchases other players see
- earned collections

**What it consistently punished:**
- several clients steering one physics body
- fun that depends on voice
- memorisable content (anomaly checklists, forgery tells, puzzle manuals)
- auto-battles that players mostly watch
- crowded lanes that AI clones can fill in days

**Adversarial review (Phase 6) changed the order:**
- **Ranks 2–6 are a statistical tie** (family means within 0.06), so they were re-ordered by **risk type**: execution risk, which can be scoped down, ranks above market risk, which cannot be fixed.
- **Blaze Brigade rose to #2.**
- **Statue Shuffle fell to #5:** Worst Class Ever only reached Steam on Nov 9, so Roblox clones will probably land before we do.
- **Paddle Panic fell to #6:** replay scored 5, 5 and 4, and the existing Boat Together peaked at about 2K.
- **"Grounded!" must be renamed** because it clashes with the Obsidian/Xbox franchise.
- **Market signals are weaker than they looked:**
  - No Body No Problem! is not yet released.
  - Halloween inflated the horror data.
  - The +42% adult DevEx barely applies to themes this young.

---

## 3. The 10 concepts (ranked by overall potential)

Score key: **Acc**essibility, **Mob**ile, **Mon**etization, **Rep**layability, **Vir**al, **Dev** simplicity, **Dif**ferentiation, **Fun** (weighted), plus advisory **Stm** (Steam adaptation) and **Com** (commercial). Gates: average ≥8.0; Acc/Mob/Mon/Rep/Fun ≥8; others ≥7. Each card shows the best-scoring evaluated version. Lines marked *(unscored)* are changes recommended after the final panel.

---

### #1 — Party's Over! *(working title; formerly Mom's Home! / Grounded!)*
1. **Pitch:** Throw the wildest house party ever, then hide the evidence before Mom gets home and goes hunting.
2. **Genre:** Asymmetric 1vN physics-comedy party game (3–6 kids vs 1 Parent; 5–7-player servers).
3. **Inspiration and research:**
   - *Steam:* No Body No Problem! (hide physics evidence, then act innocent; top 5 on gg.deals' Oct 2026 Next Fest list; **unreleased**, listed for Nov 26). Worst Class Ever (#1 Oct Next Fest by unique players).
   - *Roblox 1vN:* Granny, Flee the Facility.
   - *Competition:* no Roblox game where a **player** Parent hunts the mess was found. The nearest is *Clean the House!*, a PvE chore game with a ~5–8K peak.
4. **Core loop:** PARTY (2:00, smash for Fun Points) → PANIC (0:45, hide ~25–40 tagged evidence objects in glowing "Hide here" spots) → HUNT (1:30; the Parent uses Sniff, Blacklight and FREEZE!; kids re-hide behind the Parent's back or snitch) → REPORT CARD (funniest moments) → roles rotate.
5. **First 30 seconds:**
   - You spawn mid-party: music, confetti, a glowing tower of cups labelled "SMASH!".
   - One button knocks it over and **+Fun** pops. You bounce on the sofa and kick a ball into a lamp.
   - No text needed.
6. **First 10 minutes:**
   - **Round 1:** the car-horn PANIC, your first frantic hide (TV in the oven), the Parent's FREEZE! catching your friend mid-sneak, and the Report Card naming the funniest hiding spot.
   - **Round 2:** you try a "risky" spot for bonus points and get tempted to snitch.
   - **Rounds 1–2:** you earn your first Party Trick sidegrade.
   - **Round 3 or 4:** you're queued as Parent (guaranteed rotation).
7. **Long-term progression:** Kid and Parent mastery tracks, earned Party Trick and Gadget loadouts, a Feats log (not a checklist), a new house monthly, a weekly House Rule mutator, and a seasonal ranked Parent ladder.
8. **Multiplayer interactions:** Kids cover for each other, re-hide behind the Parent's back, use decoys, and betray each other through snitching. The Parent reads human behaviour, not a list.
9. **Replayability:** Each round opens a random subset of hiding spots and shuffles mess objects. Human opponents, role rotation, mutators and new houses add more variety.
10. **Mobile controls:** Thumbstick plus **one** contextual button above jump (pick up, hide, re-hide). The Parent has 3 gadget buttons stacked on the right edge. Every interaction is tap-on-highlight; nothing needs aiming. Fixed over-shoulder camera with wall fade; *(unscored)* an elevated camera during PANIC.
11. **Monetization (no gameplay power):**
    - Parent costumes and car skins (the most-watched character every round).
    - Kid outfits, Report-Card poses and emotes.
    - "Chaos finishers" (your smash effect when you cause the round's biggest mess).
    - Host House theme rule, monthly house cosmetic bundles, cosmetic season pass.
    - Rewarded video for a Fun multiplier (once per session).
    - Expect little adult-DevEx uplift.
12. **Viral moments:** The Parent's FREEZE catching a kid with a vase. The dog pushed over the paint stain. Snitch betrayals. The "Most Ridiculous Hiding Spot" card. The thumbnail (trashed house, Mom in the doorway) needs no explanation.
13. **Development complexity:** **Medium-high** (Dev 5/5/3). The hardest parts:
    - FREEZE and catch-while-carrying calls that feel fair under mobile lag. Judge them on server position history with generous grace.
    - Each house is a level-design project: ~60 hotspots and ~25–40 four-state evidence objects.
    - Adding systems (round 3's driving mini-game and bedrooms) made it markedly harder (Dev 3).
14. **Main competitive advantage:** The only top concept with a format no Roblox competitor occupies. It also has the highest viral scores (9/9/8) and a premise every child understands.
15. **Biggest weakness:**
    - **Content-bound retention:** once players know a house, the hunt becomes a lookup, and new houses are expensive.
    - 1vN needs dense servers.
    - Snitching and Report Cards need care to avoid bullying dynamics with young players.
16. **Scores (R2-01):** Acc 7 · Mob 7 · Mon 7 · Rep 7 · Vir 9 · Dev 5 · Dif 7 · Fun 7 · *(Stm 7 · Com 7)*
17. **Weighted average:** **7.04**. **Fails:** average; Acc, Mob, Mon, Rep and Fun below 8; Dev below 7. History: 6.98 → 7.04 → 6.30.
18. **Agent disagreements:**
    - Viral 9 versus Dev 5: the spectacle that makes it clip-worthy is what makes it expensive.
    - Fun fell 8 → 7 → 6 across panels as the Parent's idle time during PARTY and auto-picked hiding were flagged.
    - Mobile rose 5 → 7 once free physics hiding became tap-to-hide hotspots.
    - Round 3's Parent driving mini-game fixed idle time but was judged unclippable scope creep.
19. **Confidence:** **Medium.** It is the most stable family (mean 6.77), and the adversarial reviewer found no direct competitor.
20. **Recommended changes *(unscored)*:**
    - Clear a new name before any public test.
    - Build the R2 rules.
    - Give the Parent a lightweight PARTY-phase role (e.g., "upstairs peeks" that force kids to freeze) instead of round 3's driving game.

---

### #2 — Blaze Brigade: Critter Rescue
1. **Pitch:** Fight fires with your squad and rescue the animals trapped inside. Every critter you save becomes yours.
2. **Genre:** Co-op action rescue plus creature collection (1–4 players, 5-minute runs).
3. **Inspiration and research:**
   - *Sources:* Overcooked (cooperative chaos), *Flash Point: Fire Rescue* (board game), PowerWash Simulator (satisfying clearing), Pet Simulator (companion appeal).
   - *Theme demand on Roblox:* *Firefighting Sim* (~35K peak, Oct 2026; roleplay/dispatch, not round-based co-op) and *Rescue Animals!* (~20K peak, now ~3K).
   - *Caution:* *Firefighters Together* (Steam, 2025) had the same core and barely registered.
   - *Competition:* no Roblox game combining co-op fire rescue with collection was found.
4. **Core loop:** Arrive at a procedurally assembled burning building → knock down fire (spray; the water tank needs hydrant refills) → find hiding critters and carry them out before floors collapse → they join your Critter Log and follow you as companions → rank up and take harder alarm tiers.
5. **First 30 seconds:**
   - The truck pulls up to a smoking house and a puppy barks behind a window, marked by a pulsing icon.
   - Hold SPRAY: flames hiss out at the door.
   - Walk in and tap RESCUE on the puppy under the bed; carry it out to cheers: "RESCUED! Biscuit joins your Brigade."
6. **First 10 minutes:**
   - Two runs. The first is a 1-alarm house where you learn the water tank and refill at the hydrant.
   - Your first grease fire flares up because you used water; you switch to foam.
   - On the second run a floor collapses seconds after your teammate drags a cat out.
   - Back at the station, Biscuit follows you around, and you see other players' companions in hats.
7. **Long-term progression:** Alarm tiers 1–5, brigade rank, Critter Log (40 at launch, plus about 10 per season), rare critters earned by performance (e.g., no casualties at alarm 3+), truck sidegrades, seasonal building types (pet shop, zoo, school).
8. **Multiplayer interactions:** Natural roles (sprayer, searcher, carrier), two-player carries (panicked elephant calf), dragging smoke-downed teammates out, and the Captain-rule truck.
9. **Replayability:** Procedural rooms, grid fire spread that differs each run, critters that hide and flee, fire types, weekly "Big Blaze" mutator, and the collection chase.
10. **Mobile controls:** Thumbstick plus HOLD SPRAY (auto-aim in R2; drag-to-sweep in R3, which raised Fun but crowds the thumb) plus one RESCUE/USE button above jump. Fixed elevated wall-fade camera. Fire and smoke drawn as tile decals with capped particles for low-end devices.
11. **Monetization:**
    - Companion accessories (visible everywhere).
    - Hose water effects (rainbow, glitter) and uniforms.
    - Truck liveries (Captain rule).
    - Extra companion slots (also earnable).
    - Season pass and rewarded video.
    - **No paid critters, no eggs.**
12. **Viral moments:** A last-second save as the floor caves in, the two-person elephant-calf carry, an escaped goat eating the hose, and rainbow-hose water fights at the station. Viral is its weakest dimension (6/5): firefighting looks generic in thumbnails.
13. **Development complexity:** **High** (Dev 3/4). It needs about 10 systems: fire grid and smoke, hose, fire types, critter AI, carries, collapse, downed-teammate drag, procedural rooms, companions, and particle budgets.
    - **Launch scope (R3):** one building type, 20–40 critters on 2 shared rigs, and companion-follow instead of a sanctuary housing system.
14. **Main competitive advantage:**
    - An evergreen, wholesome theme that is Kids/Select-safe and fits the 9–15 audience Roblox is protecting.
    - The proven pet-companion spend pattern without gacha.
    - Its main risk is **execution**, which a team can control.
15. **Biggest weakness:** Scope, and a generic-looking pitch. If the hose doesn't feel great, it reads as "yet another firefighter sim."
16. **Scores (R2-12):** Acc 8 · Mob 7 · Mon 7 · Rep 7 · Vir 6 · Dev 3 · Dif 7 · Fun 6 · *(Stm 6 · Com 7)*
17. **Weighted average:** **6.42**. **Fails:** average; Mob, Mon, Rep and Fun below 8; Vir and Dev below 7. History: 6.42 → 6.36.
18. **Agent disagreements:**
    - Accessibility 8 and Commercial 7 versus Dev 3.
    - Fun went 6 → 7 when auto-aim became manual sweep, but Mobile and Access dropped.
    - The adversarial reviewer ranked it #2 against the panel's #5, on the grounds that its risks are execution, not market.
19. **Confidence:** **Medium-low** (only 2 panels; high scope uncertainty).

---

### #3 — Scribble Spells
1. **Pitch:** Draw a rune with your finger to cast a spell, and when two friends draw at the same time, the spells fuse into something huge.
2. **Genre:** Co-op roguelite wave defence with gesture input (1–4 players).
3. **Inspiration and research:**
   - *Sources:* YAPYAP (Steam, voice-cast spells; 1M sold in 6 weeks per GameDiscoverCo), Magicka (spell combining), Fruit Ninja (gesture feel).
   - *Roblox competition:* *Draw Spells Magic Arena* (PvP) peaks at only ~615–639 CCU. That is a **demand warning** as much as an open lane.
4. **Core loop:** Draw runes to defend the tower → time casts with a teammate to fuse (Fire + Whirlwind = Firenado) → draft 1 of 3 relics between waves → boss every 4th wave → the run ends → new fusions fill the Rune Book.
5. **First 30 seconds:**
   - You stand on a tower balcony and a faint circle glows: "Trace me." You trace it and a shield bubble pops.
   - A goblin charges; a zigzag guide appears; zap.
   - By second 25 your friend's fire meets your whirlwind: **"FIRENADO!"** fills the screen.
6. **First 10 minutes:**
   - One 6–8-minute run: escalating waves, a hilarious misfire (sloppy lightning becomes a rubber chicken), and two fusions discovered.
   - The first boss, then a relic draft that makes your lightning chain.
   - The Rune Book shows 2/30, and a new rune unlocks.
7. **Long-term progression:** Rune Book of 30 fusions, rune unlocks, wizard schools (earned sidegrade starting relics), endless leaderboard, weekly ranked Trial seed, seasonal new runes.
8. **Multiplayer interactions:** Fusion timing is wordless teamwork. Misfires and friendly-fire comedy (R3: a Firenado launches a teammate onto the tower trampoline). Shared tower HP.
9. **Replayability:** Relic drafts, weekly mutators, seeded trials, fusion discovery, and seasonal rune growth.
10. **Mobile controls:** No movement and no camera. The whole screen is the drawing pad and spells auto-target lanes. It is touch-native (Mob 9/8). PC uses mouse drag; console needs a radial fallback.
11. **Monetization:** Ink-trail cosmetics (on every cast, and colours mix inside fusions), fusion VFX skins, robes and staffs, tower themes, cosmetic season pass. *(R3: a familiars collection of shoulder creatures.)* Monetization is weak (6) because traces vanish fast and there is no lasting status item.
12. **Viral moments:** Misfire chickens, screen-filling fusions, and a teammate yeeted off the balcony. Viral is modest (6/5): a fixed-camera defence view lacks human slapstick.
13. **Development complexity:** **Medium-low** (Dev 7/7). It is the simplest of the top three. A $1-style recognizer for 6 bold glyphs is about 200 lines and runs server-side; enemies render client-side from lane data.
14. **Main competitive advantage:** Genuinely touch-native input that is *worse* on PC, and no co-op fusion game exists on Roblox. Its main risk can be tested cheaply.
15. **Biggest weakness:**
    - **Unproven demand.** The only comparable sits under 700 CCU.
    - Thumb-drawing accuracy in landscape, and fusion timing under 150–300 ms mobile latency, could make fusions feel random.
16. **Scores (R2-04):** Acc 8 · Mob 9 · Mon 6 · Rep 7 · Vir 6 · Dev 7 · Dif 6 · Fun 7 · *(Stm 6 · Com 5)*
17. **Weighted average:** **7.02**. **Fails:** average; Mon, Rep and Fun below 8; Vir and Dif below 7. History: 6.20 → 7.02 → 6.10.
18. **Agent disagreements:**
    - Mobile 9 versus Commercial 5.
    - Accessibility swung 6 → 8 → 5 as fusion windows and relics added complexity.
    - The Steam agent rose to 8 in R3 ("cleanest adaptation") while Fun and Viral fell.
    - It has the largest score swing in the slate (±0.9).
19. **Confidence:** **Low-medium.**

---

### #4 — Toybox Knockout
1. **Pitch:** Eight players draft toy armies from a shared conveyor, merge three to power up, and the bottom two are knocked out every round.
2. **Genre:** Auto-battler party game (8-minute matches).
3. **Inspiration and research:**
   - *Sources:* Clash Royale's Merge Tactics (coincided with record $82.7M monthly spend, Jul 2025), TFT, Fall Guys.
   - *Roblox comparables:* Units Battlegrounds, Merge a Mini Army, Merge Toy (~200 CCU). The genre is thin, which could mean either opportunity or no demand.
4. **Core loop:** 30-second draft from a shared conveyor → place on a 4×4 board → auto-fight against another player's board → the bottom two are eliminated → last toybox standing wins.
5. **First 30 seconds:** Chunky toy cards roll past. Drag three wind-up soldiers onto the board and they **POP** into a bigger one (the merge-3 "aha"). Your first fight auto-plays against a ghost board.
6. **First 10 minutes:** One full match plus the start of a second. You learn that placement matters and probably get knocked out mid-match. *(Unscored fix: knocked-out players become "gremlins" who drop hazards on the remaining boards.)* You earn your first toy unlock.
7. **Long-term progression:** An earned toy collection that adds toys to the shared pool, ranked seasons, and seasonal sets with new synergies.
8. **Multiplayer interactions:** Contest the shared conveyor (deny pieces others need) and elimination drama. Social interaction is otherwise thin.
9. **Replayability:** Every draft differs, skill compounds, and seasons rotate the meta. It has the strongest replay structure on the slate (Rep 8).
10. **Mobile controls:** Drag and drop only, with no thumbstick or camera. It is the most phone-native concept (Mob 9).
11. **Monetization:** Board skins, toy cosmetics, a battle pass, an avatar commander and knockout finishers (Mon 7).
12. **Viral moments:** Weakest on the slate (4): watching menus and auto-fights. *(Unscored fix: toys smashed and launched off the table on knockout.)*
13. **Development complexity:** **Medium** (Dev 6). The auto-battle sim is simple server code. The hard parts are filling 8-player lobbies at low CCU (needs bots) and ongoing balance work.
14. **Main competitive advantage:** A retention structure that suits the 28-day algorithm, plus perfect phone fit, in a genre Roblox hasn't filled.
15. **Biggest weakness:**
    - Low accessibility (5) and viral (4).
    - When the panel merged it with Critter Lineage (R2-09), the result was **vetoed for fun (3)**: "placing and watching".
16. **Scores (C15):** Acc 5 · Mob 9 · Mon 7 · Rep 8 · Vir 4 · Dev 6 · Dif 6 · Fun 6 · *(Stm 6 · Com 5)*
17. **Weighted average:** **6.40**. **Fails:** average; Acc, Mon and Fun below 8; Vir, Dev and Dif below 7. Scored in one panel only.
18. **Agent disagreements:** Mobile 9 and Replay 8 versus Viral 4 and Access 5. The adversarial reviewer raised it to #4 for algorithm fit; the fun agent's "watching" critique (made in R2 about the merged version) still stands.
19. **Confidence:** **Low** (single panel; its merged variant was vetoed).

---

### #5 — Statue Shuffle
1. **Pitch:** At night the museum statues come alive. Pull pranks behind the guard's back, and freeze the instant the flashlight hits you.
2. **Genre:** Asymmetric Red-Light-Green-Light plus hide-in-plain-sight (4–7 statues vs 1 Guard).
3. **Inspiration and research:**
   - *Sources:* Worst Class Ever (#1 Oct 2026 Next Fest; **went on sale Nov 9**), Red Light Green Light, Be NPC or Die.
   - *Roblox competition:* *Prank the Teacher* (82M visits), DISGUISE, In Plain Sight. No flashlight-beam-only tagging game was found.
4. **Core loop:** Sneak and prank to fill a shared Mischief meter → release the stick to freeze → the Guard can tag **only** inside a battery-limited beam, and wrong tags cost battery → 4-minute rounds → "Caught on Camera" reel.
5. **First 30 seconds:** You're a knight statue. "MOVE when the light's away." You creep to a glowing portrait and tap Prank: a moustache appears. The beam swings toward you, you let go of the stick, freeze mid-tiptoe, and the light slides past.
6. **First 10 minutes:** Two or three rounds. You get tagged once, laugh at the reel of pranks the Guard missed, and probably play Guard once. You unlock your first statue ability (Dust Cloud).
7. **Long-term progression:** A statue roster (mummy, astronaut, T-rex skeleton), statue abilities and Guard gadgets (earned), a ranked Guard ladder, weekly Exhibit events and new wings monthly.
8. **Multiplayer interactions:** A shared objective, distractions (the cuckoo clock) that cover teammates, and 1vN tension. *(R3: tagged "cracked statues" can still distract.)*
9. **Replayability:** Wing shuffles, rotating NPC behaviour sets, a human Guard, and randomised live pranks.
10. **Mobile controls:** Release-stick-to-freeze is a great touch verb. The Guard's look-drag plus TAG on a dark, 6-inch screen is the hardest scheme on the slate (mitigation: soft lock-on reticle).
11. **Monetization:** The weakest of the top five (5). Skins act as disguise packs (they spawn matching NPC statues), so they give no flex until the end-of-round unmasking. Guard beam colours and tag effects, plus prank-effect cosmetics, are the visible items.
12. **Viral moments:** Strong (8/8/7). A moustached T-rex. A statue frozen in a ridiculous pose with the beam on its face. A Guard tagging a real NPC.
13. **Development complexity:** **Medium** (Dev 6–7). The hardest part is making "did you move while lit" feel fair under lag: judge from server position history with ping-scaled grace.
14. **Main competitive advantage:** The beam-only tag rule is new on Roblox. It has the **highest Fun score of any version (8, R2)** and the strongest zero-progression fun.
15. **Biggest weakness:** **Market timing.** A Worst-Class-Ever clone wave will likely land in an already crowded hide-in-plain-sight lane before we ship. A prototype can't test this, which is why it is not a finalist.
16. **Scores (R2-03):** Acc 6 · Mob 7 · Mon 5 · Rep 6 · Vir 8 · Dev 6 · Dif 6 · Fun 8 · *(Stm 7 · Com 6)*
17. **Weighted average:** **6.60**. **Fails:** average; Acc, Mob, Mon and Rep below 8; Dev and Dif below 7. History: 6.54 → 6.60 → 6.20.
18. **Agent disagreements:** Fun 8 and Viral 8 versus Mon 5. Accessibility swung 8 → 6 → 7 as rules (pose placards) were added and removed. The adversarial reviewer dropped it from #3 to #5 on market risk.
19. **Confidence:** **Medium** that it is fun; **low** on market. Re-check in about 8 weeks how many WCE-style games have launched on Roblox.

---

### #6 — Paddle Panic
1. **Pitch:** Up to six friends, one ridiculous raft, and each player controls one paddle. Steer together or spin into the waterfall.
2. **Genre:** Co-op and versus party racing.
3. **Inspiration and research:**
   - *Sources:* Fart Together (Steam Oct Next Fest top 20; a crude Roblox copy hit 13M+ visits and ~14K CCU, then was taken down), RV There Yet? (~100K CCU).
   - *Roblox competition:* *Boat Together [1–6]* (8.2M visits but only ~2K all-time peak).
4. **Core loop:** Hold to paddle → use your seat's contextual verb (bail, bonk a croc, grab a coin, brace) → clear checkpoints → medals → unlock absurd vehicles with different seat layouts.
5. **First 30 seconds:** Hop into a bathtub raft. One giant HOLD button. You press and the tub spins left; someone else presses and it straightens. Everyone is laughing before the first rapid.
6. **First 10 minutes:** Two or three runs. The first waterfall wipeout and the "WHO SANK US?" blame card. A bronze medal, then a try at Raft Race versus.
7. **Long-term progression:** A vehicle collection (a new vehicle every 2–3 weeks), segment medals, a daily-seed crew leaderboard, ranked seasons, and a Boathouse (R3).
8. **Multiplayer interactions:** Coordination *is* the game. Lookout pings (R3), versus bumping and bailing water into rivals.
9. **Replayability:** **The structural weakness** (5/5/4). Coordination comedy is a one-session joke for many groups, and courses get memorised.
10. **Mobile controls:** One HOLD button plus one verb button, no thumbstick, auto camera (Mob 8/8/9). It has the simplest controls on the slate.
11. **Monetization:** Captain rule (the host's raft and skin for the whole crew, giftable, with "chip in"), per-seat cosmetics, vehicle bundles, season pass (Mon 6–7).
12. **Viral moments:** Six players spinning a bathtub off a waterfall, and the blame card.
13. **Development complexity:** **Medium** (Dev 6–7). The raft is a server-run kinematic spline controller. The risk is how it feels: client prediction can't work for a shared vehicle, so expect some input latency.
14. **Main competitive advantage:** Instantly readable, kid-safe chaos. The Fart Together copy proved the hook, and its takedown leaves the clean lane open.
15. **Biggest weakness:** Novelty burn. The closest existing format capped at about 2K CCU.
16. **Scores (R2-02):** Acc 7 · Mob 8 · Mon 6 · Rep 5 · Vir 7 · Dev 6 · Dif 6 · Fun 7 · *(Stm 7 · Com 6)*
17. **Weighted average:** **6.52**. **Fails:** average; Acc, Mon, Rep and Fun below 8; Dev and Dif below 7. History: 6.58 → 6.52 → 6.14.
18. **Agent disagreements:** Mobile 9 versus Replay 4. Fun went 6 → 7 → 5 as seat roles were added, then judged over-assisted.
19. **Confidence:** **Medium** that the first session is fun; **low** on retention.

---

### #7 — Ghost Vlog
1. **Pitch:** Grab a camera and go ghost hunting with your crew. The scarier your footage, the more views you get.
2. **Genre:** Co-op horror-comedy expedition (2–4 players).
3. **Inspiration and research:** Content Warning (6M+ free claims). No dominant Roblox Content Warning-style game was found; small camera-horror games exist.
4. **Core loop:** A 6-minute expedition into a procedurally arranged haunted location → film ghost events → return to the van → the lobby theatre plays a highlight montage scored in "views" → buy gear and grow your channel.
5. **First 30 seconds:** The van doors open on a dark school. You hold the camera and tap REC. A locker bangs and a ghost peeks out, and "SPOOKY SHOT +500" pops on screen (R2 fix).
6. **First 10 minutes:** One expedition. Your friend gets dragged off mid-shot, and the theatre replay of it is the best moment. Then your first gear purchase.
7. **Long-term progression:** Subscriber count, studio upgrades, ghost catalogue and daily sponsor contracts.
8. **Multiplayer interactions:** Bait and cameraman roles, rescuing grabbed friends, and the shared theatre payoff.
9. **Replayability:** Weak (6 → 4): once you know the ghosts, it repeats.
10. **Mobile controls:** Thumbstick, Record and Interact. Framing ghosts while moving needs auto-framing, and dark scenes are hard to read on phones (Mob 7 → 5).
11. **Monetization:** Channel branding (intro stingers and logos seen by the whole lobby), studio decor, outfits (Mon 6).
12. **Viral moments:** Strong (8). The footage *is* the score.
13. **Development complexity:** **Medium-high** (Dev 5 → 4). A real 3D replay system is costly, and recording ragdolls is hard.
14. **Main competitive advantage:** A built-in sharing loop in a lane with no dominant Roblox incumbent.
15. **Biggest weakness:** Content Warning's comedy comes from recorded **voice**, which most of the Roblox audience can't use. Without it, the payoff weakens.
16. **Scores (C08):** Acc 6 · Mob 7 · Mon 6 · Rep 6 · Vir 8 · Dev 5 · Dif 5 · Fun 6 · *(Stm 5 · Com 6)*
17. **Weighted average:** **6.16**. **Fails:** most gates. Its redesign (R2-07) fell to 4.94.
18. **Agent disagreements:** Viral 8 versus Steam adaptation 5 → 4, because the source's humour depends on voice. The real-replay fix lowered both Dev and Fun.
19. **Confidence:** **Low.**

---

### #8 — Critter Lineage
1. **Pitch:** Lead a team of critters through short battles. The survivors raise the next generation, inheriting their strengths and weird mutations.
2. **Genre:** Roguelite creature tactics plus a breeding meta.
3. **Inspiration and research:** Mewgenics (115K Steam peak, inheritance between runs) and Pokémon. On Roblox, pet sims, Catch and Tame and Blox Monsters (crowded adjacent space).
4. **Core loop:** Pick 3 critters → a 10-minute run of placement auto-battles and upgrade picks → survivors return → pair two at the nest → the hatchling inherits traits plus a visible mutation → the family tree grows.
5. **First 30 seconds:** Hatch your first critter (a three-eyed frog), drag it onto the board, and watch it win a scrappy fight.
6. **First 10 minutes:** One run. Two survivors pair up, and the first mutation reveal ("it has a fish tail!") becomes a new mutation in the log.
7. **Long-term progression:** Mutation collection log, family tree, nest upgrades and seasonal mutation pools.
8. **Multiplayer interactions:** Co-op runs and cross-breeding with a friend's critter. These are thin.
9. **Replayability:** Strong (8). Roguelite runs plus a unique lineage.
10. **Mobile controls:** Tap and drag on a small board, no avatar movement (Mob 8).
11. **Monetization:** The best on paper (8): nest slots, deterministic cosmetics, lineage banners and giftable critters. Never sell random mutations.
12. **Viral moments:** Absurd mutation reveals. Otherwise weak (5).
13. **Development complexity:** **Medium** (Dev 6). The genetics balance and the modular critter rig are the hard parts.
14. **Main competitive advantage:** Roblox's most proven spending category (creatures), with a fresh inheritance twist.
15. **Biggest weakness:** **The core isn't fun enough.** Fun scored 5, and the merged version was vetoed at 3: "a progression system without a game". Accessibility scored 4.
16. **Scores (C10):** Acc 4 · Mob 8 · Mon 8 · Rep 8 · Vir 5 · Dev 6 · Dif 6 · Fun 5 · *(Stm 7 · Com 5)*
17. **Weighted average:** **6.22**. **Fails:** average; Acc and Fun below 8; Vir, Dev and Dif below 7.
18. **Agent disagreements:** This is the clearest split on the slate: Mon, Rep and Mob at 8 versus Fun 5 and Access 4. It is exactly the trap the brief warned about (appealing progression, thin play).
19. **Confidence:** **Low.** The best use may be as a meta layer for a concept with a fun core (e.g., Blaze Brigade's Critter Log already borrows it).

---

### #9 — Night Desk
1. **Pitch:** 2–4 friends run a roadside motel. Days are simple chores; nights bring procedural anomalies to spot, report and survive.
2. **Genre:** Co-op job sim plus anomaly horror.
3. **Inspiration and research:** Sell Fries! (~112K peak), 7 Days Cat-Sitting, Scary Shawarma Kiosk, and the licensed Roblox *Exit 8* (8-player co-op). The most validated demand on the slate, and the most crowded lane.
4. **Core loop:** Day chores earn cash → nights draw from an anomaly deck → one player watches CCTV while others patrol → tap to report → missed anomalies escalate into chases → survive 5 nights → upgrade the motel.
5. **First 30 seconds:** Behind the desk a guest walks in; tap "Give Key". The clock hits 8 pm and the lights buzz. A painting in the lobby is now upside down.
6. **First 10 minutes:** Day 1 and Night 1. Your first correct report, your first missed one, and a corridor chase. Your first Field Guide entry.
7. **Long-term progression:** Motel wings, Anomaly Field Guide, numbered chapters, weekly mutation.
8. **Multiplayer interactions:** CCTV and patrol roles, a shared nerve pool, and revives.
9. **Replayability:** Weak (6 → 4). Anomaly spotting turns into memorisation.
10. **Mobile controls:** Thumbstick plus one Interact/Report button and a tap-grid CCTV. Subtle anomalies on a 6-inch screen are a problem (Mob 7 → 5).
11. **Monetization:** Uniforms, lobby decor, flashlight skins and a capped revive (Mon 6).
12. **Viral moments:** Strong (8). Friends screaming at a faceless guest.
13. **Development complexity:** **Low-medium** (Dev 7). Mostly state swaps; content volume is the cost.
14. **Main competitive advantage:** Proven, rising demand.
15. **Biggest weakness:** Differentiation 4. It is the fastest-cloning lane on Roblox, with incumbents already in chapters.
16. **Scores (C01):** Acc 5 · Mob 7 · Mon 6 · Rep 6 · Vir 8 · Dev 7 · Dif 4 · Fun 6 · *(Stm 6 · Com 7)*
17. **Weighted average:** **6.14**. **Fails:** most gates. The redesign (R2-06, information asymmetry) fell to 4.78.
18. **Agent disagreements:** Commercial 7 (demand is proven) versus Differentiation 4 (can't win it). The redesign that removed the day phase collapsed Fun to 4.
19. **Confidence:** **Medium** that the demand exists; **low** that a late entrant wins.

---

### #10 — Fake or Fortune
1. **Pitch:** Run an antique shop with friends. Inspect every item with your magnifier and UV light, buy the real treasures, and catch the forgers.
2. **Genre:** Co-op shop sim plus detective (plus a "Forger Night" social-deduction mode).
3. **Inspiration and research:** Probably Stolen (660K+ demo players, ~40K peak) and Papers, Please. The Roblox lane is nearly empty (*Fake a Masterpiece*, ~1 CCU peak).
4. **Core loop:** A customer brings an item → inspect it with tools (the right tool makes tells glow) → BUY or REJECT → resell genuine items → display rare finds in your museum. In Forger Night, a hidden player plants fakes.
5. **First 30 seconds:** A customer slaps a vase on the counter. Drag the magnifier over it, the stamp glows, and it doesn't match the catalogue card. REJECT: the vase shatters, revealing a "MADE IN 2026" sticker. "Nice catch!"
6. **First 10 minutes:** One shop day with about 10 items. One expensive mistake, and your first genuine rare for the museum.
7. **Long-term progression:** Shop upgrades, a visitable museum, earned tool tiers and seasonal Treasure Sets.
8. **Multiplayer interactions:** Split tools, a shared till, votes on big buys, and Forger Night deduction.
9. **Replayability:** Medium-weak (6). The tells can be learned.
10. **Mobile controls:** Tap item → full-screen inspect → drag tool → BUY or REJECT (Mob 7).
11. **Monetization:** A visitable museum (display cases, plaques), shop themes and tool skins (Mon 7).
12. **Viral moments:** Fake reveals (a "fossil" that is chicken bones) and the forger unmasking (6).
13. **Development complexity:** **Low-medium** (Dev 7). The tell-variant content pipeline is the main cost.
14. **Main competitive advantage:** An empty lane with a clear detective fantasy (Dif 7 in both panels).
15. **Biggest weakness:** Accessibility 4. Comparing tells against a catalogue is hard for children and on phones, and the source audience is adult PC players.
16. **Scores (C04):** Acc 4 · Mob 7 · Mon 7 · Rep 6 · Vir 6 · Dev 7 · Dif 7 · Fun 6 · *(Stm 7 · Com 6)*
17. **Weighted average:** **6.20**. **Fails:** average; Acc, Mob, Mon, Rep and Fun below 8; Vir below 7. The redesign (R2-05 Forger Night) fell to 5.68.
18. **Agent disagreements:** Differentiation 7 and Dev 7 versus Access 4. The Steam agent liked the detective flip (7); the Fun agent saw a checklist (6).
19. **Confidence:** **Low-medium.** It may suit a 13+ or 16+ audience better than a young one.


---

## 4. Final ranking

| # | Concept | Genre | Acc | Mob | Mon | Rep | Vir | Dev | Dif | Fun | Stm | Com | **WAvg** | Family mean | Qualifies? | Kill risk (adversarial) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Party's Over! | 1vN physics party | 7 | 7 | 7 | 7 | 9 | 5 | 7 | 7 | 7 | 7 | **7.04** | 6.77 | No | Medium |
| 2 | Blaze Brigade | Co-op rescue + collection | 8 | 7 | 7 | 7 | 6 | 3 | 7 | 6 | 6 | 7 | **6.42** | 6.39 | No | Medium (execution) |
| 3 | Scribble Spells | Co-op gesture roguelite | 8 | 9 | 6 | 7 | 6 | 7 | 6 | 7 | 6 | 5 | **7.02** | 6.44 | No | Med-high (demand) |
| 4 | Toybox Knockout | Auto-battler party | 5 | 9 | 7 | 8 | 4 | 6 | 6 | 6 | 6 | 5 | **6.40** | 6.40 | No | Medium |
| 5 | Statue Shuffle | Red-light + hide-in-plain-sight | 6 | 7 | 5 | 6 | 8 | 6 | 6 | 8 | 7 | 6 | **6.60** | 6.45 | No | High (timing) |
| 6 | Paddle Panic | Shared-raft party racing | 7 | 8 | 6 | 5 | 7 | 6 | 6 | 7 | 7 | 6 | **6.52** | 6.41 | No | High (retention) |
| 7 | Ghost Vlog | Co-op horror-comedy | 6 | 7 | 6 | 6 | 8 | 5 | 5 | 6 | 5 | 6 | **6.16** | 5.55 | No | Med-high |
| 8 | Critter Lineage | Roguelite + breeding | 4 | 8 | 8 | 8 | 5 | 6 | 6 | 5 | 7 | 5 | **6.22** | 6.01 | No | High (fun) |
| 9 | Night Desk | Co-op anomaly horror | 5 | 7 | 6 | 6 | 8 | 7 | 4 | 6 | 6 | 7 | **6.14** | 5.46 | No | High (saturation) |
| 10 | Fake or Fortune | Co-op shop detective | 4 | 7 | 7 | 6 | 6 | 7 | 7 | 6 | 7 | 6 | **6.20** | 5.94 | No | High (access) |

*The order follows the adversarial re-ranking, not raw WAvg. Ranks 2–6 are within noise of one another, so they were ordered by whether their main risk is one a team can control (execution) or one it cannot (market).*

### Category picks
| Category | Pick | Why |
|---|---|---|
| **Best overall concept** | **Party's Over!** | Highest and most stable scores (family mean 6.77), highest viral, and no Roblox competitor in its format |
| **Simplest to develop** | **Scribble Spells** | Dev 7/7: no movement, no physics, a ~200-line recognizer, client-rendered enemies (Night Desk and Fake or Fortune also scored Dev 7, but on weaker concepts) |
| **Best mobile experience** | **Toybox Knockout** | Mobile 9 in both panels; drag-and-drop only (Scribble Spells and Paddle Panic also reached 9 once) |
| **Highest replayability** | **Toybox Knockout** | Replay 8 in both panels (draft variance plus skill plus seasons); Critter Lineage also 8 |
| **Best monetization potential** | **Critter Lineage** on paper (Mon 8); **Blaze Brigade** in practice | Creature collection is Roblox's most proven spend, but Critter Lineage's core was judged unfun. Blaze Brigade borrows the companion layer on top of a playable core |
| **Highest viral potential** | **Party's Over!** | Viral 9/9/8: a relatable premise, betrayal, panic, and a thumbnail that needs no explanation |
| **Most original concept** | **Scribble Spells** | Co-op spell fusion drawn on the touchscreen; nothing comparable on Roblox, and the input is better on phones than on PC |
| **Best Steam-indie adaptation** | **Party's Over!** | Turns No Body No Problem!'s crime clean-up into a kid-native "hide the mess from Mom" (Steam agent 7/7/7: "the best kid reframe on the panel") |
| **Best long-term commercial opportunity** | **Blaze Brigade** | Evergreen, Kids/Select-safe theme; companion collection supports 28-day retention and policy-safe spend; risks are execution, not market (Com 7/7) |

### The three most deserving of prototyping
1. **Party's Over!** Its open questions (is the Parent fun? does a house get "solved"?) are exactly what a greybox answers.
2. **Blaze Brigade.** The hose feel and low-end performance either work in 3 weeks or kill it cheaply.
3. **Scribble Spells.** It is the cheapest test on the slate, and it settles both thumb accuracy and fusion timing.

**Not prototyped: Statue Shuffle,** which had the best fun score. Its main risk is market timing, which a prototype cannot reveal. Revisit it in about 8 weeks, once we know how many Worst-Class-Ever-style games have launched on Roblox.

---

## 5. Prototype validation plan (Phase 8)

**Ground rules for all three tests:**
- **Evidence:** only real players' observed behaviour and their own words count. Nothing in this document is a validation result; all the thresholds below are **proposed** bars, set before testing so they can't be moved afterwards.
- **Duration:** a 2–3-week greybox each, with no monetization, no progression, free/greybox art and no saving.
- **Testers:**
  - Start with 16+ testers, which matches how Roblox now gates reach to under-16s.
  - Test with 9–15-year-olds only with parental consent, inside Roblox's Terms.
  - Run at least 3 sessions of 5–8 players, with ≥50% on phones and at least one low-end Android device (~US$150 class).
  - Use an unlisted test place with analytics events, plus one silent observer per session using a tally sheet.
  - Don't explain the game. If a tester asks, log it as a comprehension failure.
- **Six lenses for every test:** first impression, immediate fun, replayability, social interaction, mobile usability, and retention signals.
- **Later soft-launch gates (from the market report):** keep a game only if, after 3 weeks live, D1 is at least 15% and D7 at least 4%. The platform medians are 10.3% and 1.6%.

### 5.1 Party's Over! — "Is the hunt fun, and does the house stay fresh?"
| | |
|---|---|
| **Minimum systems (must work)** | One 6-room house; ~25 server-tagged evidence objects (clean/messy/hidden/exposed); ~30 hotspots with a random 40% open; the 3 timed phases; the kid contextual button (pick/cycle/hide); a Parent with Sniff + FREEZE!; the catch-while-carrying rule using lag-tolerant server judgement; Parent rotation queue; a static 3-card end screen; 5–7-player server |
| **Can be mocked** | Art and audio (greybox plus free models), Blacklight, Report Card animation (text cards), Party Tricks/gadget loadouts, cosmetics, progression, saving, AI Parent |
| **A/B inside the test** | The Parent's role during PARTY: (a) absent, as in R2, vs (b) "upstairs peeks" that force kids to freeze. This settles the panel's biggest Fun complaint |
| **Behaviour to observe** | Time to first smash; whether kids hide anything in their first PANIC without being told; where items get hidden each round (heat-map); Parent catch rate; snitch use; laughter and shouting (tally); AFK or idle kids; whether players volunteer to be Parent; complaints that FREEZE! was unfair; phone vs PC success rates |
| **Success looks like** | ≥80% act meaningfully in the first 30 s with no help · ≥70% hide at least one item in their first PANIC unprompted · median ≥4 voluntary rounds when free to leave · ≥50% ask to be Parent again · Parent catch rate between 30% and 70% · hiding-spot diversity in round 8 at least 60% of round 1 (the house isn't solved) · phone players' hide and catch rates within 20% of PC players' |
| **Failure looks like** | The Parent role is avoided or dreaded · kids stand idle in PARTY or are confused in PANIC · by round 6 most items go into the same 5 spots · most testers leave after 1–2 rounds · repeated "that wasn't fair" over FREEZE! |
| **Retention signal** | Invite the same cohort back 7 days later without telling them about it. ≥30% rejoining the unlisted place unprompted is a strong signal. Also note anyone who asks "when's the next house?" |

### 5.2 Blaze Brigade — "Does the hose feel good, and does it run on a cheap phone?"
| | |
|---|---|
| **Minimum systems (must work)** | One 2-floor house built from ~8 modular rooms (3 hand-placed layouts); server grid fire spread with tile-decal fire and capped smoke; hose with a water tank and hydrant refill, built **both** ways (hold auto-aim and drag-to-sweep) for A/B; 1 special fire type (grease → foam); 8 critters on one rig that hide and flee; single carry plus one two-person carry; floor-collapse timer; 1–4-player co-op; run-end screen; rescued critters follow you in the lobby |
| **Can be mocked** | Critter Log UI, alarm tiers (one difficulty), truck, cosmetics, procedural generation (use fixed layouts), sanctuary, companion accessories |
| **Behaviour to observe** | Frame rate on the low-end Android; time to first rescue; whether players keep spraying after the fire is out (a sign the verb feels good); which hose scheme they prefer; whether a group splits up tasks on its own; reactions when a floor collapses; whether players name or talk about the critters; how often they check their companion in the lobby |
| **Success looks like** | Median ≥30 fps on the low-end phone in the worst room · ≥75% make a first rescue within 60 s unaided · ≥60% start a 3rd run voluntarily · a clear majority prefer one hose scheme · players spontaneously mention their companion or a specific critter · no camera or readability complaints through the smoke |
| **Failure looks like** | The hose feels floaty or pointless · fire spread looks random or unfair · <25 fps on the low-end phone · players ignore the critters and treat it as generic firefighting · runs feel identical by run 3. **Kill rule: if the core doesn't land within 3 weeks, stop.** |
| **Retention signal** | Testers ask to keep or name their companion, or ask what other buildings or critters exist; ≥30% rejoin the place unprompted after 7 days |

### 5.3 Scribble Spells — "Can thumbs draw it, and do fusions feel intentional?"
| | |
|---|---|
| **Minimum systems (must work)** | Server-side recognizer for 6 runes; 3 fusions with a 1-s window; one fixed balcony per player; one lane-wave system with 3 enemy types and 1 boss; one relic draft between waves (3 relics); 2 comedic misfires; 1–4 players |
| **Can be mocked** | Rune Book UI, schools, familiars, cosmetics, ranked/endless modes, tower art |
| **Instrumentation** | Log every trace: the rune prompted (during the tutorial) vs the rune classified, draw time, device, screen size and ping; fusion attempts vs successes; whether each fusion was preceded by a teammate's rune start (intentional) or not (accidental) |
| **Behaviour to observe** | Frustration after misreads; whether players switch to spamming one "safe" rune; whether strangers coordinate fusions without chat; laughter at misfires; hand fatigue; whether players start a second run |
| **Success looks like** | ≥90% classification accuracy on phones after the first run · ≥50% of fusions intentional by run 2 · ≥70% fusion success at 150–250 ms ping · ≥60% voluntarily start a second run · **clip test:** 15-s fusion or misfire clips shown to 20 people in the target age range, with ≥50% saying they'd want to try it |
| **Failure looks like** | <80% accuracy on phones · fusions feel random · rune diversity collapses to one or two runes · fatigue complaints · median session shorter than one run · the clip test lands below 30% |
| **Retention signal** | Testers ask about fusions they haven't found yet; ≥30% return unprompted after 7 days |

### What would change our minds
- **Promote Statue Shuffle:** if no Worst-Class-Ever-style Roblox games pass ~5K CCU by mid-January.
- **Demote all three finalists:** if co-op horror and party formats fall below their September 2026 levels for a quarter outside event windows.
- **Raise everything with a strong "play with me" hook (Party's Over!, Paddle Panic):** if Play on the Web launches on time and creator links convert well.

---

## 6. Limitations
- **The evaluators were AI agents.** Independent panels, honestly instructed, are still a structured opinion, not a playtest. The ±1 noise per criterion is shown openly in the score history.
- **Market figures are third-party tracker snapshots** that disagree by up to 2–5x. Steam figures came from search summaries; several primary sites were unreachable from the research environment.
- **Some concepts were evaluated in only one panel** (Toybox Knockout, Critter Lineage), so they have one draw against three for the leaders. The adversarial review's family means partly correct for this.
- **The qualifying bar requires top-quartile scores on five dimensions at once.** No concept got close, and no real Roblox hit is likely to score top-quartile everywhere either. **Treat the shortfall as a statement about evidence, not a verdict that the ideas are bad.** Only player data can close the gap.

## Appendix index
- `appendix/research/`: full research notes for Roblox, Steam and cross-platform, with citations and evidence labels.
- `appendix/concepts/`: the 44-concept long list, plus the Round 1 (20), Round 2 (12) and Round 3 (5) concept specs.
- `appendix/evaluations/score_history.md`: all three rounds' tables. `raw_eval*/`: every agent's per-concept score, confidence, justification and fix. `adversarial_review.md`: the Phase 6 review. `score.py`: the weighting and gate script.
