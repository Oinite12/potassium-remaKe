local soundbytes = {
	"glop",
    "glop_edition",
	"sfark",
	"xsfark",
	"expsfark",
}

for _, key in ipairs(soundbytes) do
	SMODS.Sound{
		key = key,
		path = key .. ".ogg"
	}
end