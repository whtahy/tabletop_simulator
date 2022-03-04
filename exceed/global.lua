p1_gauge_zone = getObjectFromGUID('04d10f')
p2_gauge_zone = getObjectFromGUID('52cac8')

p1_gauge_text = getObjectFromGUID('9edd50')
p2_gauge_text = getObjectFromGUID('ebca94')

function onLoad()
    for _, obj in ipairs(getAllObjects()) do
        if obj.hasTag('Static') or obj.hasTag('Table') then
            obj.interactable = false
            obj.drag_selectable = false
        end
    end
end

function onObjectEnterZone(zone, object)
    if zone == p1_gauge_zone
        or zone == p2_gauge_zone then
        update_gauge(p1_gauge_zone)
        update_gauge(p2_gauge_zone)
    end
end

function onObjectLeaveZone(zone, object)
    if zone == p1_gauge_zone
        or zone == p2_gauge_zone then
        update_gauge(p1_gauge_zone)
        update_gauge(p2_gauge_zone)
    end
end

function update_gauge(zone)
    local count = 0
    for _, obj in ipairs(zone.getObjects()) do
        if obj.type == "Card" then
            count = count + 1
        elseif obj.type == "Deck" then
            count = count + #obj.getObjects()
        end
    end

    if zone == p1_gauge_zone then
        p1_gauge_text.TextTool.setValue(tostring(count))
    elseif zone == p2_gauge_zone then
        p2_gauge_text.TextTool.setValue(tostring(count))
    end
end
