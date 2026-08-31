# Builds the 0.1.0 visual baseline five blocks in front of the executing player.
fill ~-4 ~-1 ~3 ~3 ~-1 ~5 minecraft:smooth_stone
fill ~-3 ~ ~4 ~-3 ~2 ~4 minecraft:dirt
fill ~-2 ~ ~4 ~-2 ~2 ~4 minecraft:stone
fill ~-1 ~ ~4 ~-1 ~2 ~4 minecraft:andesite
fill ~ ~ ~4 ~ ~2 ~4 minecraft:gravel
fill ~1 ~ ~4 ~1 ~2 ~4 minecraft:iron_ore
fill ~2 ~ ~4 ~2 ~2 ~4 minecraft:coal_ore
tellraw @s {"text":"DistinctCraft baseline: dirt, stone, andesite, gravel, iron ore, coal ore","color":"gray"}
