# RE:Potassium
A remake of Potassium, a Balatro mod that has all the bananas and glop you could ever need! Currently the mod adds:

- Glop, a scoring parameter that multiplies with Chips and Mult
- 16 Jokers
- A new Poker Hand
- 2 Planet Cards, 4 Spectral Cards, and 1 Tag
- An Edition and Sticker
- A stake and two special blinds
- Like a secret or two

and more to come!

## Motive for remaking
Potassium was released on April Fool's Day 2025; since then, a lot of breaking changes have been implemented in Steamodded that prevent the original mod from running at all. The original Potassium mod also featured several overriding changes that makes the mod less appealing to play with other mods.

This remake re-implements various Potassium features with modern Steamodded features and improved code. Modularity is also more pronounced so other mods can interface this mod and implement cross-mod content and behaviors easily. Additionally, various content from the original Potassium are subject to reworks, while other content will not be re-implemented; this is to improve balance and cross-mod interactions.

The intent is to ultimately make it easier to develop this mod and add new content that expands on the premise of bananas and glop.

## Technical documentation
### Contexts
This context occurs when a card goes extinct. It is sent by Gros Michel, Cavendish, Blue Java, Potassium in a Bottle, Banana Bean, Glopendish, and anything with the Banana sticker.
```lua
if context.kali_extinct then
{
    kali_extinct = true,
    other_card = card_key
}
```

### Evolving Jokers
Jokers that can evolve with Ambrosia (Banana-themed evolutions) can be implemented by adding a key-value pair to the table `Potassium.banana_evolutions`, where the key is the key of the initial Joker, and the value is the key of the evolved Joker.

A similar procedure is performed with Jokers that can evolve with Substance (Glop-themed evolutions), though the table `Potassium.glop_evolutions` is used instead. By default, <u>all</u> Legendary Jokers are added to this table. To opt a Legendary Joker out of the table, set the property `kali_exclude_glop_evolution` to be `true`. For example:

```lua
SMODS.Joker {
  key = "mu",
  rarity = 4,
  kali_exclude_glop_evolution = true,
  ...
}
```

### Calculation keys that cause Glop increase
Glop increases by 0.01 after each increase of chips/mult/glop. Other scoring parameters - or specifically *calculation keys* - can cause this increase if they are added to the following <u>set tables</u>:
- `Potassium.calc_keys.additive` (e.g. `chips`, `mult`)
- `Potassium.calc_keys.multiplicative` (e.g. `xchips`, `xmult`)
- `Potassium.calc_keys.exponential` (e.g. `echips`, `emult`)
- `Potassium.calc_keys.hyperoperative`
- `Potassium.calc_keys.all`

As these are <u>set tables</u>, adding an entry to these tables requires setting a key to be `true`. For example, `Potassium.calc_keys.additive["chips"] = true`. Do not use `table.insert`, this does not count as adding to a set.

Calculation keys that correspond to value scaling of certain growth types are added to their corresponding table, and also the "all" table.

These tables are also used in the Glop edition's effect, which gives Glop of a lower operation whenever a Joker gives chips, mult, or glop of a certain operation:

- Addition -> "Weak addition" (Adding the normalized [significand](https://en.wikipedia.org/wiki/Significand) of a number)
  - Example: +1242 Mult -> +1.242 Glop
- Multiplication -> Addition
- Exponentiation -> Multiplication
- Tetration and higher hyperoperations -> Exponentiation

### Banana blinds
Banana blinds are boss blinds that only appear on ante 12 and have their own special background; ante 12, and only ante 12, exclusively has banana blinds in its pool.

A flag can be added to blinds in a similar manner to showdown bosses that will mark them as banana blinds. To do so, add the following key-value pair to your SMODS.Blind: `boss = {banana = true}`.

### Regarding permanent glop (Metaglop)
This remake of Potassium does not feature permanent glop (called "metaglop" in the remake) via Glopway (as its metaprogression nature was largely a joke-y feature). Regardless, if you wish to use the mechanic for whatever reason, permanent glop can be increased per save via the function `Glop_f.increase_metaglop(number)`; all hands are updated in the current and future runs accordingly.

Metaglop is saved in the profile parameter `G.PROFILES[G.SETTINGS.profile].metaglop`, but the shorthand `Glop_f.get_metaglop()` can be used to retrive that data.

### Three-layer cards
This mod adds three-layer cards that have the same syntax (and system) as Cryptid's three-layer cards:
```lua
SMODS.Joker {
  key = "mu",
  ...
  soul_pos = {
    x=1, y=0,
    extra = {
      x=2, y=0
    }
  }
}
```

### Hand level up animation fixes
This mod makes several fixes to hand leveling animations when other scoring calculatons (such as Glop) are used. These fixes are also found in [Steamodded PR #1026](//github.com/Steamodded/smods/pull/1026) and will be removed from this mod when/if the pull request is merged.

To make these fixes:
- The following functions are added: (*func/funcs.lua*)
  - `Glop_f.scoring_parameter_is_upgradeable`
  - `Glop_f.start_level_up_hand_animation`
  - `Glop_f.level_up_hand_animation`
  - `Glop_f.end_level_up_hand_animation`
- Hooks to the following functions are added: (*func/hooks.lua*)
  - `level_up_hand` (OVERRIDE)
  - `Card:use_consumeable`
- The following vanilla objects have their ownership taken: (*func/ownership.lua*)
  - Orbital Tag, Tag
  - Black Hole, Spectral Card
  - Burnt Joker, Joker
- The following functions are patched: (*lovely/lovely.toml*)
  - `update_hand_text`
  - `SMODS.refresh_score_UI_list`