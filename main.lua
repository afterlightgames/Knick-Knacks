-- Afterlight's knick knacks

SMODS.Atlas {
	key = "custom_jokers",
	path = "custom_jokers.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "big_naturals",
	path = "big_naturals.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "custom_decks",
	path = "custom_decks.png",
	px = 71,
	py = 95
}


SMODS.Back {
name = "Singularity Deck",
	key = "singularity_deck",
	atlas = "custom_decks",
	loc_txt = {
		name = "Singularity Deck",
		text = {
			"Start run with",
			"{C:attention}#1#{} Joker slots",
			"{C:tarot,T:v_tarot_tycoon}#2#{}",
			"{C:planet,T:v_planet_tycoon}#3#{}",
			"{C:attention,T:v_overstock_norm}#4#",
			"and {C:attention,T:v_overstock_plus}#5#",
		}
	},
	pos = {x = 0, y = 0},
	config = {joker_slot = -4, vouchers = {"v_tarot_tycoon", "v_planet_tycoon", "v_overstock_norm", "v_overstock_plus"}},
	loc_vars = function(self, info_queue, back)
		return { vars = {
				self.config.joker_slot,
				localize { type = "name_text", key = self.config.vouchers[1], set = "Voucher"},
				localize { type = "name_text", key = self.config.vouchers[2], set = "Voucher"},
				localize { type = "name_text", key = self.config.vouchers[3], set = "Voucher"},
				localize { type = "name_text", key = self.config.vouchers[4], set = "Voucher"},
			}
		}
	end
}


-- SMODS.Joker {
-- 	key = "big_naturals",
-- 	loc_txt = {
-- 		name = "Jimboob",
-- 		text = {
-- 			"{C:mult}+#1#{} Mult for each",
-- 			"of Jimboob's {C:attention}big naturals{}",
-- 		}
-- 	},
-- 	config = {extra = {mult = 1000000000}},
-- 	loc_vars = function(self, info_queue, card)
-- 		return {vars = {card.ability.extra.mult * 0.5}}
-- 	end,
-- 	rarity = 1,
-- 	in_pool = function()
-- 		return false
-- 	end,
-- 	blueprint_compat = true,
-- 	atlas = "big_naturals",
-- 	pos = {x = 0, y = 0},
-- 	cost = 100000000000000000000000000000000000000000,
-- 	calculate = function(self, card, context)
-- 		if context.joker_main then
-- 			return {
-- 				mult = card.ability.extra.mult,
-- 			}
-- 		end
-- 	end
-- }

SMODS.Joker {
	key = "close_up",
	loc_txt = {
		name = "Close-Up",
		text = {
			"Gains {X:mult,C:white}X#2#{} Mult for each",
			"blind {C:attention}skipped{}, resets",
			"when {C:attention}boss blind{} is defeated",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
		}
	},
	config = {extra = {x_mult = 1, x_mult_gain = 1, default_x_mult = 1}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_gain}}
	end,
	rarity = 1,
	blueprint_compat = true,
	atlas = "custom_jokers",
	pos = {x = 1, y = 0},
	soul_pos = {x = 1, y = 1},
	cost = 3,
	calculate = function(self, card, context)
		if context.joker_main then
			if card.ability.extra.x_mult > 1 then
				return {
					message = localize{type = "variable", key = "a_xmult", vars = {card.ability.extra.x_mult}},
					Xmult_mod = card.ability.extra.x_mult
				}
			end
		end

		if context.skip_blind and not context.blueprint then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
					colour = G.C.RED,
				card = card
			})
			return
		end

		if context.end_of_round and context.main_eval and (not context.blueprint) and G.GAME.last_blind.boss and card.ability.extra.x_mult > 1 then
			card.ability.extra.x_mult = card.ability.extra.default_x_mult
			return {
				message = "Reset!",
				card = card
			}
		end

	end
}

SMODS.Joker {
	key = "digital_joker",
	loc_txt = {
		name = "Digital Joker",
		text = {
			"Scoring {C:attention}10s{} score an",
			"additional {C:chips}+#1#{} chips",
			"for each played {C:attention}10{}",
		}
	},
	config = {extra = {chips_amount = 10, card_count = 0}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips_amount}}
	end,
	rarity = 2,
	blueprint_compat = true,
	atlas = "custom_jokers",
	pos = {x = 0, y = 0},
	soul_pos = {
		x = 0, y = 1,
		draw = function(card, scale_mod, rotate_mod)
			card.hover_tilt = card.hover_tilt * 1.5
			card.children.floating_sprite:draw_shader('hologram', nil, card.ARGS.send_to_shader, nil,
				card.children.center, 2 * scale_mod, 2 * rotate_mod)
			card.hover_tilt = card.hover_tilt / 1.5
		end
	},
	cost = 4,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			card.ability.extra.card_count = 0
			for i, c in ipairs(context.full_hand) do
				if c:get_id() == 10 then
					card.ability.extra.card_count = card.ability.extra.card_count + 1
				end
			end
		end
		
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 10 then
				return {
					chips = card.ability.extra.chips_amount * card.ability.extra.card_count,
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	key = "cake",
	loc_txt = {
		name = "Cake",
		text = {
			"Gains {C:mult}+#1#{} Mult and",
			"{C:money}$#2#{} of {C:attention}sell value{}",
			"at start of round",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
		}
	},
	blueprint_compat = true, -- blueprint scores mult but doesn't scale sell value
	config = {extra = {mult_gain = 2, value_gain = 2, current_mult = 0}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult_gain, card.ability.extra.value_gain, card.ability.extra.current_mult}}
	end,
	rarity = 2,
	atlas = "custom_jokers",
	pos = {x = 2, y = 0},
	cost = 5,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.mult_gain
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.value_gain
			card:set_cost()
			return {
				card = card,
				message = localize('k_val_up'),
				colour = G.C.MONEY
			}
		end
		
		if context.joker_main then
			return {
				mult = card.ability.extra.current_mult
			}
		end
	end
}

SMODS.Joker {
	key = "dinner_party",
	loc_txt = {
		name = "Dinner Party",
		text = {
			"If five {C:attention}face cards{} are",
			"{C:attention}scored{}, create a {C:attention}Seltzer{}",
			"{C:inactive}(Must have room){}"
		}
	},
	blueprint_compat = false,
	config = {extra = {}},
	loc_vars = function(self, info_queue, card)
		return {vars = {}}
	end,
	rarity = 2,
	atlas = "custom_jokers",
	pos = {x = 3, y = 0},
	cost = 5,
	calculate = function(self, card, context)
		if context.blueprint then return end

		if context.after then
			if #context.scoring_hand < 5 then return end
			
			local faces_only = true
			for i, v in ipairs(context.scoring_hand) do
				if not v:is_face() then
					faces_only = false
					break
				end
			end

			if faces_only then
				local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
				if jokers_to_create <= 0 then return end
				G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create

				G.E_MANAGER:add_event(Event({
					func = function()
						local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_selzer", "dpy")
						card:add_to_deck()
						G.jokers:emplace(card)
						card:start_materialize()
						G.GAME.joker_buffer = 0
						return true
					end
				}))
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Thirsty!"})
			end
		end
	end
}

SMODS.Joker {
	key = "chef_joker",
	loc_txt = {
		name = "Chef Joker",
		text = {
			"When {C:attention}Boss Blind{} is",
			"defeated, create a {C:dark_edition}Negative{}",
			"{C:attention}food{} themed Joker",
		}
	},
	blueprint_compat = false,
	config = {extra = {jokers = {
		"j_egg",
		"j_ramen",
		"j_ice_cream",
		"j_popcorn",
		"j_turtle_bean",
		"j_gros_michel",
		"j_selzer",
		"j_diet_cola",
		"j_knick_knacks_cake",
	}}},
	loc_vars = function(self, info_queue, card)
		return {vars = {}}
	end,
	rarity = 3,
	atlas = "custom_jokers",
	pos = {x = 5, y = 0},
	cost = 8,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and (not context.blueprint) and G.GAME.last_blind.boss then
			G.E_MANAGER:add_event(Event({
				func = function()
					local card = create_card("Joker", G.jokers, nil, nil, nil, nil, pseudorandom_element(card.ability.extra.jokers, pseudoseed('chef_joker')), "chf")
					card:set_edition('e_negative', true)
					card:add_to_deck()
					G.jokers:emplace(card)
					card:start_materialize()
					return true
				end
			}))
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Bon appetit!"})
		end
	end
}


SMODS.Joker {
	key = "pawn_shop",
	loc_txt = {
		name = "Pawn Shop",
		text = {
			"When a card is {C:attention}sold{},",
			"this joker gains {C:mult}Mult{} equal",
			"to that card's {C:attention}sell value{}",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	blueprint_compat = true,
	config = {extra = {mult = 0}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult}}
	end,
	rarity = 2,
	atlas = "custom_jokers",
	pos = {x = 4, y = 0},
	cost = 6,
	calculate = function(self, card, context)
		if context.main_eval and context.selling_card and not context.blueprint then
			if context.card == card then return end
			card.ability.extra.mult = card.ability.extra.mult + context.card.sell_cost
			return {
				message = localize{type = "variable", key = "a_mult", vars = {card.ability.extra.mult}, colours = {G.C.MULT}},
			}
		end

		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end

	end
}


SMODS.Joker {
	key = "twisted_tom",
	loc_txt = {
		name = "Twisted Tom",
		text = {
			"Gives {C:chips}Chips{} and {C:mult}Mult{} equal to the",
			"average {C:chips}Base Chips{} and {C:mult}Base Mult{} of the",
			"last {C:attention}#2#{} {C:attention}Poker Hands{} played",
			"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips and {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	config = {extra = {entries = {}, mult = 0, chips = 0, max_entries = 5}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.max_entries, card.ability.extra.chips}}
	end,
	rarity = 1,
	blueprint_compat = true,
	atlas = "custom_jokers",
	pos = {x = 6, y = 0},
	cost = 4,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			hand_chips = G.GAME.hands[context.scoring_name].chips
			hand_mult = G.GAME.hands[context.scoring_name].mult

			table.insert(card.ability.extra.entries, {hand_chips, hand_mult})
			
			while #card.ability.extra.entries > card.ability.extra.max_entries do
				table.remove(card.ability.extra.entries, 1)
			end

			avg_chips = 0
			avg_mult = 0

			for k, v in ipairs(card.ability.extra.entries) do
				avg_chips = avg_chips + v[1]
				avg_mult = avg_mult + v[2]
			end

			avg_chips = avg_chips / #card.ability.extra.entries
			avg_mult = avg_mult / #card.ability.extra.entries

			card.ability.extra.chips = avg_chips
			card.ability.extra.mult = avg_mult
			
			return

		end
		
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
			}
		end
	end
}


SMODS.Joker {
	key = "mean_gene",
	loc_txt = {
		name = "Mean Gene",
		text = {
			"{X:mult,C:white}X#1#{} Mult",
			"When {C:attention}sold{}, creates a",
			"{C:attention}Sweet Pete{} with {C:mult}+#2#{} Mult",
			"{C:inactive}(Mult increases by",
			"{C:mult}+#3#{C:inactive} each round){}",
		}
	},
	config = {extra = {x_mult = 0.5, mult_gain = 5, mult = 0}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.x_mult, card.ability.extra.mult, card.ability.extra.mult_gain}}
	end,
	rarity = 3,
	blueprint_compat = false,
	atlas = "custom_jokers",
	pos = {x = 7, y = 0},
	cost = 7,
	calculate = function(self, card, context)
		if context.blueprint then return end

		if context.selling_self then
			G.E_MANAGER:add_event(Event({
				func = function()
					local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_knick_knacks_sweet_pete", "mnjn")

					if card.edition and card.edition.negative then
						new_card:set_edition("e_negative", true)
					end

					new_card:add_to_deck()
					G.jokers:emplace(new_card)
					new_card:start_materialize()
					new_card.ability.extra.mult = card.ability.extra.mult

					return true
				end
			}))
		end

		if context.setting_blind then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = localize{type = "variable", key = "a_mult", vars = {card.ability.extra.mult}, colours = {G.C.MULT}}
			}
		end

		if context.final_scoring_step then
			print("final scoring step")
			return {x_mult = card.ability.extra.x_mult}
		end

	end
}


SMODS.Joker {
	key = "sweet_pete",
	loc_txt = {
		name = "Sweet Pete",
		text = {
			"{C:mult}+#1#{} Mult",
			"Created when a",
			"{C:attention}Mean Gene{} is {C:attention}sold",
			"{C:inactive}(Mult is determined",
			"{C:inactive}by Mean Gene)",
		}
	},
	config = {extra = {mult = 0}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult}}
	end,
	rarity = 3,
	blueprint_compat = true,
	in_pool = function()
		return false
	end,
	atlas = "custom_jokers",
	pos = {x = 8, y = 0},
	cost = 10,
	calculate = function(self, card, context)
		if context.joker_main then
			return {mult = card.ability.extra.mult}
		end
	end
}


SMODS.Joker {
	key = "flipped_joker",
	loc_txt = {
		name = "Flipped Joker",
		text = {
			"{C:green}#1# in #2#{} chance to draw",
			"cards {C:attention}face down{}. If a",
			"{C:attention}face down{} card is played and",
			"scores, it scores {X:mult,C:white}X#3#{} Mult"
		}
	},
	config = {extra = {odds = 10, xmult = 1.25, flipped_cards = {}}},
	loc_vars = function(self, info_queue, card)
		return {vars = {G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.xmult}}
	end,
	rarity = 2,
	blueprint_compat = true,
	atlas = "custom_jokers",
	pos = {x = 9, y = 0},
	cost = 5,
	calculate = function(self, card, context)
		if (not context.blueprint) and context.stay_flipped and context.to_area == G.hand then
			if pseudorandom("knick_knacks_flipped_joker") < G.GAME.probabilities.normal / card.ability.extra.odds then
				return {stay_flipped = true}
			end
		end
		
		if context.hand_drawn then
			card.ability.extra.flipped_cards = {}
			
			for k, v in ipairs(G.hand.cards) do
				if v.facing == "back" then
					table.insert(card.ability.extra.flipped_cards, v)
				end
			end
		end
		
		if context.individual and context.cardarea == G.play then
			card_was_flipped = false
			for k, v in ipairs(card.ability.extra.flipped_cards) do
				if v == context.other_card then
					card_was_flipped = true
					break
				end
			end
			
			if card_was_flipped then
				return {
					xmult = card.ability.extra.xmult,
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	key = "handshake",
	loc_txt = {
		name = "Handshake",
		text = {
			"Lose {C:money}$#1#{} when {C:attention}Blind{} is",
			"selected, {C:attention}+#2#{} hand size",
			"{C:inactive}(Gains {C:attention}+#3#{C:inactive} hand size when",
			"{C:inactive}Boss Blind is defeated)"
		}
	},
	config = {extra = {cost = 4, h_size = 1, h_mod = 1}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.cost, card.ability.extra.h_size, card.ability.extra.h_mod}}
	end,
	rarity = 2,
	blueprint_compat = false,
	atlas = "custom_jokers",
	pos = {x = 2, y = 1},
	cost = 6,

	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.h_size)
	end,
	
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.h_size)
	end,

	calculate = function(self, card, context)
		if context.blueprint then return end
		
		if context.setting_blind then
			return {
				dollars = -card.ability.extra.cost
			}
		end

		if context.end_of_round and context.main_eval and G.GAME.last_blind.boss then
			card.ability.extra.h_size = card.ability.extra.h_size + card.ability.extra.h_mod
			G.hand:change_size(card.ability.extra.h_mod)
			return {
				message = localize { type = "variable", key = "a_handsize", vars = {card.ability.extra.h_mod} },
				colour = G.C.FILTER
			}
		end
	end
}

-- SMODS.Joker { -- todo
-- 	key = "drop_in_the_bucket",
-- 	loc_txt = {
-- 		name = "Drop in the Bucket",
-- 		text = {
-- 			"{C:green}#1# in #2#{} chance to gain {C:chips}+#3#{} Chip",
-- 			"every time a card is {C:attention}scored",
-- 			"{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}"
-- 		}
-- 	},
-- 	config = {extra = {chips = 0, chip_mod = 4, odds = 4}},
-- 	loc_vars = function(self, info_queue, card)
-- 		return {vars = {G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.chip_mod, card.ability.extra.chips}}
-- 	end,
-- 	rarity = 1,
-- 	blueprint_compat = true,
-- 	atlas = "custom_jokers",
-- 	pos = {x = 0, y = 0},
-- 	cost = 3,
	
-- 	calculate = function(self, card, context)
-- 		if (not context.blueprint) and context.individual and context.cardarea == G.play and pseudorandom("knick_knacks_drop_in_the_bucket") < G.GAME.probabilities.normal / card.ability.extra.odds then
-- 			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
-- 			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
-- 		end

-- 		if context.joker_main then
-- 			return {
-- 				chips = card.ability.extra.chips,
-- 				card = other_card
-- 			}
-- 		end
-- 	end
-- }