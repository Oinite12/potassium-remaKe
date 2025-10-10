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
                        -- "Normalize" value to significand (scientific notation)
                        local reduced_value = value/10^(math.floor(math.log(tonumber(value) --[[@as number]], 10))+1)
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

    needs_enable_flag = true,
    rate = 0.3,
    should_apply = function (self, card, center, area, bypass_reroll)
        return (
            SMODS.Sticker.should_apply(self, card, center, area, bypass_reroll)
            and not card.ability.eternal
        )
    end,
    apply = function (self, card, val)
        Glop_f.add_simple_event(nil, nil, function ()
            if not card.ability.eternal then
                SMODS.Sticker.apply(self, card, val)
            end
        end)
    end,

    calculate = function(self, card, context)
        if (
            context.end_of_round
            and not context.repetition
            and not context.playing_card_end_of_round
            and not context.individual
        ) then
            if card.ability.set == "Joker" then
                local message, went_extinct = Glop_f.evaluate_extinction(card, 'stickernana', 1, 10, true)
                if went_extinct then
                    if card.config.center.key == "j_gros_michel" then
                        G.GAME.pool_flags.gros_michel_extinct = true
                    elseif card.config.center.key == "j_cavendish" then
                        G.GAME.pool_flags.cavendish_extinct = true
                    end
                end
                return message
            end
        end

        if (
            context.cardarea == G.play
            and context.destroying_card
            and context.destroy_card == card
        ) then
            local message = Glop_f.evaluate_extinction(card, 'stickernana', 1, 10, true)
            return message
        end
    end
}

-- ...Yeah, that's it lmao