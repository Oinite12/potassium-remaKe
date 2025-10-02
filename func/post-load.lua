-- Anything in the following event will only run after the game finishes loading

Glop_f.add_simple_event(nil, nil, function ()
    local glop_values_per_hand = SMODS.Scoring_Parameters.kali_glop.hands --[[@as table]]
    for hand_name in pairs(SMODS.PokerHands) do
        if not glop_values_per_hand[hand_name] then
            glop_values_per_hand[hand_name] = {kali_glop = 1, s_kali_glop = 1, l_kali_glop = 0.01}
        end
    end
end)