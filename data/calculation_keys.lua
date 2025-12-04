-- Defines calculation keys (used in the table returned by a Joker's calculate function)
-- Files that use this data:
    -- func/post-load.lua (Add keys of calculation keys to SMODS.scoring_parameter_keys)
    -- items/0. Technical.lua (used in Glop's and Sfark's SMODS.Scoring_Parameter.calc_effect functions)

--[[

All entries of Potassium.key_effects.kali_glop or Potassium.key_effects.kali_sfark
must be a FUNCTION with parameters `current`, a number representing the current value of a scoring parameter,
and `amount`, a number representing the value used to modify `current`.

The return table of calculation key functions are defined as follows:
{
    identity = THE number that does nothing when being operated with,
    apply = formula for changing `current` with `amount`,
    message_key = localization key in misc.v_dictionary,
    message_text = (the variable to pass into message_key) OR (the message text itself),
    sound = key of an SMODS.Sound instance
}

Additional calculations can be made prior to returning the table.

]]

Potassium.key_effects = Potassium.key_effects or {}

-------
-- GLOP
-------
Potassium.key_effects.kali_glop = Potassium.key_effects.kali_glop or {}
Potassium.key_effects.kali_glop["glop"] = function (current, amount)
	return {
		identity = 0,
		apply = current+amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = number_format(amount),
		sound = "kali_glop",
	}
end
Potassium.key_effects.kali_glop["xglop"] = function (current, amount)
	return {
		identity = 1,
		apply = current*amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = 'X'..number_format(amount),
		sound = "kali_glop",
	}
end
Potassium.key_effects.kali_glop["eglop"] = function (current, amount)
	return {
		identity = 1,
		apply = current^amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = '^'..number_format(amount),
		sound = "kali_glop_edition",
	}
end
Potassium.key_effects.kali_glop["eq_glop"] = function (current, amount)
	return {
		identity = current,
		apply = amount,
		message_text = '='..number_format(amount),
		sound = "kali_glop_edition",
	}
end

--------
-- SFARK
--------
Potassium.key_effects.kali_sfark = Potassium.key_effects.kali_sfark or {}
Potassium.key_effects.kali_sfark["sfark"] = function (current, amount)
	return {
		identity = 0,
		apply = current+amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = number_format(amount),
		sound = "kali_sfark"
	}
end
Potassium.key_effects.kali_sfark["xsfark"] = function (current, amount)
	return {
		identity = 1,
		apply = current*amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = 'X'..number_format(amount),
		sound = "kali_xsfark"
	}
end
Potassium.key_effects.kali_sfark["esfark"] = function (current, amount)
	return {
		identity = 1,
		apply = current^amount,
		message_key = amount > 0 and 'a_chips' or 'a_chips_minus',
		message_text = '^'..number_format(amount),
		sound = "kali_expsfark"
	}
end
Potassium.key_effects.kali_sfark["eq_sfark"] = function (current, amount)
	return {
		identity = current,
		apply = amount,
		message_text = '='..number_format(amount),
		sound = "kali_xsfark",
	}
end