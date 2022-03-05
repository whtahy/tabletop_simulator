-- NOTE: can't use getObjectFromGUID in naked global

default_hp = 30

function onLoad()
    getObjectFromGUIDs()

    for _, obj in ipairs(getAllObjects()) do
        if obj.hasTag('Static') or obj.hasTag('Table') then
            obj.interactable = false
            obj.drag_selectable = false
        end
    end
end

function getObjectFromGUIDs()
    deck_zones_table = {
        Red = getObjectFromGUID('b367a0'),
        Blue = getObjectFromGUID('fff7cf')
    }
    card_counter_table = {
        Red = getObjectFromGUID('2cf636'),
        Blue = getObjectFromGUID('1a640f')
    }
    discard_zones_table = {
        Red = getObjectFromGUID('ea519a'),
        Blue = getObjectFromGUID('0ce6e4')
    }
    gauge_zones_table = {
        Red = getObjectFromGUID('f1a600'),
        Blue = getObjectFromGUID('059d91')
    }
    gauge_text_table = {
        Red = getObjectFromGUID('36b535'),
        Blue = getObjectFromGUID('ffed4f')
    }

    damage_counter_table = {
        Red = getObjectFromGUID('6037c1'),
        Blue = getObjectFromGUID('988e6c')
    }
    hp_counter_table = {
        Red = getObjectFromGUID('2d53fe'),
        Blue = getObjectFromGUID('7c2894')
    }
end

function onObjectEnterZone(zone, object)
    update_game(zone, object)
end

function onObjectLeaveZone(zone, object)
    update_game(zone, object)
end

function update_game(zone, object)
    -- not a card or deck -> no need to update
    if object.type ~= 'Card' and object.type ~= 'Deck' then
        return nil
    end

    -- otherwise, update the player's gauge
    if zone == gauge_zones_table['Red'] then
        update_gauge('Red')
        update_card_counter('Red')
    elseif zone == discard_zones_table['Red'] then
        update_card_counter('Red')
    elseif zone == gauge_zones_table['Blue'] then
        update_gauge('Blue')
        update_card_counter('Blue')
    elseif zone == discard_zones_table['Blue'] then
        update_card_counter('Blue')
    end
end

function update_gauge(player_color)
    local gauge_objects = gauge_zones_table[player_color].getObjects()
    local count = 0
    for _, obj in ipairs(gauge_objects) do
        if obj.type == 'Card' then
            count = count + 1
        elseif obj.type == 'Deck' then
            count = count + #obj.getObjects()
        end
    end
    gauge_text_table[player_color].TextTool.setValue(tostring(count))
end

function update_card_counter(player_color)
end
