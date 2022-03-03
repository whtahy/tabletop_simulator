scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    params = {
        function_owner  = self,
        click_function  = 'discardFromBlue',
        label           = 'Discard',
        position        = {0, 0.5, 0},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 1600,
        height          = 400,
        font_size       = 400,
        color           = {0.5, 0.5, 0.5},
        font_color      = {1, 1, 1},
        tooltip         = "Discard random card from your hand"
    }
    self.createButton(params)
end

discardData = {
  ['Blue'] = {position = {25.98, 1.5, 14.57}, position0 = {14.43, 1.12, 8.71}, rotation = {0,180,0}},
  ['Red'] = {position = {-23.73, 1.5, 14.64}, position0 = {-14.43, 1.12, 8.71}, rotation = {0,180,0}}
}

function moveToDiscard(obj)
    local data = discardData['Blue']
    if obj.type == 'Card' and data ~= nil then
        obj.setPosition(data.position0)
        obj.setPositionSmooth(data.position, false, false)
        obj.setRotation(data.rotation)
    end
end

function discardFromBlue()
    local count = 0
    for i,obj in pairs(Player['Blue'].getHandObjects()) do
        count = count + 1
    end

    local randomCardIndex = math.random(1, count)

    for i,obj in pairs(Player['Blue'].getHandObjects()) do
        if i == randomCardIndex then
            moveToDiscard(obj)
            break
        end
    end
end
