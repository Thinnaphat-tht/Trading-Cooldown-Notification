execute unless data entity @s Offers.Recipes[0] run return 0

scoreboard players set @s vcd.locked 0
data modify storage villagercd:tmp sell set value "?"
data modify storage villagercd:tmp buy set value "?"

scoreboard players set #i vcd.calc 0
data modify storage villagercd:loop i set value 0
function villagercd:check_slot with storage villagercd:loop

scoreboard players set @s vcd.haslabel 0
execute on passengers if entity @s[tag=vcd_label] run tag @s remove vcd_orphan
execute on passengers if entity @s[tag=vcd_label] on vehicle run scoreboard players set @s vcd.haslabel 1

execute if score @s vcd.locked matches 1 run function villagercd:on_locked
execute if score @s vcd.locked matches 0 run function villagercd:on_unlocked
