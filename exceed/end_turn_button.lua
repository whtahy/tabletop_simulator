scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    self.createButton({
        function_owner  = self,
        click_function  = 'end_turn',
        label           = 'End Turn',
        position        = {0, 0.5, 0},
        scale           = {1/scale_width, 1/scale_height, 1/scale_length},
        width           = 1600,
        height          = 400,
        font_size       = 400,
        color           = {0.5, 0.5, 0.5},
        font_color      = {1, 1, 1}
    })
end

function end_turn()
    update_hp_counter('Red')
    update_hp_counter('Blue')
    Turns.turn_color = Turns.getNextTurnColor()
end

function update_hp_counter(player_color)
    local damage_counter = Global.getTable('damage_counter_table')[player_color]
    local hp_counter = Global.getTable('hp_counter_table')[player_color]

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
