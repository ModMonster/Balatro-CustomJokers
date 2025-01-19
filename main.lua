-- Load data files
SMODS.load_file("atlas.lua")()
SMODS.load_file("jokers/jokers.lua")()
SMODS.load_file("consumables/consumables.lua")()

SMODS.Joker {
    key = "lucky_7s",
    rarity = 2,
    cost = 5,
    pos = {x = 3, y = 0},
    atlas = "Jokers",
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
	end,
    calculate = function(self, card, context)
        if (context.cardarea == G.jokers and context.before and not context.blueprint) then
            -- count 7s (modified from superposition code)
            local sevens = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 7 then sevens = sevens + 1 end
            end
            if (sevens <= 0) then return end

            -- make lucky (modified from midas mask)
            for k, v in ipairs(context.scoring_hand) do
                v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                }))
            end
            return {
                message = "Lucky",
                colour = G.C.ORANGE,
                card = card
            }
        end
    end,
}