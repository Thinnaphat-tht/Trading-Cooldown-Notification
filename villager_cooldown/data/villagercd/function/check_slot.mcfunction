$execute unless data entity @s Offers.Recipes[$(i)] run return 0

$execute store result score #uses vcd.calc run data get entity @s Offers.Recipes[$(i)].uses
$execute store result score #max vcd.calc run data get entity @s Offers.Recipes[$(i)].maxUses

$execute if score #uses vcd.calc >= #max vcd.calc if score @s vcd.locked matches 0 run data modify storage villagercd:tmp sell set from entity @s Offers.Recipes[$(i)].sell.id
$execute if score #uses vcd.calc >= #max vcd.calc if score @s vcd.locked matches 0 run data modify storage villagercd:tmp buy set from entity @s Offers.Recipes[$(i)].buy.id
execute if score #uses vcd.calc >= #max vcd.calc run scoreboard players set @s vcd.locked 1

scoreboard players add #i vcd.calc 1
execute store result storage villagercd:loop i int 1 run scoreboard players get #i vcd.calc
execute if score #i vcd.calc matches ..31 run function villagercd:check_slot with storage villagercd:loop
