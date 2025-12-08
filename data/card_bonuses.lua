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

local function generate_ability_keys(mod_prefix, operator)
	local function frmt(template)
		return template:format(mod_prefix, operator)
	end
	return {
		nocopy      = frmt("%s_%s"),
		nocopy_held = frmt("%s_h_%s"),
		perma       = frmt("%s_perma_%s"),
		perma_held  = frmt("%s_perma_h_%s"),
	}
end

local function generate_loc_keys(mod_prefix, operator)
	local function frmt(template)
		return template:format(mod_prefix, operator)
	end
	return {
		vars_key      = frmt("%s_bonus_%s"),
		loc_key       = frmt("%s_card_extra_%s"),
		held_vars_key = frmt("%s_bonus_h_%s"),
		held_loc_key  = frmt("%s_card_extra_h_%s"),
	}
end

----

Potassium.card_bonuses = Potassium.card_bonuses or {}

-- Old form of Glop - DEPRECATED
table.insert(Potassium.card_bonuses, {
	calculation_key = 'glop',
	base = 0,

	ability_keys = {
		perma = 'perma_glop'
	},
	loc_keys = {
		vars_key = 'bonus_glop',
		loc_key = 'kali_card_extra_glop'
	},
	get_bonus = function(nocopy, perma)
		return perma
	end
})

-- Additive Glop
table.insert(Potassium.card_bonuses, {
	calculation_key = 'glop',
	base = 0,

	ability_keys = generate_ability_keys('kali', 'glop'),
	loc_keys = generate_loc_keys('kali', 'glop'),
	get_bonus = function(nocopy, perma)
		return (nocopy or 0) + (perma or 0)
	end
})

-- Multiplicative Glop
table.insert(Potassium.card_bonuses, {
	calculation_key = 'xglop',
	base = 1,

	ability_keys = generate_ability_keys('kali', 'x_glop'),
	loc_keys = generate_loc_keys('kali', 'x_glop'),
	get_bonus = function(nocopy, perma)
		return SMODS.multiplicative_stacking(nocopy or 1, perma or 0)
	end
})

-- Exponential Glop
table.insert(Potassium.card_bonuses, {
	calculation_key = 'eglop',
	base = 1,

	ability_keys = generate_ability_keys('kali', 'exp_glop'),
	loc_keys = generate_loc_keys('kali', 'exp_glop'),
	get_bonus = function(nocopy, perma)
		-- We can use mult-stack since (x^y)^z = x^(y*z)
		-- (We're working with y and z here and are trying to find a given x^a)
		-- (for context, mult-stacking is used in x_glop for (x*y)*z = x*(y*z))
		return SMODS.multiplicative_stacking(nocopy or 1, perma or 0)
	end
})

-- Additive Sfark
table.insert(Potassium.card_bonuses, {
	calculation_key = 'sfark',
	base = 0,

	ability_keys = generate_ability_keys('kali', 'sfark'),
	loc_keys = generate_loc_keys('kali', 'sfark'),
	get_bonus = function(nocopy, perma)
		return (nocopy or 0) + (perma or 0)
	end
})

-- Multiplicative Sfark
table.insert(Potassium.card_bonuses, {
	calculation_key = 'xsfark',
	base = 1,

	ability_keys = generate_ability_keys('kali', 'x_sfark'),
	loc_keys = generate_loc_keys('kali', 'x_sfark'),
	get_bonus = function(nocopy, perma)
		return SMODS.multiplicative_stacking(nocopy or 1, perma or 0)
	end
})

-- Exponential Sfark
table.insert(Potassium.card_bonuses, {
	calculation_key = 'esfark',
	base = 1,

	ability_keys = generate_ability_keys('kali', 'exp_sfark'),
	loc_keys = generate_loc_keys('kali', 'exp_sfark'),
	get_bonus = function(nocopy, perma)
		-- See Exponential Glop
		return SMODS.multiplicative_stacking(nocopy or 1, perma or 0)
	end
})