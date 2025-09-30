return {
    descriptions = {
        Joker = {

        },
		Planet = {
			c_kali_glopur = {
				name = "Glopur",
				text = {
					"All poker hands",
					"gain {C:glop}+#1#{} Glop"
				}
			},
			c_kali_dvant = {
				name = "Dvant",
				text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} Chips and",
					"{C:glop}+#5#{} Glop",
				}
			},
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
		Edition = {
			e_kali_glop = {
				name = "Glop",
				text = {
					"Scoring effects",
					"also give {C:glop}Glop"
				}
			}
		},
		Tag = {
			tag_kali_glop = {
				name = "Glop Tag",
				text = {
					"{C:glop}+0.5{} Glop",
                    "Gives a copy of the",
                    "next selected {C:attention}Tag{}",
                    "{s:0.8,C:glop}Glop Tag{s:0.8} excluded",
				}
			}
		},
        Other = {
            -- Sticker
            kali_stickernana = {
                name = "Banana",
                text = {
                    "{C:green}#1# in #2#{} chance this",
                    "card is destroyed",
                    "at end of round",
                }
            },
			kali_stickernana_playing_card = {
				name = "Banana",
				text = {
					"{C:green}#1# in #2#{} chance",
					"to destroy card",
				},
			}
        }
    },
    misc = {
        labels = {
            kali_stickernana = "Banana",
            e_kali_glop = "Glop"
        },
		poker_hands = {
			kali_virgin_bouquet = "Virgin Bouquet",
		},
		poker_hand_descriptions = {
			kali_virgin_bouquet = {
				"A hand that contains a Queen, Jack, 10, and 2"
			}
		}
    }
}