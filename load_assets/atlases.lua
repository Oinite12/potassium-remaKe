local card_atlases = {
	'bananokers',
    'consumables',
    'stickers',
    'xmod_bananokers',
    'placeholders'
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

---------------
-- Placeholders
---------------
Potassium.placeholder_sprites = {
    j_common    = {x=0,y=0},
    j_uncommon  = {x=1,y=0},
    j_rare      = {x=2,y=0},
    j_legendary = {x=3,y=0},

    c_tarot     = {x=0,y=1},
    c_planet    = {x=1,y=1},
    c_spectral  = {x=2,y=1},
}

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