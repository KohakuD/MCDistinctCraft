package ch.minenox.distinctcraft;

import net.neoforged.neoforge.common.ModConfigSpec;

public final class DistinctCraftConfig {
    public static final ModConfigSpec SPEC;
    public static final ModConfigSpec.BooleanValue TARGET_OUTLINE;

    static {
        ModConfigSpec.Builder builder = new ModConfigSpec.Builder();
        builder.comment("Client-side accessibility preferences").push("accessibility");
        TARGET_OUTLINE = builder
                .comment("Draw a high-contrast outline around the block under the crosshair.")
                .translation("config.distinctcraft.target_outline")
                .define("targetOutline", false);
        builder.pop();
        SPEC = builder.build();
    }

    private DistinctCraftConfig() {
    }

    public static void setTargetOutline(boolean enabled) {
        TARGET_OUTLINE.set(enabled);
        SPEC.save();
    }

}
