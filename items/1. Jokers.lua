--[[
- Flower Pot (Virgin Bouquet)
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
    blueprint_compat = true,

    calculate = function (self, card, context)
		if context.other_joker and context.other_joker.ability.kali_stickernana then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if (
            context.end_of_round
            and context.game_over == false
            and not context.blueprint
        ) then
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
	blueprint_compat = true,

    yes_pool_flag = 'cavendish_extinct',

    calculate = function (self, card, context)
		if context.joker_main then
            return { emult = card.ability.extra.emult }
		end

        if (
            context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint
        ) then
			if not SMODS.pseudorandom_probability(card, 'kali_bluejava', 1, card.ability.extra.odds) then
				return { message = localize('k_safe_ex') }
			end

            -- Odd is hit
            SMODS.destroy_cards(card, nil, true, true)
            SMODS.calculate_context({kali_extinct = true, other_card = card.config.center.key})
            return { message = localize('k_extinct_ex') }
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
	blueprint_compat = true,

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
	blueprint_compat = true,
	perishable_compat = false,

    calculate = function (self, card, context)
		if context.joker_main then
			return { glop = card.ability.extra.glop }
		end
		if context.individual and context.cardarea == G.play and not context.blueprint then
			simple_scale(card, "glop", "glop_mod", G.C.GLOP)
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
	blueprint_compat = true,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if (
            context.end_of_round
            and context.game_over == false
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

---------------
-- Banana Split
---------------
SMODS.Joker {
    key = "banana_split",
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'kali_bananasplit')
        return {vars = {
            card.ability.extra.chips,
            numerator,
            denominator
        }}
    end,
    config = {
        extra = {
            chips = 200,
            odds = 6
        }
    },

    atlas = "bananokers",
    pos = {x=0, y=0},

    rarity = 1,
    cost = 4,
	blueprint_compat = true,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if context.joker_main then
            return {chips = card.ability.extra.chips}
        end

        if (
            context.end_of_round
            and context.game_over == false
            and not context.blueprint
        ) then
            if not SMODS.pseudorandom_probability(card, 'kali_bananasplit', 1, card.ability.extra.odds) then
                return {message = localize('k_safe_ex')}
            end

            -- Odd is hit
            Glop_f.add_simple_event(nil, nil, function ()
                play_sound('tarot1')
                card:juice_up(0.3, 0.4)
                card.ability.extra.chips = card.ability.extra.chips/2
                local split_card = SMODS.add_card{key = "j_kali_banana_split"}
                split_card.ability.extra.chips = card.ability.extra.chips/2
            end)
            return {message = localize('k_split_ex')}
        end
    end,
}

--------------
-- Banana Bean
--------------
SMODS.Joker {
    key = "banana_bean",
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'kali_bean')
        return {vars = {
            card.ability.extra.hand_size,
            card.ability.extra.hand_size_mod,
            numerator,
            denominator
        }}
    end,
    config = {
        extra = {
            hand_size = 3,
            hand_size_mod = 1,
            odds = 20
        }
    },

    atlas = "bananokers",
    pos = {x=3, y=0},

    rarity = 2,
    cost = 7,
	blueprint_compat = true,
    in_pool = function() return false end,

    add_to_deck = function (self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function (self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
    calculate = function (self, card, context)
        if (
            context.end_of_round
            and context.game_over == false
            and not context.blueprint
        ) then
            card.ability.extra.hand_size = card.ability.extra.hand_size + card.ability.extra.hand_size_mod
            G.hand:change_size(card.ability.extra.hand_size_mod)
            return { message = localize('k_upgrade_ex') }
        end

        if (
            context.after
            and context.main_eval
            and not context.blueprint
            and SMODS.pseudorandom_probability(card, 'kali_bean', 1, card.ability.extra.odds)
        ) then
            SMODS.destroy_cards(context.scoring_hand, nil, true, true)
            SMODS.destroy_cards(card, nil, true, true)
            SMODS.calculate_context({kali_extinct = true, other_card = card.config.center.key})
            return { message = localize('k_extinct_ex') }
        end
    end,
}

------------------------
-- Potassium in a Bottle
------------------------
SMODS.Joker {
    key = "potassium_bottle",
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'kali_potassiumbottle')
        return {vars = {
            card.ability.extra.retriggers,
            numerator,
            denominator
        }}
    end,
    config = {
        extra = {
            retriggers = 2,
            odds = 6
        }
    },

    atlas = "bananokers",
    pos = {x=1, y=0},

    rarity = 2,
    cost = 7,
	blueprint_compat = true,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if context.repetition and context.cardarea == G.play then
            context.other_card:add_sticker('kali_stickernana', true)
            context.other_card:juice_up(0.3, 0.4)
            return {
                repetitions = card.ability.extra.retriggers
            }
        end

        if (
            context.end_of_round
            and context.game_over == false
            and not context.blueprint
        ) then
            if not SMODS.pseudorandom_probability(card, 'kali_potassiumbottle', 1, card.ability.extra.odds) then
                return { message = localize('k_val_up') }
            end

            -- Odd is hit
            SMODS.destroy_cards(card, nil, true, true)
            return { message = localize('k_nope_ex') }
        end
    end,
}

--------

--------------
-- Glop Michel
--------------
SMODS.Joker {
    key = "glop_michel",
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'kali_glopmichel')
        return {vars = {
            card.ability.extra.glop,
            numerator,
            denominator,
            card.ability.extra.glop*denominator,
        }}
    end,
    config = {
        extra = {
            glop = 0.1,
            odds = 6
        }
    },

    atlas = "bananokers",
    pos = {x=1, y=1},

    rarity = 1,
    cost = 4,
	blueprint_compat = true,
	perishable_compat = false,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if context.joker_main then
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'kali_glopmichel')
            -- copied from SMODS just to make sure things go smoothly idk
            local odds_hit = pseudorandom('kali_glopmichel') < numerator / denominator
            SMODS.post_prob = SMODS.post_prob or {}
            SMODS.post_prob[#SMODS.post_prob+1] = {pseudorandom_result = true, numerator = numerator, denominator = denominator, identifier = 'kali_glopmichel'}

            return {
                glop = card.ability.extra.glop*(odds_hit and denominator or 1)
            }
        end
    end,
}

--------
-- Glegg
--------
SMODS.Joker {
    key = "glegg",

    atlas = "bananokers",
    pos = {x=4, y=1},

    rarity = 1,
    cost = 4,
	blueprint_compat = true,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if (
            context.setting_blind
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
        ) then
            if SMODS.pseudorandom_probability(card, 'kali_glegg_nope', 1, 6) then
                return {
                    message = localize("k_nope_ex"),
                    colour = G.C.GLOP
                }
            end

            if SMODS.pseudorandom_probability(card, 'kali_glegg_glopway', 1, 100) then
                SMODS.add_card{key = 'c_kali_glopway'}
            else
                SMODS.add_card{key = 'c_kali_glopur'}
            end
            play_sound('tarot1')
            card:juice_up()
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.GLOP})
            return nil, true
        end
    end,
}

-------------
-- Glopendish
-------------
SMODS.Joker {
    key = "glopendish",
    loc_vars = function (self, info_queue, card)
        local numerator_destroy_other, denominator_destroy_other = SMODS.get_probability_vars(card, 1, card.ability.extra.odds_destroy_other, 'kali_glopendish_destroyother')
        local numerator_destroy_self , denominator_destroy_self  = SMODS.get_probability_vars(card, 1, card.ability.extra.odds_destroy_self , 'kali_glopendish_destroyself' )
        return {vars = {
            numerator_destroy_other,
            denominator_destroy_other,
            numerator_destroy_self,
            denominator_destroy_self,
            card.ability.extra.glop
        }}
    end,
    config = {
        extra = {
            glop = 1.5,
            odds_destroy_other = 2,
            odds_destroy_self  = 1000
        }
    },

    atlas = "bananokers",
    pos = {x=3, y=1},

    rarity = 1,
    cost = 4,
	blueprint_compat = true,
	perishable_compat = false,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if (
            context.setting_blind
            and not card.getting_sliced
            and not context.blueprint
            and SMODS.pseudorandom_probability(card, 'kali_glopendish_destroyother', 1, card.ability.extra.odds_destroy_other)
        ) then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = 1
                    break
                end
            end

            local right_joker = G.jokers.cards[my_pos + 1]
            if not (
                right_joker
                and not right_joker.ability.eternal
                and not right_joker.getting_sliced
            ) then return end

            card.ability.extra.glop = card.ability.extra.glop + right_joker.sell_cost*0.1
            right_joker.getting_sliced = true
            SMODS.destroy_cards(right_joker, false, false, false)
            play_sound('slice1', 0.96+math.random()*0.08)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = number_format(card.ability.extra.glop+0.1*right_joker.sell_cost).." Glop", colour = G.C.GLOP, no_juice = true})
        end

        if context.joker_main then
            return {glop = card.ability.extra.glop}
        end

        if (
            context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint
        ) then
			if not SMODS.pseudorandom_probability(card, 'kali_glopendish_destroyself', 1, card.ability.extra.odds_destroy_self) then
				return { message = localize('k_safe_ex') }
			end

            -- Odd is hit
            SMODS.destroy_cards(card, nil, true, true)
            SMODS.calculate_context({kali_extinct = true, other_card = card.config.center.key})
            return { message = localize('k_extinct_ex') }
        end
    end,
}

------------
-- Glop Cola
------------
SMODS.Joker {
    key = "glop_cola",
    loc_vars = function (self, info_queue, card)
        return {vars = {
            localize{type = 'name_text', set = 'Tag', key = 'tag_kali_glop'}
        }}
    end,

    atlas = "bananokers",
    pos = {x=2, y=1},

    rarity = 2,
    cost = 6,
	blueprint_compat = true,
	eternal_compat = false,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_kali_glop'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
            return nil, true -- This is for Joker retrigger purposes, per VanillaRemade
        end
    end,
}

------------
-- Glop Corn
------------
SMODS.Joker {
    key = "glop_corn",
    loc_vars = function (self, info_queue, card)
        return {vars = {
            card.ability.extra.glop,
            -card.ability.extra.glop_mod,
        }}
    end,
    config = {
        extra = {
            glop = 0.7,
            glop_mod = -0.1
        }
    },

    atlas = "bananokers",
    pos = {x=0, y=1},

    rarity = 1,
    cost = 4,
	blueprint_compat = true,
	perishable_compat = false,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if context.joker_main then
            return {glop = card.ability.extra.glop}
        end

        if (
            context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint
        ) then
            if card.ability.extra.glop - card.ability.extra.glop_mod <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'glop',
                scalar_value = 'glop_mod',
                scaling_message = {
                    message =  localize { type = 'variable', key = 'a_glop_minus', vars = { -card.ability.extra.glop_mod } },
                    colour = G.C.GLOP
                }
            })
        end
    end,
}

-------------
-- Glopmother
-------------
SMODS.Joker {
    key = "glopmother",
    loc_vars = function (self, info_queue, card)
        return {key = card.ability.extra.fake_out and "j_kali_glopmother_fakeout" or nil}
    end,
    config = {
        extra = {
            fake_out = true,
            eglop = 2
        }
    },

    atlas = "bananokers",
    pos = {x=2, y=3},
    soul_pos = {x=3, y=3},

    rarity = 4,
    cost = 20,
	blueprint_compat = true,
	perishable_compat = false,
    in_pool = function() return false end,

    calculate = function (self, card, context)
        if context.joker_main then
            card.ability.extra.fake_out = false
            return {eglop = 2}
        end
    end,
}

--------

---------
-- Glopku
---------
SMODS.Joker {
    key = "glopku",
    loc_vars = function (self, info_queue, card)
        return {vars = {
            card.ability.extra.glop
        }}
    end,
    config = {
        extra = {
            glop = 0.1
        }
    },

    atlas = "bananokers",
    pos = {x=0, y=3},
    soul_pos = {x=1, y=3},
	blueprint_compat = true,
	perishable_compat = false,
    in_pool = function() return false end,

    rarity = 4,
    cost = 20,

    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_glop = (context.other_card.ability.perma_glop or 0) + card.ability.extra.glop
            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.GLOP,
            }
        end
    end,
}