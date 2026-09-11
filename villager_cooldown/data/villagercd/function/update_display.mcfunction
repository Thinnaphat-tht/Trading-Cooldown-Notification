data modify storage villagercd:tmp show set from storage villagercd:tmp sell
execute if data storage villagercd:tmp {sell:"minecraft:emerald"} run data modify storage villagercd:tmp show set from storage villagercd:tmp buy

data modify storage villagercd:tmp rawid set from storage villagercd:tmp show
data modify storage villagercd:tmp ns set string storage villagercd:tmp rawid 0 10
execute if data storage villagercd:tmp {ns:"minecraft:"} run data modify storage villagercd:tmp show set string storage villagercd:tmp rawid 10

execute store result score #now vcd.calc run time query gametime

scoreboard players set #lastrestock vcd.calc 0
scoreboard players set #restocks vcd.calc 0
execute store result score #lastrestock vcd.calc run data get entity @s LastRestock
execute store result score #restocks vcd.calc run data get entity @s RestocksToday

scoreboard players operation #target vcd.calc = #lastrestock vcd.calc
execute if score #restocks vcd.calc matches 1 run scoreboard players add #target vcd.calc 2400
execute if score #restocks vcd.calc matches 2.. run scoreboard players add #target vcd.calc 12000

scoreboard players operation #remain vcd.calc = #target vcd.calc
scoreboard players operation #remain vcd.calc -= #now vcd.calc
execute if score #restocks vcd.calc matches 0 run scoreboard players set #remain vcd.calc 0
execute if score #remain vcd.calc matches ..0 run scoreboard players set #remain vcd.calc 0

scoreboard players operation #sec vcd.calc = #remain vcd.calc
scoreboard players operation #sec vcd.calc /= #20 vcd.const

scoreboard players operation #min vcd.calc = #sec vcd.calc
scoreboard players operation #min vcd.calc /= #60 vcd.const

scoreboard players operation #secmod vcd.calc = #sec vcd.calc
scoreboard players operation #secmod vcd.calc %= #60 vcd.const

execute store result storage villagercd:tmp min int 1 run scoreboard players get #min vcd.calc
execute store result storage villagercd:tmp sec int 1 run scoreboard players get #secmod vcd.calc

execute if score @s vcd.haslabel matches 0 run function villagercd:spawn_label

execute if score @s vcd.state matches 1 if score #remain vcd.calc matches 1.. on passengers if entity @s[tag=vcd_label] run function villagercd:set_text_cooling with storage villagercd:tmp
execute if score @s vcd.state matches 1 if score #remain vcd.calc matches ..0 if data entity @s Brain.memories."minecraft:job_site" on passengers if entity @s[tag=vcd_label] run function villagercd:set_text_waiting with storage villagercd:tmp
execute if score @s vcd.state matches 1 if score #remain vcd.calc matches ..0 unless data entity @s Brain.memories."minecraft:job_site" on passengers if entity @s[tag=vcd_label] run function villagercd:set_text_nojob with storage villagercd:tmp
execute if score @s vcd.state matches 2 on passengers if entity @s[tag=vcd_label] run function villagercd:set_text_ready
