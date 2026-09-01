# DistinctCraft Roadmap

## 0.1.0 / Initial Accessibility Baseline

- [x] Implement the **client-side** Minecraft 26.2 / NeoForge 26.2.0.75 DistinctCraft base mod setup.
- [x] Establish and ship the initial visual baseline for:
  - Stone (vanilla reference; no override)
  - Andesite
  - Gravel
  - Iron ore
  - Coal ore
- [x] Replace color-only differentiation with a pattern-and-contrast-first visual approach for the four customized blocks.
- [x] Keep behavior and resource definitions client-only and document compatibility constraints (no OptiFine reliance).
- [x] Add baseline `en_us`, `de_de`, and `nl_nl` entries and keep all three locales in sync.
- [x] Add smoke-test level and resource checks for all baseline textures.
- [x] Record initial in-game test notes with the target player for baseline blocks.

## 0.2.0 / Profile System + Pattern Variants

- [x] Introduce a built-in profile system loaded as bundled resource-pack profiles:
  - `subtle`
  - `clear`
  - `monochrome`
- [x] Add profile switching in-game and persistence of user-selected profile.
- [x] Add UI labels and descriptions for each profile in `en_us`, `de_de`, and `nl_nl`.
- [x] Add automated checks that validate profile assets are complete and correctly referenced.
- [x] Ensure every profile works without OptiFine or another rendering mod.
- [x] Ship first documentation pass describing “what to choose when” for each profile.

## 0.3.0 / UX, Controls and Feedback

- [x] Add mod configuration menu (client-side) for profile and accessibility preferences.
- [x] Add keybinds for fast profile toggling and quick contrast settings.
- [x] Add optional high-contrast highlight for looked-at target blocks:
  - subtle outline
  - evaluate an optional symbol marker beside the crosshair; remove it after playtesting showed that the outline is clearer
- [ ] Run and document in-game playtests with the target player and iterate on feel tuning.
- [x] Add texture validation hooks into the build pipeline for profile assets.
- [x] Ensure `en_us`, `de_de`, and `nl_nl` parity for all new config and UI strings.

## 0.4.0 / Coverage Expansion (No X-ray, No Gameplay Advantage)

- [x] Add additional vanilla ores and matching inventory-item textures.
- [x] Extend profile support to inventory textures while preserving world texture readability.
- [x] Confirm no X-ray-like behavior or luminance tricks that expose hidden blocks.
- [x] Extend automated validation to include inventory texture completeness and registry consistency.
- [x] Add changelog and screenshots showcasing all new block and inventory profiles.
- [x] Validate feedback from the target player after adding the broader ore set.

## 0.5.0 / Compatibility and Future Extensions

- [x] Keep Jade compatibility intact and verify against Jade 26.2.10 first.
- [x] Prepare optional Jade integration path (off by default, compatible later); no integration is currently needed because vanilla block identity remains intact.
- [x] Evaluate optional NeoForge-based emissive layers; defer them after review so 0.5.0 remains texture-only and revisit only if in-game readability proves insufficient.
- [x] Verify resource-pack priority, preserve it during profile changes, and document interaction with third-party texture packs.
- [x] Add staged compatibility plan for modded blocks.
- [x] Add integration smoke tests for no-conflict operation with common client mods; Jade 26.2.10 and WTHIT 20.0.0 are verified as mutually exclusive overlay alternatives.
- [x] Keep resource and localization quality gates unchanged (no regressions in `en_us`/`de_de`/`nl_nl`).

## 0.6.0 / Release Readiness

- [ ] Add mod icon and polished metadata for distribution.
- [ ] Include release screenshots for all profile modes and key screens.
- [ ] Final QA for packaged resource validation, locale parity, and profile switching.
- [ ] Publish CurseForge release with clear installation and usage notes.
