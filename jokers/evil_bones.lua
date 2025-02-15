SMODS.Joker {
    key = "evil_bones",
    rarity = 2,
    cost = 5,
    pos = {x = 0, y = 0},
    atlas = "Jokers",
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    -- TODO: impletment locked_loc_vars to hide text saying mr bones until mr bones is unlocked
    calculate = function(self, card, context)
        if (context.blueprint_card) then return end -- disable blueprint / brainstorm
        if (context.game_over and G.GAME.chips/G.GAME.blind.chips >= 0.25) then
            G.hand_text_area.blind_chips:juice_up()
            G.hand_text_area.game_chips:juice_up()
            play_sound('tarot1')

            -- code stealed from madness
            local destructable_jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
            end
            local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('evilbones')) or nil

            if joker_to_destroy then
                joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
            end

            if (joker_to_destroy) then
                return {
                    -- TODO: can we make it not say saved by mr bones?
                    message = localize("k_saved_ex"),
                    saved = true,
                    colour = G.C.RED
                }
            end
        end
    end,
    check_for_unlock = function(self, args)
        -- TODO: is there a better way to do this??
        if (args.type == "round_win" and G.GAME.chips < G.GAME.blind.chips) then
            unlock_card(self)
        end
    end
}