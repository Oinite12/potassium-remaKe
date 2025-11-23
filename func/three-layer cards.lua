-- Yoinked from Potassium, which yoinked from Crypitd
-- Will clean up later (or feel free to do so)

if not (SMODS.Mods["Cryptid"] or {}).can_load then
------------------------------
SMODS.DrawStep({
    key = "floating_sprite2",
    order = 59,
    func = function(self)
        local center = self.config.center
        if not (
            center.soul_pos
            and center.soul_pos.extra
            and (center.discovered or self.bypass_discovery_center)
        ) then return end

        local scale_mod = 0.07
        local rotate_mod = 0
        local floating_sprite2 = self.children.floating_sprite2

        floating_sprite2:draw_shader(
            "dissolve",   0, nil, nil, self.children.center, scale_mod, rotate_mod, nil, 0.1, nil, 0.6
        )
        floating_sprite2:draw_shader(
            "dissolve", nil, nil, nil, self.children.center, scale_mod, rotate_mod
        )
    end,
    conditions = {
        vortex = false,
        facing = "front"
    },
})

SMODS.draw_ignore_keys.floating_sprite2 = true
local set_spritesref = Card.set_sprites
function Card:set_sprites(_center, _front)
    set_spritesref(self, _center, _front)
    if not (
        _center
        and _center.soul_pos
        and _center.soul_pos.extra
    ) then return end

    self.children.floating_sprite2 = Sprite(
        self.T.x, self.T.y,
        self.T.w, self.T.h,
        G.ASSET_ATLAS[_center.atlas or _center.set],
        _center.soul_pos.extra
    )
    local floating_sprite2 = self.children.floating_sprite2
    floating_sprite2.role.draw_major  = self
    floating_sprite2.states.hover.can = false
    floating_sprite2.states.click.can = false
end
------------------------------
end

--[[

Some additional notes:
- scale_mod used to use the following:
-- 0.07 + 0.02*math.cos(1.8*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
- rotate_mod used to use the following:
-- 0.05*math.cos(1.219*G.TIMERS.REAL) + 0.00*math.cos((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2
- The 9th value of the first draw_shader of floating_sprite2 used to use the following:
-- 0.1 + 0.03*math.cos(1.8*G.TIMERS.REAL)

]]