SMODS.Sound({
	key = "music_disco",
	path = "music_disco.ogg",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(SMODS.find_card("j_mods_disco_joker")) and 6969696969
	end,
})

SMODS.Joker {
    key = "disco_joker",
    atlas = "Jokers",
    pos = {x = 2, y = 0},
    cost = 3,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition({negative = true}) -- card is always negative
    end
}