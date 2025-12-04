SMODS.current_mod.optional_features = {
    post_trigger = true
}

if not to_big then
    function to_big(x) return x end
end
if not is_number then
    function is_number(x) return type(x) == 'number' end
end

Potassium = Potassium or {}
Potassium.mod = SMODS.current_mod
Potassium.mod_path = tostring(SMODS.current_mod.path)
Glop_f = Glop_f or {}

----------
-- LOADING
----------

-- A shorthand of adding an event to G.E_MANAGER that only defines the properties trigger, delay, and func.\
-- Event function will always return true, so "return true" is not required.\
-- Consequently, do not use this function if the event function needs to return a non-true value\
-- or if other parameters such as blocking require specification.
---@param trigger string | nil
---@param delay number | nil
---@param func function
---@return nil
Glop_f.add_simple_event = function(trigger, delay, func)
	-- This is here in index.lua so it's loaded before everything, which uses this function
	G.E_MANAGER:add_event(Event {
		trigger = trigger,
		delay = delay,
		func = function() func(); return true end
	})
end

-- Loads all Lua files in a directory.
---@param folder_name string
---@param condition_function? fun(file_name: string): boolean
---@return nil
function Glop_f.load_directory(folder_name, condition_function)
	local mod_path = Potassium.mod_path
	local files = NFS.getDirectoryItems(mod_path .. folder_name)

	for _,file_name in ipairs(files) do if file_name:match("%.lua$") then
		local condition_is_met = true
		if condition_function then condition_is_met = condition_function(file_name) end

		if condition_is_met then
			print("[POTASSIUM] Loading file " .. file_name)
			local file_format = "%s/%s"
			local file_func, err = SMODS.load_file(file_format:format(folder_name, file_name))
			if err then error(err) end --Steamodded actually does a really good job of displaying this info! So we don't need to do anything else.
			if file_func then file_func() end
		end
	end end
end

Glop_f.load_directory("load_assets")
Glop_f.load_directory("func")
Glop_f.load_directory("items")

-------------
-- MOD OBJECT
-------------
Potassium.mod.reset_game_globals = function (run_start)
	if run_start then
		G.GAME.kali_glop_increase_from_calc_keys = 0.01
	end
end

-------------
-- EVOLUTIONS
-------------

-- Add Ambrosia evolutions
Potassium.banana_evolutions = Potassium.banana_evolutions or {}
local k_map = Potassium.banana_evolutions
k_map["j_egg"]         = "j_kali_begg"
k_map["j_ice_cream"]   = "j_kali_banana_split"
k_map["j_turtle_bean"] = "j_kali_banana_bean"
k_map["j_selzer"]      = "j_kali_potassium_bottle"

-- Add Substance evolutions
Potassium.glop_evolutions = Potassium.glop_evolutions or {}
local g_map = Potassium.glop_evolutions
g_map["j_gros_michel"] = "j_kali_glop_michel"
g_map["j_egg"]         = "j_kali_glegg"
g_map["j_cavendish"]   = "j_kali_glopendish"
g_map["j_diet_cola"]   = "j_kali_glop_cola"
g_map["j_popcorn"]     = "j_kali_glop_corn"

-----------------------------
-- CALCULATION KEY DEFINITION
-----------------------------
Potassium.key_effects = Potassium.key_effects or {}
Potassium.key_effects.kali_glop = Potassium.key_effects.kali_glop or {}
Potassium.key_effects.kali_glop["glop"] = function (current, amount)
	return {
		identity = 0,
		apply = current+amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = number_format(amount),
		sound = "kali_glop",
	}
end
Potassium.key_effects.kali_glop["xglop"] = function (current, amount)
	return {
		identity = 1,
		apply = current*amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = 'X'..number_format(amount),
		sound = "kali_glop",
	}
end
Potassium.key_effects.kali_glop["eglop"] = function (current, amount)
	return {
		identity = 1,
		apply = current^amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = '^'..number_format(amount),
		sound = "kali_glop_edition",
	}
end
Potassium.key_effects.kali_glop["eq_glop"] = function (current, amount)
	return {
		identity = current,
		apply = amount,
		message_text = '='..number_format(amount),
		sound = "kali_glop_edition",
	}
end

Potassium.key_effects.kali_sfark = Potassium.key_effects.kali_sfark or {}
Potassium.key_effects.kali_sfark["sfark"] = function (current, amount)
	return {
		identity = 0,
		apply = current+amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = number_format(amount),
		sound = "kali_sfark"
	}
end
Potassium.key_effects.kali_sfark["xsfark"] = function (current, amount)
	return {
		identity = 1,
		apply = current*amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = 'X'..number_format(amount),
		sound = "kali_xsfark"
	}
end
Potassium.key_effects.kali_sfark["esfark"] = function (current, amount)
	return {
		identity = 1,
		apply = current^amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = '^'..number_format(amount),
		sound = "kali_expsfark"
	}
end
Potassium.key_effects.kali_sfark["eq_sfark"] = function (current, amount)
	return {
		identity = current,
		apply = amount,
		message_text = '='..number_format(amount),
		sound = "kali_xsfark",
	}
end

-------------------------------
-- CALCULAITON KEY ORGANIZATION
-------------------------------

-- Manual list of calculation keys and their growth speed
Potassium.calc_keys = Potassium.calc_keys or {}
-- Hash tables
Potassium.calc_keys.additive       = {}
Potassium.calc_keys.multiplicative = {}
Potassium.calc_keys.exponential    = {}
Potassium.calc_keys.hyperoperative = {}
Potassium.calc_keys.all            = {}

-- Additive scaling
for _, key in ipairs({
	'chips', 'h_chips', 'chip_mod',
	'mult', 'h_mult', 'mult_mod',
	'glop',
	'sfark'
}) do
	Potassium.calc_keys.additive[key] = true
	Potassium.calc_keys.all[key] = true
end

-- Multiplicative scaling
for _, key in ipairs({
	'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
	'xglop',
	'xsfark'
}) do
	Potassium.calc_keys.multiplicative[key] = true
	Potassium.calc_keys.all[key] = true
end

-- Exponential scaling
for _, key in ipairs({
	'e_mult', 'emult', 'Emult_mod',
	'e_chips', 'echips', 'Echip_mod',
	'eglop',
	'esfark'
}) do
	Potassium.calc_keys.exponential[key] = true
	Potassium.calc_keys.all[key] = true
end

-- Hyperoperative scaling
for _, key in ipairs({
	'ee_mult', 'eemult','EEmult_mod',
    'eee_mult', 'eeemult','EEEmult_mod',
	'hyper_mult', 'hypermult', 'hypermult_mod',
	'ee_chips', 'eechips', 'EEchip_mod',
	'eee_chips', 'eeechips', 'EEEchip_mod',
	'hyper_chips', 'hyperchips', 'hyperchip_mod'
}) do
	Potassium.calc_keys.hyperoperative[key] = true
	Potassium.calc_keys.all[key] = true
end

---------------
-- CARD BONUSES
---------------
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

--------------------
-- CROSS-MOD LOADING
--------------------

-- Cross-mod files (named with mod ID) only loaded if mod is loaded
Glop_f.load_directory("cross-mod", function (file_name)
	return (SMODS.Mods[file_name:gsub('%.lua$', '')] or {}).can_load
end)

----------
-- CREDITS
----------

local og_contrib_credits = {
	{
		'firz',
		'zedruu_the_goat',
		'vexastrae',
		'playerrWon',
		'Mysthaps',
		'Foegro',
		'pannella',
		'Lexi',
		'Project666',
		'astrapboy',
		'notmario',
		'Mystic Misclick',
		'Aomi',
	}, {
		'Crimson Heart',
		'Squiddy',
		'Dragokillfist',
		'Jevonn',
		'cassknows',
		'ori',
		'unexian',
		'Aure',
		'xphrogx',
		'GloomyStew',
		'George the Rat',
		'5381',
		'GiygasBandicoot',
	}
}

local contrib_credits = {
	{
		"Lil Mr. Slipstream",
		"HexaCryonic",
	},
	{
		"-",
		"-",
	},
	{
		"Sprites",
		"Sound effects",
	}
}

local function prepare_credits(texts, align, text_scale)
	local nodes = {}
	for _, text in ipairs(texts) do
		table.insert(nodes, {n=G.UIT.R, config={align = align, padding = 0}, nodes = {
			{n=G.UIT.T, config={text = text, scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
		}})
	end
	return {n=G.UIT.C, config={align = "tl", padding = 0.10}, nodes=nodes}
end

local function prepare_header(texts, text_scale)
	local nodes = {}
	for _, text in ipairs(texts) do
		table.insert(nodes, {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
			{n=G.UIT.T, config={text = text, scale = text_scale*0.8, colour = G.C.WHITE, shadow = true}},
		}})
	end
	return {n=G.UIT.R, config={align = "cm", padding = 0.15, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes=nodes}
end

local function prepare_subheader(texts, text_scale)
	local nodes = {}
	for _, text in ipairs(texts) do
		table.insert(nodes, {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
			{n=G.UIT.T, config={text = text, scale = text_scale*0.6, colour = G.C.WHITE, shadow = true}},
		}})
	end
	return {n=G.UIT.R, config={align = "cm", padding = 0.1, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes=nodes}
end

local function banana_credits()
    local text_scale = 0.8
    return {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 6}, nodes={

		-- REMAKE CREDITS
		{n=G.UIT.C, config={align = "cm", padding = 0.05}, nodes = {
			prepare_header({"Remake credits"}, text_scale),
			prepare_subheader({
				"Lead Developer: Oinite",
				"Lead Designer: cassknows",
			}, text_scale),
			{n=G.UIT.R, config={align = "cm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
					{n=G.UIT.T, config={text = "Additional contributions", scale = text_scale*0.6, colour = G.C.BANAN1, shadow = true}},
				}},
				{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
					prepare_credits(contrib_credits[1], 'cr', text_scale),
					prepare_credits(contrib_credits[2], 'cm', text_scale),
					prepare_credits(contrib_credits[3], 'cl', text_scale),
				}},
			}},
		}},

		-- ORIGINAL CREDITS
		{n=G.UIT.C, config={align = "cm", padding = 0.05}, nodes = {
			prepare_header({"Original mod credits"}, text_scale),
			prepare_subheader({"Lead Developer: MathIsFun_"}, text_scale),
			{n=G.UIT.R, config={align = "cm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
					{n=G.UIT.T, config={text = "Contributors", scale = text_scale*0.6, colour = G.C.BANAN1, shadow = true}},
				}},
				{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
					prepare_credits(og_contrib_credits[1], 'cr', text_scale),
					prepare_credits(og_contrib_credits[2], 'cl', text_scale),
				}},
			}}
		}}
	}}
end

SMODS.current_mod.extra_tabs = function ()
	return {
		{
			label = "Credits",
			tab_definition_function = banana_credits
		}
	}
end