SMODS.Joker {
    key = "revolving_door",
    rarity = 1,
    cost = 3,
    pos = {x = 1, y = 0},
    atlas = "Jokers",
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            -- TODO: the joker will subtract hands first if added in the middle of the round
            hand_size = -2,
            target_size = -2
        }
    },
    calculate = function(self, card, context)
        if (context.setting_blind and not context.blueprint_card) then
            card.ability.extra.target_size = -card.ability.extra.target_size

            G.E_MANAGER:add_event(Event({func = function()
                if (card.ability.extra.hand_size ~= card.ability.extra.target_size) then
                    G.hand:change_size(card.ability.extra.target_size - card.ability.extra.hand_size)
                    card.ability.extra.hand_size = card.ability.extra.target_size
                end
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = tostring(card.ability.extra.hand_size) .. " hand size"})
            return true end }))
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end
}