package ch.minenox.distinctcraft;

import java.util.Arrays;
import java.util.List;
import net.minecraft.network.chat.Component;

public enum AccessibilityProfile {
    SUBTLE("subtle"),
    CLEAR("clear"),
    MONOCHROME("monochrome");

    private final String id;

    AccessibilityProfile(String id) {
        this.id = id;
    }

    public String id() {
        return this.id;
    }

    public String packId() {
        return "mod/" + DistinctCraft.MOD_ID + ":resourcepacks/" + this.id;
    }

    public Component displayName() {
        return Component.translatable("pack.distinctcraft.profile." + this.id + ".name");
    }

    public Component description() {
        return Component.translatable("pack.distinctcraft.profile." + this.id + ".description");
    }

    public AccessibilityProfile next() {
        AccessibilityProfile[] profiles = values();
        return profiles[(this.ordinal() + 1) % profiles.length];
    }

    public static List<String> names() {
        return Arrays.stream(values()).map(AccessibilityProfile::id).toList();
    }

    public static boolean isProfilePack(String packId) {
        return Arrays.stream(values()).anyMatch(profile -> profile.packId().equals(packId));
    }
}
