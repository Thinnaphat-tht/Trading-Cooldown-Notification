scoreboard objectives add vcd.state dummy
scoreboard objectives add vcd.locked dummy
scoreboard objectives add vcd.haslabel dummy
scoreboard objectives add vcd.calc dummy
scoreboard objectives add vcd.const dummy

scoreboard players set #20 vcd.const 20
scoreboard players set #60 vcd.const 60

execute as @e[type=minecraft:villager] if score @s vcd.state matches 1..2 run data modify entity @s CustomNameVisible set value 0b
execute as @e[type=minecraft:villager] if score @s vcd.state matches 1..2 run data remove entity @s CustomName

schedule function villagercd:tick_slow 1s replace

tellraw @a {"text":"[VillagerCD] loaded","color":"green"}
