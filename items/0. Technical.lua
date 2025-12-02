------------------
-- POKER HAND PART
-- Virgin Bouquet
------------------
SMODS.PokerHandPart {
    key = "virgin_bouquet",
    func = function (hand)
        if #hand < 4 then return {} end

        local track_ranks = {}

        for _,card in ipairs(hand) do
            local rank = card:get_id()
            track_ranks[rank] = track_ranks[rank] or {}
            table.insert(track_ranks[rank], card)
        end

        if not (
            -- A rank is not tracked if the rank is not in the hand
            track_ranks[12]     -- queens
            and track_ranks[11] -- jacks
            and track_ranks[10] -- ...10s
            and track_ranks[2]  -- ok come on, what do you think
        ) then return {} end

        local scoring_cards = SMODS.merge_lists{
            track_ranks[12],
            track_ranks[11],
            track_ranks[10],
            track_ranks[2]
        }

        return {scoring_cards}
    end
}

-----------------
-- POKER HAND
-- Virgin Bouquet
-----------------
SMODS.PokerHand {
    key = "virgin_bouquet",
    chips   = 20, mult   = 4,
    l_chips = 15, l_mult = 1,

    visible = false,
    above_hand = "Three of a Kind",
    example = {
        {'S_Q', true },
        {'H_J', true },
        {'C_T', true },
        {'D_2', true },
        {'S_7', false}
    },

    evaluate = function (parts, hand)
        return parts.kali_virgin_bouquet
    end,
}

--------------------
-- SCORING PARAMETER
-- Glop
--------------------
SMODS.Scoring_Parameter {
    key = 'glop',
    default_value = 1,
    colour = G.C.UI_GLOP,

    -- glop values for all hands added in func/post-load.lua
    hands = {
        -- Note that Potassium has "x_kali_glop", parameter for holding non-level Glop
        kali_virgin_bouquet = {kali_glop = 2, s_kali_glop = 2, l_kali_glop = 0.2}
    },
    level_up_hand = function (self, amount, hand)
        local new_kali_glop = hand.s_kali_glop + hand.l_kali_glop*(hand.level - 1) + hand.kali_extra_glop
        hand.kali_glop = math.max(new_kali_glop, 0)
    end,

    calculation_keys = {'glop', 'xglop', 'eglop', 'eq_glop'},
    calc_effect = function (self, effect, scored_card, key, amount, from_edition)
        if not amount then return end

        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end

        -- Define what happens when a key is used, via Potassium.key_effects.kali_glop
        local key_effects = Potassium.key_effects[self.key]
        if key_effects and key_effects[key] then
            local effect_values = key_effects[key](self.current, amount)
            if amount == effect_values.identity then return end

            self:modify(effect_values.apply - self.current)

            local status_text_target = effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus
            card_eval_status_text(status_text_target, 'extra', nil, percent, nil, effect[key .. "_message"] or {
                message = effect_values.message_key and localize{
                    type = 'variable',
                    key = effect_values.message_key,
                    vars = {effect_values.message_text}
                } or effect_values.message_text,
                colour = self.colour,
                sound = effect_values.sound
            })
            return true
        end
    end
}

--------------------
-- SCORING PARAMETER
-- Sfark
--------------------
SMODS.Scoring_Parameter {
    key = 'sfark',
    default_value = 1,
    colour = G.C.SFARK,

    calculation_keys = {'sfark', 'xsfark', 'esfark', 'eq_sfark'},
    calc_effect = function (self, effect, scored_card, key, amount, from_edition)
        if not amount then return end

        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end

        -- Define what happens when a key is used, via Potassium.key_effects.kali_sfark
        local key_effects = Potassium.key_effects[self.key]
        if key_effects and key_effects[key] then
            local effect_values = key_effects[key](self.current, amount)
            if amount == effect_values.identity then return end

            self:modify(effect_values.apply - self.current)

            local status_text_target = effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus
            card_eval_status_text(status_text_target, 'extra', nil, percent, nil, effect[key .. "_message"] or {
                message = effect_values.message_key and localize{
                    type = 'variable',
                    key = effect_values.message_key,
                    vars = {effect_values.message_text}
                } or effect_values.message_text,
                colour = self.colour,
                sound = effect_values.sound
            })
            return true
        end
    end
}

----------------------
-- SCORING CALCULATION
-- Glop
----------------------
SMODS.Scoring_Calculation {
    key = 'glop',
    parameters = {'mult', 'chips', 'kali_glop'},
    func = function (self, chips, mult, flames) --[[@overload fun(self, chips, mult, flames): number]]
        local glop = SMODS.get_scoring_parameter('kali_glop', flames)
        if type(glop) == "string" then return 0 end
        return chips * mult * glop
    end,
    replace_ui = function (self) --[[@overload fun(self): table]]
        local scale = 0.3
        return
		{n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
			{n=G.UIT.C, config={align = 'cm', id = 'hand_chips_container'}, nodes = {
				SMODS.GUI.score_container({
					type = 'chips',
					text = 'chip_text',
					align = 'cr',
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_mult_container'}, nodes = {
				SMODS.GUI.score_container({
					type = 'mult',
					align = 'cm',
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_kali_glop_container'}, nodes = {
				SMODS.GUI.score_container({
					type = 'kali_glop',
					align = 'cl',
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
		}}
    end
}

----------------------
-- SCORING CALCULATION
-- Sfark
----------------------
SMODS.Scoring_Calculation {
    key = 'sfark',
    parameters = {'mult', 'chips', 'kali_glop', 'kali_sfark'},
    func = function (self, chips, mult, flames) --[[@overload fun(self, chips, mult, flames): number]]
        local glop  = SMODS.get_scoring_parameter('kali_glop',  flames)
        local sfark = SMODS.get_scoring_parameter('kali_sfark', flames)
        if type(glop)  == "string" then return 0 end
        if type(sfark) == "string" then return 0 end
        return chips * mult * glop * sfark
    end,
    replace_ui = function (self) --[[@overload fun(self): table]]
        local scale = 0.25
        local w = 2.0
        local h = 0.6
        return
        {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
            {n=G.UIT.C, config={align = 'cm'}, nodes = { -- left side
                {n=G.UIT.R, config={align = 'cm', id = 'hand_chips'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'chips',
                        text = 'chip_text',
                        align = 'cr',
                        w = w,
                        h = h,
                        scale = scale
                    })
                }},
                {n=G.UIT.R, config={align = 'cm', id = 'hand_kali_glop'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'kali_glop',
                        align = 'cr',
                        w = w,
                        h = h,
                        scale = scale
                    })
                }},
            }},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { -- middle
                SMODS.GUI.operator(0.5)
            }},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { -- right side
                {n=G.UIT.R, config={align = 'cm', id = 'hand_mult'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'mult',
                        align = 'cl',
                        w = w,
                        h = h,
                        scale = scale
                    })
                }},
                {n=G.UIT.R, config={align = 'cm', id = 'hand_kali_sfark'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'kali_sfark',
                        align = 'cl',
                        w = w,
                        h = h,
                        scale = scale
                    })
                }},
            }},
        }}
    end
}