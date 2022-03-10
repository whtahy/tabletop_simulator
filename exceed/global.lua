-- NOTE: can't use getObjectFromGUID in global global

max_hp = 30

function onLoad()
    for _, obj in ipairs(getAllObjects()) do
        if obj.hasTag('Static') or obj.hasTag('Table') then
            obj.locked = true
            obj.interactable = false
            obj.drag_selectable = false
        end
    end

    -- global tables

    -- draw decks
    deck_zones_table = {
        Red = getObjectFromGUID('2ecbe4'),
        Blue = getObjectFromGUID('30de79')}

    -- card counting
    card_counter_table = {
        Red = getObjectFromGUID('2cf636'),
        Blue = getObjectFromGUID('1a640f')}

    -- discards
    discard_zones_table = {
        Red = getObjectFromGUID('ea519a'),
        Blue = getObjectFromGUID('0ce6e4')}

    -- gauges
    gauge_zones_table = {
        Red = getObjectFromGUID('f1a600'),
        Blue = getObjectFromGUID('059d91')}
    gauge_text_table = {
        Red = getObjectFromGUID('36b535'),
        Blue = getObjectFromGUID('ffed4f')}

    -- hp and damage counters
    damage_counter_table = {
        Red = getObjectFromGUID('6037c1'),
        Blue = getObjectFromGUID('988e6c')}
    hp_counter_table = {
        Red = getObjectFromGUID('2d53fe'),
        Blue = getObjectFromGUID('7c2894')}
end

function onObjectEnterZone(zone, object)
    update_game(zone, object)
end

function onObjectLeaveZone(zone, object)
    update_game(zone, object)
end

function onPlayerTurn(player, previous_player)
    update_hp_counter('Red')
    update_hp_counter('Blue')
end

function update_game(zone, object)
    -- not a card or deck -> no need to update
    if object.type ~= 'Card' and object.type ~= 'Deck' then
        return nil
    end

    -- otherwise, update player's gauge
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

function update_hp_counter(player_color)
    local damage_counter = damage_counter_table[player_color]
    local hp_counter = hp_counter_table[player_color]

    -- calculate hp
    local damage = damage_counter.Counter.getValue()
    local old_hp = hp_counter.Counter.getValue()
    local new_hp = old_hp - damage

    -- animate hp and damage decrements
    for i = 1, damage do
        Wait.time(
            function()
                hp_counter.Counter.decrement()
                damage_counter.Counter.decrement()
            end,
            0.1 * i
        )
    end
end

function update_card_counter(player_color)
    -- create table of used card names (discard + gauge)
    local used_cards = {}
    local function count(zone)
        for _, obj in ipairs(zone.getObjects()) do
            if obj.is_face_down or obj.isSmoothMoving() then
                goto continue
            elseif obj.type == 'Card' then
                table.insert(used_cards, obj.getName())
            elseif obj.type == 'Deck' then
                for _, c in ipairs(obj.getObjects()) do
                    table.insert(used_cards, c.name)
                end
            end
            ::continue::
        end
    end

    count(discard_zones_table[player_color])
    count(gauge_zones_table[player_color])

    -- create 2 card counter tables: 1 for face up, 1 for face down
    local card_counter = card_counter_table[player_color].getObjects()
    local face_down = {}
    local face_up = {}
    for _, obj in ipairs(card_counter) do
        if obj.type ~= 'Card' then
            goto continue
        elseif obj.is_face_down then
            table.insert(face_down, obj)
        elseif not obj.is_face_down then
            table.insert(face_up, obj)
        end
        ::continue::
    end

    -- NOTE
    -- used_cards stores card name strings
    -- face_down and face_up store cards -> use getName()
    -- removing cards from used_cards creates holes -> use pairs (NOT ipairs)

    -- remove face down cards from used_cards table
    for _, c in ipairs(face_down) do
        for k, v in pairs(used_cards) do
            if c.getName() == v then
                used_cards[k] = nil
                break
            end
        end
    end

    -- flip remaining cards in used_cards table
    for _, c in pairs(used_cards) do
        if c == nil then
            goto continue
        end
        for k, v in pairs(face_up) do
            if v and c == v.getName() then
                face_up[k] = nil
                v.flip()
                break
            end
        end
        ::continue::
    end
end

function round(x)
    return math.floor(x + 0.5)
end
