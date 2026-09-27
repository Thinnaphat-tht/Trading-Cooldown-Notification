schedule function villagercd:tick_slow 1s replace

tag @e[type=minecraft:text_display,tag=vcd_label] add vcd_orphan

# Only villagers within 48 blocks of a player are updated; labels on the rest are left
# tagged as orphans and removed, so far-away villagers show nothing until someone returns
execute at @a run tag @e[type=minecraft:villager,distance=..48] add vcd_near
execute as @e[type=minecraft:villager,tag=vcd_near] at @s run function villagercd:tick_villager
tag @e[type=minecraft:villager,tag=vcd_near] remove vcd_near

kill @e[type=minecraft:text_display,tag=vcd_orphan]
