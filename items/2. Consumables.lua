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
        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 0.8,
            delay = 0.3
        }, {
            handname = localize('k_all_hands'),
            chips = '...',
            mult = '...',
            kali_glop = '...',
            level=''
        })

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))

        update_hand_text({
            delay = 0
        }, {
            kali_glop = '+'..card.ability.extra.glop,
            StatusText = true
        })

        delay(1.3)

        for _,hand_prop in pairs(G.GAME.hands) do
            hand_prop.kali_extra_glop = hand_prop.kali_extra_glop + card.ability.extra.glop
            SMODS.Scoring_Parameters.kali_glop:level_up_hand(0, hand_prop)
        end

        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 1.1,
            delay = 0
        }, {
            mult = 0,
            chips = 0,
            kali_glop = SMODS.Scoring_Parameters.kali_glop.default_value,
            handname = '', level = ''
        })
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

----------------

-----------
-- SPECTRAL
-- Ambrosia
-----------
SMODS.Consumable {
    set = "Spectral",
    key = "ambrosia",
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, 10, 'stickernana')
        table.insert(info_queue, {
            set = "Other",
            key = "kali_stickernana",
            vars = {numerator, denominator}
        })
    end,

    atlas = "consumables",
    pos = {x = 2, y = 1},

    can_use = function(self, card)
        for held_joker in ipairs(G.jokers.cards) do
            if not (
                held_joker.ability.kali_stickernana
                or held_joker.ability.eternal
            ) then return true end
        end
        return false
    end,

    use = function (self, card, area, copier)
        local eligible_jokers = {}
        for held_joker in ipairs(G.jokers.cards) do
            if not (
                held_joker.ability.kali_stickernana
                or held_joker.ability.eternal
            ) then table.insert(eligible_jokers, held_joker) end
        end

        if #eligible_jokers == 0 then return end

        local select_joker = pseudorandom_element(
            eligible_jokers,
            pseudoseed('ambrosia'..G.GAME.round_resets.ante)
        ) --[[@as Card]]

        play_sound('tarot1')
        local select_joker_key = select_joker.config.center.key
        local select_joker_evo = Potassium.banana_evolutions[select_joker_key]

        if select_joker_evo then
            select_joker:set_ability(G.P_CENTERS[select_joker_evo])
        else
            select_joker:add_sticker('kali_stickernana')
        end
    end,
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

    can_use = function(self, card)
        for held_joker in ipairs(G.jokers.cards) do
            if not held_joker.edition then return true end
        end
        return false
    end,

    use = function (self, card, area, copier)
        local eligible_jokers = {}
        for held_joker in ipairs(G.jokers.cards) do
            if not held_joker then
                table.insert(eligible_jokers, held_joker)
            end
        end

        if #eligible_jokers == 0 then return end

        local select_joker = pseudorandom_element(
            eligible_jokers,
            pseudoseed('ambrosia'..G.GAME.round_resets.ante)
        ) --[[@as Card]]

        play_sound('tarot1')
        local select_joker_key = select_joker.config.center.key
        local select_joker_evo = Potassium.glop_evolutions[select_joker_key]

        if select_joker_evo then
            select_joker:set_ability(G.P_CENTERS[select_joker_evo])
            play_sound('kali_glop_edition', 1, 1)
        elseif (
            select_joker.config.center.rarity == 4
            and select_joker.config.center.key ~= "j_kali_glopmother"
            and select_joker.config.center.key ~= "j_kali_glopku"
        ) then
            select_joker:set_ability(G.P_CENTERS['j_banana_glopmother'])
            play_sound('kali_glop_edition', 1, 1)
        else
            select_joker:set_edition('e_kali_glop')
        end

        select_joker:juice_up(0.3, 0.4)
    end,
}

--------------
-- SPECTRAL
-- Glopularity
--------------
SMODS.Consumable {
    set = "Spectral",
    key = "glopularity",

    atlas = "consumables",
    pos = {x = 1, y = 1},

    can_use = function (self, card) return true end,
    use = function (self, card, area, copier)
        -- todo: implement glop
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
        -- todo: add glop
        SMODS.add_card{key = "j_kali_glopku"}
    end
}