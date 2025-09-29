# potassium-remaKe
***<u>DISCLAIMER: HIGHLY WIP DOES NOT WORK AT THE MOMENT</u>***

A remake of Potassium, a Balatro mod that has all the bananas and glop you could ever need.

## Technical documentation
- Jokers that can evolve with Ambrosia (Banana-themed evolutions) can be implemented by adding a key-value pair the table `Potassium.banana_evolutions`, where the key is the key of the initial Joker, and the value is the key of the evolved Joker.
- Jokers that can evolve with Substance (Glop-themed evolutions) can be implemented by adding a key-value pair the table `Potassium.glop_evolutions`, where the key is the key of the initial Joker, and the value is the key of the evolved Joker.
- Glop increases by 0.01 per increase of chips/mult/glop. Other scoring parameters - or specifically *calculation keys* - can cause this increase if they are added to the following tables:
  - `Potassium.calc_keys.additive`
  - `Potassium.calc_keys.multiplicative`
  - `Potassium.calc_keys.exponential`
  - `Potassium.calc_keys.hyperoperative`
  - `Potassium.calc_keys.all`
  - Calculation keys that correspond to value scaling of certain growth types are added to their corresponding table, and also the "all" table.
    - For example, the calculation key `chips` goes into `Potassium.calc_keys.additive`, while the calculation key `x_chips` goes into `Potassium.calc_keys.multiplicative`
  - These tables are also used in the Glop edition's effect, where calculation keys corresponding to value scaling of certain growth types also scale Glop at a lower growth type.