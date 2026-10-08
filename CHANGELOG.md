# Changelog

## v1.2.1 - 2026-10-07

- v1.2.1 page text and changelog (2026-10-07) (2026-10-07)
- Cloud Strike: mark the target on its failed Wisdom save, Lua turns the attacker invisible (2026-10-07) (2026-10-07)
- TEMP: interrupt casts Bane (UseSpell diagnosis) (2026-10-07)
- TEMP: D derived from Target_Bane (2026-10-07)
- TEMP: D uses BLESSED control (2026-10-07)
- TEMP: variant D minimal (2026-10-07) (2026-10-07)
- TEMP: name/icon on the Cloud hidden spells; the direct cases grant the spell (2026-10-07) (2026-10-07)
- TEMP: three variants of the Cloud hidden spell to find why it never casts (2026-10-07) (2026-10-07)
- Cloud Strike hidden spell: the same target condition as the base game's interrupt-cast spells (2026-10-07) (2026-10-07)
- Cloud Strike hidden spell: animation (a spell without one never resolves), direct test case (2026-10-07) (2026-10-07)
- Cloud Strike hidden spell: give it a range (a spell with no TargetRadius never casts) (2026-10-07) (2026-10-07)
- Cloud Strike: the struck creature rolls the Wisdom save (hidden spell cast on it via UseSpell) (2026-10-07) (2026-10-07)
- Maelstrom Aura text: the slow has no saving throw (matches the data) (2026-10-07) (2026-10-07)
- WIP 1.2.1: Rune Shaper ability choice in play, accurate Cloud Strike, Stone Throw range and Maelstrom radius units (2026-10-07) (2026-10-07)
- Nexus page spec rewritten from what the mod does; CHANGELOG wording; meta.lsx as the Toolkit left it after the mod.io publish (build 1.2.0.3) (2026-10-07) (2026-10-07)
- Nexus page spec: version 1.2.0 (set by the upload) (2026-10-07) (2026-10-07)
- Build & Release workflow: manual only; releases are made locally after the gate (2026-10-07) (2026-10-07)

## v1.2.1 - 2026-10-07

- **Rune Shaper: choose your spellcasting ability** (Intelligence, Wisdom or Charisma) with the new *Choose Rune Shaper Ability*
  action. It works for the feat taken at a level-up and for the Rune Carver background, any time after the game loads.
- **Cloud Strike now follows the book's save:** the *target* rolls the Wisdom save and you turn invisible only if it fails
  (before, you were invisible no matter what). The invisibility ends at the start of your next turn or when you attack or cast.
- Fixed: Stone Throw's range (60 ft) and Maelstrom Aura's radius (10 ft) were in the wrong units.
- Fixed: area rune spells could spend several spell slots in one cast.
- Added the "How this differs from the book" section to the page: the deliberate buffs are listed openly.

## v1.2.0 - 2026-10-07

- Renamed to **Bigby Presents: Backgrounds & Feats** (was "PHB2024-BigbyPresents-Backrgounds-Feats"). Same mod ID - existing
  saves keep working.
- **Works standalone.** DnD 5.5e All-in-One BEYOND is now optional; with it loaded, this mod's Giant feats replace DnD 5.5e's
  versions of the same feats (load this mod after DnD 5.5e).
- **Feat prerequisites enforced** with BG3 Script Extender (v22+): each "of the ... Giant" feat needs its matching Strike,
  Rune Shaper needs spellcasting or the Rune Carver background. Strike of the Giants needs Martial Weapon proficiency.
- Fixed: the Giant feats gave no +1 ability score (Str/Con/Wis; Guile Str/Con/Cha; Soul Str/Wis/Cha).
- Fixed: Giant Foundling and Rune Carver gave no skill proficiencies.
- Fixed: the Strike of the Giants picker (broken by a DnD 5.5e update).
- Fixed: Searing Ignition's save was inverted (a failed save took half damage and no Blinded).
- Fixed: Frigid Retaliation's speed 0 and Stone Throw's prone never applied.
- Fixed: area rune spells (Burning Hands, Thunderwave, Fog Cloud, Entangle) could spend several spell slots in one cast.
- Strike riders now use saving throws (DC 8 + proficiency bonus + Strength or Constitution modifier); Storm Strike gives disadvantage on attack rolls.
- Feat descriptions state their prerequisites.
- Every feature is now covered by an automated in-game test suite (65 cases).
