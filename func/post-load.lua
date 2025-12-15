-- Anything in the following hook will only run after the game finishes loading all mods

local game_splash_hook = Game.splash_screen
function Game:splash_screen()



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
            and not center.kali_exclude_glop_evolution
        ) then
            Potassium.glop_evolutions[center.key] = "j_kali_glopmother"
        end
    end

    -- Add calculation keys for Glop, if not yet added
    local glop_calc_keys_already_added = {}
    for _,key in ipairs(SMODS.Scoring_Parameters["kali_glop"].calculation_keys) do
        glop_calc_keys_already_added[key] = true
    end
    for key in pairs(Potassium.key_effects.kali_glop) do if not glop_calc_keys_already_added[key] then
        table.insert(SMODS.scoring_parameter_keys, key)
    end end

    -- Add calculation keys for Sfark, if not yet added
    local sfark_calc_keys_already_added = {}
    for _,key in ipairs(SMODS.Scoring_Parameters["kali_sfark"].calculation_keys) do
        sfark_calc_keys_already_added[key] = true
    end
    for key in pairs(Potassium.key_effects.kali_sfark) do if not sfark_calc_keys_already_added[key] then
        table.insert(SMODS.scoring_parameter_keys, key)
    end end

    -- Create table for card bonus ability keys
    -- This is a non-ordered list; use Potassium.card_bonuses for an ordered list
    Potassium.card_bonus_ability_keys = {}
    for _,bonus_def in pairs(Potassium.card_bonuses) do
        local ability_keys = bonus_def.ability_keys
        for _,key in pairs(ability_keys) do
            Potassium.card_bonus_ability_keys[key] = bonus_def
        end
    end



    game_splash_hook(self)
end