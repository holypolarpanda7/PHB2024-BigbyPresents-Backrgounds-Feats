-- Server half of the Giant feat prerequisites: works out each party member's Strike of the Giants choices and whether they
-- can cast spells, and sends that to the clients (the level-up screen, and so the lock, lives on the client).
Ext.Require("Shared.lua")
local B = BigbyPresents

local RUNE_CARVER_PASSIVE = "PHB2024_RuneShaper_Feature"   -- the Rune Carver background grants Rune Shaper through it

local function has(char, kind, name)
    local ok, r = pcall(function()
        if kind == "status" then return Osi.HasActiveStatus(char, name) == 1 end
        return Osi.HasPassive(char, name) == 1
    end)
    return ok and r
end

local function casts(char)
    local ok, r = pcall(function()
        for u, list in pairs(Ext.Entity.Get(char).ActionResources.Resources) do
            local d = Ext.StaticData.Get(u, "ActionResource")
            if d and (d.Name == "SpellSlot" or d.Name == "WarlockSpellSlot") then
                for _, x in ipairs(list) do if x.MaxAmount > 0 then return true end end
            end
        end
        return false
    end)
    return ok and r
end

local function facts(char)
    local f = { strikes = {}, caster = casts(char) or has(char, "passive", RUNE_CARVER_PASSIVE) }
    for _, t in ipairs(B.STRIKES) do
        f.strikes[t] = has(char, "status", "PHB2024_STRIKE_UNLOCK_" .. string.upper(t))
            or has(char, "status", "STRIKE_OF_THE_GIANTS_" .. string.upper(t))
            or has(char, "passive", "PHB2024_StrikeOfGiants_" .. t)
    end
    return f
end

local function party()
    local out = {}
    for _, row in pairs(Osi.DB_Players:Get(nil) or {}) do
        local g = row[1]
        local ok, uuid = pcall(function() return Ext.Entity.Get(g).Uuid.EntityUuid end)
        if ok and uuid then out[uuid] = facts(g) end
    end
    return out
end

function B.Sync()
    local ok, err = pcall(function() B.Channel:Broadcast({ chars = party() }) end)
    if not ok then B.Log("sync failed: " .. tostring(err)) end
end

-- a Strike choice is a status (this mod's picker or dnd55e's); level-ups change spell slots
local function strikeStatus(status)
    return string.find(status, "^PHB2024_STRIKE_UNLOCK_") or string.find(status, "^STRIKE_OF_THE_GIANTS_")
end
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(obj, status) if strikeStatus(status) then B.Sync() end end)
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(obj, status) if strikeStatus(status) then B.Sync() end end)
Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function() B.Sync() end)
Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function() B.Sync() end)
Ext.Events.SessionLoaded:Subscribe(function() B.Sync() end)
-- a client that loads later (or reloads Lua) asks for the facts
B.Channel:SetRequestHandler(function() return { chars = party() } end)
