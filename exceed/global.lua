-- NOTE: can't use getObjectFromGUID in naked global

function onLoad()
    gauge_zones_table = {
        Red = getObjectFromGUID('f1a600'),
        Blue = getObjectFromGUID('059d91')
    }

    gauge_text_table = {
        Red = getObjectFromGUID('36b535'),
        Blue = getObjectFromGUID('ffed4f')
    }

    for _, obj in ipairs(getAllObjects()) do
        if obj.hasTag('Static') or obj.hasTag('Table') then
            obj.interactable = false
            obj.drag_selectable = false
        end
    end
end

function onObjectEnterZone(zone, object)
    update_gauges(zone, object)
end

function onObjectLeaveZone(zone, object)
    update_gauges(zone, object)
end

function update_gauges(zone, object)
    -- not a card or deck -> no need to update
    if object.type ~= 'Card' and object.type ~= 'Deck' then
        return nil
    end

    -- otherwise, update the player's gauge
    if zone == gauge_zones_table['Red'] then
        update_gauge('Red')
    elseif zone == gauge_zones_table['Blue'] then
        update_gauge('Blue')
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
