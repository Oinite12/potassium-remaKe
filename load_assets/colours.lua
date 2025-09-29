G.C.BANAN1 = HEX('f5d953')
G.C.BANAN2 = HEX('9be344')
G.C.GLOP = HEX('11ff11')
G.C.UI_GLOP = G.C.GLOP

local lc_hook = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc_hook()
	end
	G.ARGS.LOC_COLOURS.glop = G.C.GLOP
    G.ARGS.LOC_COLOURS.sfark = HEX("ff00ff")
	return lc_hook(_c, _default)
end