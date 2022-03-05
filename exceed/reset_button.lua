scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
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
    -- reset decks
    reset_deck('Red')
    reset_deck('Blue')

    -- reset card counters
    reset_card_counter('Red')
    reset_card_counter('Blue')

    -- reset hp and damage counters
    reset_counters('Red')
    reset_counters('Blue')
end

function reset_deck(player_color)
    -- send object to deck zone
    local deck_zone = Global.getTable('deck_zones_table')[player_color]
    local function fetch(object)
        if object.type == 'Card' then
            object.use_hands = false
            Wait.time(function() object.use_hands = true end, 0.5)
        end
        object.setRotationSmooth({x = 0, y = 180, z = 180})
        object.setPositionSmooth(deck_zone.getPosition())
    end

    -- fetch all objects from zone
    local function fetch_all(objects)
        for _, obj in ipairs(objects) do
            if obj.type == 'Card' or obj.type == 'Deck' then
                fetch(obj)
            end
        end
    end

    -- fetch from discard, gauge, hand
    fetch_all(Global.getTable('discard_zones_table')[player_color].getObjects())
    fetch_all(Global.getTable('gauge_zones_table')[player_color].getObjects())
    fetch_all(Player[player_color].getHandObjects())

    -- shuffle deck
    Wait.condition(
        function() end, -- noop
        function()
            for _, obj in ipairs(deck_zone.getObjects()) do
                if obj.type == 'Deck' then
                    obj.setRotationSmooth({x = 0, y = 180, z = 180})
                end
                if obj.type == 'Deck' and obj.getQuantity() == 30 then
                    Wait.time(function() obj.shuffle() end, 0.3)
                    return true
                end
            end
            return false
        end
    )
end

function reset_counters(player_color)
    local damage_counter = Global.getTable('damage_counter_table')[player_color]
    local hp_counter = Global.getTable('hp_counter_table')[player_color]
    hp_counter.Counter.setValue(Global.getVar('max_hp'))
    damage_counter.Counter.setValue(0)
end

function reset_card_counter(player_color)
    local card_counter = Global.getTable('card_counter_table')[player_color]
    for _, obj in ipairs(card_counter.getObjects()) do
        if obj.type == 'Card' and obj.is_face_down then
            obj.flip()
        end
    end
end
