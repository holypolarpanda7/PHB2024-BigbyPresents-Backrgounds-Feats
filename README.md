# Bigby Presents: Glory of the Giants - Backgrounds & Feats

A Baldur's Gate 3 mod that adds content from *Bigby Presents: Glory of the Giants*.

## Features

### Backgrounds
- **Giant Foundling**: Raised among giants, you've learned to embody their might. Grants Intimidation and Survival proficiency, plus Strike of the Giants feat.
- **Rune Carver**: Master of runecraft and ancient giant traditions. Grants History and Perception proficiency, plus Rune Shaper feat.

### Feats

#### Origin Feats (from Backgrounds)
- **Strike of the Giants**: Choose from 6 giant strike types (Cloud, Fire, Frost, Hill, Stone, Storm), each with unique combat effects
VFX Statuses (applied to your character for 1 turn):

Strike	VFX Effect
Cloud	Ghostly spectre aura (like spectral undead)
Fire	Chromatic fire infusion (fiery weapon/hands)
Frost	Chromatic cold infusion (icy weapon/hands)
Hill	None (as requested)
Stone	Stoneskin effect
Storm	Lightning infusion (electrical crackling)
- **Rune Shaper**: Learn giant runes that grant access to 1st-level spells

#### Advanced Giant Feats (require level 4+ and corresponding Strike)
- **Ember of the Fire Giant**: Fire resistance and area fire burst attack
- **Fury of the Frost Giant**: Cold resistance and reactive ice blast
- **Guile of the Cloud Giant**: Defensive teleportation reaction
- **Keenness of the Stone Giant**: Enhanced darkvision and magical rock throwing
- **Soul of the Storm Giant**: Maelstrom aura with lightning/thunder resistance
- **Vigor of the Hill Giant**: Anti-knockdown reaction and enhanced healing

## Installation

1. Download the mod files
2. Place the mod folder in your BG3 Mods directory
3. Enable in your mod manager
4. Launch the game and create/modify a character

## Compatibility

- Requires Baldur's Gate 3
- Compatible with PHB 2024 mods
- Should work with most other mods
- **Script Extender:** optional, but recommended. With [BG3 Script Extender](https://github.com/Norbyte/bg3se) installed, these features work closer to the rules:

  | Feature | With Script Extender | Without it |
  |---|---|---|
  | Bulwark (Vigor of the Hill Giant) | If the effect still pushes you, you are moved back to where you stood. | Prone is prevented, but you can still be pushed. |
  | Cloudy Escape (Guile of the Cloud Giant) | Also ends when you use an item. | Ends when you move, cast, attack or end your turn. |
  | Iron Stomach (Vigor of the Hill Giant) | The first time you eat food after each rest, you regain Con mod + Proficiency Bonus HP. The short-rest temp HP is also cleared on long rest. | Only the short-rest bonus. |

  Everything else works the same with or without it. See `CLAUDE.md` for the development policy.

## File Structure

```
PHB2024-BigbyPresents-Backrgounds-Feats/
├── Mods/BigbyPresents_[UUID]/
│   ├── meta.lsx
│   └── Localization/English/english.xml
└── Public/BigbyPresents_[UUID]/
    ├── Backgrounds/
    ├── Feats/
    ├── Lists/
    └── Stats/Generated/Data/Passive.txt
```

## Credits

Based on *Bigby Presents: Glory of the Giants* by Wizards of the Coast.

## Version

1.0.0 - Initial Release
