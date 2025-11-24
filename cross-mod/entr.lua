-- CROSS-MOD for Entropy
-- Content includes: Expoglop (Atomikos compatibility)

if not (SMODS.Mods["Cryptid"] or {}).can_load then
------------------------------

----------------------
-- SCORING CALCULATION
-- Expoglop
----------------------
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

------------------------------
end

-- todo: poker hand info ui fix for expoglop