-- Welcome to the RE:Potassium source code! This file is for loading separate files,
-- which are split to improve code readibility and navigability.

-- Points of interest:
	-- /cross-mod   - Code for features that only activate when the corresponding mod is enabled.
	-- /data        - Data that is used across the entire mod, and is designed to be as easily expandible as possible.
	-- /func        - Largely technical code that is usually not based on specific content.
	-- /items       - The code for the mod's content itself, including cards, card modifiers, blinds, and stakes.
	-- /load-assets - Allows assets to be defined quickly and easily.

SMODS.current_mod.optional_features = {
    post_trigger = true
}

-- talisman compatibility
to_big = to_big or function (x) return x end
is_number = is_number or function(x) return type(x) == 'number' end

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
Glop_f.load_directory("data")
Glop_f.load_directory("cross-mod", function (file_name)
	return (SMODS.Mods[file_name:gsub('%.lua$', '')] or {}).can_load
end)