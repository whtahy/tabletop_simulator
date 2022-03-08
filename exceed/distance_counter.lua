scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

is_on = false
arena_tile_width = 3

function onLoad()
    self.createButton({
        function_owner  = self,
        click_function  = 'toggle_on_off',
        label           = '',
        position        = {0, 0.5, 0},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 400,
        height          = 400,
        font_size       = 400,
        color           = {0.5, 0.5, 0.5},
        font_color      = {1, 1, 1}
    })

    -- global table of tables
    -- i = 1: 1st table is top row
    -- i = 2: 2nd table is bottom row
    distance_tables = {}
    local top_distance_table = {}
    local bottom_distance_table = {}
    for _, obj in ipairs(getObjects()) do
        local x = round(obj.getPosition().x)
        local y = round(obj.getPosition().y)
        local z = round(obj.getPosition().z)
        if obj.type == '3D Text'
            and y == 0
            and -12 <= x and x <= 12 then
            if z == 23 then
                table.insert(top_distance_table, obj)
            elseif z == 18 then
                table.insert(bottom_distance_table, obj)
            end
        end
    end

    table.sort(top_distance_table, by_x_position)
    table.sort(bottom_distance_table, by_x_position)

    table.insert(distance_tables, top_distance_table)
    table.insert(distance_tables, bottom_distance_table)
end

function onObjectEnterZone(zone, object)
    if is_on
        and (object == heroes[1] or object == heroes[2])
        and zone == Global.getVar('arena_zone') then
        update_rangefinder(1)
        update_rangefinder(2)
    end
end

function get_heroes()
    heroes = {}
    local arena_zone = Global.getVar('arena_zone')
    for _, obj in ipairs(arena_zone.getObjects()) do
        if obj.type == 'Card'
            and obj.getName():find('(C)', 1, true) then
            table.insert(heroes, obj)
        end
    end
    table.sort(heroes, by_x_position)
end

function toggle_on_off()
    get_heroes()
    if is_on then
        clear_rangefinder()
    else
        update_rangefinder(1)
        update_rangefinder(2)
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

function update_rangefinder(i)
    local position = round(heroes[i].getPosition().x / arena_tile_width) + 5
    local distance_table = distance_tables[i]
    distance_table[position].textTool.setValue(' ')
    for i = 1, 9 do
        local left = position - i
        if 1 <= left and left <= 9 then
            distance_table[left].textTool.setValue(tostring(i))
        end
        local right = position + i
        if 1 <= right and right <= 9 then
            distance_table[right].textTool.setValue(tostring(i))
        end
    end
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

function by_x_position(a, b)
    return round(a.getPosition().x) < round(b.getPosition().x)
end
