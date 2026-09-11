execute if score @s vcd.state matches 1 run scoreboard players set @s vcd.state 2

execute if score @s vcd.state matches 2 run function villagercd:update_display
