scale_width = self.getScale().x
scale_height = self.getScale().y
scale_length = self.getScale().z

function onLoad()
    damage_counter_table = Global.getTable('damage_counter_table')
    hp_counter_table = Global.getTable('hp_counter_table')

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
    Turns.turn_color = Turns.getNextTurnColor()

    --get value from damage_counter_table
    local redDamage = damage_counter_table['Red'].Counter.getValue()
    local blueDamage = damage_counter_table['Blue'].Counter.getValue()

    --minus damage from hp_counter_table
    local redCurrHP = hp_counter_table['Red'].Counter.getValue()
    local blueCurrHP = hp_counter_table['Blue'].Counter.getValue()

    local newRedHP = redCurrHP - redDamage
    local newBlueHP = blueCurrHP - blueDamage

    --animated hp decrementer
    for i = 1, redDamage do
        Wait.time(function() hp_counter_table['Red'].Counter.decrement() end, (0.2 * i))
    end

    for i = 1, blueDamage do
        Wait.time(function() hp_counter_table['Blue'].Counter.decrement() end, (0.2 * i))
    end

    --immediate result version
    --hp_counter_table['Red'].Counter.setValue(newRedHP)
    --hp_counter_table['Blue'].Counter.setValue(newBlueHP)

    --set value of damage_counter_table to 0
    Wait.time(
    function()
        damage_counter_table['Red'].Counter.setValue(0)
        damage_counter_table['Blue'].Counter.setValue(0)
    end,
    1)
end
