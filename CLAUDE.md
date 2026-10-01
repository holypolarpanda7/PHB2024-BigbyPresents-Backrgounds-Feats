# Working on this mod

Baldur's Gate 3 mod adding the *Bigby Presents: Glory of the Giants* backgrounds and feats
(PHB 2024 rules). Content lives in:

- `Public/<mod>_8829ee20-.../Stats/Generated/Data/*.txt` — spells, passives, statuses, interrupts
- `Public/<mod>_8829ee20-.../{Feats,Backgrounds,Lists,ActionResourceDefinitions}/*.lsx`
- `Mods/<mod>_8829ee20-.../Localization/English/PHB2024-BigbyPresents.xml` — all display text
- `Editor/` — Toolkit project files, git-ignored and not shipped

`.github/workflows/Build&Release.yml` packs `Mods/`, `Public/` and `Localization/` into the `.pak`
when a `v*.*.*` tag is pushed.

## Fixing issues: stats first, Script Extender when stats can't do it

Try to fix a problem in stats/LSX data first. Most bugs are a wrong `EnableContext`, cost, condition
or `using` parent, and a data fix keeps the mod working for players who don't have Script Extender.

**Script Extender ([BG3SE](https://github.com/Norbyte/bg3se)) is an approved tool for difficult
issues.** Use it, rather than stacking more stats workarounds, when:

- the rules text needs an event the stats engine doesn't expose (for example "when you eat food",
  "until you move", or preventing forced movement before it happens),
- a fix needs many near-identical stats entries that a few lines of Lua could replace,
- state is lost or desyncs (save/load, respec, equip changes) and a stats-only fix has already
  failed or only partly worked,
- the stats fix only approximates the rule and the approximation causes visible bugs.

When you use Script Extender:

1. Put scripts in `Mods/<mod>_8829ee20-.../ScriptExtender/`, with `Config.json` (`RequiredVersion`,
   `ModTable`, `FeatureFlags: ["Lua"]`) and `Lua/BootstrapServer.lua`. That folder is already under
   `Mods/`, so the release workflow will pack it.
2. Keep stats as the base. Lua should fill the gap the stats can't, not reimplement the feature, so
   the feat still mostly works without SE.
3. Say in the README which features need Script Extender and what happens without it.
4. Put a comment on the stats entry that points to the Lua handling it, so the two stay in step.
5. In the commit message, say why stats alone weren't enough.

## Fix history

These past fixes show where stats-only solutions hit their limits. If one of these areas breaks again
or needs to match the rules more closely, consider Script Extender.

| Commit | Area | What was done | Stats-only limitation |
|---|---|---|---|
| `316f0ec` | Strike of the Giants interrupts (`Interrupt.txt`) | Strike stopped working after unequipping and re-equipping. `EnableContext` was widened from `OnDamage` to `OnEquip;OnActionResourcesChanged;OnStatusApplied;OnStatusRemoved` so the interrupt re-checks its condition. | This relies on the engine re-checking at the right moments. If it breaks again, an SE listener can re-enable the interrupt or restore charges directly. |
| `316f0ec` | Iron Stomach (`Passive.txt`, `Status_BOOST.txt`) | Rule says "when you consume food and spend Hit Dice". Implemented as an `OnShortRest` heal plus a temporary HP status. | Stats can't detect eating food or spending Hit Dice, so the trigger is only approximate. |
| `6716cf5` | Rune Shaper spells (`Spell_Rune.txt`, `Rune.stats`) | Slot casts failed or charged twice. Changed to `UseActionResource(SELF,SpellSlot,...)` and added separate upcast entries for levels 2–6 for each upcastable rune. | It produces about 1,000 lines of near-duplicate entries, and every new rune repeats the pattern. |
| `19de374`, next | Rune Shaper slot casting (`Spell_Rune.txt`, `Spell_Shout.txt`, `Passive.txt`) | Armor of Agathys (and other runes) could only be cast with the free charge. The slot option was greyed out, only listed at level 1, and could not be upcast. The hand-made `_Slot`/`_Slot_N` variants were replaced by unlocking the vanilla spell next to the free rune spell, so the engine handles slot costs, Warlock slots and upcasting. | Still stats-only. Chromatic Orb and Command are vanilla containers, so their free rune spell is a matching container whose children use the rune charge. Comprehend Languages (custom spell, `Spell_Shout.txt`) is now separate free and slot spells. `Editor/.../Rune.stats` is out of date with the generated `.txt`, so don't regenerate from it without updating it first. |
| `86ee045` | Shout spells (`Spell_Shout.txt`) | Adjusted attributes and metadata. | — |
| next | Bulwark (`Interrupt.txt`, `Status_BOOST.txt`, `BootstrapServer.lua`) | `PHB2024_BULWARK_RESIST` was defined but never applied, so prone was never prevented. The interrupt now applies it (1 turn, `StatusImmunity(PRONE)`); it no longer removes `DOWNED`. **Script Extender:** when Bulwark is used, the character's position is saved and restored after 1.5 s if the effect still pushed them. | Stats can't cancel forced movement. Without SE, Bulwark prevents prone and makes the Strength save very likely, but a failed save still pushes. Shoves are not Strength saves, so Bulwark doesn't trigger on them. |
| next | Cloudy Escape (`Status_BOOST.txt`, `BootstrapServer.lua`) | "Until you act or move" is done with `RemoveEvents` (`OnMove;OnSpellCast;OnAttack;OnTurnEnd`). **Script Extender:** the status is also removed on `UseStarted` (using any item). | Item use isn't a status remove event. Without SE, using an item doesn't end it. |
| next | Iron Stomach meal (`Status_BOOST.txt`, `BootstrapServer.lua`) | **Script Extender:** the first food eaten after a rest (`UseFinished` on an item whose stats have `SupplyValue` > 0) applies `PHB2024_IRON_STOMACH_MEAL` (heal Con mod + PB). `PHB2024_IRON_STOMACH_FED` marks it used and is cleared on `ShortRested` / `LongRestFinished`. Long rest also clears `PHB2024_IRON_STOMACH_TEMP_HP`. | Stats can't detect eating. `RemoveEvents "OnLongRest"` / `"OnShortRest"` are not valid status events, so rest-based removal has to go through SE. |

When you fix an issue, add a row here.
