-- CROSS-MOD for Entropy
-- Content includes:
	-- WhatSunn (Joker)
	-- Expoglop (Scoring Calculation)

if not (SMODS.Mods["Cryptid"] or {}).can_load then
---- START CAN-LOAD ----

-----------
-- SOUND
-- WhatsApp
-----------
SMODS.Sound{
	key = "whatsapp",
	path = "whatsapp.ogg"
}

-----------
-- JOKER
-- WhatSunn
-----------
SMODS.Joker {
	key = "whatsunn",
	loc_vars = function (self, info_queue, card)
		return {vars = {
			card.ability.extra.eq_glop,
			card.ability.extra.asc
		}}
	end,
	config = {
		extra = {
			eq_glop = 1.5,
			asc = 0.5
		}
	},

	atlas = "xmod_bananokers",
	pos = {x=0, y=0},

	rarity = 1,
	cost = 3,

	calculate = function (self, card, context)
        if context.joker_main then
            return {
				eq_glop = card.ability.extra.eq_glop,
				eq_glop_message = {
					message = "="..card.ability.extra.eq_glop,
					colour = SMODS.Scoring_Parameters.kali_glop.colour,
					sound = "kali_whatsapp",
					pitch = 1
				},
                plus_asc = card.ability.extra.asc
            }
        end
	end,
}

----------------------
-- SCORING CALCULATION
-- Expoglop
----------------------
-- This scoring calculation is needed for Atomikos compatibility,
-- so as to not entirely void Glop when the Joker is in effect
-- TODO: Add Exposfark
-- TODO: poker hand info ui fix for expoglop
SMODS.Scoring_Calculation {
    key = 'expoglop',
    parameters = {'mult', 'chips', 'kali_glop'},
    func = function (self, chips, mult, flames) --[[@overload fun(self, chips, mult, flames): number]]
        local glop = SMODS.get_scoring_parameter('kali_glop', flames)
        if type(glop) == "string" then return 0 end
        return (chips ^ mult) * glop
    end,
    replace_ui = function (self) --[[@overload fun(self): table]]
        local scale = 0.3
		local function op(text, scale, colour)
			return
			{n=G.UIT.C, config={align = "cm"}, nodes={
				{n=G.UIT.T, config={text = text, lang = G.LANGUAGES['en-us'], scale = scale, colour = colour or G.C.WHITE, shadow = true}},
			}}
		end

        return
		{n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
            op("(", 0.5),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_chips'}, nodes = {
				SMODS.GUI.score_container({
					type = 'chips',
					text = 'chip_text',
					align = 'cr',
					w = 1.125,
                    h = 0.7,
					scale = scale
				})
			}},
            op("^", 0.5, G.C.RED),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_mult'}, nodes = {
				SMODS.GUI.score_container({
					type = 'mult',
					align = 'cm',
					w = 1.125,
                    h = 0.7,
					scale = scale
				})
			}},
            op(")", 0.5),
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_kali_glop'}, nodes = {
				SMODS.GUI.score_container({
					type = 'kali_glop',
					align = 'cl',
					w = 1.125,
                    h = 0.7,
					scale = scale
				})
			}},
		}}
    end
}

-------------------------------
-- CALCULATION KEY ORGANIZATION
-------------------------------
-- Ascension Power increase now counts toward the +0.01 Glop increase
for _,key in ipairs({
	'asc', 'asc_mod', 'plus_asc', 'plusasc_mod'
}) do
	Potassium.calc_keys.additive[key] = true
	Potassium.calc_keys.all[key] = true
end

for _,key in ipairs({
	'x_asc'
}) do
	Potassium.calc_keys.multiplicative[key] = true
	Potassium.calc_keys.all[key] = true
end

for _,key in ipairs({
	'exp_asc', 'exp_asc_mod'
}) do
	Potassium.calc_keys.exponential[key] = true
	Potassium.calc_keys.all[key] = true
end

for _,key in ipairs({
	'hyper_asc', 'hyper_asc_mod', 'hyperasc', 'hyperasc_mod'
}) do
	Potassium.calc_keys.hyperoperative[key] = true
	Potassium.calc_keys.all[key] = true
end

---- END CAN-LOAD ----
end