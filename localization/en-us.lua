return {
    descriptions = {
        Joker = {

        },
        Spectral = {
            c_kali_ambrosia = {
				name = "Ambrosia",
				text = {
					"Applies {C:attention}Banana{} to",
					"a random Joker, gain {C:money}$20",
					"Some Jokers {C:attention,E:1}evolve {}instead"
				}
			},
            c_kali_substance = {
				name = "Substance",
				text = {
					"Applies {C:glop}Glop{} to",
					"a random Joker",
					"Some Jokers {C:attention,E:1}evolve {}instead"
				}
			},
            c_kali_glopularity = {
				name = "Glopularity",
				text = {
					"{C:attention}Halve{} all hand levels,",
					"all poker hands gain {C:glop}+0.2{} Glop",
					"for each removed level",
				}
			},
            c_kali_glopway = {
				name = "Glopway",
				text = {
					"{C:glop}+0.01{} base Glop",
					"across all runs",
					"Create a {C:attention}Glopku",
					"{C:inactive}(Must have room)"
				}
			},
        },
        Stake = {
            stake_kali_banana = {
                name = "Banana Stake",
                text = {
                    "Cards can be {C:attention}Banana{}",
                    "{s:0.8,C:inactive}({C:green}1 in 10{C:inactive} chance of being destroyed each round){}",
                    "{s:0.8}Applies all previous Stakes",
                },
            }
        },
        Other = {
            -- Sticker
            kali_banana = {
                name = "Banana",
                text = {
                    "{C:green}#1# in #2#{} chance this",
                    "card is destroyed",
                    "at end of round",
                }
            }
        }
    }
}