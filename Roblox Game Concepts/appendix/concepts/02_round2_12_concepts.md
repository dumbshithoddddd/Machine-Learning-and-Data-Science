# Concepts — Round 2 (12 concepts: 10 redesigns, 1 merge, 1 new)

Context for evaluators: Roblox, Nov 2026. 55–80% of sessions on mobile; Roblox default thumbstick (bottom-left) and jump (bottom-right) occupy the corners. Discovery rewards 28-day retention and co-play. Under-16 reach needs Kids/Select eligibility (no free-form drawing/hangouts by default; chat gated by age check, so games must work with pings/emotes only). Small team = 2–5 devs with AI-assisted tools, ~3–4 months to first public version. Paid random items must disclose odds and are region-blocked — none of these concepts sell randomness. Research files: ../research/{steam,roblox,crossplatform}.md.

Common technical stance for all concepts (applies unless stated): server-authoritative state; no multi-client-owned physics bodies; "physics" props that matter to scoring are tagged server objects with discrete states; cosmetic debris is client-side only; in-server party pads + bot backfill instead of cross-server matchmaking; one save per round/night.

---

## R2-01 — GROUNDED! (redesign of C05 Mom's Home!)
**Pitch:** Throw the wildest house party ever — then hide the evidence before Mom gets home and goes hunting.
**Genre:** Asymmetric 1vN physics party game (3–7 kids vs 1 Parent). **Inspiration:** No Body No Problem! (Oct 2026 Next Fest top 5), Worst Class Ever (#1), Granny, Flee the Facility.
**Round (≈5 min):**
- PARTY (2:00): Kids smash, spill and bounce for Fun Points. Every mess-able object is one of ~40 tagged "evidence" objects with discrete states (clean → messy → hidden → exposed). Smash VFX/debris are client-side.
- PANIC (0:45): car pulls into the driveway (big banner + horn). Every piece of evidence glows red; a "MESS LEFT: 12" counter. Kids use ONE contextual button: near a mess it auto-picks the nearest item and offers glowing "Hide here" hotspots (under rug, in oven, behind dog, inside piano, on top of fridge). Some hotspots are "risky" (more points, easier to find).
- HUNT (1:30): the Parent player becomes a hunter, not an auditor: Sniff (shows a 3-s scent trail to recently touched hotspots), Blacklight (reveals sticky residue), and "FREEZE!" shout (anyone moving in view in the next 1 s is caught). Kids can re-hide items behind the Parent's back and must not be caught carrying. Kids may "snitch" a teammate's spot for a personal bonus.
- REPORT CARD (0:20): auto-slideshow of the 3 funniest moments (the most absurd hiding spot, the snitch, the freeze-catch) with a Parent "gasp" reaction pose — built for screenshots/clips.
**Score:** Kids team = Fun − evidence found; best kid & best Parent get medals.
**Variety:** Each round shuffles mess objects and opens/closes hotspot sets; houses built from modular room kits (launch: suburban house + grandma's cottage; then school, museum, castle, spaceship monthly). Weekly "House Rule" mutator (e.g., the dog follows the Parent; lights go out during PANIC).
**Progression:** Kid "Party Trick" loadouts (earned sidegrades: Speedy Sweeper, Rug Expert, Distraction Whoopee-Balloon) and Parent "Gadget" loadouts (earned: Baby Monitor, Flashlight, Grandma Visit); mastery levels per role; a Hiding-Spot Collection Log (find all 60 hotspots in each house).
**Mobile controls:** Thumbstick + ONE contextual action button (above the jump button) + Parent's 3 gadget buttons in a vertical stack on the right edge. Fixed over-shoulder interior camera with auto-wall-fade. No precise aiming anywhere.
**Monetization:** Parent costumes (the single most-watched character every round), kid outfits, "chaos finisher" effects (custom smash splat / sound when you cause the biggest mess — everyone sees it), Report-Card frames, cosmetic season pass, "Host House" rule (the host's owned house theme is used for the round — visible purchase, giftable), R15 avatars for adult DevEx, rewarded video for a bonus Fun multiplier (one per session). No paid gameplay power.
**Social/viral:** 1vN betrayal (snitching), absurd hiding, Parent catching a kid mid-sneak; the Report Card is a ready-made clip.
**Competition:** "Clean the House!" (Snowy Interactive, ~6K peak, PvE chore game — same theme, different structure); Granny-likes; Flee the Facility.
**Tech:** ~40 server-tagged evidence objects, hotspot table per room, client-side debris; no free physics hiding; scent/blacklight are visual reveals of server data.

## R2-02 — PADDLE PANIC (redesign of C03 Raft Rush)
**Pitch:** Up to six friends, one ridiculous raft, everyone controls one paddle — steer together or spin into the waterfall.
**Genre:** Co-op/versus party racing. **Inspiration:** Fart Together (Steam top-20 Next Fest; a crude Roblox copy hit 13M+ visits before takedown), RV There Yet?, Overcooked.
**Core:** The raft is a kinematic controller on a procedural river spline (lateral offset, yaw, speed), stepped on the server and predicted on each client — no physics ownership problem. Each seat has a HOLD-to-paddle button pushing in that seat's direction, plus one contextual verb that changes with what's next to your seat: BAIL water (raft sinks lower and slows), BONK a crocodile, GRAB a floating coin/star, BRACE before a drop. Players can hop to an empty seat (tap seat icon).
**Courses:** Rivers are assembled from ~30 modular segments (rapids, log jam, croc lagoon, whirlpool, waterfall, cave, ice floe) with a daily seed; 3–4 minute runs; checkpoints.
**Vehicles = the depth layer:** each has a different seat/thruster layout and propulsion gimmick — bathtub (4 seats, sneezing walrus), shopping-cart rocket (soda-bottle bursts, overshoots), inflatable duck (6 seats, bouncy), hot-air balloon "river" in the sky (altitude instead of yaw). New absurd vehicle every 2 weeks. All vehicles earnable; premium ones also directly buyable.
**Modes:** Co-op Time Trial (medals + friends' ghost rafts), Raft Race (2–4 rafts, bump each other), Daily Seed Ranked (crew leaderboard), 2-player "Tandem" for small groups; bots fill empty seats with simple AI.
**Feedback:** Each seat shows a big coloured arrow when paddling; post-run "WHO SANK US?" card shows each player's input timeline; slow-mo wipeout cam on falls.
**Progression:** Vehicle collection, crew level, medals per segment type, cosmetic crew badges.
**Mobile:** One big HOLD button (bottom-right, replacing jump) + one contextual verb button above it; auto camera; no thumbstick.
**Monetization:** "Captain rule": the host's owned raft + skin + wake trail is used by the whole crew (purchase is seen by everyone, giftable); vehicle skins; wake trails; crew badge cosmetics; premium vehicle shortcuts (all earnable); cosmetic season pass.
**Competition:** Boat Together [1–6 Player] (~8.2M visits, row-in-sync boat); Backseat Rally (role-split rally).

## R2-03 — STATUE SHUFFLE (redesign of C19)
**Pitch:** At night, the museum statues come alive — pull pranks behind the guard's back and freeze the instant the flashlight hits you.
**Genre:** Asymmetric Red-Light-Green-Light + hide-in-plain-sight. **Inspiration:** Worst Class Ever (#1 Oct 2026 Next Fest), Be NPC or Die, Red Light Green Light.
**Core rule:** Tagging is ONLY possible inside the Guard's flashlight beam, and the flashlight has a limited battery (recharge at charging stations). Statues release the thumbstick → instantly freeze (server-confirmed with 0.3 s grace). Each statue spawns on a plinth with a pose placard; when frozen you snap to your pose — if you freeze OFF your plinth you stand out. ~30 NPC statues also slowly shift poses so movement alone isn't proof.
**Mischief:** Shared Mischief meter filled by pranks (glowing targets): swap paintings, draw a moustache on a portrait (preset stamp, not free drawing), stack the knight's helmet on the T-rex, set off the cuckoo clock (distracts the guard). Physics pranks: knock a vase off a pedestal — loud, Guard hears it.
**Guard tools (loadouts, earned):** wide beam vs long beam flashlight, motion-sensor tripwire, "Night Camera" that photographs one room, whistle that makes everything freeze for 2 s. Wrong tags cost battery.
**Round:** 4 minutes. Statues win if the Mischief meter fills; Guard wins by tagging all or surviving the timer.
**End-of-round:** "Caught on Camera" security-footage reel of the best pranks the Guard missed.
**Variety:** museum wings shuffle each round (Egypt, Dinosaurs, Knights, Space); NPC behaviour sets rotate; weekly "Exhibit" event with new prank set.
**Progression:** statue unlocks (mummy, knight, dinosaur skeleton, astronaut), statue abilities (earned: Dust Cloud, Fake Crack, Echo Footsteps), guard gadgets, ranked Guard ladder.
**Mobile:** Thumbstick + Prank button; release stick = freeze. Guard: flashlight follows camera direction with a wide cone; recently-moved statues get a faint shimmer only the Guard sees.
**Monetization:** Statue skins are "disguise packs": equipping a skin spawns matching NPC statues that round (skins never make you stand out); prank-effect cosmetics (moustache styles, confetti) shown when the Guard discovers the prank; Guard costumes; cosmetic pass.
**Competition:** Be NPC or Die, DISGUISE, In Plain Sight, Prank the Teacher.

## R2-04 — SCRIBBLE SPELLS (redesign of C09)
**Pitch:** Draw a rune with your finger to cast a spell — and when two friends draw at the same time, the spells fuse into something huge.
**Genre:** Co-op roguelite wave defence with gesture input. **Inspiration:** YAPYAP (1M sold in 6 weeks; performative input), Magicka (spell combining), Fruit Ninja (gesture feel).
**Core:** Up to 4 apprentices stand on fixed tower balconies — NO movement, no thumbstick, no camera control. The whole screen is the drawing pad; spells auto-target the nearest enemy lane. Six bold, forgiving runes at launch (circle = shield, zigzag = lightning, spiral = whirlwind, V = fire, line = ice spear, heart = heal), shown as faint trace guides for the first runs. Sloppy shapes still cast at partial power (never a "nothing happened"). Hilarious misfire table for very sloppy traces (lightning becomes a rubber chicken; whirlwind spins your teammate's hat off).
**Fusion:** If two players cast within 1 second, the spells fuse (fire + whirlwind = firenado; ice + lightning = frozen storm; heal + shield = bubble dome) with a big named banner. Discovering fusions fills the Rune Book (collection log of 30 fusions).
**Run (6–8 min):** waves of cartoon monsters with a boss every 4th wave; between waves each player drafts 1 of 3 relics (e.g., "lightning chains once more", "fire leaves lava puddles"); weekly mutator (e.g., "enemies are invisible until frozen").
**Progression:** new rune unlocks (earned), wizard schools (sidegrade starting relic sets), tower decorations, endless-mode leaderboard, ranked "Trial" seeds.
**Mobile:** native touch-first; landscape full-screen drawing; trace trail preview; PC uses mouse drag.
**Monetization:** ink-trail cosmetics (your rune trail colour/pattern, seen by everyone and on fusions), fusion VFX skins (your colour in the firenado), robes/hats/staffs, tower themes via Captain rule, cosmetic season pass; schools purchasable as shortcuts but all earnable.
**Policy:** traces are ephemeral (vanish in 0.5 s) and only classify into fixed runes → not free-form drawing.
**Competition:** Draw Spells Magic Arena (PvP, ~615 CCU snapshot).

## R2-05 — FORGER NIGHT (redesign of C04 Fake or Fortune)
**Pitch:** Run an antique shop with friends — but one of you is secretly the forger slipping fakes onto the shelves.
**Genre:** Social deduction + shop sim. **Inspiration:** Probably Stolen (660K+ demo players), Papers, Please, Among Us.
**Core round (6 min, 4–8 players):** Customers bring items; players inspect with a tool (each player gets ONE tool per round: magnifier, UV lamp, scale, sniffer-dog) and press BUY or REJECT. Tells are purely visual and glow when the right tool passes over them (wrong-colour stamp, no UV glow, weight icon red). Catalogue = side-by-side picture card, no text. One or two players are secretly FORGERS: they swap genuine items for fakes in the back room, plant fakes, and can "vouch" for a fake. Each sale of a fake damages the shop. Any player can call an "Appraisal Meeting" (stamp-based evidence board: who touched what item, shown as icons) and vote.
**Reveal:** Fake items are unmasked with a visual punchline (vase shatters revealing "MADE IN 2026" sticker; fossil is chicken bones).
**Solo/co-op mode:** "Open Shop" PvE with adaptive NPC forgers who learn which tells players catch and change technique weekly.
**Progression:** visitable personal museum of genuine rare items (earned, seasonal "Treasure Sets"), shop reputation, forger mastery, tool sidegrades (earned).
**Mobile:** tap item → item fills screen → drag tool → BUY/REJECT; evidence board is tap-to-accuse.
**Monetization:** museum display cases/plaques (visitable), shop themes (Captain rule), forger "calling cards" seen at the reveal, outfits.
**Competition:** "Fake a Masterpiece" (tiny); MM2 / Among-Us-likes for the deduction audience.

## R2-06 — NIGHT DESK (redesign of C01)
**Pitch:** One friend watches the cameras and sees what others can't; everyone else patrols the haunted motel and must trust their pings.
**Genre:** Co-op anomaly horror with information asymmetry. **Inspiration:** I'm on Observation Duty, Exit 8, Sell Fries!.
**Core:** Day phase removed. Each night (4 min) the Watcher sits at CCTV (tap-grid of static thumbnails; tap one = live feed) and is the ONLY one who can see anomalies on camera; Patrollers walk the motel and can see anomalies only up close, dimly. The Watcher pings a camera → Patrollers get a direction arrow; a Patroller taps the anomaly to report (no category pick). Two-person confirm for big anomalies. Missed anomalies escalate into a chase.
**Content:** anomalies built from 6 data primitives (swap, move, tint, animate, spawn, sound) × targets → hundreds of combinations without new art; 40 hand-made "signature" anomalies. Endless "Graveyard Shift" mode with score.
**Progression:** motel wings, Anomaly Field Guide, staff rank.
**Monetization:** decorate-your-motel-lobby (visible between nights), uniforms, flashlight skins, revive (once/night, rewarded video or product).
**Competition:** Sell Fries!, 7 Days Cat-Sitting, licensed Exit 8 (8-player co-op), many anomaly games — the most crowded lane.

## R2-07 — GHOST VLOG (redesign of C08)
**Pitch:** Film ghosts with your friends — at the end you watch the replay of your crew screaming, flailing and getting dragged off.
**Genre:** Co-op horror-comedy. **Inspiration:** Content Warning (6M+ free claims).
**Core:** 6-minute expedition; camera holder sees a live "VIEWS" counter and "SPOOKY SHOT +500" pop-ups the instant a ghost event is in frame (generous auto-framing). Server records character CFrames/emotes/ragdolls at 10 Hz while recording; the lobby theatre plays a real 3D replay of the best 30 seconds, ending on a fake comments screen. Daily "sponsor contracts" (film the ghost stealing a hat).
**Progression:** subscriber count, studio upgrades, camera gear (earned), ghost catalogue.
**Monetization:** channel branding (intro stingers, logos, montage filters seen by the whole lobby), visitable studio, outfits.
**Competition:** several small Content-Warning-likes on Roblox; ghost hunts crowded.

## R2-08 — HANDLE WITH CARE (redesign of C14 Fragile Express)
**Pitch:** Deliver wobbling wedding cakes, sloshing aquariums and sleeping baby dragons through obstacle-filled houses — every bump costs you the tip.
**Genre:** Co-op physics-comedy delivery. **Inspiration:** R.E.P.O. value meter, Totally Reliable Delivery Service, Overcooked.
**Core:** No driving (van ride is a 5-s cutscene). Shifts of 3 deliveries (≈5 min). Each parcel has a floating value meter and its own handling rule: cake sags if you run, aquarium sloshes on turns, dragon wakes if bumped twice, grandfather clock needs 2 carriers (scripted "linked carry": both players hold one button; movement is the average of both sticks, server-side). Auto-grab nearest. Hazards: dogs, sprinklers, revolving doors, toddlers, stairs. Perfect delivery → customer throws a bonus item.
**Modes:** Co-op shifts; Versus Couriers (2 teams same street, sabotage pickups like banana peels).
**Progression:** procedural neighbourhoods from modular house kits; daily order board; rare-parcel collection log; courier rank.
**Monetization:** signature parcel wraps + customer-reaction effects seen on perfect deliveries; uniforms; agency HQ decoration; cosmetic pass.
**Competition:** Carry the Glass Together, Don't Shatter (small), delivery sims.

## R2-09 — CRITTER CLASH (merge of C10 Critter Lineage + C15 Toybox Knockout)
**Pitch:** Breed the weirdest critters, then send your team into 4-player knockout brawls where one tap at the right moment wins the fight.
**Genre:** Creature collection + quick auto-battler. **Inspiration:** Mewgenics (inheritance), Clash Royale Merge Tactics, Pokémon.
**Core match (4 min, 4 players, bots fill):** Each player brings 3 critters. Rounds: drag critters onto a 3×3 board (or tap AUTO-PLACE) → fight auto-plays → each player has ONE live tap ability per round (critter's signature move — timing matters). A big "your power vs theirs" bar before each fight. Lowest HP after each round is knocked out; knocked-out players become "gremlins" who drop hazards on remaining boards.
**Meta:** After matches, critters that won fights earn "hearts"; pair two critters at the nest → hatchling inherits one trait icon from each parent plus a guaranteed loud VISUAL mutation (extra legs change attack pattern, fish tail, three heads) — mutations are earned, never sold. Family tree shown as a swipeable card stack; cross-breed with a friend's critter (both get a hatchling).
**Progression:** mutation collection log (150 mutations), lineage banners, ranked season.
**Mobile:** drag/tap only; no avatar movement.
**Monetization:** nest themes, critter accessories (deterministic), extra nest slots (convenience), lineage name banners, gifting critters, cosmetic battle pass.
**Competition:** pet sims, Units Battlegrounds, Merge a Mini Army.

## R2-10 — FUSE FRIENDS (redesign of C02)
**Pitch:** One friend sees the bomb, one friend reads the picture-manual — defuse the party cannon using only pointing and stickers.
**Genre:** Asymmetric co-op puzzle. **Inspiration:** BOMBANANA! (675K+ demo players), Keep Talking.
**Core:** 2-player is the main mode (Eyes+Hands vs Book); 3-player variant unlocks later; bots backfill drop-outs. Manual is 100% pictographic (symbol → colour → action); the 8 stamps on the wheel are the same symbols used in the manual, so relaying = tapping the matching stamp. 60–90 s devices; failure is a cartoon confetti blast launching both players out the window. Solo daily puzzle. 25 module types; rulebook rotates each season.
**Monetization:** squad device skins (buyer reskins the device and blast for the session), sticker-stamp art packs (functional symbols identical, art cosmetic), outfits.
**Competition:** none found on Roblox.

## R2-11 — MAYDAY CREW (redesign of C12)
**Pitch:** Your airship is falling apart — run around the cabin putting out fires, patching holes and cranking the landing gear before you crash.
**Genre:** Overcooked-style co-op crisis on a vehicle. **Inspiration:** Overcooked, IRON NEST, FTL.
**Core:** 2–6 crew; flight is semi-scripted along a route spline; the pilot steers within a corridor (drag yoke). Everyone else physically runs between stations: extinguisher, patch kit, pump, crank, fuel. Failures cascade (fire spreads to the fuel line). Every emergency is a big flashing icon above the station. Roles rotate at checkpoints. Landing mini-game; spectacular survivable crashes.
**Progression:** airship, submarine, rocket, train; routes; crew rank.
**Monetization:** vehicle liveries (Captain rule), crew outfits, vehicle shortcuts (earnable).
**Competition:** Land or Die!, Survive the Plane Crash, Backseat Rally.

## R2-12 — BLAZE BRIGADE: CRITTER RESCUE (new)
**Pitch:** Fight fires with your squad and rescue the animals trapped inside — every critter you save moves into your sanctuary.
**Genre:** Co-op action rescue + creature collection. **Inspiration:** Overcooked (chaos roles), Flash Point: Fire Rescue (board game), Pet Simulator collection appeal, PowerWash Simulator satisfaction.
**Core run (5 min, 1–4 players, bots optional):** Procedural building assembled from modular rooms (house, pet shop, zoo, school). Fire spreads on a server grid; smoke hides rooms. Each player has a hose (auto-aim at nearest flames while you hold SPRAY) and a contextual RESCUE button (auto-grabs nearest critter/hydrant/axe-door). Carry critters to the ambulance; some need two players (panicked elephant calf) or tools (bird stuck on a shelf → ladder). Floors collapse after a timer; last-second rescues.
**Collection:** every rescued critter (deterministic per building type + rare "special guests" that appear in harder buildings — earned, never sold) moves into your visitable Sanctuary, where friends can visit and play with them. Critter Log has 120 critters across seasons.
**Progression:** brigade rank, building difficulty tiers (1–5 alarm), truck upgrades (sidegrades: ladder truck vs water tanker), sanctuary expansions.
**Mobile:** thumbstick + HOLD SPRAY (auto-aim) + RESCUE button; fixed elevated camera that fades walls.
**Monetization:** sanctuary habitats/decor (visitable), critter accessories, firefighter uniforms & hose effects (rainbow water), truck liveries (Captain rule), sanctuary expansions (also earnable), cosmetic pass, rewarded video for an extra rescue-bonus.
**Social/viral:** collapsing floors, the elephant-calf two-person carry, a hose fight in the sanctuary.
**Competition:** firefighter roleplay (Emergency Response: Liberty County etc.), Firefighter simulators; none known combining procedural co-op rescue with collection (unverified).
**Tech:** grid fire spread (server), raycast spray, modular rooms, critter carry as scripted attach.
