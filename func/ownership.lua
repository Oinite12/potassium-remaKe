-- Taking ownership of various objects for better compatibility

-- TAG: Orbital Tag
-- Proper level up hand animation with other scoring parameters
SMODS.Tag:take_ownership('orbital', {
    apply = function (self, tag, context)
        if context.type == 'immediate' then
            local orbital_hand = tag.ability.orbital_hand

            Glop_f.start_level_up_hand_animation{
                hand = orbital_hand,
            }
            level_up_hand(tag, orbital_hand, nil, tag.config.levels)
            Glop_f.end_level_up_hand_animation{}

            tag:yep('+', G.C.MONEY, function ()
                G.CONTROLLER.locks[tag.ID] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}, true)

-- CONSUMABLE: Black Hole
-- Proper level up hand animation with other scoring parameters
SMODS.Consumable:take_ownership('black_hole', {
    use = function (self, card, area, copier)
        Glop_f.start_level_up_hand_animation{
            hand_text = localize('k_all_hands'),
            all_parameter_text = '...',
            level_text = '',
        }
        Glop_f.level_up_hand_animation{
            card = card,
            all_parameter_status_text = '+',
            level_text = '+1'
        }
        Glop_f.end_level_up_hand_animation{}
        for hand_key in pairs(G.GAME.hands) do
            level_up_hand(card, hand_key, true)
        end
    end
}, true)

-- JOKER: Burnt Joker
-- Proper level up hand animation with other scoring parameters
SMODS.Joker:take_ownership('burnt', {
    calculate = function (self, card, context)
        if context.pre_discard then
            local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            Glop_f.start_level_up_hand_animation{
                hand = text,
            }
            level_up_hand(card, text, nil, 1)
            Glop_f.end_level_up_hand_animation{}
            return nil, true
        end

    end
}, true)

-- JOKER: Gros Michel
-- Extinct context compatibility
SMODS.Joker:take_ownership('gros_michel', {
    calculate = function (self, card, context)
        if context.joker_main then
            return {mult = card.ability.extra.mult}
        end

        if (
            context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint
        ) then
			if not SMODS.pseudorandom_probability(card, 'gros_michel', 1, card.ability.extra.odds) then
				return { message = localize('k_safe_ex') }
			end

            -- Odd is hit
            SMODS.destroy_cards(card, nil, true, true)
            SMODS.calculate_context({kali_extinct = true, other_card = card})
            G.GAME.pool_flags.gros_michel_extinct = true
            return { message = localize('k_extinct_ex') }
        end
    end
}, true)

-- JOKER: Cavendish
-- Extinct context compatibility
SMODS.Joker:take_ownership('cavendish', {
    no_pool_flag = 'cavendish_extinct',
    calculate = function (self, card, context)
        if context.joker_main then
            return {mult = card.ability.extra.Xmult}
        end

        if (
            context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint
        ) then
			if not SMODS.pseudorandom_probability(card, 'cavendish', 1, card.ability.extra.odds) then
				return { message = localize('k_safe_ex') }
			end

            -- Odd is hit
            SMODS.destroy_cards(card, nil, true, true)
            SMODS.calculate_context({kali_extinct = true, other_card = card})
            G.GAME.pool_flags.cavendish_extinct = true
            return { message = localize('k_extinct_ex') }
        end
    end
}, true)

-- SCORING PARAMETER: Mult
-- Exponential mult
local sp_mult_calc_hook = SMODS.Scoring_Parameters.mult.calc_effect
SMODS.Scoring_Parameter:take_ownership('mult', {
    calc_effect = function(self, effect, scored_card, key, amount, from_edition)
        if (key == 'emult' or key == 'e_mult' or key == 'Emult_mod') then
            if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
            self:modify(self.current^amount - self.current)
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = localize{
                    type = 'variable',
                    key = amount > 0 and 'a_emult' or 'a_emult_minus',
                    vars = {number_format(amount)}
                },
                colour = self.colour,
                sound = 'multhit2'
            })
            return true
        end
        return sp_mult_calc_hook(self, effect, scored_card, key, amount, from_edition)
    end
}, true)
table.insert(SMODS.Scoring_Parameters.mult.calculation_keys, 'emult')
table.insert(SMODS.Scoring_Parameters.mult.calculation_keys, 'e_mult')
table.insert(SMODS.Scoring_Parameters.mult.calculation_keys, 'Emult_mod')