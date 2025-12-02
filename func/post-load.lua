-- Anything in the following event will only run after the game finishes loading

Glop_f.add_simple_event(nil, nil, function ()
    -- Set glop values for each hand, if not defined
    local glop_values_per_hand = SMODS.Scoring_Parameters.kali_glop.hands --[[@as table]]
    for hand_name in pairs(SMODS.PokerHands) do
        if not glop_values_per_hand[hand_name] then
            glop_values_per_hand[hand_name] = {kali_glop = 1, s_kali_glop = 1, l_kali_glop = 0.01}
        end
    end

    -- Set Legendary Jokers as evolving into Glop Mother, except for Glopku and Glop Mother
    for _,center in pairs(G.P_CENTERS) do
        if (
            center.set == 'Joker'
            and center.rarity == 4
            and center.key ~= "j_kali_glopmother"
            and center.key ~= "j_kali_glopku"
        ) then
            Potassium.glop_evolutions[center.key] = "j_kali_glopmother"
        end
    end

    -- Add calculation keys for Glop, if not yet added
    local glop_calc_keys_already_added = {}
    for _,key in ipairs(SMODS.Scoring_Parameters["kali_glop"].calculation_keys) do
        glop_calc_keys_already_added[key] = true
    end

    local glop_calc_keys = {}
    for key in pairs(Potassium.key_effects.kali_glop) do if not glop_calc_keys_already_added[key] then
        table.insert(glop_calc_keys, key)
    end end
    SMODS.Scoring_Parameters["kali_glop"].calculation_keys = glop_calc_keys

    -- Add calculation keys for Sfark, if not yet added
    local sfark_calc_keys_already_added = {}
    for _,key in ipairs(SMODS.Scoring_Parameters["kali_sfark"].calculation_keys) do
        sfark_calc_keys_already_added[key] = true
    end

    local sfark_calc_keys = {}
    for key in pairs(Potassium.key_effects.kali_sfark) do  if not sfark_calc_keys_already_added[key] then
        table.insert(sfark_calc_keys, key)
    end end
    SMODS.Scoring_Parameters["kali_sfark"].calculation_keys = sfark_calc_keys
end)