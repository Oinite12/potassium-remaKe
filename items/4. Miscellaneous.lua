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

    applied_stakes = { "gold" },
    prefix_config = { applied_stakes = { mod = false } },

    modifiers = function ()
        G.GAME.modifiers.enable_kali_stickernana = true
    end,
}

-------------
-- BLIND
-- The Banana
-------------
SMODS.Blind {
    key = "blindnana",
    boss = {banana = true},
    boss_colour = G.C.BANAN1,
    dollars = 15,

    atlas = "blinds",
    pos = {x = 0, y = 0},
    in_pool = function() return false end,

    calculate = function (self, blind, context)
        if blind.disabled then return end

        if context.hand_drawn then
            local applicable_jokers = {}
            for _,joker in ipairs(G.jokers.cards) do
                if (
                    joker.config.center.key ~= 'j_gros_michel'
                    -- This Cryptid compat conditional was present in the original Potassium
                    or not joker.config.center.immune_to_vermillion
                ) then
                    table.insert(applicable_jokers, joker)
                end
            end

            if #applicable_jokers == 0 then return end

            local select_joker = pseudorandom_element(applicable_jokers, "kali_blindnana") --[[@as Card]]
            Glop_f.add_simple_event('after', 0, function ()
                select_joker:flip()
                select_joker:juice_up(0.3, 0.3)
                play_sound('tarot1')
                play_sound('card1')
            end)
            Glop_f.add_simple_event('after', 0.25, function ()
                select_joker:set_ability(G.P_CENTERS.j_gros_michel)
                select_joker:flip()
                select_joker:juice_up(0.3, 0.3)
                play_sound('tarot2')
            end)
        end
    end
}

-----------
-- BLIND
-- The Peel
-----------
SMODS.Blind {
    key = "peel",
    boss = {banana = true},
    boss_colour = G.C.BANAN1,
    dollars = 15,
    loc_vars = function (self)
        local numerator, denominator = SMODS.get_probability_vars(self, 1, 6, 'kali_peelblind')
        return {vars = {
            numerator, denominator
        }}
    end,
    collection_loc_vars = function(self)
        return { vars = { 1, 6 } }
    end,

    atlas = "blinds",
    pos = {x = 0, y = 1},
    in_pool = function() return false end,

    calculate = function (self, blind, context)
        if blind.disabled then return end

        if (
            context.post_trigger
            and context.other_card
            and not context.other_context.mod_probability
            and not context.other_context.fix_probability
        ) then
            if (
                context.other_card.ability.eternal
            ) then return {
                message = localize('k_safe_ex'),
                message_card = context.other_card
            } end

            local message, went_extinct = Glop_f.evaluate_extinction(context.other_card, 'kali_peelblind', 1, 6)
            message.message_card = context.other_card

            if went_extinct then
                if context.other_card.config.center.key == "j_gros_michel" then
                    G.GAME.pool_flags.gros_michel_extinct = true
                elseif context.other_card.config.center.key == "j_cavendish" then
                    G.GAME.pool_flags.cavendish_extinct = true
                else
                    G.GAME.banned_keys[context.other_card.config.center.key] = true
                end
            end

            return message
        end
    end
}