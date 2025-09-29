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
        if (
            context.post_trigger
            and context.other_card == card
            and context.other_ret -- "other return"
        ) then
            local calc_keys = Potassium.calc_keys
            local increased = false
            local glop = 0
            local xglop = 1
            local eglop = 1

            for _,something in pairs(context.other_ret) do
                for return_key, value in pairs(something) do
                    if calc_keys.additive[return_key] then
                        -- Get value's closest power of 10, add 1
                        local reduced_value = value/10^(math.floor(math.log(tonumber(value), 10))+1)
                        glop = glop + reduced_value
                        increased = true
                    elseif calc_keys.multiplicative[return_key] then
                        glop = glop + value
                        increased = true
                    elseif calc_keys.exponential[return_key] then
                        xglop = xglop*value
                        increased = true
                    elseif calc_keys.hyperoperative[return_key] then
                        eglop = eglop*value
                        increased = true
                    end
                end
            end

            if increased then return {
                glop = glop,
                xglop = xglop,
                eglop = eglop
            } end
        end
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
        if context.type == "tag_add" and context.tag.key ~= "tag_kali_glop" then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.BLUE,function()
                if context.tag.ability and context.tag.ability.orbital_hand then
                    G.orbital_hand = context.tag.ability.orbital_hand
                end
                add_tag(Tag(context.tag.key))
                G.orbital_hand = nil
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
        end

        if context.type == "scoring" then
            -- identical to calc_effect down at glop scoring param
            SMODS.Scoring_Parameters.kali_glop:modify(0.5)
            card_eval_status_text(tag.HUD_tag, 'extra', nil, nil, nil, {
                message = localize{
                    type = 'variable',
                    key = 'a_chips',
                    vars = {number_format(0.5)}
                },
                colour = self.colour
            })
        end
    end
}

----------
-- STICKER
-- Banana
----------
SMODS.Sticker {
    key = "stickernana",
    badge_colour = HEX("e8c500"),
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, 10, 'stickernana')
        local key = "kali_stickernana"
        if card.ability.set ~= "Joker" then
            key = "kali_stickernana_playing_card"
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
            and G.GAME.modifiers.enable_stickernana
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
                return card:calculate_stickernana()
            end
        end

        if (
            context.cardarea == G.play
            and context.destroying_card
            and context.destroy_card == card
        ) then
            return card:calculate_stickernana()
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
        if not amount then return end

        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end

        if key == 'glop' and amount ~= 0 then
            self:modify(amount)
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = localize{
                    type = 'variable',
                    key = amount > 0 and 'a_chips' or 'a_chips_minus',
                    vars = {number_format(amount)}
                },
                colour = self.colour,
                sound = 'kali_glop'
            })
            return true
        end

        if key == 'xglop' and amount ~= 1 then
            self:modify(self.current*(amount - 1))
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = localize{
                    type = 'variable',
                    key = amount > 0 and 'a_chips' or 'a_chips_minus',
                    vars = {'X'..number_format(amount)}
                },
                colour = self.colour,
                sound = 'kali_glop'
            })
            return true
        end

        if key == 'eglop' and amount ~= 1 then
            self:modify(self.current^amount - self.current)
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = localize{
                    type = 'variable',
                    key = amount > 0 and 'a_chips' or 'a_chips_minus',
                    vars = {'^'..number_format(amount)}
                },
                colour = self.colour,
                sound = 'kali_glop'
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
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_mult'}, nodes = {
				SMODS.GUI.score_container({
					type = 'mult',
					align = 'cm',
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_kali_glop'}, nodes = {
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