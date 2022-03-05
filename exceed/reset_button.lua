scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    damage_counter_table = Global.getTable('damage_counter_table')
    hp_counter_table = Global.getTable('hp_counter_table')
    card_counter_table = Global.getTable('card_counter_table')

    discard_zones_table = Global.getTable('discard_zones_table')
    gauge_zones_table = Global.getTable('gauge_zones_table')
    deck_zones_table = Global.getTable('deck_zones_table')

    self.createButton({
        function_owner  = self,
        click_function  = 'reset_game',
        label           = 'Reset Game',
        position        = {0, 0.5, 0},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 2200,
        height          = 400,
        font_size       = 400,
        color           = {0.5, 0.5, 0.5},
        font_color      = {1, 1, 1}
    })
end

function reset_game()
    reset_hp()
    reset_counter_zone()
    reset_deck()
end

function reset_hp()
    damage_counter_table['Red'].Counter.setValue(0)
    damage_counter_table['Blue'].Counter.setValue(0)

    hp_counter_table['Red'].Counter.setValue(Global.getVar('default_hp'))
    hp_counter_table['Blue'].Counter.setValue(Global.getVar('default_hp'))
end

function reset_counter_zone()
    face_up_cards_in_counter_zone('Red')
    face_up_cards_in_counter_zone('Blue')
end

function face_up_cards_in_counter_zone(player_color)
    local card_counter_objects = card_counter_table[player_color].getObjects()

    for _, obj in ipairs(card_counter_objects) do
        if obj.type == 'Card' then
            if obj.is_face_down then
                obj.flip()
            end
        end
    end
end

function reset_deck()
    group_cards_to_deck_zone('Red')
    group_cards_to_deck_zone('Blue')
end

function group_cards_to_deck_zone(player_color)
    local discard_zones_table = discard_zones_table[player_color].getObjects()
    local gauge_zones_table = gauge_zones_table[player_color].getObjects()
    local deck_zones_table = deck_zones_table[player_color].getObjects()
    local hand = Player[player_color].getHandObjects()

    local mainDeck

    for _, obj in pairs(deck_zones_table) do
        if obj.type == 'Deck' then
            mainDeck = obj
        end
    end

    for _, obj in pairs(discard_zones_table) do
        if obj.type == 'Card' or obj.type == 'Deck' then
            mainDeck.putObject(obj)
        end
    end

    for _, obj in pairs(gauge_zones_table) do
        if obj.type == 'Card' or obj.type == 'Deck' then
            mainDeck.putObject(obj)
        end
    end

    for _, obj in pairs(hand) do
        if obj.type == 'Card' or obj.type == 'Deck' then
            mainDeck.putObject(obj)
        end
    end

    Wait.time(function() mainDeck.shuffle() end, 1)
end
