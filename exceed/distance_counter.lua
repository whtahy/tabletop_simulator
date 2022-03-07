scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    -- store text
    --top_distance_table = {}
    --bottom_distance_table = {}
    --for _, obj in ipairs(getAllObjects()) do
    --    local x = round(obj.getPosition().x)
    --    local y = round(obj.getPosition().y)
    --    if obj.type == '3D Text'
    --        local z = round(obj.getPosition().z)
    --        if z == 23 then
    --            table.insert(top_distance_table, obj)
    --        elseif z ==
    --        end
    --        and  then
    --
    --      end
    --  end
    --for i = -4, 4 do
    --    local text = spawn_text({i * 3, 0.3, 23})
    --    text.textTool.setValue(tostring(i))
    --    --local text = spawn_text({i * 3, 0.5, 18})
    --    --text.textTool.setValue(tostring(i))
    --end

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
end

function toggle_on_off()
end

function round(x)
    return math.floor(x + 0.5)
end
