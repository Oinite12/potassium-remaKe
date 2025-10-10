---------
-- PLANET
-- Glopur
---------
SMODS.Consumable {
    set = "Planet",
    key = "glopur",
    loc_vars = function (self, info_queue, card)
        return {vars = {card.ability.extra.glop}}
    end,
    config = {
        extra = {
            glop = 0.1
        }
    },

    atlas = "consumables",
    pos = {x = 0, y = 0},

    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        Glop_f.start_level_up_hand_animation{
            hand_text = localize('k_all_hands'),
            all_parameter_text = '...',
            level_text = '',
        }

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            return true end }))

        update_hand_text({delay = 0}, {
            kali_glop = '+'..card.ability.extra.glop,
            StatusText = true
        })

        delay(1.3)

        for _,hand_prop in pairs(G.GAME.hands) do
            hand_prop.kali_extra_glop = hand_prop.kali_extra_glop + card.ability.extra.glop
            SMODS.Scoring_Parameters.kali_glop:level_up_hand(0, hand_prop)
        end

        Glop_f.end_level_up_hand_animation{}
    end
}

---------
-- PLANET
-- Dvant
---------
SMODS.Consumable {
    set = "Planet",
    key = "dvant",
    loc_vars = function (self, info_queue, card)
        local hand = G.GAME.hands[card.ability.hand_type]
		return {
			vars = {
				hand.level,
				localize("kali_virgin_bouquet", "poker_hands"),
				hand.l_mult, hand.l_chips, hand.l_kali_glop,
				colours = {(
                    (to_big(hand.level) == to_big(1))
                    and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[math.min(7, hand.level)]
                )},
			},
		}
    end,
    config = {
        hand_type = "kali_virgin_bouquet",
        softlock = true
    },

    atlas = "consumables",
    pos = { x = 1, y = 0 }
}

-----------
-- SPECTRAL
-- Ambrosia
-----------
SMODS.Consumable {
    set = "Spectral",
    key = "ambrosia",
    loc_vars = function (self, info_queue, card)
        Glop_f.stickernana_infoqueue(card, info_queue)
    end,

    atlas = "consumables",
    pos = {x = 2, y = 1},

    add_to_deck = function (self, card, from_debuff)
        for _,consumable in ipairs(G.consumeables.cards) do
            if consumable.config.center.key == 'c_kali_ambrosia' then
                return
            end
        end

        -- Juice evolvable cards until all Ambrosia are removed
        local evo_table = Potassium.banana_evolutions
        G.GAME.juice_banana_cards = true
        for _,joker in ipairs(G.jokers.cards) do
            if evo_table[joker.config.center.key] then
                juice_card_until(joker, function ()
                    return G.GAME.juice_banana_cards
                end, true)
            end
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        for _,consumable in ipairs(G.consumeables.cards) do
            if consumable.config.center.key == 'c_kali_ambrosia' then
                return
            end
        end
        G.GAME.juice_banana_cards = false
    end,

    can_use = function(self, card)
        local evo_table = Potassium.banana_evolutions
        for _,held_joker in ipairs(G.jokers.cards) do
            if (
                not (held_joker.ability.kali_stickernana or held_joker.ability.eternal)
                or evo_table[held_joker.config.center.key]
            ) then return true end
        end
        return false
    end,
    use = function (self, card, area, copier)
        local evo_table = Potassium.banana_evolutions

        local evolving_jokers = {}
        local non_evolving_jokers = {}

        for _,held_joker in ipairs(G.jokers.cards) do
            if evo_table[held_joker.config.center.key] then
                table.insert(evolving_jokers, held_joker)
            elseif not (held_joker.ability.kali_stickernana or held_joker.ability.eternal) then
                table.insert(non_evolving_jokers, held_joker)
            end
        end

        local target_joker
        if #evolving_jokers > 0 then
            target_joker = pseudorandom_element(evolving_jokers, 'kali_ambrosia') --[[@as table]]
            local evo_key = evo_table[target_joker.config.center.key]
            target_joker:set_ability(G.P_CENTERS[evo_key])
        else
            target_joker = pseudorandom_element(non_evolving_jokers, 'kali_ambrosia') --[[@as table]]
            target_joker:add_sticker('kali_stickernana', true)
        end
        play_sound('tarot1')
        target_joker:juice_up(0.3, 0.4)

        ease_dollars(20)
    end
}

------------
-- SPECTRAL
-- Substance
------------
SMODS.Consumable {
    set = "Spectral",
    key = "substance",
    loc_vars = function (self, info_queue, card)
        table.insert(info_queue, G.P_CENTERS.e_kali_glop)
    end,

    atlas = "consumables",
    pos = {x = 0, y = 1},

    add_to_deck = function (self, card, from_debuff)
        for _,consumable in ipairs(G.consumeables.cards) do
            if consumable.config.center.key == 'c_kali_substance' then
                return
            end
        end

        -- Juice evolvable cards until all Substance are removed
        local evo_table = Potassium.glop_evolutions
        G.GAME.juice_glop_cards = true
        for _,joker in ipairs(G.jokers.cards) do
            if evo_table[joker.config.center.key] then
                juice_card_until(joker, function ()
                    return G.GAME.juice_glop_cards
                end, true)
            end
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        for _,consumable in ipairs(G.consumeables.cards) do
            if consumable.config.center.key == 'c_kali_substance' then
                return
            end
        end
        G.GAME.juice_glop_cards = false
    end,

    can_use = function(self, card)
        local evo_table = Potassium.glop_evolutions
        for _,held_joker in ipairs(G.jokers.cards) do
            if (
                not held_joker.edition
                or evo_table[held_joker.config.center.key]
            ) then return true end
        end
        return false
    end,
    use = function (self, card, area, copier)
        local evo_table = Potassium.glop_evolutions

        local evolving_jokers = {}
        local non_evolving_jokers = {}

        for _,held_joker in ipairs(G.jokers.cards) do
            if evo_table[held_joker.config.center.key] then
                table.insert(evolving_jokers, held_joker)
            elseif not held_joker.edition then
                table.insert(non_evolving_jokers, held_joker)
            end
        end

        local target_joker
        if #evolving_jokers > 0 then
            target_joker = pseudorandom_element(evolving_jokers, 'kali_substance') --[[@as table]]
            local evo_key = evo_table[target_joker.config.center.key]
            target_joker:set_ability(G.P_CENTERS[evo_key])
        else
            target_joker = pseudorandom_element(non_evolving_jokers, 'kali_substance') --[[@as table]]
            target_joker:set_edition('e_kali_glop')
        end
        play_sound('tarot1')
        target_joker:juice_up(0.3, 0.4)
    end
}

--------------
-- SPECTRAL
-- Glopularity
--------------
SMODS.Consumable {
    set = "Spectral",
    key = "glopularity",
    loc_vars = function (self, info_queue, card)
        return {vars = {card.ability.extra.glop}}
    end,
    config = {
        extra = {
            glop = 0.2
        }
    },

    atlas = "consumables",
    pos = {x = 1, y = 1},

    soul_set = "Planet",
    hidden = true,
    can_use = function (self, card)
        for _,hand in pairs(G.GAME.hands) do
            if hand.level > 1 then return true end
        end
        return false
    end,
    use = function (self, card, area, copier)
        local spread_glop = 0
        -- Count how much glop to spread
        for _,hand in pairs(G.GAME.hands) do
            local level = hand.level
            local taken_levels = math.floor(level/2)
            spread_glop = spread_glop + 0.2*taken_levels
        end

        Glop_f.start_level_up_hand_animation{
            hand_text = localize('k_all_hands'),
            all_parameter_text = '...',
            level_text = '',
        }
        Glop_f.level_up_hand_animation{
            card = card,
            parameter_status_text = {kali_glop = '+'..spread_glop},
            all_parameter_status_text = '-',
            level_text = '/2'
        }
        Glop_f.end_level_up_hand_animation{}

        -- Spread Glop and update hands accordingly
        for hand_key,hand in pairs(G.GAME.hands) do
            hand.kali_extra_glop = hand.kali_extra_glop + spread_glop
            local taken_levels = math.floor(hand.level/2)
            level_up_hand(card, hand_key, true, -taken_levels)
        end
    end
}

-----------
-- SPECTRAL
-- Glopway
-----------
SMODS.Consumable {
    set = "Spectral",
    key = "glopway",

    atlas = "consumables",
    pos = {x = 0, y = 2},
    soul_pos = {x = 1, y = 2,
        extra = {x = 2, y = 2}
    },

    hidden = true,
    can_use = function (self, card)
        return #G.jokers.cards < G.jokers.config.card_limit or card.area == G.jokers
    end,
    use = function (self, card, area, copier)
        Glop_f.add_simple_event('after', 0.4, function ()
            play_sound('timpani')
            SMODS.add_card{key = "j_kali_glopku"}
            check_for_unlock { type = 'spawn_legendary' }
            card:juice_up(0.3, 0.5)
        end)
        delay(0.6)
    end
}

----------------

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