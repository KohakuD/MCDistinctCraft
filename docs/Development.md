# DistinctCraft Development

- Minecraft: 26.2
- NeoForge: 26.2.0.75
- Java: 25
- Distribution: client-side only
- Supported locales: `en_us`, `de_de`, `nl_nl`

Build with `.\gradlew.bat build` and start the development client with `.\gradlew.bat runClient`.

On Windows, `runClient` starts a short-lived helper that places the Minecraft window on the left two thirds of its current monitor at full usable screen height. The helper exits after positioning the window and does not affect packaged mod behavior.

## Resource validation

The build runs `validateBaselineResources`, `validateProfileResources`, and `validateClientUxResources` automatically. They verify locale parity, smoke-test coverage, pack metadata, registration, complete 16 x 16 PNG sets for all profiles, distinct variants, the absence of a stone override, and the translated 0.3.0 controls.

Regenerate the checked-in baseline textures after changing their pixel maps with:

```powershell
.\tools\generate-baseline-textures.ps1
```

## Compatibility

DistinctCraft is client-side only and replaces vanilla block textures through standard bundled resource packs. Stone deliberately keeps its vanilla texture and acts as the neutral baseline. It does not require or use OptiFine. Third-party packs placed above the selected DistinctCraft profile can override its four custom textures.
