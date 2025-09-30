-- Increase permaglop on the current save file.
---@param amount number
---@return nil
Glop_f.increase_permaglop = function(amount)
    G.PROFILES[G.SETTINGS.profile].permaglop = (G.PROFILES[G.SETTINGS.profile].permaglop or 0) + amount
end

-- Get the permaglop of the current save file.
---@return number
Glop_f.get_permaglop = function() return G.PROFILES[G.SETTINGS.profile].permaglop or 0 end

-- Get the current scoring calculation.
---@return SMODS.Scoring_Calculation
Glop_f.current_scoring_calculation = function()
    return getmetatable(G.GAME.current_scoring_calculation).__index
end