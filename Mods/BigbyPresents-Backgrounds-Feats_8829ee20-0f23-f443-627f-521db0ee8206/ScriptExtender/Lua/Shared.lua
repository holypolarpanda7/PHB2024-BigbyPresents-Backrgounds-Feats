-- Shared by server and client (2026-10-07): the net channel and which feat needs which Strike of the Giants choice.
BigbyPresents = BigbyPresents or {}
local B = BigbyPresents

B.TAG = "[BigbyPresents]"
function B.Log(msg) Ext.Utils.Print(B.TAG .. " " .. msg) end

B.Channel = Ext.Net.CreateChannel(ModuleUUID, "GiantFeatFacts")

B.STRIKES = { "Cloud", "Fire", "Frost", "Hill", "Stone", "Storm" }

-- Glory of the Giants: each of these needs level 4+ and the matching Strike of the Giants choice. dnd55e ships feats with
-- the same names (added 2026-08), so both copies are covered.
B.GIANT_FEATS = {
    EmberOfTheFireGiant = "Fire",
    FuryOfTheFrostGiant = "Frost",
    GuileOfTheCloudGiant = "Cloud",
    KeennessOfTheStoneGiant = "Stone",
    SoulOfTheStormGiant = "Storm",
    VigorOfTheHillGiant = "Hill",
}
-- Rune Shaper: Spellcasting feature or the Rune Carver background (this mod's feat is named RuneCarver, dnd55e's RuneShaper)
B.RUNE_FEATS = { RuneCarver = true, RuneShaper = true }
