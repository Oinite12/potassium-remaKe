-- These commonly called functions are used across the mod

-- 1. PERMAGLOP
-- 2. LEVEL UP HAND ANIMATION
-- 3. MISCELLANEOUS



-------------------
---- PERMAGLOP ----
-------------------

-- Increase permaglop on the current save file.
---@param amount number
---@return nil
Glop_f.increase_permaglop = function(amount)
    G.PROFILES[G.SETTINGS.profile].permaglop = (G.PROFILES[G.SETTINGS.profile].permaglop or 0) + amount
end

-- Get the permaglop of the current save file.
---@return number
Glop_f.get_permaglop = function() return G.PROFILES[G.SETTINGS.profile].permaglop or 0 end



---------------------------------
---- LEVEL UP HAND ANIMATION ----
---------------------------------

-- Fetch the scoring parameters for the current scoring calculation.\
-- If `hand` is specified, only scoring parameters with defined level hand upgrade\
-- values will be returned.
---@param hand? string
---@return string[]
Glop_f.current_upgradeable_scoring_parameters = function (hand)
    local current_scoring_params = {}
    for _, param_name in ipairs(G.GAME.current_scoring_calculation.parameters) do
        if hand and G.GAME.hands[hand] then
            if G.GAME.hands[hand][param_name] then
                table.insert(current_scoring_params, param_name)
            end
        else
            table.insert(current_scoring_params, param_name)
        end
    end
    return current_scoring_params
end

-- Prepares the level up hand animation by setting parameter, hand, and level text.
---@param args table<string, any>
---@return nil
Glop_f.start_level_up_hand_animation = function (args)
    args = args or {}
    local hand = args.hand
    local hand_text = args.hand_text or hand or ''
    local parameter_text = args.parameter_text or {}
    local all_parameter_text = args.all_parameter_text or ''
    local level_text = args.level_text or (hand and G.GAME.hands[hand].level) or '?'
    local scoring_params = Glop_f.current_upgradeable_scoring_parameters()

    local init_hand_text = {handname = hand_text, level = level_text}
    for _,param_name in ipairs(scoring_params --[[@as table]]) do
        init_hand_text[param_name] = parameter_text[param_name] or (hand and G.GAME.hands[hand][param_name]) or all_parameter_text
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, init_hand_text)
end

-- Plays the level up hand animation by flashing parameter text, and updating level text.
---@param args table<string, any>
---@return nil
Glop_f.level_up_hand_animation = function (args)
    args = args or {}
    local hand = args.hand
    local card = args.card
    local parameter_status_text = args.parameter_status_text or {}
    local all_parameter_status_text = args.all_parameter_status_text or ''
    local level_text = args.level_text or (hand and G.GAME.hands[hand].level) or ''
    local scoring_params = Glop_f.current_upgradeable_scoring_parameters()

    -- Animations play in order of the `parameters` parameter of the scoring calculation
    for i,param_name in ipairs(scoring_params --[[@as table]]) do
        local current_param_text = parameter_status_text[param_name] or (hand and G.GAME.hands[hand][param_name]) or all_parameter_status_text
        Glop_f.add_simple_event('after', i == 1 and 0.2 or 0.9, function ()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
        end)
        update_hand_text({delay = 0}, {[param_name] = current_param_text, StatusText = true})
    end

    Glop_f.add_simple_event('after', 0.9, function ()
        play_sound('tarot1')
        if card then card:juice_up(0.8, 0.5) end
        G.TAROT_INTERRUPT_PULSE = nil
    end)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level=level_text})
    delay(1.3)
end

-- Finishes the level up hand animation by clearing hand and level text,\
-- and reseting parameter text to default values.
---@param args table<string, any>
---@return nil
Glop_f.end_level_up_hand_animation = function (args)
    args = args or {}
    local scoring_params = Glop_f.current_upgradeable_scoring_parameters()

    local post_hand_text = {handname = '', level = ''}
    for _,param_name in ipairs(scoring_params --[[@as table]]) do
        post_hand_text[param_name] = SMODS.Scoring_Parameters[param_name].default_value
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, post_hand_text)
end



---------------------------------
---- LEVEL UP HAND ANIMATION ----
---------------------------------

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