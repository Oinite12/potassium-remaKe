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
Potassium.mod_path = tostring(SMODS.current_mod.path)
Glop_f = Glop_f or {}

-- A shorthand of adding an event to G.E_MANAGER that only defines the properties trigger, delay, and func.\
-- Event function will always return true, so "return true" is not required.\
-- Consequently, do not use this function if the event function needs to return a non-true value\
-- or if other parameters such as blocking require specification.
---@param trigger string | nil
---@param delay number | nil
---@param func function
---@return nil
Glop_f.add_simple_event = function(trigger, delay, func)
	-- This is here in Oblivion.lua so it's loaded before everything, which uses this function
	G.E_MANAGER:add_event(Event {
		trigger = trigger,
		delay = delay,
		func = function() func(); return true end
	})
end

-- Loads all Lua files in a directory.
---@param folder_name string
---@return nil
function Glop_f.load_directory(folder_name)
	local mod_path = Potassium.mod_path
	local files = NFS.getDirectoryItems(mod_path .. folder_name)
	for _,file_name in ipairs(files) do
		if file_name:match(".lua$") then
			print("[POTASSIUM] Loading file " .. file_name)
			local file_format = ("%s/%s")
			local file_func, err = SMODS.load_file(file_format:format(folder_name, file_name))
			if err then error(err) end
			if file_func then file_func() end
		end
	end
end

Glop_f.load_directory("load_assets")
Glop_f.load_directory("func")
Glop_f.load_directory("items")

-- Add Ambrosia evolutions
Potassium.banana_evolutions = Potassium.banana_evolutions or {}
local k_map = Potassium.banana_evolutions
k_map["j_ice_cream"]   = "j_kali_banana_split"
k_map["j_selzer"]      = "j_kali_potassium_bottle"
k_map["j_egg"]         = "j_kali_begg"
k_map["j_turtle_bean"] = "j_kali_banana_bean"

-- Add Substance evolutions
Potassium.glop_evolutions = Potassium.glop_evolutions or {}
local g_map = Potassium.glop_evolutions
g_map["j_popcorn"]     = "j_kali_glop_corn"
g_map["j_gros_michel"] = "j_kali_glop_michel"
g_map["j_diet_cola"]   = "j_kali_glop_cola"
g_map["j_cavendish"]   = "j_kali_glopendish"
g_map["j_egg"]         = "j_kali_glegg"

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
	'glop'
}) do
	Potassium.calc_keys.additive[key] = true
	Potassium.calc_keys.all[key] = true
end

-- Multiplicative scaling
for _, key in ipairs({
	'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
	'xglop'
}) do
	Potassium.calc_keys.multiplicative[key] = true
	Potassium.calc_keys.all[key] = true
end

-- Exponential scaling
for _, key in ipairs({
	'e_mult', 'emult', 'Emult_mod',
	'e_chips', 'echips', 'Echip_mod',
	'eglop'
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