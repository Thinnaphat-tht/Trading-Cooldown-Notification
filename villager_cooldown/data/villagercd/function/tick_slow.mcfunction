schedule function villagercd:tick_slow 1s replace

tag @e[type=minecraft:text_display,tag=vcd_label] add vcd_orphan

execute as @e[type=minecraft:villager] at @s run function villagercd:tick_villager

kill @e[type=minecraft:text_display,tag=vcd_orphan]
