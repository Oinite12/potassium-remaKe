return {
    descriptions = {
        Joker = {
			j_kali_plantation = {
				name = "Plantation",
				text = {
					"{C:attention}Banana{} Jokers give {X:mult,C:white}X#1# {} Mult",
					"At end of round, apply",
					"{C:attention}Banana{} to adjacent Jokers",
				}
			},
			j_kali_blue_java = {
				name = "Blue Java",
				text = {
                    "{X:dark_edition,C:white} ^#1# {} Mult",
                    "{C:green}#2# in #3#{} chance this",
                    "card is destroyed",
                    "at end of round",
				}
			},
			j_kali_banana_bread = {
				name = "Banana Bread",
				text = {
					"Gain {X:mult,C:white}X#1# {} Mult when a",
					"{C:attention}Banana card{} goes extinct",
					"{C:inactive}(Currently: {X:mult,C:white}X#2# {C:inactive} Mult)",
				}
			},
			j_kali_glop_bucket = {
				name = "A Glop in the Bucket",
				text = {
					"This Joker gains",
					"{C:glop}+#1#{} Glop when each",
					"played {C:attention}card{} is scored",
					"{C:inactive}(Currently {C:glop}+#2#{C:inactive} Glop)",
				}
			},
			j_kali_poppies_dreamt = {
				name = "Poppies, Dreamt",
				text = {
                    "{X:mult,C:white}X#1# {} Mult and {C:glop}+#2# {}Glop",
                    "if poker hand contains a",
					"{C:attention}Queen{}, {C:attention}Jack{}, {C:attention}10{}, and {C:attention}2",
				}
			},

			j_kali_begg = {
				name = "Begg",
				text = {
                    "Gains {C:money}$#1#{} of {C:attention}sell value",
                    "at end of round",
					"{C:green}#2# in #3#{} chance to",
					"{C:attention}halve{} sell value instead"
				}
			},
			j_kali_banana_split = {
				name = "Banana Split",
				text = {
					"{C:chips}+#1#{} Chips",
                    "{C:green}#2# in #3#{} chance this",
                    "card is {C:attention}split",
                    "at end of round",
					"{C:inactive}(Does not require room)"
				}
			},
			j_kali_banana_bean = {
				name = "Banana Bean",
				text = {
                    "{C:attention}+#1#{} hand size, increases",
                    "by {C:attention}#2#{} every round",
					"{C:green}#3# in #4#{} chance to destroy",
					"this Joker and scored cards",
					"when hand played"
				}
			},
			j_kali_potassium_bottle = {
				name = "Potassium in a Bottle",
				text = {
					"Retrigger all cards {C:attention}#1#{} additional times",
					"Scoring cards become {C:attention}Banana",
                    "{C:green}#2# in #3#{} chance this card",
                    "is destroyed at end of round",
				}
			},

			j_kali_glop_michel = {
				name = "Glop Michel",
				text = {
					"{C:glop}+#1#{} Glop",
					"{C:green}#2# in #3#{} chance for",
					"{C:glop}+#4#{} Glop instead"
				}
			},
			j_kali_glegg = {
				name = "Glegg",
				text = {
					"When Blind selected,",
					"create a {C:attention}Glopur{C:inactive,E:1}?",
					"{C:inactive}(Must have room)"
				}
			},
			j_kali_glopendish = {
				name = "Glopendish",
				text = {
                    "When {C:attention}Blind{} is selected, {C:green}#1# in #2#{} chance ",
                    "to destroy Joker to the right",
                    "and permanently add {C:attention}one-tenth{} of",
                    "its sell value to this {C:glop}Glop",
					"{C:green}#3# in #4#{} chance this card",
                    "is destroyed at end of round",
                    "{C:inactive}(Currently {C:glop}+#5#{C:inactive} Glop)",
				}
			},
			j_kali_glop_cola = {
				name = "Glop Cola",
                text={
                    "Sell this card to",
                    "create a free",
                    "{C:glop}#1#",
                },
			},
			j_kali_glop_corn = {
				name = "Glop Corn",
				text = {
					"{C:glop}+#1#{} Glop",
					"Decreases by {C:glop}#2#{} at",
					"end of round",
					"{C:inactive,s:0.8}Fresh off the clob",
				}
			},
			j_kali_glopmother = {
				name = "Glopmother",
				text = {
					"{X:glop,C:white,E:1,s:1.5}^2{s:1.5,E:1,C:dark_edition} Glop"
				}
			},
			j_kali_glopmother_fakeout = {
				name = "Glopmother",
				text = {
					"Playing cards give",
					"{X:sfark,C:white}X7{} Sfark when scored"
				}
			},
			j_kali_glopku = {
				name = "Glopku",
				text = {
                    "Every played {C:attention}card{}",
                    "permanently gains",
                    "{C:glop}+#1#{} Glop when scored",
				}
			},
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
					"all poker hands gain {C:glop}+#1#{} Glop",
					"for each removed level",
				}
			},
            c_kali_glopway = {
				name = "Glopway",
				text = {
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
		Blind = {
			bl_kali_blindnana = {
				name = "The Banana",
				text = {
					"One random Joker replaced",
					"with Gros Michel every hand",
				}
			},
			bl_kali_peel = {
				name = "The Peel",
				text = {
					"#1# in #2# chance for Jokers to",
					"go extinct when triggered",
				}
			}
		},
        Other = {
			card_extra_glop = {
				text = {
					"{C:glop}+#1#{} Glop",
				}
			},
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
			},
			kali_banana_bread_extincting_cards = {
				name = "Extincting Banana cards",
				text = {
					"Gros Michel, Cavendish,",
					"Blue Java, Potassium in a Bottle,",
					"Banana Bean, Glopendish,",
					"cards with Banana sticker"
				}
			},
        }
    },
    misc = {
        labels = {
            kali_stickernana = "Banana",
            kali_glop = "Glop"
        },
		poker_hands = {
			kali_virgin_bouquet = "Virgin Bouquet",
		},
		poker_hand_descriptions = {
			kali_virgin_bouquet = {
				"A hand that contains a Queen, Jack, 10, and 2"
			}
		},
		dictionary = {
			k_split_ex = "Split!",
		},
		v_dictionary = {
            a_emult="^#1# Mult",
            a_emult_minus="-^#1# Mult",
			a_glop="+#1# Glop",
			a_glop_minus="-#1# Glop",
		}
    }
}