-- Override to properly update all scoring parameters during level up
function level_up_hand(card, hand, instant, amount)
    amount = amount or 1
    G.GAME.hands[hand].level = math.max(0, G.GAME.hands[hand].level + amount)

    for name, parameter in pairs(SMODS.Scoring_Parameters) do
        if G.GAME.hands[hand][name] then
            parameter:level_up_hand(amount, G.GAME.hands[hand])
        end
    end

    if not instant then
        local anim_once = false

        -- Animations play in order of the `parameters` parameter of the scoring calculation
        local current_scoring_params = Glop_f.current_scoring_calculation().parameters --[[@as table]]
        for _,name in ipairs(current_scoring_params) do
            Glop_f.add_simple_event('after', anim_once and 0.9 or 0.2, function ()
                play_sound('tarot1')
                if card then card:juice_up(0.8, 0.5) end
                if not anim_once then G.TAROT_INTERRUPT_PULSE = true end
            end)
            update_hand_text({delay = 0}, {[name] = G.GAME.hands[hand][name], StatusText = true})
            anim_once = true
        end

        Glop_f.add_simple_event('after', 0.9, function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = nil
        end)

        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level=G.GAME.hands[hand].level})
        delay(1.3)
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function() check_for_unlock{type = 'upgrade_hand', hand = hand, level = G.GAME.hands[hand].level} return true end)
    }))
end

-- New Card method: calculate_stickernana

-- Determine if the card with a Banana sticker hits the chance to go extinct.
---@return { message: string } | nil
function Card:calculate_stickernana()
    if not self.ability.extinct then
        if self.ability.kali_stickernana and SMODS.pseudorandom_probability(self, 'stickernana', 1, 10) then
            self.ability.extinct = true
            SMODS.destroy_cards(self, nil, nil, true)

            if self.config.center.key == "j_gros_michel" then
                G.GAME.pool_flags.gros_michel_extinct = true
            elseif self.config.center.key == "j_cavendish" then
                G.GAME.pool_flags.cavendish_extinct = true
            end

            SMODS.calculate_context({extinct = true, other_card = self})
            return { message = localize("k_extinct_ex") }
        elseif self.ability.kali_stickernana then
            return { message = localize("k_safe_ex") }
        end
    end
end

-- Hook to set profile permaglop, if not already set
local game_initgameobj_hook = Game.init_game_object
function Game:init_game_object()
    local ret = game_initgameobj_hook(self)
    G.PROFILES[G.SETTINGS.profile].permaglop = G.PROFILES[G.SETTINGS.profile].permaglop or 0

    local permaglop = G.PROFILES[G.SETTINGS.profile].permaglop
    SMODS.Scoring_Parameters.kali_glop.default_value = permaglop + 1

    return ret
end

-- Hook to set default Glop
local game_startrun_hook = Game.start_run
function Game:start_run(...)
    game_startrun_hook(self, ...)
    local permaglop = G.PROFILES[G.SETTINGS.profile].permaglop
    SMODS.Scoring_Parameters.kali_glop.default_value = permaglop + 1
    SMODS.set_scoring_calculation('kali_glop')

    if not G.GAME.set_permaglop then
        for _,hand_info in pairs(G.GAME.hands) do
            hand_info.kali_extra_glop = Glop_f.get_permaglop()
            SMODS.Scoring_Parameters.kali_glop:level_up_hand(0, hand_info)
            G.GAME.set_permaglop = true
        end
        G.GAME.set_permaglop = true
    end

    G.hand_text_area.chips = G.HUD:get_UIE_by_ID('hand_chips_area') or nil
    G.hand_text_area.mult  = G.HUD:get_UIE_by_ID('hand_mult_area')  or nil
end

-- Hook to increase Glop by 0.01 per chip/mult/glop/etc increase
local smods_calcfx_hook = SMODS.calculate_effect
function SMODS.calculate_effect(effect, ...)
    local ret = smods_calcfx_hook(effect, ...)
    for key in pairs(effect) do
        if Potassium.calc_keys.all[key] then
            SMODS.Scoring_Parameters.kali_glop:modify(0.01)
        end
    end
    return ret
end

-- Ownership of Eternal sticker to prevent it from applying to cards with Banana sticker
SMODS.Sticker:take_ownership('eternal', {
    should_apply = function (self, card, center, area, bypass_reroll)
        return (
            G.GAME.modifiers.enable_eternals_in_shop
            and not card.perishable
            and not card.kali_stickernana
            and card.config.center.eternal_compat
        )
    end
}, true)