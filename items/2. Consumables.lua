---------
-- PLANET
-- Glopur
---------
-- todo: implement glop

---------
-- PLANET
-- Dvant
---------
-- todo: implement glop

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
            select_joker:set_stickernana(true)
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