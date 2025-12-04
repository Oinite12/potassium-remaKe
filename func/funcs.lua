-- These commonly called functions are used across the mod

-- 1. METAGLOP
-- 2. LEVEL UP HAND ANIMATION
-- 3. CARD BONUSES
-- 4. MISCELLANEOUS



------------------
---- METAGLOP ----
------------------

-- Increase metaglop on the current save file.
---@param amount number
---@return nil
Glop_f.increase_metaglop = function(amount)
    G.PROFILES[G.SETTINGS.profile].metaglop = (G.PROFILES[G.SETTINGS.profile].metaglop or 0) + amount
end

-- Get the metaglop of the current save file.
---@return number
Glop_f.get_metaglop = function() return G.PROFILES[G.SETTINGS.profile].metaglop or 0 end



---------------------------------
---- LEVEL UP HAND ANIMATION ----
---------------------------------

---Check if a scoring parameter can be upgraded in a hand.
---@param param_key string
---@param hand_key? string If not given, function returns true.
---@return boolean
function Glop_f.scoring_parameter_is_upgradeable(param_key, hand_key)
    -- This function is necessary to prevent unnecessary inclusions
    -- of unused scoring parameters into the update_hand_text `vals` table
    -- Might see use outside SMODS code?
    if hand_key and G.GAME.hands[hand_key] then
        if G.GAME.hands[hand_key][param_key] then
            return true
        end
    else
        return true
    end
    return false
end

---Begins the hand level-up animation by setting initial text for scoring parameters and the hand level.
---@param args table|{hand: string?, hand_text: string?, parameter_text: table<string, string>?, all_parameter_text: string?, level_text: string}
---@return nil
function Glop_f.start_level_up_hand_animation(args)
    args = args or {}
    local hand = args.hand
    local hand_text = args.hand_text or hand or ''
    local parameter_text = args.parameter_text or {}
    local all_parameter_text = args.all_parameter_text or ''
    local level_text = args.level_text or (hand and G.GAME.hands[hand].level) or '?'

    local init_hand_text = {handname = hand_text, level = level_text}
    for _,param_key in ipairs(G.GAME.current_scoring_calculation.parameters) do
        if Glop_f.scoring_parameter_is_upgradeable(param_key, hand) then
            init_hand_text[param_key] = parameter_text[param_key] or (hand and G.GAME.hands[hand][param_key]) or all_parameter_text
        else
            init_hand_text[param_key] = SMODS.Scoring_Parameters[param_key].default_value
        end
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, init_hand_text)
end

---Update the text of each scoring parameter one at a time\
---(in the order of `G.GAME.current_scoring_calculation.parameters`),\
---then update the text of the displayed hand level.
---@param args table|{hand: string?, card: Card?, parameter_status_text: table<string, string>?, all_parameter_status_text: string?, level_text: string}
---@return nil
function Glop_f.level_up_hand_animation(args)
    args = args or {}
    local hand = args.hand
    local card = args.card
    local parameter_status_text = args.parameter_status_text or {}
    local all_parameter_status_text = args.all_parameter_status_text or ''
    local level_text = args.level_text or (hand and G.GAME.hands[hand].level) or ''

    -- Animations play in order of the `parameters` parameter of the scoring calculation
    for i,param_key in ipairs(G.GAME.current_scoring_calculation.parameters) do
        if Glop_f.scoring_parameter_is_upgradeable(param_key, hand) then
            local current_param_text = parameter_status_text[param_key] or (hand and G.GAME.hands[hand][param_key]) or all_parameter_status_text
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = i == 1 and 0.2 or 0.9,
                func = function ()
                    play_sound('tarot1')
                    if card then card:juice_up(0.8, 0.5) end
                    G.TAROT_INTERRUPT_PULSE = true
                    return true
                end
            })
            update_hand_text({delay = 0}, {[param_key] = current_param_text, StatusText = true})
        end
    end

    -- Finally, 'level' text is animated
    G.E_MANAGER:add_event(Event {
        trigger = 'after',
        delay = 0.9,
        func = function ()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = nil
            return true
        end
    })
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level=level_text})
    delay(1.3)
end

---Ends the hand level-up animation by re-setting default values as displayed text for scoring parameters, and hiding the hand level.
---@param args table
---@return nil
function Glop_f.end_level_up_hand_animation(args)
    args = args or {}

    local post_hand_text = {handname = '', level = ''}
    for _,param_key in ipairs(G.GAME.current_scoring_calculation.parameters) do
        if Glop_f.scoring_parameter_is_upgradeable(param_key, hand) then
            post_hand_text[param_key] = SMODS.Scoring_Parameters[param_key].default_value
        end
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, post_hand_text)
end



----------------------
---- CARD BONUSES ----
----------------------

-- Sets additional ability values during Card:set_ability.
---@param card Card
---@param new_ability_table table
---@return nil
Glop_f.add_ability_values = function(card, new_ability_table)
    for _,bonus_def in pairs(Potassium.card_bonuses) do
        local ability_key = bonus_def.ability_key
        new_ability_table[ability_key] = card.ability and card.ability[ability_key] or 0

        local held_ability_key = bonus_def.held_ability_key
        if held_ability_key then
            new_ability_table[held_ability_key] = card.ability and card.ability[held_ability_key] or 0
        end
    end
end

-- Sets localization variables for additional bonus values during Card:generate_UIBox_ability_table.
---@param card Card
---@param loc_vars_table table
---@return nil
Glop_f.add_bonus_vars = function(card, loc_vars_table)
    for _,bonus_def in ipairs(Potassium.card_bonuses) do
        local ability_key = bonus_def.ability_key
        local vars_key = bonus_def.vars_key
        loc_vars_table[vars_key] = card.ability[ability_key] ~= 0 and card.ability[ability_key] or nil

        local held_ability_key = bonus_def.held_ability_key
        local held_vars_key = bonus_def.held_vars_key
        if held_ability_key and held_vars_key then
            loc_vars_table[held_vars_key] = card.ability[held_ability_key] ~= 0 and card.ability[held_ability_key] or nil
        end
    end
end

-- Sets calculation keys for additional bonus values for PLAYED cards.
---@param card Card
---@param ret table
---@return nil
Glop_f.additional_played_card_effects = function (card, ret)
    if card.debuff then return end
    for _,bonus_def in ipairs(Potassium.card_bonuses) do
        local ability_key = bonus_def.ability_key
        local calculation_key = bonus_def.calculation_key
        local base = bonus_def.base

        local value = card.ability[ability_key] or 0
        if value and value ~= 0 then
            ret.playing_card[calculation_key] = value + base
            if ability_key == 'perma_glop' then
                sendWarnMessage("[POTASSIUM] card.ability.perma_glop is depreciated, please use card.ability.kali_perma_glop instead.")
            end
        end
    end
end

-- Sets calculation keys for additional bonus values for HELD cards.
---@param card Card
---@param ret table
---@return nil
Glop_f.additional_held_card_effects = function (card, ret)
    if card.debuff then return end
    for _,bonus_def in ipairs(Potassium.card_bonuses) do
        local held_ability_key = bonus_def.held_ability_key
        if not held_ability_key then return end

        local calculation_key = bonus_def.calculation_key
        local base = bonus_def.base

        local value = card.ability[held_ability_key] or 0
        if value and value ~= 0 then
            ret.playing_card[calculation_key] = value + base
        end
    end
end



-----------------------
---- MISCELLANEOUS ----
-----------------------

-- Determine if the card with a Banana sticker hits the chance to go extinct.
---@param card Card
---@param seed string
---@param num number
---@param denom number
---@param is_banana? boolean If true, context.kali_extinct is calculated.
---@return { message: string } | table | nil message
---@return boolean went_extinct
Glop_f.evaluate_extinction = function (card, seed, num, denom, is_banana)
    if not SMODS.pseudorandom_probability(card, seed, num, denom) then
        return {message = localize("k_safe_ex")}, false
    end

    -- Odd is hit
    SMODS.destroy_cards(card, nil, true, true)
    if is_banana then
        SMODS.calculate_context({kali_extinct = true, other_card = card.config.center.key})
    end

    return {message = localize("k_extinct_ex")}, true
end

-- Inserts Stickernana information into the info qeuue.
---@param card Card
---@param info_queue table
---@return nil
Glop_f.stickernana_infoqueue = function (card, info_queue)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, 10, 'stickernana')
    table.insert(info_queue, {
        set = "Other",
        key = "kali_stickernana",
        vars = {numerator, denominator}
    })
end