local shaders = {
	"glop",
    "vital"
}

for _, key in ipairs(shaders) do
	SMODS.Shader{
		key = key,
		path = key .. ".fs"
	}
end