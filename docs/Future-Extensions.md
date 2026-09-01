# DistinctCraft Future Extensions

DistinctCraft 0.5.0 keeps compatibility additions optional and client-side. The shipped profiles still replace only standard resource files and do not add server requirements, registry entries, or dependencies on other mods.

## Modded blocks

Support for blocks from other mods will be added in stages instead of guessing block names or taking over every ore-like texture:

1. **Resource add-on:** confirm the mod namespace, registry IDs, texture paths, and redistribution terms for one supported mod and provide an optional DistinctCraft add-on pack.
2. **Profile parity:** give every supported block a Subtle, Clear, and Monochrome texture and validate all three variants with the same size, opacity, and contrast checks as the vanilla set.
3. **Identity and overlay check:** verify the real block name, required tool, and harvest information with the selected overlay provider. Jade remains the preferred development provider; no Jade API dependency is introduced while vanilla block identity is sufficient.
4. **Runtime adapter only when necessary:** add a feature-gated compatibility adapter only if a mod generates models dynamically and cannot be supported with resources alone. It must fail closed when that mod is absent.
5. **Per-mod smoke test:** test exposed blocks in daylight and darkness, inventory items, profile switching, a third-party resource pack above and below DistinctCraft, and a client without the optional mod installed.

Each integration stays in its own namespace and validation list. A problem in one optional add-on must not change the vanilla profiles.

## Visible-surface light accents

NeoForge 26.2 changed the chunk-rendering extension path substantially. Any later light-accent prototype therefore has these non-negotiable boundaries:

- disabled by default and clearly labelled as an accessibility option;
- emitted only while Minecraft builds geometry for a currently visible block surface;
- no world scans, hidden-block indicators, depth-test bypass, beacons, particles, or through-wall rendering;
- only the ore marking may receive a restrained light floor; the surrounding stone or deepslate stays normally lit;
- automatically absent when the feature is disabled or its rendering prerequisites are unavailable;
- separately tested in darkness, behind solid blocks, at chunk borders, after resource reloads, and with Jade enabled.

The 0.5.0 compatibility foundation deliberately does not ship a rendering prototype. Texture-only profiles are the chosen implementation. This topic will be reopened only if later in-game testing shows that the patterns and contrast profiles do not provide enough readability; any proposal must then pass both visual approval and the no-X-ray boundary tests above.
