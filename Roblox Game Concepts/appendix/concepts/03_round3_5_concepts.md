# Concepts — Round 3 (5 deep redesigns)

Context for evaluators: Roblox, Nov 2026. 55–80% of sessions on mobile; default thumbstick (bottom-left) and jump (bottom-right) occupy the corners. Discovery rewards 28-day retention and co-play. Under-16 reach needs Kids/Select eligibility (no free-form drawing/hangouts; chat gated by age check → games must work with pings/emotes). Small team = 2–5 devs with AI tools, ~3–4 months to first public version. No paid random items in any concept. All use R15 avatars (adult DevEx +42%). Research: ../research/{steam,roblox,crossplatform}.md.

Shared technical stance: server-authoritative state; no multi-client-owned physics bodies; scoring-relevant props are tagged server objects with discrete states; cosmetic debris client-side; lag-tolerant judgement (server position history, ≥0.5 s grace scaled by ping); in-server party pads; small servers (5–8).

---

## R3-01 — GROUNDED!
**Pitch:** Throw the wildest house party ever — then hide the evidence before Mom gets home and goes hunting.
**Genre:** Asymmetric 1vN physics-comedy party game (3–6 kids vs 1 Parent; 5–7-player servers). **Inspiration:** No Body No Problem! (Oct 2026 Next Fest top 5), Worst Class Ever (#1), Granny, Flee the Facility. **Nearest Roblox competitor:** Clean the House! (PvE chore game, ~5–8K peak).

**Round (≈5 min), every player always active:**
1. **PARTY (1:45).** Kids smash, spill, bounce for Fun Points; ~25 tagged evidence objects per house (states: clean → messy → hidden → exposed; debris is client-side). **Meanwhile the Parent is DRIVING HOME** in a 1:45 arcade lane-dodge mini-game (swipe lanes, dodge traffic, grab coffee). Driving well = arrive early (shorter PANIC). The Parent also collects "Neighbour Gossip" postcards that reveal 2 rooms where the biggest mess happened — known only to the Parent.
2. **PANIC (0:45, length set by Parent's drive).** Car pulls into the driveway; full-screen pictogram "HIDE!"; evidence glows red; "MESS LEFT: 12". Camera rises to an elevated view. Kids tap a mess to pick it up (tap again to cycle to another item in reach); 2–3 nearby hiding spots light up with arrows; tap the arrow to hide. Only ~40% of each house's 60 hiding spots are open each round (random), so the Parent can't memorise. Kids can also drop a **Decoy** (a suspicious lump under a rug) once per round.
3. **HUNT (1:30).** Parent gadgets on ONE radial button (first-time Parents only get Sniff; more unlock with mastery): Sniff (3-s scent trail to recently touched spots), Blacklight (sticky residue), FREEZE! (server snapshot; anyone who moved more than a generous threshold in the Parent's view in the next second is caught). Kids can re-hide behind the Parent's back; kids carrying evidence when caught are Grounded (sent to the "naughty step", where they can still throw 1 paper-plane distraction per 20 s — no idle spectating). Kids may **Snitch** a teammate's spot for a personal bonus.
4. **REPORT CARD (0:20).** Three snapshot cards: "Most Ridiculous Hiding Spot", "The Snitch", "Caught Red-Handed", each with the player's chosen pose; Parent gasp pose. Built for screenshots.

**Variety:** random spot subsets, random mess objects, kid Party Trick loadouts (earned sidegrades: Speedy Sweeper, Rug Expert, Whoopee Balloon distraction), Parent Gadget loadouts, weekly House Rule mutator (dog follows Parent; lights go out during PANIC; grandma arrives instead of Mom and is half-blind but has a hearing aid). Launch: 1 house + practice house; 2nd house at week 4, then monthly.
**Long-term:** Parent and Kid mastery tracks; **Feats log** (pull off a snitch-and-escape; hide the TV in the oven; win as Parent with Sniff only) instead of a checklist; seasonal ranked Parent ladder.
**Mobile:** thumbstick + ONE contextual button (above jump) + Parent radial. All world interactions are tap-on-highlight with large hit areas; no free aiming. Parent drive is swipe-only.
**Monetization (no gameplay power):**
- Parent costumes (the most-watched character every round) and Parent car skins (seen by all during the arrival cutscene).
- Kid outfits, **Report Card poses and caught/escape emotes** (shown to the lobby every round).
- **Chaos finishers** (custom smash splat/sound when you cause the round's biggest mess).
- **Your Bedroom**: each player has a bedroom in the lobby street that friends walk into between rounds; furniture/posters/trophies from Feats; furniture packs sold; giftable.
- Monthly house launches as a cosmetic bundle; cosmetic season pass; Host House rule (host's owned house theme used); rewarded video for a one-off Fun multiplier.
**Viral:** party chaos → panic → Parent's FREEZE catching a kid mid-sneak → snitch betrayal → Report Card punchline.
**Cold start:** 5–7-player servers so 1vN fills faster; party pads for friends; AI Parent only in the practice house.

## R3-02 — SCRIBBLE SPELLS
**Pitch:** Draw a rune with your finger to cast a spell — and when two friends draw at the same time, the spells fuse into something huge.
**Genre:** Co-op roguelite wave defence with gesture input (1–4 players). **Inspiration:** YAPYAP (performative input), Magicka (combining), Fruit Ninja (gesture feel). **Nearest competitor:** Draw Spells Magic Arena (PvP, ~615 CCU) — this game is positioned as "co-op fusion", not "draw spells".

**Core:** Each apprentice has 3 balconies on the tower; tap a balcony to hop (no thumbstick, no camera control). The screen is the drawing pad; traces are classified on the server into 6 bold, forgiving runes (circle shield, zigzag lightning, spiral whirlwind, V fire, line ice spear, heart heal). Faint trace guides on first runs. Sloppy traces cast at partial power; very sloppy ones misfire comically (lightning becomes a rubber chicken; whirlwind steals a teammate's hat). Drawn runes are shown big on screen for viewers.
**Fusion as intentional teamwork:** When one player starts a rune, teammates see a 1-s "fusion window" glow plus the suggested partner rune icon. Cast within the window → fusion with a big named banner (fire+whirlwind = Firenado; ice+lightning = Frozen Storm; heal+shield = Bubble Dome). Friendly-fire comedy: a Firenado can launch a teammate off the balcony onto the tower trampoline (no damage, big laugh).
**Run (6–8 min):** monster waves; enemy types demand fusions (armoured = Frozen Storm; flyers = Firenado; ghosts = Bubble Dome pushes them back); boss every 4th wave. Between waves, draft 1 of 3 relics that **change fusion behaviour** (Firenado leaves lava; Frozen Storm chains; Bubble Dome reflects) → build-defining runs. Weekly mutator.
**Long-term:** Rune Book of fusions (launch 12, +4 per season with new runes), Familiars collection (40 cosmetic shoulder creatures unlocked by discovering fusions and feats — never random), ranked weekly Trial seed, endless leaderboard, wizard schools (earnable sidegrade starting relics).
**Mobile/PC/console:** native touch drawing; PC mouse drag; console radial rune selector with stick flicks.
**Monetization:** ink-trail cosmetics (seen on every cast and inside fusions — two players' colours mix), fusion finisher skins, boss-kill finishers, familiar cosmetics (hats/colours) and premium familiars (direct purchase, also earnable variants), Rune Book covers, tower themes (Captain rule), cosmetic season pass, rewarded-video "second wind" tower revive (once per run).
**Viral:** misfire chickens, friend launched off the balcony by a Firenado, screen-filling fusions.
**Launch scope:** 6 runes, 12 fusions, 3 enemy types + 1 boss, enemies rendered client-side from server lane data.

## R3-03 — STATUE SHUFFLE
**Pitch:** At night the museum statues come alive — pull pranks behind the guard's back and freeze the instant the flashlight hits you.
**Genre:** Asymmetric Red-Light-Green-Light × hide-in-plain-sight (4–7 statues vs 1 Guard). **Inspiration:** Worst Class Ever (#1 Oct 2026 Next Fest), Red Light Green Light, Be NPC or Die. **Nearest competitors:** Be NPC or Die, DISGUISE, In Plain Sight (none use a beam-only tag rule).

**Core rule (simple):** Release the thumbstick = freeze. When frozen you auto-snap into the nearest plinth pose (no placard rule to remember). A "LIGHT COMING" vignette pulses on your screen when the beam approaches. The Guard can ONLY tag statues inside the flashlight beam, battery is limited, and wrong tags cost battery. ~30 NPC statues slowly shift poses so movement alone isn't proof. Lag-tolerant: judgement uses server position history with ping-scaled grace.
**Guard controls:** the beam follows the camera; a centre reticle TAG button with soft lock-on to the statue inside the cone (no world tapping). Recently moved statues shimmer faintly for the Guard.
**Mischief:** shared meter filled by pranks; each round only some pranks are live and a few are hidden (find them first): moustache stamp on a portrait, swap two paintings, put the knight's helmet on the T-rex, trigger the cuckoo clock (distracts the Guard), knock a vase (loud). Statue abilities (earned): Dust Cloud, Fake Crack, Echo Footsteps.
**No idle players:** tagged statues become "Cracked Statues" — they can still trigger one distraction per 20 s and can be revived by a teammate touching them.
**Round (4 min):** wings lock as the Guard's battery drains, shrinking the map toward a finale. Statues win if Mischief fills; Guard wins by tagging all or surviving the timer.
**End-of-round:** "Unmasking": each real statue's skin, owner name and signature pose are revealed; "Caught on Camera" snapshot cards of the pranks the Guard missed.
**Long-term:** ranked Guard ladder with stat cards; statue roster (mummy, knight, astronaut, dino skeleton) and Guard gadgets earned; **Prank Gallery** — your lobby plaque wall of feats (e.g., "Moustached the Mona 50 times"); weekly Exhibit event with new prank set; new wing monthly.
**Mobile:** thumbstick + one Prank button (above jump); release-to-freeze; Guard has look-drag + TAG.
**Monetization:** statue skins work as disguise packs (equipping spawns matching NPC statues) and are credited at the Unmasking with name + signature pose; signature freeze poses and reveal stingers; Guard beam colours and tag effects (most visible items in the game); prank-effect cosmetics (moustache styles, confetti); Prank Gallery frames; cosmetic season pass.
**Launch scope:** one museum (3 wings), R15 humanoid statues only, 8 pranks, still-snapshot reel.

## R3-04 — PADDLE PANIC
**Pitch:** Up to six friends, one ridiculous raft, everyone controls one paddle — steer together or spin into the waterfall.
**Genre:** Co-op/versus party racing (2–6 players per raft). **Inspiration:** Fart Together (crude Roblox copy hit 13M+ visits before takedown), RV There Yet?, Overcooked. **Nearest competitor:** Boat Together [1–6 Player] (~8.2M visits, ~2K all-time peak; no versus, no vehicle roster).

**Core:** The raft runs server-side as a kinematic controller on a river spline at 20–30 Hz with client interpolation (no physics ownership). Each seat has a HOLD-to-paddle button and a **seat role** that differs per vehicle: Paddler, Bailer (scoop water out — or INTO a rival raft in Versus), Lookout (sees the upcoming-hazard strip and can ping "LEFT/RIGHT/STOP" — the pings appear as huge arrows on everyone's screen), Bonker (bonk crocs, grab coins). A live combined heading arrow shows where the raft is going; a ghost arrow suggests "paddle now".
**Skill ceiling:** river segments offer line choices and shortcut branches (narrow gaps needing a coordinated burst; a jump ramp needing everyone to BRACE together). Medals per segment; daily seed ranked crew leaderboard; friends' ghost rafts.
**Versus Raft Race (launch):** 2–3 rafts on the same river; bump, bail water into rivals, throw water balloons from the Bonker seat. Weekly "Saboteur Seat" mutator: one random seat secretly scores points if the raft sinks.
**Onboarding:** first run is a 2-seat calm-water tandem with arrows.
**Vehicles = identity:** bathtub (sneezing walrus), shopping-cart rocket (soda bursts), inflatable duck (6 seats, bouncy), sky balloon (altitude instead of yaw). New vehicle every 2–3 weeks; all earnable, premium ones directly buyable.
**Feedback/viral:** slow-mo waterfall freeze-frame highlighting the blamed player; "WHO SANK US?" card with each seat's input timeline and chosen emote.
**Long-term:** vehicle collection displayed in your **Boathouse** (lobby dock where your raft collection floats and friends can hop in), crew level, segment medals, ranked seasons.
**Mobile:** one big HOLD button (bottom-right) + role button above it; no thumbstick; auto camera.
**Monetization:** Captain rule (host's raft, skin, wake trail used by whole crew; crew can "chip in" by gifting the host the vehicle), per-seat cosmetics (paddle skins, splash/bonk effects, seat emotes on the blame card), vehicle + trail bundles, Boathouse decor, cosmetic season pass.
**Launch scope:** 2 vehicles, 12 segments, co-op + versus.

## R3-05 — BLAZE BRIGADE: CRITTER RESCUE
**Pitch:** Fight fires with your squad and rescue the animals trapped inside — every critter you save becomes your companion.
**Genre:** Co-op action rescue + creature collection (1–4 players). **Inspiration:** Overcooked (chaos), Flash Point: Fire Rescue (board game), PowerWash Simulator (satisfying sweep), Pet Simulator collection appeal, Dumpster Gang (downed-teammate rescue). **Nearest competitors:** Firefighting Sim and other fire roleplay/dispatch sims; Rescue Animals! (~20K peak, animal rescue trend) — none combine round-based co-op fire chaos with collection.

**Core run (5 min):** Procedural house built from modular rooms (launch: 2-floor house; pet shop and zoo later). Fire spreads on a coarse server grid; fire/smoke render as tile decals with capped particles (low-end tier). **Hose skill:** drag on the right half of the screen to sweep the hose (generous magnetism toward flames, PowerWash-style satisfying clear); limited water tank refilled at hydrants. **Fire types:** grease fire needs the foam extinguisher (water makes it flare up), electrical fire needs the breaker switched off first. **Critters behave:** they hide under beds, flee from fire, panic if you run while carrying them (they wriggle free). Some need two players (panicked elephant calf at the zoo) or a tool (ladder for a parrot). Floors collapse on a timer → last-second saves. Teammates downed by smoke can be dragged out by others.
**Rescue → collection:** each building type has a deterministic critter pool; **rare critters appear only for performance** (e.g., no casualties at alarm level 3+, under 3 min) — earned, never sold. Rescued critters become **companions** that follow you in the Fire Station lobby and ride on your truck in runs (visible to everyone). Critter Log: 40 at launch on 2 shared rigs (quadruped, bird), +10 per season.
**Long-term:** alarm tiers 1–5, brigade rank, truck sidegrades (ladder truck vs tanker), Critter Log, seasonal critter drops tied to new building types, weekly "Big Blaze" mutator.
**Comedy failure:** an escaped critter causes mayhem (goat eats the hose, elephant sprays the team), slow-mo rescue cam on floor collapses.
**Mobile:** thumbstick + right-side drag-to-sweep hose + one contextual RESCUE/USE button above jump; fixed elevated wall-fade camera; bold pulsing critter icons through smoke.
**Monetization:** companion accessories (hats, capes — on the critter that follows you everywhere), giftable accessories, firefighter uniforms, hose water effects (rainbow, glitter — on screen constantly), truck liveries (Captain rule), Fire Station locker decor, extra companion slots (convenience; also earnable), cosmetic season pass, rewarded video for a bonus rescue reward. No paid critters.
**Launch scope:** one building type, 20–40 critters on 2 rigs, companion-follow instead of a sanctuary housing system (sanctuary later).
