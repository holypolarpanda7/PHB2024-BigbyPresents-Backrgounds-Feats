-- Client half: locks the Giant feats and Rune Shaper on the level-up screen when the controlled character lacks the
-- prerequisite. Feats.lsx Requirements can't say "has Fire Strike" or "can cast spells" (the engine only parses ability and
-- proficiency requirements), but the parsed Feat.FeatRequirements is writable and the level-up screen reads it when it
-- opens (verified 2026-10-06, Apotheosis Epic Boons). The server doesn't re-check feat requirements, so this client lock is
-- the whole gate, per player. A locked feat shows "Strength needs to be higher than 99"; each feat's description states
-- its real prerequisite.
Ext.Require("Shared.lua")
local B = BigbyPresents

local LOCK = { { Requirement = "BigbyGiantFeatPrerequisite", Type = 0, Ability = "Strength", AbilityValue = 99 } }
local POLL_MS = 250

local feats = nil        -- { {feat, kind = "giant"/"rune", strike, original} }
local chars = {}         -- uuid -> facts from the server
local state = {}         -- feat index -> locked?
local lastPoll = 0

local function collect()
    feats = {}
    for _, id in pairs(Ext.StaticData.GetAll("Feat")) do
        local f = Ext.StaticData.Get(id, "Feat")
        local name = f and tostring(f.Name)
        if name and (B.GIANT_FEATS[name] or B.RUNE_FEATS[name]) then
            feats[#feats + 1] = { feat = f, name = name, strike = B.GIANT_FEATS[name], original = f.FeatRequirements }
        end
    end
    B.Log(string.format("feat lock: %d Giant/Rune Shaper feats", #feats))
end

local function controlled()
    local ok, uuid = pcall(function()
        local e = Ext.Entity.GetAllEntitiesWithComponent("ClientControl")[1]
        return e and e.Uuid and e.Uuid.EntityUuid
    end)
    return ok and uuid or nil
end

local function update()
    if not feats then return end
    local f = chars[controlled() or ""]
    if not f then return end                 -- no facts yet: leave the feats as the data has them
    for i, x in ipairs(feats) do
        local ok
        if x.strike then ok = f.strikes and f.strikes[x.strike] else ok = f.caster end
        local lock = not ok
        if state[i] ~= lock then
            x.feat.FeatRequirements = lock and LOCK or (x.original or {})
            state[i] = lock
        end
    end
end

B.Channel:SetHandler(function(data)
    chars = data.chars or {}
    update()
end)

Ext.Events.SessionLoaded:Subscribe(function()
    collect()
    B.Channel:RequestToServer({}, function(data) chars = data.chars or {}; update() end)
end)

Ext.Events.Tick:Subscribe(function()
    local now = Ext.Timer.MonotonicTime()
    if now - lastPoll < POLL_MS then return end
    lastPoll = now
    update()
end)

-- console/test hook: Mods.BigbyPresents.GiantFeatLock.State()
GiantFeatLock = {
    State = function()
        local out = { controlled = controlled(), feats = {} }
        for i, x in ipairs(feats or {}) do out.feats[x.name .. "#" .. i] = state[i] and "locked" or "open" end
        out.facts = chars[out.controlled or ""]
        return out
    end,
}
