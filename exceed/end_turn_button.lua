scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    self.createButton({
        function_owner  = self,
        click_function  = 'end_turn',
        label           = 'End Turn',
        position        = {0, 0.1, 0},
        scale           = {1/scale_width, 1, 1/scale_length},
        width           = 120 * scale_width,
        height          = 32 * scale_length,
        font_size       = 30 * scale_width,
        color           = {0.5, 0.5, 0.5},
        font_color      = {1, 1, 1}
    })
end

function end_turn()
    Turns.turn_color = Turns.getNextTurnColor()
end
