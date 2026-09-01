package ch.minenox.distinctcraft;

import com.mojang.blaze3d.platform.InputConstants;
import net.minecraft.client.KeyMapping;
import net.minecraft.resources.Identifier;
import net.neoforged.neoforge.client.event.RegisterKeyMappingsEvent;

public final class DistinctCraftKeyMappings {
    private static final KeyMapping.Category CATEGORY = new KeyMapping.Category(
            Identifier.fromNamespaceAndPath(DistinctCraft.MOD_ID, "accessibility"));

    public static final KeyMapping OPEN_SETTINGS = new KeyMapping(
            "key.distinctcraft.open_settings",
            InputConstants.Type.KEYSYM,
            InputConstants.KEY_O,
            CATEGORY);
    public static final KeyMapping CYCLE_PROFILE = new KeyMapping(
            "key.distinctcraft.cycle_profile",
            InputConstants.Type.KEYSYM,
            InputConstants.KEY_P,
            CATEGORY);
    public static final KeyMapping TOGGLE_HIGHLIGHT = new KeyMapping(
            "key.distinctcraft.toggle_highlight",
            InputConstants.Type.KEYSYM,
            InputConstants.KEY_H,
            CATEGORY);

    private DistinctCraftKeyMappings() {
    }

    public static void register(RegisterKeyMappingsEvent event) {
        event.registerCategory(CATEGORY);
        event.register(OPEN_SETTINGS);
        event.register(CYCLE_PROFILE);
        event.register(TOGGLE_HIGHLIGHT);
    }
}
