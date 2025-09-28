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

Potassium.banana_evolutions = Potassium.banana_evolutions or {}
local k_map = Potassium.banana_evolutions
k_map["j_ice_cream"]   = "j_kali_banana_split"
k_map["j_selzer"]      = "j_kali_potassium_bottle"
k_map["j_egg"]         = "j_kali_begg"
k_map["j_turtle_bean"] = "j_kali_banana_bean"

Potassium.glop_evolutions = Potassium.glop_evolutions or {}
local g_map = Potassium.glop_evolutions
g_map["j_popcorn"]     = "j_kali_glop_corn"
g_map["j_gros_michel"] = "j_kali_glop_michel"
g_map["j_diet_cola"]   = "j_kali_glop_cola"
g_map["j_cavendish"]   = "j_kali_glopendish"
g_map["j_egg"]         = "j_kali_glegg"