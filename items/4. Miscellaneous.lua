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