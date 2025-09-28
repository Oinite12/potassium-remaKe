----------
-- EDITION
-- Glop
----------
SMODS.Edition {
    key = "glop",

    shader = "glop",
    pos = {x = 7, y = 6},
    sound = {
        sound = "kali_glop_edition",
        per = 1,
        vol = 1
    },

    calculate = function (self, card, context)
        -- todo: implement glop scoring parameter
    end
}

-----------
-- TAG
-- Glop Tag
-----------
SMODS.Tag {
    key = "glop",

    atlas = "tags",
    pos = {x = 0, y = 0},

    in_pool = function () return false end,

    apply = function (self, tag, context)
        -- todo: implement glop
    end
}

----------
-- STICKER
-- Banana
----------
SMODS.Sticker {
    key = "banana",
    badge_colour = HEX("e8c500"),
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, 10, 'stickernana')
        local key
        if card.ability.set ~= "Joker" then
            key = "banana_playing_card"
        end
        return {
            key = key,
            vars = {
                numerator,
                denominator
            }
        }
    end,

    atlas = "stickers",
    pos = {x = 0, y = 0},

    needs_enabled_flag = true,
    should_apply = function (self, card, center, area, bypass_reroll)
        return (
            (
                area == G.pack_cards
                or area == G.shop_jokers
            )
            and card.ability.set == "Joker"
            and G.GAME.modifiers.enable_banana
        )
    end,
    rate = 0.3,

    calculate = function(self, card, context)
        if (
            context.end_of_round
            and not context.repetition
            and not context.playing_card_end_of_round
            and not context.individual
        ) then
            if card.ability.set == "Joker" then
                return card:calculate_banana()
            end
        end

        if (
            context.cardarea == G.play
            and context.destroying_card
            and context.destroy_card == card
        ) then
            return card:calculate_banana()
        end
    end
}

---------
-- STAKE
-- Banana
---------
SMODS.Stake {
    key = "banana",
    colour = HEX("e8c500"),

    pos = {x = 3, y = 1},
    sticker_atlas = "stickers",
    sticker_pos = {x = 0, y = 0},

    applied_stakes = { "stake_gold" },

    modifiers = function ()
        G.GAME.modifiers.enable_banana = true
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

    calculation_keys = {'glop', 'xglop', 'eglop'},
    calc_effect = function (self, effect, scored_card, key, amount, from_edition)
        
    end
}

----------------------
-- SCORING CALCULATION
-- Glop
----------------------
SMODS.Scoring_Calculation {
    key = 'glop',
    parameters = {'chips', 'mult', 'kali_glop'},
    func = function (self, chips, mult, flames) --[[@overload fun(self, chips, mult, flames): number]]
        return chips * mult * SMODS.get_scoring_parameter('kali_glop', flames)
    end,
    replace_ui = function (self) --[[@overload fun(self): table]]
        local scale = 0.3
        return
		{n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
			{n=G.UIT.C, config={align = 'cm', id = 'hand_chips'}, nodes = {
				SMODS.GUI.score_container({
					type = 'chips',
					text = 'chip_text',
					align = 'cr',
					w = 1.1,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_mult'}, nodes = {
				SMODS.GUI.score_container({
					type = 'mult',
					align = 'cm',
					w = 1.1,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_kali_glop'}, nodes = {
				SMODS.GUI.score_container({
					type = 'kali_glop',
					align = 'cl',
					w = 1.1,
					scale = scale
				})
			}},
		}}
    end
}