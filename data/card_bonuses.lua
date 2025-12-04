-- Defines playing card bonuses in a modular manner
-- Files that use this data:
    -- func/funcs.lua (All functions in the section CARD BONUSES)
    -- func/hooks.lua (generate_card_ui hook)

--[[

Card bonuses are defined as follows:
{
    calculation_key = entry of SMODS.scoring_parameter_keys,
    base = number (e.g. mult -> 0, xmult -> 1),

    ability_key = key used in card.ability,
    vars_key = key used in loc_vars (return) table,
    loc_key = key of localization text in descriptions.Other,
    
    held_ability_key = key used in card.ability,
    held_vars_key = key used in loc_vars (return) table,
    held_loc_key = key of localization text in descriptions.Other,
}

]]

Potassium.card_bonuses = Potassium.card_bonuses or {}

-- Old form of Glop - DEPRECATED
table.insert(Potassium.card_bonuses, {
	calculation_key = 'glop',
	base = 0,

	ability_key = 'perma_glop',
	vars_key = 'bonus_glop',
	loc_key = 'card_extra_glop'
})

-- Additive Glop
table.insert(Potassium.card_bonuses, {
	calculation_key = 'glop',
	base = 0,

	ability_key = 'kali_perma_glop',
	vars_key = 'kali_bonus_glop',
	loc_key = 'card_extra_glop',

	held_ability_key = 'kali_perma_h_glop',
	held_vars_key = 'kali_bonus_h_glop',
	held_loc_key = 'card_extra_h_glop'
})

-- Multiplicative Glop
table.insert(Potassium.card_bonuses, {
	calculation_key = 'xglop',
	base = 1,

	ability_key = 'kali_perma_x_glop',
	vars_key = 'kali_bonus_x_glop',
	loc_key = 'card_extra_x_glop',

	held_ability_key = 'kali_perma_h_x_glop',
	held_vars_key = 'kali_bonus_h_x_glop',
	held_loc_key = 'card_extra_h_x_glop'
})

-- Exponential Glop
table.insert(Potassium.card_bonuses, {
	calculation_key = 'eglop',
	base = 1,

	ability_key = 'kali_perma_exp_glop',
	vars_key = 'kali_bonus_exp_glop',
	loc_key = 'card_extra_exp_glop',

	held_ability_key = 'kali_perma_h_exp_glop',
	held_vars_key = 'kali_bonus_h_exp_glop',
	held_loc_key = 'card_extra_h_exp_glop'
})

-- Additive Sfark
table.insert(Potassium.card_bonuses, {
	calculation_key = 'sfark',
	base = 0,

	ability_key = 'kali_perma_sfark',
	vars_key = 'kali_bonus_sfark',
	loc_key = 'card_extra_sfark',

	held_ability_key = 'kali_perma_h_sfark',
	held_vars_key = 'kali_bonus_h_sfark',
	held_loc_key = 'card_extra_h_sfark'
})

-- Multiplicative Sfark
table.insert(Potassium.card_bonuses, {
	calculation_key = 'xsfark',
	base = 1,

	ability_key = 'kali_perma_x_sfark',
	vars_key = 'kali_bonus_x_sfark',
	loc_key = 'card_extra_x_sfark',

	held_ability_key = 'kali_perma_h_x_sfark',
	held_vars_key = 'kali_bonus_h_x_sfark',
	held_loc_key = 'card_extra_h_x_sfark'
})

-- Exponential Sfark
table.insert(Potassium.card_bonuses, {
	calculation_key = 'esfark',
	base = 1,

	ability_key = 'kali_perma_exp_sfark',
	vars_key = 'kali_bonus_exp_sfark',
	loc_key = 'card_extra_exp_sfark',

	held_ability_key = 'kali_perma_h_exp_sfark',
	held_vars_key = 'kali_bonus_h_exp_sfark',
	held_loc_key = 'card_extra_h_exp_sfark'
})