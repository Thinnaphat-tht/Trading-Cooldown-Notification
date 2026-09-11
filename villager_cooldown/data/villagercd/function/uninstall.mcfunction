execute as @e[type=minecraft:villager] run function villagercd:clear_display

kill @e[type=minecraft:text_display,tag=vcd_label]

schedule clear villagercd:tick_slow

scoreboard objectives remove vcd.state
scoreboard objectives remove vcd.locked
scoreboard objectives remove vcd.haslabel
scoreboard objectives remove vcd.calc
scoreboard objectives remove vcd.const

tellraw @a {"text":"[VillagerCD] uninstalled — you can disable the datapack now","color":"red"}
