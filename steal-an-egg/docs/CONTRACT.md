# Steal an Egg — integration contract

Every script in this game is written by a different author. This file is what
makes them fit together. Where anything you find online disagrees with this
file, this file wins.

## Game loop

A boss sleeps on a nest full of eggs. Players sneak in, steal an egg, carry it
back to a delivery zone, then hatch it for a pet that pays coins. Noise
(running, snapping branches, grabbing an egg) raises the boss's alertness;
when it wakes it chases the noisiest player and catches them. Coins buy sneak
upgrades in the shop, treadmills train run speed, and a spin wheel hands out
bonus rewards.

## Layout (Rojo, `default.project.json`)

| Roblox location | Disk path | Kind |
|---|---|---|
| `ReplicatedStorage.<Name>Config` | `src/ReplicatedStorage/<Name>Config.lua` | ModuleScript, one per system |
| `ReplicatedStorage.Remotes` | `src/ReplicatedStorage/Remotes.lua` | ModuleScript (exists, do not edit) |
| `ServerScriptService.ServerBus` | `src/ServerScriptService/ServerBus.lua` | ModuleScript (exists, do not edit) |
| `ServerScriptService.CurrencyService` | `src/ServerScriptService/CurrencyService.lua` | ModuleScript (economy group) |
| `ServerScriptService.<Name>` | `src/ServerScriptService/<Name>.server.lua` | Script |
| `StarterPlayerScripts.<Name>` | `src/StarterPlayer/StarterPlayerScripts/<Name>.client.lua` | LocalScript |

Language: Luau, `--!strict` where practical, `task.wait`/`task.spawn` (never
`wait`/`spawn`). There are no pre-built GUI or model assets: LocalScripts build
their own minimal GUI with `Instance.new`.

## Fixed conventions

- **Remotes**: all are `RemoteEvent`s fetched with
  `require(ReplicatedStorage.Remotes).get(name)`. Names are
  `<System><Action>Request` (client → server) and `<System><Action>Response`
  (server → client). Never create a remote any other way. Never use
  RemoteFunctions.
- **Currency**: `player.leaderstats.Coins`, an `IntValue`, in a `Folder` named
  `leaderstats`. Only `CurrencyService` creates or writes it.
- **Config modules**: `EggConfig`, `ShopConfig`, `SpinConfig`,
  `TreadmillConfig`, `BossConfig`, `SneakConfig`. All tunables and all
  weighted tables live there, not in scripts.
- **Server authority**: every roll, purchase, hatch, spin, noise and boss-wake
  decision is made in a server `Script`. LocalScripts only request and
  animate. The server never trusts a price, reward, position or loudness sent
  by a client. Validate argument types on every `OnServerEvent`, and rate
  limit per player.
- **Detection**: `workspace:GetPartsInPart` or
  `workspace:GetPartBoundsInRadius` with `OverlapParams`, on the server, in a
  throttled loop (fixed rate, 10 Hz or slower). No `RenderStepped` or
  `Heartbeat`-every-frame detection, no per-frame `GetTagged`. Read
  `CollectionService:GetTagged` once and keep it current with
  `GetInstanceAddedSignal` / `GetInstanceRemovedSignal`.
- **Treadmill reward loop**: overlap check at `TreadmillConfig.TickRate`
  (5 per second), exactly one reward per character per tick; several body
  parts of one character count once. Resolve a part to its character with
  `FindFirstAncestorOfClass("Model")` + Humanoid check +
  `Players:GetPlayerFromCharacter`, not `part.Parent`. No distance pre-filter.
- **Cleanup**: clear every per-player table on `Players.PlayerRemoving`.

## Cross-group interfaces

### CurrencyService (ModuleScript, server only) — economy group owns

```lua
CurrencyService.GetCoins(player: Player): number
CurrencyService.AddCoins(player: Player, amount: number, reason: string): boolean
CurrencyService.SpendCoins(player: Player, amount: number, reason: string): boolean -- false if short, never goes negative
```

Requiring it sets up `leaderstats` for current and future players. Amounts
must be positive integers; anything else returns false. No DataStore in this
version.

### ServerBus events (server only)

`local ServerBus = require(ServerScriptService.ServerBus)`, then
`ServerBus.fire(name, ...)` / `ServerBus.connect(name, fn)`.

| Event | Arguments | Fired by | Consumed by |
|---|---|---|---|
| `NoiseEmitted` | `player: Player?, position: Vector3, loudness: number, source: string` | NoiseService only | BossWakeStateMachine |
| `BossStateChanged` | `state: string, target: Player?` | BossWakeStateMachine only | BossAI, NoiseService/SneakService if useful |
| `PlayerCaught` | `player: Player` | BossAI only | EggCarryService |
| `EggStolen` | `player: Player, eggType: string` | EggCarryService only | NoiseService (emits a noise), BossWakeStateMachine may ignore |
| `EggDropped` | `player: Player, eggType: string, reason: string` | EggCarryService only | anyone |
| `EggDelivered` | `player: Player, eggType: string` | EggCarryService only | EggHatchService |

- `loudness` is in studs: the radius at which the noise is fully audible.
  `source` is one of `"Footstep"`, `"Branch"`, `"EggGrab"`, `"Landing"`.
- Boss `state` is one of `"Asleep"`, `"Stirring"`, `"Awake"`, `"Returning"`.
- Other services wanting to make a noise do not fire `NoiseEmitted`
  themselves; NoiseService listens for `EggStolen` and emits on their behalf.

### Player attributes (server writes, replicate to clients for display)

| Attribute | Type | Default | Only writer | Readers |
|---|---|---|---|---|
| `SpeedBonus` | number | 0 | TreadmillService (SpinService may add via the same attribute) | SneakService |
| `IsSneaking` | boolean | false | SneakService | NoiseService, clients |
| `CarryingEgg` | string or nil | nil | EggCarryService | SneakService, NoiseService, clients |
| `NoiseMultiplier` | number | 1 | ShopService | NoiseService |
| `LuckMultiplier` | number | 1 | ShopService | EggHatchService |
| `Spins` | number | 0 | SpinService (ShopService adds purchased spins) | SpinService, clients |
| `NextFreeSpinAt` | number (os.time) | 0 | SpinService | clients |

Treat a missing attribute as its default. Workspace attributes
`BossState: string` and `BossAlertness: number` (0–1) are written only by
BossWakeStateMachine.

### WalkSpeed has exactly one owner: SneakService

No other script sets a player character's `Humanoid.WalkSpeed` (BossAI sets the boss NPC's own speed). SneakService recomputes on
attribute change:

```
WalkSpeed = (SneakConfig.BaseWalkSpeed + SpeedBonus)
          * (IsSneaking and SneakConfig.SneakSpeedMultiplier or 1)
          * (CarryingEgg and EggConfig.Eggs[CarryingEgg].CarrySpeedMultiplier or 1)
```

### Config fields other groups read

- `EggConfig.Eggs[eggType] = { DisplayName: string, CarrySpeedMultiplier: number, GrabLoudness: number, Pets = { { Name: string, Weight: number, CoinValue: number }, ... } }`
- `TreadmillConfig.MaxSpeedBonus: number` — the cap on the `SpeedBonus` attribute; every writer of `SpeedBonus` clamps to it and never lowers an existing value.
- `SneakConfig.BaseWalkSpeed: number`, `SneakConfig.SneakSpeedMultiplier: number`
- `ShopConfig.DevProducts[productId] = { Kind: "Spins", Amount: number }` —
  `MarketplaceService.ProcessReceipt` is set only by ShopService.

### Fixed remotes

| Remote | Direction | Arguments | Owner |
|---|---|---|---|
| `BuyItemRequest` | C→S | `itemId: string` | ShopService |
| `BuyItemResponse` | S→C | `success: boolean, itemId: string, message: string` | ShopService |
| `HatchEggRequest` | C→S | `eggType: string` | EggHatchService |
| `HatchEggResponse` | S→C | `success: boolean, eggType: string, petName: string?, coinValue: number?` | EggHatchService |
| `SpinRequest` | C→S | none | SpinService |
| `SpinResponse` | S→C | `success: boolean, slotIndex: number?, message: string?` | SpinService |
| `SneakToggleRequest` | C→S | `wantSneak: boolean` | SneakService |
| `NoiseEmitResponse` | S→C | `position: Vector3, loudness: number, source: string, isOwn: boolean` (true only for the client whose character made the noise) | NoiseService |
| `BossWakeResponse` | S→C (all clients) | `state: string, alertness: number` | BossWakeStateMachine |
| `EggInventoryRequest` | C→S | none | EggHatchService |
| `EggInventoryResponse` | S→C | `inventory: { [eggType]: number }` | EggHatchService |
| `SpinOpenResponse` | S→C | none (open the wheel GUI) | SpinService |

A group may add more remotes for its own client, following the naming rule.

### Workspace tags (CollectionService) the level designer applies

| Tag | On | Attributes | Used by |
|---|---|---|---|
| `Treadmill` | BasePart hitbox volume above the belt | optional `SpeedPerTick: number` | TreadmillService |
| `NestEgg` | BasePart or Model (PrimaryPart set) | `EggType: string` | EggCarryService |
| `DeliveryZone` | BasePart volume | — | EggCarryService |
| `BossNPC` | Model with Humanoid + HumanoidRootPart | — | BossAI, BossWakeStateMachine, NoiseService |
| `BossWaypoint` | BasePart | `Order: number` | BossAI |
| `BossNest` | BasePart | — | BossAI (sleep/home position) |
| `Branch` | BasePart lying on the ground | optional `Loudness: number` | NoiseService |
| `SpinWheel` | BasePart | — | SpinService (ProximityPrompt to open) |

Every script must run without error when a tag has zero instances (warn once
and idle).
