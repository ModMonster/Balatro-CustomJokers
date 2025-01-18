-- TODO: make artwork
-- TODO: make sure it can only show up in runs with stickers
-- TODO: unlock condition? - when the first stake with stickers is unlocked

SMODS.Consumable {
    key = "spire",
    set = "Spectral",
    atlas = "Consumables",
    pos = {x = 0, y = 0},
    cost = 3, -- TODO: tbd
    unlocked = true,
    discovered = false,
    use = function(self, card, area, copier)
        local used_consumable = copier or card -- TODO: wtf does this mean??
        local conv_card = G.jokers.highlighted[1]
        local unstickered_jokers = get_unstickered_jokers()
        local rand_card = #unstickered_jokers > 0 and pseudorandom_element(unstickered_jokers, pseudoseed('spire')) or nil

        if (not rand_card) then return end

        local eternal = conv_card.ability.eternal
        local perishable = conv_card.ability.perishable
        local rental = conv_card.ability.rental

        -- remove stickers from joker
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            used_consumable:juice_up(0.3, 0.5)
        return true end }))

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound("gold_seal")
            conv_card.ability.eternal = false
            conv_card.ability.perishable = false
            conv_card.ability.rental = false
            conv_card:juice_up(0.3, 0.3)
        return true end }))

        -- set sticker on joker
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            used_consumable:juice_up(0.3, 0.5)
        return true end }))

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound("gold_seal")
            rand_card.ability.eternal = rand_card.ability.eternal or eternal
            if (perishable and not rand_card.ability.perishable) then
                rand_card.ability.perish_tally = G.GAME.perishable_rounds
            end
            rand_card.ability.perishable = rand_card.ability.perishable or perishable
            rand_card.ability.rental = rand_card.ability.rental or rental
            rand_card:juice_up(0.3, 0.3)
        return true end }))

        -- deselect joker
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.7, func = function() G.jokers:unhighlight_all(); return true end }))
    end,
    can_use = function(self, card)
        return #G.jokers.highlighted == 1
            and G.jokers.highlighted[1]
            and (G.jokers.highlighted[1].ability.eternal
                or G.jokers.highlighted[1].ability.perishable
                or G.jokers.highlighted[1].ability.rental)
            and #get_unstickered_jokers() >= 1
    end
}

-- Get a list of jokers which do not have a sticker
function get_unstickered_jokers()
    local jokers = {}
    for k, v in pairs(G.jokers.cards) do
        if (not v.ability.eternal and not v.ability.perishable and not v.ability.rental) then
            jokers[#jokers+1] = v
        end
    end
    return jokers
end