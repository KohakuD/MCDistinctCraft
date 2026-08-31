# DistinctCraft Development

- Minecraft: 26.2
- NeoForge: 26.2.0.75
- Java: 25
- Distribution: client-side only
- Supported locales: `en_us`, `de_de`, `nl_nl`

Build with `.\gradlew.bat build` and start the development client with `.\gradlew.bat runClient`.

On Windows, `runClient` starts a short-lived helper that places the Minecraft window on the left two thirds of its current monitor at full usable screen height. The helper exits after positioning the window and does not affect packaged mod behavior.

## Resource validation

The build runs `validateBaselineResources` automatically. It verifies that the four custom 0.1.0 block textures are present as 16 x 16 PNG files, vanilla stone is not overridden, the smoke-test function covers all five baseline blocks, and `en_us`, `de_de`, and `nl_nl` contain the same translation keys.

Regenerate the checked-in baseline textures after changing their pixel maps with:

```powershell
.\tools\generate-baseline-textures.ps1
```

## Compatibility

DistinctCraft is client-side only and replaces vanilla block textures through the standard Minecraft resource system. Stone deliberately keeps its vanilla texture and acts as the neutral baseline. It does not require or use OptiFine. A resource pack loaded above mod resources can override the four custom textures; packs below them remain hidden for those blocks.
