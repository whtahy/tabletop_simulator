scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onPlayerConnect(player)
    player.promote()
end

function onLoad()
    self.createButton({
        function_owner  = self,
        click_function  = 'promote_me',
        label           = 'Promote Me',
        position        = {0, 0.5, 0},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 2150,
        height          = 425,
        font_size       = 400,
        color           = {0.5, 0.5, 0.5},
        font_color      = {1, 1, 1}
    })
end

function promote_me(object, player_color)
    Player[player_color].promote()
end
