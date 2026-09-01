# No-X-ray design boundary

DistinctCraft 0.4.0 changes only ordinary client resource-pack textures for visible block faces and matching inventory items.

- No world or chunk scanning is performed.
- No hidden-block data is collected or displayed.
- No transparency is added to world block textures.
- No emissive, animated, or full-bright ore metadata is used.
- No depth test, through-wall renderer, entity glow, or outline is attached to ores.
- The optional target outline still follows Minecraft's normal looked-at block and cannot select a block behind terrain.

The patterns can make an exposed ore face easier to recognize, but they cannot reveal an ore that vanilla rendering does not already show.
