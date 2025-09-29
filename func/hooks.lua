-- New Card method: calculate_banana

-- Determine if the card with a Banana sticker hits the chance to go extinct.
---@return { message: string } | nil
function Card:calculate_banana()
    if not self.ability.extinct then
        if self.ability.kali_stickernana and SMODS.pseudorandom_probability(self, 'stickernana', 1, 10) then
            self.ability.extinct = true
            SMODS.destroy_cards(self, nil, nil, true)

            if self.config.center.key == "j_gros_michel" then
                G.GAME.pool_flags.gros_michel_extinct = true
            elseif self.config.center.key == "j_cavendish" then
                G.GAME.pool_flags.cavendish_extinct = true
            end

            SMODS.calculate_context({extinct = true, other_card = self})
            return { message = localize("k_extinct_ex") }
        elseif self.ability.kali_stickernana then
            return { message = localize("k_safe_ex") }
        end
    end
end

-- New Card method: set_banana

--- Toggle the Banana sticker on a card.
---@param _stickernana boolean
---@return nil
function Card:set_stickernana(_stickernana) self.ability.kali_stickernana = _stickernana end

-- Hook to set profile Glop, if not already set
local game_initgameobj_hook = Game.init_game_object
function Game:init_game_object()
    local ret = game_initgameobj_hook(self)
    G.PROFILES[G.SETTINGS.profile].glop = G.PROFILES[G.SETTINGS.profile].glop or 1
    SMODS.Scoring_Parameters.kali_glop.default_value = G.PROFILES[G.SETTINGS.profile].glop
    return ret
end

-- Hook to increase Glop by 0.01 per chip/mult/glop/etc increase
local smods_calcfx_hook = SMODS.calculate_effect
function SMODS.calculate_effect(effect, ...)
    local ret = smods_calcfx_hook(effect, ...)
    for key in pairs(effect) do
        if Potassium.calc_keys.all[key] then
            SMODS.Scoring_Parameters.kali_glop:modify(0.01)
        end
    end
    return ret
end

-- Ownership of Eternal sticker to prevent it from applying to cards with Banana sticker
SMODS.Sticker:take_ownership('eternal', {
    should_apply = function (self, card, center, area, bypass_reroll)
        return (
            G.GAME.modifiers.enable_eternals_in_shop
            and not card.perishable
            and not card.kali_stickernana
            and card.config.center.eternal_compat
        )
    end
}, true)