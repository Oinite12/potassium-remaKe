-- These commonly called functions are used across the mod

-- 1. PERMAGLOP
-- 2. LEVEL UP HAND ANIMATION



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

-- Get the current scoring calculation.
---@return SMODS.Scoring_Calculation
Glop_f.current_scoring_calculation = function()
    return getmetatable(G.GAME.current_scoring_calculation).__index
end



---------------------------------
---- LEVEL UP HAND ANIMATION ----
---------------------------------

Glop_f.current_upgradeable_scoring_parameters = function (hand)
    local current_scoring_params = {}
    for _, param_name in ipairs(Glop_f.current_scoring_calculation().parameters) do
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

Glop_f.start_level_up_hand_animation = function (args)
    args = args or {}
    local hand = args.hand
    local hand_text = args.hand_text or hand or ''
    local all_parameter_text = args.all_parameter_text or ''
    local level_text = args.level_text or (hand and G.GAME.hands[hand].level) or '?'
    local scoring_params = args.scoring_params or Glop_f.current_scoring_calculation().parameters

    local init_hand_text = {handname = hand_text, level = level_text}
    for _,param_name in ipairs(scoring_params --[[@as table]]) do
        init_hand_text[param_name] = hand and G.GAME.hands[hand][param_name] or all_parameter_text
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, init_hand_text)
end

Glop_f.level_up_hand_animation = function (args)
    args = args or {}
    local hand = args.hand
    local card = args.card
    local all_parameter_status_text = args.all_parameter_status_text or ''
    local level_text = args.level_text or (hand and G.GAME.hands[hand].level) or ''
    local scoring_params = args.scoring_params or Glop_f.current_scoring_calculation().parameters

    -- Animations play in order of the `parameters` parameter of the scoring calculation
    for i,param_name in ipairs(scoring_params --[[@as table]]) do
        local current_param_text = hand and G.GAME.hands[hand][param_name] or all_parameter_status_text
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

Glop_f.end_level_up_hand_animation = function (args)
    args = args or {}
    local scoring_params = args.scoring_params or Glop_f.current_scoring_calculation().parameters

    local post_hand_text = {handname = '', level = ''}
    for _,param_name in ipairs(scoring_params --[[@as table]]) do
        post_hand_text[param_name] = SMODS.Scoring_Parameters[param_name].default_value
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, post_hand_text)
end