p1_gauge_zone_guid = '04d10f'
p2_gauge_zone_guid = '52cac8'

p1_gauge_text_guid = '9edd50'
p2_gauge_text_guid = 'ebca94'

function onLoad()
    loadZones()
    loadTexts()

    for _, obj in ipairs(getAllObjects()) do
        if obj.hasTag('Static') or obj.hasTag('Table') then
            obj.interactable = false
            obj.drag_selectable = false
        end
    end
end

--Gauge Logic
function loadZones()
    p1_gauge_zone = getObjectFromGUID(p1_gauge_zone_guid)
    p2_gauge_zone = getObjectFromGUID(p2_gauge_zone_guid)
end

function loadTexts()
    p1_gauge_text = getObjectFromGUID(p1_gauge_text_guid)
    p2_gauge_text = getObjectFromGUID(p2_gauge_text_guid)
end

function countCardsInZone(zone)
    local count=0
    for i, lobj in ipairs(zone.getObjects()) do
      if lobj.type == "Card" then
        count = count + 1
      elseif lobj.type == "Deck" then
        count = count + #lobj.getObjects()
      end
    end

    if p2_gauge_zone == zone then
        p2_gauge_text.TextTool.setValue(tostring(count))
    elseif p1_gauge_zone == zone then
        p1_gauge_text.TextTool.setValue(tostring(count))
    end
end

function refreshcount()
    countCardsInZone(p1_gauge_zone)
    countCardsInZone(p2_gauge_zone)
end

function onObjectEnterZone(curzone,obj)
    if p2_gauge_zone == curzone then
        refreshcount()
    elseif p1_gauge_zone == curzone then
        refreshcount()
    end
end

function onObjectLeaveZone(curzone,obj)
    if p2_gauge_zone == curzone then
        refreshcount()
    elseif p1_gauge_zone == curzone then
        refreshcount()
    end
end
--End of Gauge Logic
