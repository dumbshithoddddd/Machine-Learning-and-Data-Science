--!strict
-- ServerBus: server-only event bus so independently written services never
-- need to require each other. Event names and argument lists are fixed by
-- docs/CONTRACT.md. Events are created lazily, so load order does not matter.

local ServerBus = {}

local events: { [string]: BindableEvent } = {}

local ALLOWED = {
	NoiseEmitted = true, -- (player: Player?, position: Vector3, loudness: number, source: string)
	BossStateChanged = true, -- (state: string, target: Player?)
	PlayerCaught = true, -- (player: Player)
	EggStolen = true, -- (player: Player, eggType: string)
	EggDropped = true, -- (player: Player, eggType: string, reason: string)
	EggDelivered = true, -- (player: Player, eggType: string)
}

function ServerBus.get(name: string): BindableEvent
	assert(ALLOWED[name], "Unknown ServerBus event: " .. name)
	local event = events[name]
	if not event then
		event = Instance.new("BindableEvent")
		event.Name = name
		events[name] = event
	end
	return event
end

function ServerBus.fire(name: string, ...: any)
	ServerBus.get(name):Fire(...)
end

function ServerBus.connect(name: string, callback: (...any) -> ()): RBXScriptConnection
	return ServerBus.get(name).Event:Connect(callback)
end

return ServerBus
