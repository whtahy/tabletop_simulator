scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    self.createButton({
        function_owner  = self,
        click_function  = 'discard',
        label           = 'Discard',
        position        = {0, 0.5, 0},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 1600,
        height          = 400,
        font_size       = 400,
        color           = {0.5, 0.5, 0.5},
        font_color      = {1, 1, 1},
        tooltip         = "Discard a random card from hand."
    })
end

function discard(object, player_color)
    local hand = Player[player_color].getHandObjects()

    -- empty hand -> do nothing
    if #hand == 0 then
        return nil
    end

    -- otherwise, discard a random card from hand
    local zone = Global.getTable('discard_zones_table')[player_color]
    local card = hand[math.random(1, #hand)]
    card.use_hands = false
    card.setPositionSmooth(zone.getPosition())
    Wait.time(function() card.use_hands = true end, 0.5)
end
