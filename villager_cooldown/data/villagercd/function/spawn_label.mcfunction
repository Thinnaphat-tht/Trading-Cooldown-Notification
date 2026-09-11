tag @s add vcd_vehicle

summon minecraft:text_display ~ ~0.6 ~ {Tags:["vcd_label","vcd_new"],billboard:"center",text:{text:""}}

execute as @e[type=minecraft:text_display,tag=vcd_new] run ride @s mount @e[tag=vcd_vehicle,limit=1]

tag @e[type=minecraft:text_display,tag=vcd_new] remove vcd_new
tag @s remove vcd_vehicle
