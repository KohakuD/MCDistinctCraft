# DistinctCraft Development

- Minecraft: 26.2
- NeoForge: 26.2.0.75
- Java: 25
- Distribution: client-side only
- Supported locales: `en_us`, `de_de`, `nl_nl`

Build with `.\gradlew.bat build` and start the development client with `.\gradlew.bat runClient`.

On Windows, `runClient` starts a short-lived helper that places the Minecraft window on the left two thirds of its current monitor at full usable screen height. The helper exits after positioning the window and does not affect packaged mod behavior.

## Resource validation

The build runs `validateBaselineResources`, `validateProfileResources`, `validateClientUxResources`, `validateCoverageResources`, and `validateCompatibilityResources` automatically. They verify locale parity, smoke-test coverage, pack metadata and priority handling, registration, complete 16 x 16 PNG sets for all profiles, distinct variants, the absence of a stone override, translated controls, Minecraft 26.2 registry names, transparent item backgrounds, the no-emissive coverage boundary, and the reproducible Jade/WTHIT compatibility matrix.

Regenerate the checked-in baseline textures after changing their pixel maps with:

```powershell
.\tools\generate-baseline-textures.ps1
.\tools\generate-coverage-contact-sheet.ps1
```

## Compatibility

DistinctCraft is client-side only and replaces vanilla block and item textures through standard bundled resource packs. Stone deliberately keeps its vanilla texture and acts as the neutral baseline. It does not require or use OptiFine. Third-party packs placed above the selected DistinctCraft profile can override its custom textures. Changing the DistinctCraft profile preserves that chosen pack position.

Jade and WTHIT are tested as optional overlay mods, never as DistinctCraft dependencies. Use `tools/select-compatibility-mod.ps1` to activate exactly one pinned provider in the ignored development `run/mods` directory, then start the normal client from Gradle or the IDE play button. The complete matrix and smoke-test procedure are documented in `docs/testing/0.5.0-compatibility.md`.

The staged rules for future modded blocks and a later visible-surface light-accent experiment are documented in `docs/Future-Extensions.md`. They are compatibility boundaries, not packaged integrations or dependencies.
