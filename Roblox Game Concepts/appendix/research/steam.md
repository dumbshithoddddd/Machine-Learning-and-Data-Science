# Steam Indie Scan: Mechanics Worth Bringing to Roblox (research date 2026-11-13)

## Method and caveats
- **Tooling limit:** WebFetch could not reach the publishers (pcgamer.com, gamesradar.com and newsletter.gamediscover.co would not resolve in this sandbox). Everything below comes from **web-search result summaries**, so I could not open the primary pages myself. Treat every figure as "reported by [source]", not as something I checked against SteamDB.
- **Data quality:** Figures from SteamDB-derived press (PC Gamer, Notebookcheck, PCGamesN, Gematsu, Insider Gaming, 80.lv) count as **evidence**. Figures that come only from aggregators (raijin.gg, tracker.gg, steambase, datahumble) or SEO/fan sites are marked **(aggregator)** or **unverified**. Several search hits came from spam-mirror domains (for example berkeleyhistoricalsociety.org and notices.mce.ca.gov), and I excluded them.
- **Next Fest rankings disagree.** Valve ranks by unique players, while Output Lag ranks by peak concurrent players. Both are noted where relevant.
- **Labels:** "Roblox analogue" says whether I found evidence of a similar Roblox experience. "Speculation" marks my own design reasoning.

---

## A. Proven 2026 breakouts (released)

### 1. How to Fish (Dazed Games), released 2026-08-20, $4.95
- **Evidence:** SteamDB all-time peak of about 373,971 CCU on Aug 26, reported via search summary of [dlcompare](https://www.dlcompare.com/gaming-news/how-to-fish-player-count-drops-but-isn-t-that-normal) and [GamesRadar](https://www.gamesradar.com/games/co-op/amid-the-friendslop-renaissance-usd5-co-op-fishing-game-hits-370-000-peak-players-on-steam-in-5-days/) (about 370.9k). [Niche Gamer](https://nichegamer.com/how-to-fish-attracts-one-million-players-in-two-days/) reports 1M players in 2 days.
- **Core loop:** Physics fishing → kill or sell the catch → buy gear → quests and island bosses → unlock new islands.
- **Unique mechanic:** The catch is a physics object. Players can launch a fish into the air and shoot it for a **trick-shot money multiplier** ([PC Gamer](https://www.pcgamer.com/games/sim/the-latest-cooperative-craze-is-a-physics-based-fishing-simulator-where-you-can-launch-your-catch-into-the-air-and-no-scope-it-with-a-sniper-rifle/)). Line tension also matters on big fish.
- **Memorable moments:** Unscripted physics comedy, mid-air no-scopes, and group boss fights.
- **What to adapt:** Fishing is already saturated on Roblox ([Fish It! reportedly ~273k CCU](https://rowatcher.com/news/fish-it-reels-in-270k-players-inside-roblox-s-most-addictive-casual-game-of-2026)). The *new* part is "the reward is a physics object you can style on before you bank it." This can carry over to any collect-and-sell sim (fruit, ore, pets).
- **Kid/mobile changes:** Swap guns for a slingshot or bubble wand, and use a one-thumb flick to launch. Reaching the multiplier should take a single tap.
- **Roblox analogue:** The fishing genre exists. I found no evidence of a trick-shot style multiplier.

### 2. Meccha Chameleon (2-person team), released June 2026, about $5.99
- **Evidence:** Peak of 340,535 CCU per [OpenCritic](https://opencritic.com/news/33692/meccha-chameleon-splashes-past-ten-million-copies-sold-into-steams-top-five-most-played-games). [Windows Central](https://www.windowscentral.com/gaming/the-viral-hit-of-2026-has-sold-15-million-copies-in-a-month-on-steam-costs-usd5-and-was-made-by-2-people) reports 15M copies in a month. [Outlook Respawn](https://respawn.outlookindia.com/gaming/gaming-news/meccha-chameleon-hits-20m-sales-with-22k-daily-players) reports 20M by mid-August.
- **Core loop:** Hiders paint their white bodies using an eyedropper and MS-Paint tools, pose, and freeze. Hunters search, and each tagged hider joins the hunters ([allthings.how](https://allthings.how/meccha-chameleon-how-the-paint-to-hide-game-works-pc/)).
- **Why people care:** Creative expression *is* the hiding skill, and the reveals make great clips.
- **Roblox analogue:** **Already heavily cloned.** [games.gg](https://games.gg/news/roblox-clones-meccha-chameleon-more-players/) reports the Roblox clones pulling 150k–200k+ players, and a paid clone kit is sold on [BuiltByBit](https://builtbybit.com/resources/meccha-chameleon-paint-hide-and-seek.116392/). **Avoid a direct clone.** The principle worth keeping is "player-authored disguise."

### 3. BOMBANANA! (Lefto Studio / TARK), Next Fest June 2026 #1 demo, released 2026-09-02, $7.99
- **Evidence:** Most-played demo of June Next Fest. [Niche Gamer](https://nichegamer.com/bombanana-demo-tops-675000-players-during-steam-next-fest/) reports 675k+ demo players. [Game Developer PR](https://www.gamedeveloper.com/press-release/bombanana-celebrate-1-million-wishlists-by-announcing-release-date-set-your-countdown-for-2-september-2026-) reports 1M wishlists.
- **Core loop:** Exactly 3 players defuse bombs, and each has a sensory handicap. The **Blind** monkey can touch the bomb but cannot see. The **Mute** monkey reads the manual but cannot speak. The **Deaf** monkey sees the bomb but cannot hear ([co-optimus](https://www.co-optimus.com/article/17868/3-player-bomb-defusing-game-bombanana-arrives-on-steam.html), [TechTimes](https://www.techtimes.com/articles/326359/20260902/bombanana-hits-steam-799-three-way-asymmetric-co-op-outdoes-keep-talking.htm)).
- **Unique mechanic:** A *cyclic* information chain (A→B→C→A), so every player is a bottleneck.
- **What to adapt:** Asymmetric information split across 3 roles, with gestures and emotes as the channel.
- **Kid/mobile changes:** This **fits well with no voice.** Make emotes, pointing and drawn symbols the *only* channel, and use a big touch-friendly radial emote wheel. Replace the bomb with a cake about to explode or a rocket launch countdown.
- **Roblox analogue:** None found (unverified; my search found nothing).

### 4. YAPYAP, released 2026-02-03, about $9.99
- **Evidence:** 500k sales in week 1 per [consolepcgaming](https://consolepcgaming.com/yapyap-reaches-500000-sales-in-its-first-week-on-steam/), and GameDiscoverCo headlines [1M in 6 weeks](https://newsletter.gamediscover.co/p/how-yapyap-jammed-its-way-to-1-million). Launch peak of about 8,661 CCU (single outlet, unverified).
- **Core loop:** Up to 6 wizards cast spells by *speaking* incantations into the mic while wrecking a procedural tower.
- **Kid/mobile changes:** Voice is not usable for minors. **Replace it with gesture or drawing spells:** trace a rune on the touchscreen, and accuracy sets power. The "performative input" fun survives.
- **Roblox analogue:** Unverified.

### 5. RV There Yet? (Nuggets Entertainment), released 2025-10-21
- **Evidence:** About 100k CCU per [PC Gamer](https://www.pcgamer.com/games/adventure/a-game-jam-game-about-pudgy-chainsmoking-dads-seems-to-be-steams-latest-co-op-hit-hitting-100-000-concurrent-players-on-its-first-weekend) and [GamesRadar](https://www.gamesradar.com/games/co-op/with-a-peak-of-100-000-concurrent-players-sending-it-straight-into-steams-best-sellers-chart-the-latest-indie-hit-is-a-silly-physics-based-co-op-game-about-driving-an-rv). [wnhub](https://wnhub.io/news/stores-and-publishing/item-49142) reports 1.3M sold in week 1.
- **Mechanic:** 4 players share one fragile physics vehicle and use a winch to get past terrain. The memorable moments come from shared failure.
- **Roblox analogue:** Unverified. Roblox has many vehicle and obby games, and I found no confirmed equivalent of a shared co-op vehicle with a winch.

### 6. Big Walk (House House), released 2026-08-04
- **Evidence:** Steam peak of 46,409 and 1M sold in 6 days ([Outlook Respawn](https://respawn.outlookindia.com/gaming/gaming-news/big-walk-hits-1m-sales-in-6-days-outpacing-goose-game)). [mein-mmo](https://mein-mmo.de/en/creators-of-an-indie-hit-release-their-new-coop-game-on-steam-immediately-reaches-91-percent-positive,1581722/) reports a 91–95% positive rating. Supports 2–12 players.
- **Unique mechanic:** **Communication itself is the terrain.** Voices fade, muffle and echo, and text chat follows the same range rules. Tools include flares, megaphones, walkie-talkies, laser pointers, whiteboards and cowbells ([PC Gamer](https://www.pcgamer.com/games/puzzle/untitled-goose-game-studio-unpacks-its-new-open-world-co-op-game-big-walk-and-it-looks-like-nothing-else-ive-played-before), [press kit](https://bigwalk.game/presskit)).
- **Kid/mobile changes:** Make non-verbal tools (pings, flares, laser dots, whiteboard stamps) the core design, which the official site says is already viable without a mic.
- **Roblox analogue:** None found.

### 7. Escape from Duckov (Team Soda / bilibili), released Oct 2025
- **Evidence:** About 300k CCU peak per [GamesRadar](https://www.gamesradar.com/games/third-person-shooter/duck-based-extraction-shooter-escape-from-duckov-was-one-of-the-biggest-games-on-steam-over-the-weekend-beating-the-likes-of-battlefield-6-thanks-to-a-peak-of-300-000-concurrent-players). [Gematsu](https://www.gematsu.com/2025/10/escape-from-duckov-sales-top-one-million) reports 1M sold in under a week.
- **Mechanic:** Cute-skinned **PvE** single-player extraction (raid → loot → extract or lose it → upgrade base).
- **Takeaway:** The extraction tension does not require PvP griefing. That suits kids.
- **Roblox analogue:** Extraction games exist on Roblox (unverified specifics).

### 8. Megabonk, released 2025-09-18
- **Evidence:** 117,336 CCU peak, beating Hades II ([Notebookcheck](https://www.notebookcheck.net/Megabonk-beats-Hades-2-s-all-time-record-as-it-morphs-into-Steam-s-new-indie-sensation.1136297.0.html)). [GameWorldObserver](https://gameworldobserver.com/2025/10/03/megabonk-is-a-new-indie-hit-on-steam-the-games-sales-have-surpassed-one-million-copies) reports 1M sold in 2 weeks.
- **Mechanic:** A 3D survivors-like with auto-attack, so players only steer and pick upgrades. That suits touch controls.
- **Roblox analogue:** Survivors-likes exist on Roblox (unverified scale).

### 9. Mewgenics (Edmund McMillen / Tyler Glaiel), released 2026-02-10
- **Evidence:** 115,428 CCU peak, above Hades II, per [PCGamesN](https://www.pcgamesn.com/mew-genics/concurrent-player-count-hades). [GamingOnLinux](https://www.gamingonlinux.com/2026/02/mewgenics-is-a-clear-hit-reaching-over-a-million-sales) reports 1M+ sales.
- **Mechanic:** Tactical roguelike in which surviving cats **breed between runs**. Offspring inherit traits, abilities and mutations.
- **What to adapt:** Breeding and inheritance as the meta-progression, so a run's survivors seed the next generation. Roblox pet games have hatching, and inheritance with mutation adds a reason to keep losing pets around.
- **Kid changes:** Remove crude humour. Present it as "family tree" or "fusion" rather than breeding.

### 10. Voidling Bound, released 2026-06-09
- **Evidence:** All-time peak of about 8,600 CCU **(aggregator)** ([steambase](https://steambase.io/games/voidling-bound)). About 400k pre-launch wishlists (single source, unverified).
- **Mechanic:** Hatch, evolve and upgrade creatures, then **directly pilot** them in third-person shooting.
- **What to adapt:** Possession or ride-as-your-pet combat as a twist on Roblox pet sims.

### 11. Far Far West (Evil Raptor / Fireshine), Early Access 2026-04-28
- **Evidence:** 1M sold in under 2 weeks per publisher ([pulse.bot](https://www.pulse.bot/gaming/news/futuristic-wild-west-co-op-shooter-far-far-west-gets-first-major-update-and-hits-1-million-in-sales-69958093-0d01-4487-8775-84266ccf044a/)). Peak of about 47k CCU **(aggregator, unverified)**.
- **Mechanic:** 4-player PvE co-op shooter with a strong theme (robot cowboys versus monsters).
- **Takeaway:** Theme plus co-op PvE carries a standard loop. Its mechanics are the least novel on this list.

### 12. BALL x PIT (Kenny Sun / Devolver), released 2025-10-15
- **Evidence:** About 35k CCU peak **(steamcharts)**. Over 2M purchases in under a year per [wnhub](https://wnhub.io/news/investment/item-51689).
- **Mechanic:** Breakout-style ball bouncing as a roguelite. *Ball fusion and the base-building between runs come from my prior knowledge, not from this search.*
- **What to adapt:** A one-input aim mechanic that suits phones, with combinatorial upgrades.

---

## B. Next Fest standouts (Oct 19–26 and June 2026), upcoming or just launched

### 13. Worst Class Ever (Funcore Games), Oct 2026 Next Fest #1 by unique players, released 2026-11-09, about $6.99
- **Evidence:** #1 on Valve's list per [Inven Global](https://www.invenglobal.com/articles/27767/steam-next-fest-top-50-most-played-demos-revealed-worst-class-ever-takes-1st-place) and [GamingTrend](https://gamingtrend.com/news/here-are-the-20-most-played-demos-from-octobers-steam-next-fest/). Peak of 27,684 CCU per [Output Lag](https://outputlag.com/news/steam-next-fest-october-2026-the-most-played-demos-by-the-numbers/). A Japanese outlet reports 300k demo players in 10 days ([gaming-st](https://gaming-st.com/pc-games/worst-class-ever-demo-players-japanese/)).
- **Core loop:** 1 teacher versus up to 5–7 students hidden among about 20 NPC classmates. Students pull pranks to fill a shared **Mischief meter**. The teacher identifies and "dunces" the real players before the timer runs out. Classes alternate between break and class phases ([wikily.gg](https://wikily.gg/worst-class-ever/how-a-class-works), fan wiki).
- **Memorable moments:** Pulling a prank in the teacher's blind spot, and the teacher's wrong accusations.
- **Kid/mobile changes:** The theme already suits kids. Use touch-friendly prank buttons and a "freeze and look innocent" button.
- **Roblox analogue:** **Partial.** Roblox has [Be NPC or Die](https://www.distractify.com/p/roblox-game-among-us-npcs), DISGUISE, In Plain Sight, and a Prank the Teacher game. The *combination* (blend in **while** filling a shared objective meter, with a phase rhythm) may be less covered (speculation).

### 14. Probably Stolen – Cyberpunk Shopkeeper Sim (Questing Goose / tinyBuild), released 2026-10-28
- **Evidence:** Per tinyBuild, 660k+ demo players, 98% positive, and about 40k CCU during Next Fest ([search summary](https://www.gematsu.com/2026/09/probably-stolen-launches-october-28)). Output Lag reports a 39,696 peak.
- **Core loop:** Buy, appraise and sell goods to make rent and eventually buy the shop. Starting professions include gunsmith, chemist and fence.
- **Unique mechanic:** **Authenticity and risk.** You inspect goods and can cut quality or pass off fakes, and one bust can end the run. It also has *AI impostors posing as customers*, compared to "Papers, Please" by [80.lv](https://80.lv/articles/this-new-shopkeeping-sim-is-like-cyberpunk-2077-meets-papers-please).
- **What to adapt:** Inspect-and-spot-the-fake as a shop-tycoon minigame, with a "suspicious customer" detection layer.
- **Kid changes:** Drop the smuggling and drug themes. Recast it as an antique, fossil or toy appraiser who catches counterfeits, so the player is the detective rather than the fraudster.
- **Roblox analogue:** Shop tycoons are common. I found no evidence of a Roblox game built on inspection or counterfeit detection (unverified).

### 15. Find The Needle (Needless Games?), #4 on Valve's Oct list per GamingTrend, release TBD
- **Evidence:** Demo peak of about 8,600 CCU per [PC Games (DE)](https://www.pcgames.de/Spiele-Thema-239104/News/Find-the-Needle-Automatisierung-Demo-Spielerzahl-1554903/). Release date conflicts between Q4 2026 and 2027 (unverified).
- **Mechanic:** First-person **incremental automation** around an absurd goal: find 24 needles in a haystack of millions of strands by building Satisfactory-style hay-processing lines ([Kotaku listing](https://kotaku.com/games/find-the-needle)).
- **What to adapt:** A meme-simple goal with a huge visible quantity, plus automation that visibly shrinks the pile. Server-wide progress on one giant pile would make it social (speculation).
- **Roblox analogue:** Browser "needle in haystack" clickers exist on Poki and CrazyGames. A Roblox automation version is unverified.

### 16. Fart Together (GamesMrkt), Valve Oct top-20, Early Access 2026-10-29
- **Evidence:** Top-20 demo per [PCGH](https://www.pcgameshardware.de/Steam-Software-69900/News/Nilpferde-pupsen-sich-zum-Erfolg-Koop-Spiel-mit-4000-Spielern-1557701/), with nearly 4k CCU.
- **Mechanic:** 1–4 hippos steer **one shared raft** with individual thrust bursts through a physics obstacle course, plus competitive modes for up to 8 players.
- **What to adapt:** Each player controls one thruster on a shared vehicle, which forces coordination with almost no UI. That suits kids, and toilet humour lands with the young audience. A dignified reskin option is jetpacks or balloons.
- **Roblox analogue:** Unverified.

### 17. No Body No Problem! (Crime Cleanup Co. / Red Axe Games), top 5 on gg.deals' Oct list, coming soon
- **Evidence:** Listed in the [gg.deals top 50](https://gg.deals/gaming-news/here-are-the-50-most-played-demos-from-steams-october-2026-next-fest/). No other figures found.
- **Mechanic:** 3 suspects versus 1 officer in **physics social stealth**: hide the evidence and act normal ([Steam](https://store.steampowered.com/app/4954970)).
- **Kid changes:** Reframe as "hide the broken vase or the cookie crumbs before Mom checks", keeping the physics-hiding plus bluffing.
- **Roblox analogue:** None found.

### 18. Dumpster Gang (Coyote House / Curve), demo now, launches 2026-12-03 (Game Pass)
- **Evidence:** No numeric figures found. Coverage comes from [Gematsu](https://www.gematsu.com/2026/10/dumpster-gang-launches-december-3) and [Inven](https://www.invenglobal.com/articles/27367/raccoon-co-op-sandbox-dumpster-gang-heads-to-pc-game-pass-on-december-3rd).
- **Mechanic:** 1–4 raccoons loot houses, carry heavy loot together, rescue captured teammates and dodge an exterminator.
- **Takeaway:** This is the R.E.P.O. loop with a cute theme. Rescuing teammates makes a downed player a group objective instead of spectating.
- **Roblox analogue:** R.E.P.O.-style games exist on Roblox (unverified specifics).

### 19. HANDS OVER (ArtDock), Valve Oct top-20, Early Access around 2026-10-30
- **Evidence:** In the Valve top-20 per Techtroduce/GamingTrend. Rated 18+ ([GamePressure](https://www.gamepressure.com/games/hands-over/z374e3)).
- **Mechanic:** Childhood games ("Kroko Doc" style) twisted into lethal bluff-and-sabotage rounds for 5 players ([Bloody Disgusting](https://bloody-disgusting.com/video-games/3953532/familiar-party-game-turns-gruesome-in-hands-over-trailer/)).
- **Kid changes:** Remove the gore and keep "familiar toy game plus a hidden saboteur" (slime instead of blood).

### 20. Demon Bluff (UmiArt / offbrand, Northernlion), launching Nov 2026
- **Evidence:** Nearly 300k playtest players averaging about 6 hours (single report via [Thinky Games](https://thinkygames.com/news/deduce-which-villagers-are-good-or-evil-in-this-upcoming-roguelite-game-of-demonic-bluffing/) search summary, unverified).
- **Mechanic:** **Single-player social deduction.** Villager cards give clues, some of them lies, and you deduce the demons with logic, plus a roguelite deck of villagers.
- **What to adapt:** A daily logic-deduction puzzle that can be played solo or shared, with no chat moderation needed.

### 21. IRON NEST: Heavy Turret Simulator, June 2026 Next Fest #2
- **Evidence:** #2 on Valve's June list. The demo is rated Overwhelmingly Positive (3,768 reviews, per [vaporlens](https://vaporlens.app/app/4300500/iron_nest_heavy_turret_simulator_demo.md), aggregator).
- **Mechanic:** Diegetic control. Coordinates arrive by radio, and you set the charge and shell type with levers and dials. There is no hand-holding ([Game*Spark](https://www.gamespark.jp/article/2026/06/16/168040.html)).
- **What to adapt:** Multi-step physical "control panel" procedures shared across a crew, like a submarine or train cockpit.

### 22. just volleyball (temkosoft), Valve Oct top-20, launched around 2026-11-04 (unverified)
- **Mechanic:** Every touch goes where the cursor points, with no fixed positions, scaling from 1v1 to 6v6 ([mein-mmo](https://mein-mmo.de/steam-next-fest-oktober-2026-top-10/5/)).
- **What to adapt:** A one-input sports game (tap where the ball goes) that scales from duel to team. It suits mobile.

---

## C. Patterns across the list (evidence plus speculation)
1. **Cheap, small and co-op dominates.** How to Fish ($4.95), Meccha Chameleon (about $6), BOMBANANA ($7.99) and Worst Class Ever (about $6.99) are all low-priced, session-based and streamer-friendly. This is evidence, from the figures above.
2. **Communication constraints as the mechanic** appear in BOMBANANA (sensory roles), Big Walk (range-limited voice) and YAPYAP (voice as input). For Roblox, the version that works without voice (gestures, pings, drawn symbols) is both safer and arguably *more* novel. This is speculation.
3. **Blend in and deceive under a timer** appears in Worst Class Ever, No Body No Problem! and Meccha Chameleon. Roblox already has several NPC-blend games, so a team objective meter or physics evidence is the needed differentiator.
4. **Absurd single-goal incrementals** (Find the Needle) plus a reported 7 incremental games in Oct's top 50 (per the [PC Gamer headline](https://pcgamer.com/software/platforms/the-50-most-played-steam-next-fest-demos-include-7-incremental-games-4-ai-disclosures-and-only-one-instance-of-haystack-slop/)) suggest the idle and incremental appetite is strong.
5. **Persistence between runs** (Mewgenics inheritance, BALL x PIT base, Probably Stolen's run-ending bust) gives roguelites a "one more run" pull.

### Already widely cloned on Roblox (deprioritise direct copies)
Meccha Chameleon (paint and hide), fishing sims, R.E.P.O., PEAK, Lethal Company and Schedule I-style games, and NPC-blend hide and seek. The Roblox clone landscape is only verified for the first two plus NPC-blend.
