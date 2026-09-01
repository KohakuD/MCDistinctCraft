# Builds the 0.4.0 ore coverage as three-block-high columns with dirt as a neutral contrast reference.
fill ~-9 ~-1 ~3 ~9 ~-1 ~11 minecraft:dirt
fill ~-9 ~ ~4 ~-9 ~2 ~4 minecraft:dirt
fill ~-8 ~ ~4 ~-8 ~2 ~4 minecraft:coal_ore
fill ~-7 ~ ~4 ~-7 ~2 ~4 minecraft:iron_ore
fill ~-6 ~ ~4 ~-6 ~2 ~4 minecraft:copper_ore
fill ~-5 ~ ~4 ~-5 ~2 ~4 minecraft:gold_ore
fill ~-4 ~ ~4 ~-4 ~2 ~4 minecraft:redstone_ore
fill ~-3 ~ ~4 ~-3 ~2 ~4 minecraft:lapis_ore
fill ~-2 ~ ~4 ~-2 ~2 ~4 minecraft:diamond_ore
fill ~-1 ~ ~4 ~-1 ~2 ~4 minecraft:emerald_ore
fill ~-9 ~ ~7 ~-9 ~2 ~7 minecraft:dirt
fill ~-8 ~ ~7 ~-8 ~2 ~7 minecraft:deepslate_coal_ore
fill ~-7 ~ ~7 ~-7 ~2 ~7 minecraft:deepslate_iron_ore
fill ~-6 ~ ~7 ~-6 ~2 ~7 minecraft:deepslate_copper_ore
fill ~-5 ~ ~7 ~-5 ~2 ~7 minecraft:deepslate_gold_ore
fill ~-4 ~ ~7 ~-4 ~2 ~7 minecraft:deepslate_redstone_ore
fill ~-3 ~ ~7 ~-3 ~2 ~7 minecraft:deepslate_lapis_ore
fill ~-2 ~ ~7 ~-2 ~2 ~7 minecraft:deepslate_diamond_ore
fill ~-1 ~ ~7 ~-1 ~2 ~7 minecraft:deepslate_emerald_ore
fill ~-9 ~ ~10 ~-9 ~2 ~10 minecraft:dirt
fill ~-8 ~ ~10 ~-8 ~2 ~10 minecraft:nether_quartz_ore
fill ~-7 ~ ~10 ~-7 ~2 ~10 minecraft:nether_gold_ore
give @s minecraft:coal
give @s minecraft:raw_iron
give @s minecraft:raw_copper
give @s minecraft:raw_gold
give @s minecraft:redstone
give @s minecraft:lapis_lazuli
give @s minecraft:diamond
give @s minecraft:emerald
give @s minecraft:quartz
give @s minecraft:gold_nugget
tellraw @s {"translate":"distinctcraft.smoke.coverage_ready","color":"gray"}
