-- Defines card evolutions (when Ambrosia or Substance targets specific Jokers)
-- Files that use this data:
    -- items/2. Consumables.lua (Ambrosia and Substance registers)
    -- func/post-load.lua (Automatically add Legendaries to Potassium.glop_evolutions)

--[[

Both Potasssium.banana_evolutions and Potassum.glop_evolutions take key-value pairs,
where the key is the key of the Joker being transformed,
and the value is the key of the Joker to transform into

]]

----------------------
-- AMBROSIA EVOLUTIONS
----------------------
Potassium.banana_evolutions = Potassium.banana_evolutions or {}
local k_map = Potassium.banana_evolutions
k_map["j_egg"]         = "j_kali_begg"
k_map["j_ice_cream"]   = "j_kali_banana_split"
k_map["j_turtle_bean"] = "j_kali_banana_bean"
k_map["j_selzer"]      = "j_kali_potassium_bottle"

-----------------------
-- SUBSTANCE EVOLUTIONS
-----------------------
Potassium.glop_evolutions = Potassium.glop_evolutions or {}
local g_map = Potassium.glop_evolutions
g_map["j_gros_michel"] = "j_kali_glop_michel"
g_map["j_egg"]         = "j_kali_glegg"
g_map["j_cavendish"]   = "j_kali_glopendish"
g_map["j_diet_cola"]   = "j_kali_glop_cola"
g_map["j_popcorn"]     = "j_kali_glop_corn"