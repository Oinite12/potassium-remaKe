-- Manual list of calculation keys and their growth speed
-- Files that use this data:
    -- cross-mod/entr.lua (Adding Ascension Power calc keys)
    -- 3. Card modifiers.lua (Glop edition)
    -- lovely/lovely.lua (function SMODS.calculate_effect patch, for +0.01 Glop increase)

--[[

The tables of Potassium.calc_keys are all actually sets;
of each key-value pair, the value must ALWAYS be either true or nil;
if a key is assigned true, it is an element of the set.
This is required to eliminate duplicate entries, and increase look-up time of calc_keys

]]

Potassium.calc_keys = Potassium.calc_keys or {}
-- Hash tables - key-true pairs (i.e. tbl.foo = true)
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