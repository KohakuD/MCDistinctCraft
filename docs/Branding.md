# DistinctCraft branding

The editable source of the DistinctCraft symbol is [`docs/assets/branding/distinctcraft-logo.svg`](assets/branding/distinctcraft-logo.svg). Raster exports used by NeoForge and CurseForge must be generated from this file; the SVG remains the canonical design.

After editing the SVG on Windows, regenerate both checked-in PNG exports with:

```powershell
.\tools\export-branding.ps1
```

The script creates the 1024 × 1024 CurseForge image at `docs/assets/branding/distinctcraft-logo.png` and the 256 × 256 NeoForge icon at `src/main/resources/distinctcraft.png`.

## Concept

- Nox is the recurring guide character. His brown hair and beard, blue eyes, dark hoodie, blue sleeves, and amber zipper are interpreted from his MCPlayerTwo skin as original vector geometry.
- Two generic ore blocks supply the Minecraft association without copying a Minecraft logo or texture.
- The low-contrast block and the strongly patterned block form a compact before/after story: DistinctCraft turns visually similar material into something legible through shape and contrast.
- The cream rounded square, restrained gradients, soft depth, and one central metaphor follow the visual language of the existing Kohaku Steps and Kohaku Drink icons.

## Reusable family rules

Future KohakuD Minecraft project symbols can share these construction rules while retaining a unique central metaphor:

1. Use a square `viewBox` and a warm rounded-square container with generous internal space.
2. Prefer Nox as the friendly recurring guide plus one project-specific visual story.
3. Keep silhouettes readable at 64 × 64 pixels; avoid text and small decorative details.
4. Use dark outlines for critical edges and never rely on hue alone to separate adjacent shapes.
5. Reserve amber (`#F4C64F`) as the Kohaku family accent; choose one secondary project color.
6. Use only original geometry. Do not copy Minecraft textures, logos, or existing Kohaku project artwork.

## DistinctCraft palette

- Warm background: `#FFFDF8` to `#F5EAD7`
- Amber family accent: `#F4C64F`
- Teal project accent: `#4F8584` to `#294F54`
- Structural dark: `#263334`
- Neutral block faces: `#F1F2EC`, `#899591`, `#455353`

The logo source and original exports are licensed under CC BY 4.0. Minecraft and its trademarks are not part of the DistinctCraft branding license.
