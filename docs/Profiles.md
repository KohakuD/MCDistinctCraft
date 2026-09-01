# DistinctCraft Profiles

DistinctCraft 0.5.0 includes three bundled resource-pack profiles. They use the same block and matching inventory-item patterns with different contrast ranges.

## Which profile should I choose?

- **Clear** is the default. Choose it for strong patterns without extreme brightness differences.
- **Subtle** stays closer to vanilla contrast. Choose it when the default feels too visually prominent.
- **Monochrome** uses only neutral grays and the strongest luminance separation. Choose it when color cues are unreliable or when testing in grayscale.

## Switching profiles

1. Open **Options > Resource Packs** in Minecraft.
2. Move the active DistinctCraft profile back to **Available**.
3. Move **DistinctCraft: Clear**, **DistinctCraft: Subtle**, or **DistinctCraft: Monochrome** to **Selected**.
4. Keep exactly one DistinctCraft profile selected.
5. Select **Done** and wait for resources to reload.

Clear is selected automatically when no profile has been chosen yet. Minecraft stores the enabled resource-pack list in its normal options, so the selected profile persists across restarts.

All profiles use standard Minecraft resource-pack behavior and require neither OptiFine nor another rendering mod.

## Priority with other resource packs

Minecraft lets the higher pack in the **Selected** list override matching files from packs below it. Put a third-party pack above DistinctCraft when its version of an overlapping texture should win. Put DistinctCraft above it when the accessibility pattern should win. Textures that only one of the packs provides are unaffected.

Switching between Clear, Subtle, and Monochrome keeps DistinctCraft at its existing priority. It also removes any accidentally selected second DistinctCraft profile, so exactly one remains active. When no DistinctCraft profile was selected before, Clear or the newly selected profile is added at the normal highest selected priority and can then be moved in Minecraft's resource-pack screen.

## Covered ore families

Coal, iron, copper, gold, redstone, lapis, diamond, and emerald include both stone and deepslate variants. Nether quartz and Nether gold are also covered. Their primary drops use matching shapes in the inventory. Ancient debris is intentionally excluded from 0.4.0 because its directional top/side textures make it a separate design case.
