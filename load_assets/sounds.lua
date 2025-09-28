local soundbytes = {
	"glop",
    "glop_edition"
}

for _, key in ipairs(soundbytes) do
	SMODS.Sound{
		key = key,
		path = key .. ".ogg"
	}
end