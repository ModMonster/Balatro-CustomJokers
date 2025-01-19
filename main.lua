-- Load data files
SMODS.load_file("atlas.lua")()
SMODS.load_file("jokers/jokers.lua")()
SMODS.load_file("consumables/consumables.lua")()

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
            h_size = 2
        }
    },
    calculate = function(self, card, context)
        if (context.setting_blind and not context.blueprint_card) then
            G.E_MANAGER:add_event(Event({func = function()
                G.hand:change_size(self.ability.extra.h_size)
                -- card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {self.ability.extra}}})
            return true end }))
        end
    end
}