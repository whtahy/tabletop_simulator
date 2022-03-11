arena_zone = getObjectFromGUID('a5a3ec')
distance_text = getObjectFromGUID('246491')

is_on = true
arena_tile_width = 3

hero_table = {}
checkpoint_table = {}
distance_tables = {
    [1] = {}, -- top row of textboxes (red player)
    [2] = {}  -- bottom row of textboxes (blue player)
}

font_size = 40
font_color_enemy = {255/255, 194/255, 0/255}
font_color_table = {
    [1] = {255/255, 215/255, 215/255}, -- red player
    [2] = {200/255, 255/255, 255/255}, -- blue player
}

scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    -- non interactive button
    self.createButton({
        function_owner  = self,
        click_function  = 'n/a',
        position        = {0, 0.5, 1/30 * scale_length},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 0,
        height          = 0,
        font_size       = 2/3 * 1000 * scale_length,
        font_color      = font_color_enemy
    })

    -- interactive button
    self.createButton({
        function_owner  = self,
        click_function  = 'toggle_on_off',
        position        = {0, 0.5, 1/30 * scale_length},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 400 / 1.5 * scale_width,
        height          = 400 / 1.5 * scale_height,
        color           = {0, 0, 0, 0}
    })

    for _, obj in ipairs(getObjects()) do
        local x = round(obj.getPosition().x)
        local y = round(obj.getPosition().y)
        local z = round(obj.getPosition().z)

        if obj.type == 'Scripting'
            and z == 20 then
            table.insert(checkpoint_table, obj)
        elseif obj.type == '3D Text'
            and y == 0
            and -12 <= x and x <= 12 then
            -- top row: red player
            if z == 23 then
                obj.textTool.setFontSize(font_size)
                obj.textTool.setFontColor(font_color_table[1])
                table.insert(distance_tables[1], obj)
            -- bottom row: blue player
            elseif z == 18 then
                obj.textTool.setFontSize(font_size)
                obj.textTool.setFontColor(font_color_table[2])
                table.insert(distance_tables[2], obj)
            end
        end
    end

    table.sort(distance_tables[1], by_x_position)
    table.sort(distance_tables[2], by_x_position)

    update_hero_table()
    update_rangefinder()
end

function onObjectEnterZone(zone, object)
    if is_on and (zone == arena_zone or is_checkpoint(zone)) then
        if object == hero_table[1] or object == hero_table[2] then
            update_rangefinder()
        elseif is_hero(object) then
            clear_rangefinder()
            Wait.condition(
                update_rangefinder,
                function()
                    update_hero_table()
                    return #hero_table == 2
                end
            )
        end
    end
end

function is_checkpoint(zone)
    for _, obj in ipairs(checkpoint_table) do
        if obj == zone then
            return true
        end
    end
    return false
end

function update_hero_table()
    hero_table = {}
    for _, obj in ipairs(arena_zone.getObjects()) do
        if is_hero(obj) then
            table.insert(hero_table, obj)
        end
    end
    table.sort(hero_table, by_x_position)
end

function is_hero(object)
    return object.type == 'Card' and object.getName():find('(C)', 1, true)
end

function toggle_on_off()
    if is_on then
        clear_rangefinder()
    else
        update_hero_table()
        update_rangefinder()
    end
    is_on = not is_on
end

function clear_rangefinder()
    for _, tbl in ipairs(distance_tables) do
        for _, tt in ipairs(tbl) do
            tt.textTool.setValue(' ')
        end
    end
end

function update_rangefinder()
    update_rangefinder_row(1)
    update_rangefinder_row(2)
end

function update_rangefinder_row(row)
    local position = hero_position(row)
    local distance_table = distance_tables[row]
    distance_table[position].textTool.setValue(' ')

    for i = 1, 9 do
        local left = position - i
        if 1 <= left and left <= 9 then
            local tt = distance_table[left].textTool
            tt.setFontColor(font_color_table[row])
            tt.setValue(tostring(i))
        end
        local right = position + i
        if 1 <= right and right <= 9 then
            local tt = distance_table[right].textTool
            tt.setFontColor(font_color_table[row])
            tt.setValue(tostring(i))
        end
    end

    local enemy_position = hero_position(row % 2 + 1)
    distance_table[enemy_position].textTool.setFontColor(font_color_enemy)

    local distance = math.abs(position - enemy_position)
    self.editButton({label = tostring(distance)})
end

function hero_position(row)
    return 5 + round(hero_table[row].getPosition().x / arena_tile_width)
end

function round(x, to)
    local to = to or 1
    local new_x = math.floor(math.abs(x) / to + 0.5) * to
    if x < 0 then
        return -new_x
    else
        return new_x
    end
end

-- helper function for table.sort
function by_x_position(a, b)
    return round(a.getPosition().x) < round(b.getPosition().x)
end
