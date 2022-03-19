-- button tile
scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

-- board
center = {x = 2.3, y = 1, z = 0}
radius = 6.5

-- button layout
font_size = 400
offset_x = 0.32
offset_z = 0.2

-- font colors
white = {1, 1, 1}
blue = {113/255, 184/255, 230/255}
yellow = {236/255, 203/255, 0/255}
orange = {236/255, 135/255, 0/255}
red = {172/255, 27/255, 27/255}

function onLoad()
    -- food
    create_display(offset_x * -2.65, -offset_z, white, 'Food')
    create_display(offset_x * -1, -offset_z, red)
    create_display(offset_x * 0, -offset_z, yellow)

    -- shelter
    create_display(offset_x * -3, offset_z, white, 'Shelter')
    create_display(offset_x * -1, offset_z, red)
    create_display(offset_x * 0, offset_z, orange)
    create_display(offset_x * 1, offset_z, yellow)
    create_display(offset_x * 2, offset_z, blue)

    refresh()
end

function onObjectRotate(object)
    if is_built(object)
        and (
            object.getName() == "Hunter's Hut"
            or object.getName() == '') then
        Wait.time(refresh, 0.7)
    end
end

function onObjectDrop(player_color, object)
    if object.type == 'Tile'
        and (
            object.getName() == "Hunter's Hut"
            or object.getName() == '') then
        refresh()
    end
end

function create_display(x, z, font_color, label)
    local font_color = font_color or white
    local label = label or '0'
    self.createButton({
        function_owner  = self,
        click_function  = 'n/a',
        label           = label,
        position        = {x, 0.5, z},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 0,
        height          = 0,
        font_size       = font_size,
        font_color      = font_color
    })
end

function refresh()
    local n_red_huts = 0
    local n_yellow_huts = 0

    local n_ruins = 0
    local n_tents = 0
    local n_bunkhouses = 0
    local n_houses = 0

    for _, obj in ipairs(getObjects()) do
        if is_built(obj) then
            local desc = obj.getDescription()
            -- food
            if obj.getName() == "Hunter's Hut" then
                if obj.is_face_down then
                    n_red_huts = n_red_huts + 1
                else
                    n_yellow_huts = n_yellow_huts + 1
                end
            -- shelter
            elseif obj.getName() == ''
                and contains(desc, '•• Ruins ••') then
                if obj.is_face_down then
                    n_ruins = n_ruins + 1
                elseif contains(desc, '•• Tent ••') then
                    n_tents = n_tents + 1
                elseif contains(desc, '•• Bunkhouse ••') then
                    n_bunkhouses = n_bunkhouses + 1
                elseif contains(desc, '•• House ••') then
                    n_houses = n_houses + 1
                end
            end
        end
    end

    -- index starts at 0
    local function update_display(index, value)
        self.editButton({index = index, label = tostring(value)})
    end

    -- food
    update_display(1, n_red_huts)
    update_display(2, n_yellow_huts)

    -- shelter
    update_display(4, n_houses)
    update_display(5, n_bunkhouses)
    update_display(6, n_tents)
    update_display(7, n_ruins)
end

function contains(full_string, substring)
    return full_string:find(substring, 1, true)
end

function is_built(obj)
    local function between(axis)
        local coord = obj.getPosition()[axis]
        return center[axis] - radius <= coord
            and coord <= center[axis] + radius
    end

    return between('x')
        and round(obj.getPosition().y) == center.y
        and between('z')
        and obj.type == 'Tile'
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
