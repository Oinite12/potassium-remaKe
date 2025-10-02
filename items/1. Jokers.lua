--[[
- Flower Pot (Virgin Bouquet)

Banana evolutions:
- Banana Split
- Banana Bean
- Potassium in a Bottle

Glop evolutions:
- Glop Michel
- Glegg
- Glopendish
- Glop Cola
- Glop Corn
- Glopmother
- Glopku
]]

---@param card Card
---@param target string
---@param scalar string
---@param colour? table
---@param message_key? string
---@return nil
local function simple_scale(card, target, scalar, colour, message_key)
	SMODS.scale_card(card, {
		ref_table = card.ability.extra,
		ref_value = target,
		scalar_value = scalar,
		message_key = message_key,
		message_colour = colour
	})
end

-------------
-- Plantation
-------------
SMODS.Joker {
    key = "plantation",
    loc_vars = function (self, info_queue, card)
        return {vars = {
            card.ability.extra.xmult
        }}
    end,
    config = {
        extra = {
            xmult = 2
        }
    },

    atlas = "bananokers",
    pos = {x=2, y=2},

    rarity = 3,
    cost = 8,

    calculate = function (self, card, context)
		if context.other_joker and context.other_joker.ability.kali_stickernana then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					if i > 1 then
						G.jokers.cards[i - 1]:add_sticker('kali_stickernana', true)
                        G.jokers.cards[i - 1]:juice_up(0.3, 0.4)
					end
					if i < #G.jokers.cards then
						G.jokers.cards[i + 1]:add_sticker('kali_stickernana', true)
                        G.jokers.cards[i + 1]:juice_up(0.3, 0.4)
					end
				end
			end
        end
    end,
}

------------
-- Blue Java
------------
SMODS.Joker {
    key = "blue_java",
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'kali_bluejava')
        return {vars = {
            card.ability.extra.emult,
            numerator, denominator
        }}
    end,
    config = {
        extra = {
            emult = 2,
            odds = 2^1023.99
        }
    },

    atlas = "bananokers",
    pos = {x=0, y=2},

    rarity = 1,
    cost = 4,

    calculate = function (self, card, context)
		if context.joker_main then
            return { emult = card.ability.extra.emult }
		end
        if (
            context.end_of_round
            and context.game_over == false
            and not context.repetition
            and not context.blueprint
        ) then
			if not SMODS.pseudorandom_probability(card, 'kali_bluejava', 1, card.ability.extra.odds) then
				return { message = localize('k_safe_ex') }
			end

            -- Odd is hit
            SMODS.destroy_cards(card, nil, true, true)
            SMODS.calculate_context({kali_extinct = true, other_card = card})
            return { message = localize('k_extinct_ex') }
        end
    end,
}

-----------------------
-- A Glop in the Bucket
-----------------------
SMODS.Joker {
    key = "glop_bucket",
    loc_vars = function (self, info_queue, card)
        return {vars = {
            card.ability.extra.glop_mod,
            card.ability.extra.glop
        }}
    end,
    config = {
        extra = {
            glop = 0,
            glop_mod = 0.01,
        }
    },

    atlas = "bananokers",
    pos = {x=1, y=2},

    rarity = 2,
    cost = 7,

    calculate = function (self, card, context)
		if context.joker_main and card.ability.extra.glop > 0 then
			return { glop = card.ability.extra.glop }
		end
		if context.cardarea == G.play and context.individual and not context.blueprint then
			simple_scale(card, "glop", "glop_mod", G.C.GLOP)
		end
    end,
}

---------------
-- Banana Bread
---------------
SMODS.Joker {
    key = "banana_bread",
    loc_vars = function (self, info_queue, card)
        return {vars = {
            card.ability.extra.xmult_mod,
            card.ability.extra.xmult,
        }}
    end,
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.5
        }
    },

    atlas = "bananokers",
    pos = {x=3, y=2},

    rarity = 2,
    cost = 6,

    calculate = function (self, card, context)
		if context.joker_main and card.ability.extra.xmult > 1 then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if context.kali_extinct then
			simple_scale(card, "xmult", "xmult_mod", G.C.RED)
		end
    end,
}

--------

-------
-- Begg
-------
SMODS.Joker {
    key = "begg",
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'kali_begg')
        return {vars = {
            card.ability.extra.cash,
            numerator, denominator
        }}
    end,
    config = {
        extra = {
            cash = 6,
            odds = 6
        }
    },

    atlas = "bananokers",
    pos = {x=2, y=0},

    rarity = 1,
    cost = 4,

    calculate = function (self, card, context)
        if (
            context.end_of_round
            and context.cardarea == G.jokers
            and not context.blueprint
        ) then
            if not SMODS.pseudorandom_probability(card, 'kali_begg', 1, card.ability.extra.odds) then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.cash
                card:set_cost()
                return {
                    message = localize('k_val_up')
                }
            end

            -- Odd is hit
            local new_cost = math.max(1, math.floor(card.cost/2))
            card.ability.extra_value = (new_cost + card.ability.extra_value)/2 - new_cost
            card:set_cost()
            return {
                message = localize('k_nope_ex'),
            }
        end
    end,
}