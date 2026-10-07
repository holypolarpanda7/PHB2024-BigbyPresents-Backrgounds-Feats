# Changelog

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
- Strikes follow the book: saving throws (DC 8 + proficiency + Str or Con), Storm Strike gives disadvantage on attack rolls.
- Feat descriptions state their prerequisites.
- Every feature is now covered by an automated in-game test suite (65 cases).
