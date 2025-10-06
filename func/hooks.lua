-- These functions append certain behaviors onto existing functions
-- in a manner easier than patching

-- 1. GLOBAL FUNCTIONS
-- 2. CARD OBJECT
-- 3. GAME OBJECT



--------------------------
---- GLOBAL FUNCTIONS ----
--------------------------

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
        Glop_f.level_up_hand_animation{
            hand = hand,
            scoring_params = Glop_f.current_upgradeable_scoring_parameters(hand)
        }
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function() check_for_unlock{type = 'upgrade_hand', hand = hand, level = G.GAME.hands[hand].level} return true end)
    }))
end

-- Hook to add card perma glop values to UI
local gencardui_hook = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
    full_UI_table = gencardui_hook(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
    if card and card.ability and card.ability.perma_glop then
        local desc_nodes = full_UI_table.main
        if card.ability.perma_glop ~= 0 then
            localize{type = 'other', key = 'card_extra_glop', nodes = desc_nodes, vars = {card.ability.perma_glop}}
        end
    end
    return full_UI_table
end


---------------------
---- CARD OBJECT ----
---------------------

-- Hook for Planet Cards having proper level up hand animation
-- with other scoring parameters
local card_useconsumeable_hook = Card.use_consumeable
function Card:use_consumeable(area, copier)
    -- START OF RIP FROM SOURCE --
    stop_use()
    if not copier then set_consumeable_usage(self) end
    if self.debuff then return nil end
    local used_tarot = copier or self

    if self.ability.consumeable.max_highlighted then
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
    end

    local obj = self.config.center
    if obj.use and type(obj.use) == 'function' then
        obj:use(self, area, copier)
        return
    end
    -- END OF RIP FROM SOURCE --
    if self.ability.consumeable.hand_type then
        local current_scoring_params = Glop_f.current_upgradeable_scoring_parameters()
        Glop_f.start_level_up_hand_animation{
            hand = self.ability.consumeable.hand_type,
            scoring_params = current_scoring_params
        }
        level_up_hand(self, self.ability.consumeable.hand_type, nil, 1)
        Glop_f.end_level_up_hand_animation{
            scoring_params = current_scoring_params
        }
    else
        card_useconsumeable_hook(self, area, copier)
    end
end

-- New method: get_glop()

-- Get the amount of glop applied to a playing card.
---@return integer
function Card:get_glop()
    if self.debuff then return 0 end
    return (self.ability.perma_glop or 0)
end



---------------------
---- GAME OBJECT ----
---------------------

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
end