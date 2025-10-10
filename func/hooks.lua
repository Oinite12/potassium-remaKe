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
        Glop_f.level_up_hand_animation{hand = hand}
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

-- Hook to add Glop to hand information
local uiboxhandrow_hook = create_UIBox_current_hand_row
function create_UIBox_current_hand_row(handname, simple)
    local ret = uiboxhandrow_hook(handname, simple)
    if ret and not simple then
        ret.nodes[2] = {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK,r = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.CHIPS, minw = 1.1}, nodes={
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
              {n=G.UIT.T, config={text = number_format(G.GAME.hands[handname].chips, 1000000), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
            }},
            {n=G.UIT.T, config={text = "X", scale = 0.45, colour = G.C.MULT}},
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.MULT, minw = 1.1}, nodes={
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
              {n=G.UIT.T, config={text = number_format(G.GAME.hands[handname].mult, 1000000), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
            }},
            {n=G.UIT.T, config={text = "X", scale = 0.45, colour = G.C.MULT}},
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.GLOP, minw = 1.1}, nodes={
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
              {n=G.UIT.T, config={text = number_format(G.GAME.hands[handname].kali_glop, 1000000), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
            }},
          }}
    end
    return ret
end

-- Hook to select Banana blinds on Ante 12
local getboss_hook = get_new_boss
function get_new_boss()
    if G.GAME.round_resets.ante == 12 then
        local eligible_bosses = {}
        for key,blind in pairs(G.P_BLINDS) do
            if blind.boss and blind.boss.banana then
                eligible_bosses[key] = true
            end
        end
        
        for key in pairs(G.GAME.banned_keys) do
            eligible_bosses[key] = nil
        end

        local min_use = 100
        for key,use_count in pairs(G.GAME.bosses_used) do
            if eligible_bosses[key] then
                eligible_bosses[key] = use_count
                if eligible_bosses[key] <= min_use then
                    min_use = eligible_bosses[key]
                end
            end 
        end
        for key in pairs(eligible_bosses) do
            if eligible_bosses[key] > min_use then
                eligible_bosses[key] = nil
            end
        end

        local _, boss = pseudorandom_element(eligible_bosses, 'bananaboss_select')
        G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] + 1
        return boss
    else return getboss_hook() end
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
        Glop_f.start_level_up_hand_animation{
            hand = self.ability.consumeable.hand_type
        }
        level_up_hand(self, self.ability.consumeable.hand_type, nil, 1)
        Glop_f.end_level_up_hand_animation{}
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

    Glop_f.add_simple_event('after', 1, function ()
        G.hand_text_area.mult = G.HUD:get_UIE_by_ID('hand_mult_area')
        G.hand_text_area.chips = G.HUD:get_UIE_by_ID('hand_chips_area')
    end)
end