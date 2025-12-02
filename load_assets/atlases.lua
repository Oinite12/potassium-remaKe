local card_atlases = {
	'bananokers',
    'consumables',
    'stickers',
    'xmod_bananokers'
}

---------------------
-- Card-sized sprites
---------------------
for _, key in ipairs(card_atlases) do
	SMODS.Atlas {
		key = key,
		path = key .. ".png",
		px = 71,
		py = 95
	}
end

-------
-- Tags
-------
SMODS.Atlas {
    key = "tags",
    path = "tags.png",
    px = 34,
    py = 34,
}

---------
-- Blinds
---------
SMODS.Atlas {
    key = "blinds",
    atlas_table = "ANIMATION_ATLAS",
    path = "blinds.png",
    px = 34,
    py = 34,
    frames = 21
}

-----------
-- Mod icon
-----------
SMODS.Atlas {
    key = "modicon",
    path = "mod_icon.png",
    px = 34, py = 34,
}