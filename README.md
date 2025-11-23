# potassium-remaKe
A remake of Potassium, a Balatro mod that has all the bananas and glop you could ever need.

## Motive
Potassium was released on April Fool's Day 2025; a lot of breaking changes have since been implemented in Steamodded that prevent the original mod from running at all. It also features several overriding changes that makes it less appealing to play with other mods. This remake intends to re-implement Potassium features with modern features, while also making it more friendly to use with other mods. Some content may also be subject to reworks, while other content will not be brought into this remake; this is to improve balance and cross-mod interactions.

## Technical documentation
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
Glop increases by 0.01 per increase of chips/mult/glop. Other scoring parameters - or specifically *calculation keys* - can cause this increase if they are added to the following <u>set tables</u>:
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

### Regarding permanent glop
This remake of Potassium does not feature permanent glop via Glopway (as its metaprogression nature was largely a joke-y feature). Regardless, if you wish to use the mechanic for whatever reason, permanent glop can be increased per save via the function `Glop_f.increase_permaglop(number)`; all hands are updated in the current and future runs accordingly.

Permaglop is saved in the profile parameter `G.PROFILES[G.SETTINGS.profile].permaglop`, but the shorthand `Glop_f.get_permaglop()` can be used to retrive that data.

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

### Contexts
This context occurs when a card goes extinct. It is sent by Gros Michel, Cavendish, Blue Java, Potassium in a Bottle, Banana Bean, Glopendish, and anything with the Banana sticker.
```lua
if context.kali_extinct then
{
    kali_extinct = true,
    other_card = card_key
}
```