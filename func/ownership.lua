-- Taking ownership of various objects for better compatibility

-- TAG: Orbital Tag
-- Proper level up hand animation with other scoring parameters
SMODS.Tag:take_ownership('orbital', {
    apply = function (self, tag, context)
        if context.type == 'immediate' then
            local orbital_hand = tag.ability.orbital_hand
            local current_scoring_params = Glop_f.current_upgradeable_scoring_parameters(orbital_hand)

            Glop_f.start_level_up_hand_animation{
                hand = orbital_hand,
                scoring_params = current_scoring_params
            }
            level_up_hand(tag, orbital_hand, nil, tag.config.levels)
            Glop_f.end_level_up_hand_animation{
                scoring_params = current_scoring_params
            }

            tag:yep('+', G.C.MONEY, function ()
                G.CONTROLLER.locks[tag.ID] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
})

-- CONSUMABLE: Black Hole
-- Proper level up hand animation with other scoring parameters
SMODS.Consumable:take_ownership('black_hole', {
    use = function (self, card, area, copier)
        local current_scoring_params = Glop_f.current_upgradeable_scoring_parameters()
        Glop_f.start_level_up_hand_animation{
            hand_text = localize('k_all_hands'),
            all_parameter_text = '...',
            level_text = '',
            scoring_params = current_scoring_params
        }
        Glop_f.level_up_hand_animation{
            card = card,
            all_parameter_status_text = '+',
            scoring_params = current_scoring_params,
            level_text = '+1'
        }
        Glop_f.end_level_up_hand_animation{
            scoring_params = current_scoring_params
        }
        for hand_key in pairs(G.GAME.hands) do
            level_up_hand(card, hand_key, true)
        end
    end
})

-- JOKER: Burnt Joker
-- Proper level up hand animation with other scoring parameters
SMODS.Joker:take_ownership('burnt', {
    calculate = function (self, card, context)
        if context.pre_discard then
            local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            local current_scoring_params = Glop_f.current_upgradeable_scoring_parameters()
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            Glop_f.start_level_up_hand_animation{
                hand = text,
                scoring_params = current_scoring_params
            }
            level_up_hand(card, text, nil, 1)
            Glop_f.end_level_up_hand_animation{
                scoring_params = current_scoring_params
            }
            return nil, true
        end

    end
})

-- STICKER: Eternal
-- Prevent it from applying to cards with Banana sticker
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