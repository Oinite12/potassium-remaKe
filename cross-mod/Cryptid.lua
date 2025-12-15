-- CROSS-MOD for Cryptid
-- Content includes: N/A

Glop_f = Glop_f or {}

-- Evaluate whether an ability value should be manipulated.
---@param num number
---@param name string
---@return boolean
function Glop_f.do_multiplicative_manipulate(num, name)
    local bonus_def = Potassium.card_bonus_ability_keys[name]
    if not bonus_def then return true end

    local base = bonus_def.base
    return to_big(num) ~= to_big(base)
end