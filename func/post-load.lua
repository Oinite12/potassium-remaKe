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
    for joker in pairs(G.P_CENTERS) do
        if (
            joker.ability.set == 'Joker'
            and joker.config.center.rarity == 4
            and joker.config.center.key ~= "j_kali_glopmother"
            and joker.config.center.key ~= "j_kali_glopku"
        ) then
            Potassium.glop_evolutions[joker.config.center.key] = "j_kali_glopmother"
        end
    end
end)