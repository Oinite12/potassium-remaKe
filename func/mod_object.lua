-- Setting some stuff in this mod's mod object

---------------------
-- RESET GAME GLOBALS
---------------------
Potassium.mod.reset_game_globals = function (run_start)
	if run_start then
		G.GAME.kali_glop_increase_from_calc_keys = 0.01
	end
end

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