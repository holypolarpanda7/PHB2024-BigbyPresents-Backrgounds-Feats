-- PHB2024 Bigby Presents: Backgrounds & Feats - Script Extender fixes
--
-- These handlers fill gaps the stats engine can't cover. Every feature still works
-- without Script Extender using its stats-only behaviour (see README / CLAUDE.md).

local NULL_GUID = "NULL_00000000-0000-0000-0000-000000000000"

local function log(msg)
    Ext.Utils.Print("[PHB2024_BigbyPresents] " .. msg)
end

-- Runs fn safely so an error in one handler never breaks the others or the game.
local function safe(name, fn)
    return function(...)
        local ok, err = pcall(fn, ...)
        if not ok then
            log(name .. " failed: " .. tostring(err))
        end
    end
end

local function hasStatus(entity, status)
    return Osi.HasActiveStatus(entity, status) == 1
end

local function hasPassive(entity, passive)
    return Osi.HasPassive(entity, passive) == 1
end

-- ==================== VIGOR OF THE HILL GIANT - BULWARK ====================
-- Stats: Interrupt_PHB2024_Bulwark rerolls the Strength save and applies
-- PHB2024_BULWARK_VFX + PHB2024_BULWARK_RESIST (prone immunity).
-- Stats can't cancel forced movement, so when Bulwark is used we remember where the
-- character stood and put them back once the triggering effect has resolved.

local BULWARK_STATUS = "PHB2024_BULWARK_VFX"
local BULWARK_RESTORE_DELAY_MS = 1500  -- long enough for push/knockback to finish
local BULWARK_MIN_DISTANCE = 0.5       -- metres; ignore tiny position jitter

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", safe("Bulwark", function(target, status, _, _)
    if status ~= BULWARK_STATUS then
        return
    end
    local x, y, z = Osi.GetPosition(target)
    if x == nil then
        return
    end
    Ext.Timer.WaitFor(BULWARK_RESTORE_DELAY_MS, safe("Bulwark restore", function()
        local nx, ny, nz = Osi.GetPosition(target)
        if nx == nil then
            return
        end
        local dx, dy, dz = nx - x, ny - y, nz - z
        if math.sqrt(dx * dx + dy * dy + dz * dz) > BULWARK_MIN_DISTANCE then
            Osi.TeleportToPosition(target, x, y, z, "", 0, 0, 0, 0, 1)
        end
    end))
end))

-- ==================== GUILE OF THE CLOUD GIANT - CLOUDY ESCAPE ====================
-- Stats: PHB2024_CLOUDY_ESCAPE has RemoveEvents OnMove;OnSpellCast;OnAttack;OnTurnEnd.
-- Using an item (potion, scroll, door, lever...) is not one of those events, so end
-- the status here when the character starts using an item.

local CLOUDY_ESCAPE_STATUS = "PHB2024_CLOUDY_ESCAPE"

Ext.Osiris.RegisterListener("UseStarted", 2, "after", safe("Cloudy Escape", function(character, _)
    if hasStatus(character, CLOUDY_ESCAPE_STATUS) then
        Osi.RemoveStatus(character, CLOUDY_ESCAPE_STATUS, NULL_GUID)
    end
end))

-- ==================== VIGOR OF THE HILL GIANT - IRON STOMACH ====================
-- Stats: PHB2024_IronStomach heals on short rest (BG3's equivalent of spending Hit Dice).
-- Stats can't detect eating food, so here: the first time after each rest that the
-- character eats food, apply PHB2024_IRON_STOMACH_MEAL (heals Con mod + Proficiency).
-- PHB2024_IRON_STOMACH_FED marks that the meal bonus was used; rests clear it.
-- Food = an item whose stats have a positive SupplyValue (camp supplies).

local IRON_STOMACH_PASSIVE = "PHB2024_IronStomach"
local IRON_STOMACH_MEAL = "PHB2024_IRON_STOMACH_MEAL"
local IRON_STOMACH_FED = "PHB2024_IRON_STOMACH_FED"
-- Short-rest temp HP status. Its stats RemoveEvents "OnLongRest" is not a valid status
-- event, so it is also cleared here on long rest.
local IRON_STOMACH_TEMP_HP = "PHB2024_IRON_STOMACH_TEMP_HP"

local function isFood(item)
    local statName = Osi.GetStatString(item)
    if statName == nil or statName == "" then
        return false
    end
    local stat = Ext.Stats.Get(statName)
    if stat == nil then
        return false
    end
    local ok, supply = pcall(function() return stat.SupplyValue end)
    return ok and type(supply) == "number" and supply > 0
end

Ext.Osiris.RegisterListener("UseFinished", 3, "after", safe("Iron Stomach", function(character, item, success)
    if success ~= 1 or not hasPassive(character, IRON_STOMACH_PASSIVE) then
        return
    end
    if hasStatus(character, IRON_STOMACH_FED) or not isFood(item) then
        return
    end
    Osi.ApplyStatus(character, IRON_STOMACH_MEAL, 0, 1, character)
    Osi.ApplyStatus(character, IRON_STOMACH_FED, -1, 1, character)
end))

local function clearFed(character)
    if hasStatus(character, IRON_STOMACH_FED) then
        Osi.RemoveStatus(character, IRON_STOMACH_FED, NULL_GUID)
    end
end

Ext.Osiris.RegisterListener("ShortRested", 1, "after", safe("Iron Stomach short rest", clearFed))

Ext.Osiris.RegisterListener("LongRestFinished", 0, "after", safe("Iron Stomach long rest", function()
    -- Party story databases; clearFed is idempotent, so checking both is harmless.
    for _, db in ipairs({ "DB_PartyMembers", "DB_Players" }) do
        local ok, rows = pcall(function() return Osi[db]:Get(nil) end)
        if ok and rows then
            for _, row in pairs(rows) do
                clearFed(row[1])
                if hasStatus(row[1], IRON_STOMACH_TEMP_HP) then
                    Osi.RemoveStatus(row[1], IRON_STOMACH_TEMP_HP, NULL_GUID)
                end
            end
        end
    end
end))

log("Loaded")
