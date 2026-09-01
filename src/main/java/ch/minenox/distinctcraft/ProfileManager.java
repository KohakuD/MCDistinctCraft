package ch.minenox.distinctcraft;

import java.util.ArrayList;
import java.util.List;
import net.minecraft.client.Minecraft;
import net.minecraft.network.chat.Component;
import net.minecraft.server.packs.repository.Pack;
import net.minecraft.server.packs.repository.PackRepository;
import net.neoforged.neoforge.client.event.ClientResourceLoadFinishedEvent;

public final class ProfileManager {
    private ProfileManager() {
    }

    public static AccessibilityProfile selectedProfile() {
        PackRepository repository = Minecraft.getInstance().getResourcePackRepository();
        return repository.getSelectedPacks().stream()
                .map(Pack::getId)
                .map(ProfileManager::fromPackId)
                .filter(profile -> profile != null)
                .reduce((lowerProfile, higherProfile) -> higherProfile)
                .orElse(AccessibilityProfile.CLEAR);
    }

    public static void applyProfile(AccessibilityProfile profile, boolean showMessage) {
        Minecraft minecraft = Minecraft.getInstance();
        PackRepository repository = minecraft.getResourcePackRepository();
        if (!repository.isAvailable(profile.packId())) {
            return;
        }

        List<String> selectedPacks = repository.getSelectedPacks().stream()
                .map(Pack::getId)
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        int profilePackIndex = selectedPacks.size();
        for (int index = selectedPacks.size() - 1; index >= 0; index--) {
            if (AccessibilityProfile.isProfilePack(selectedPacks.get(index))) {
                profilePackIndex = 0;
                for (int lowerIndex = 0; lowerIndex < index; lowerIndex++) {
                    if (!AccessibilityProfile.isProfilePack(selectedPacks.get(lowerIndex))) {
                        profilePackIndex++;
                    }
                }
                break;
            }
        }

        selectedPacks.removeIf(AccessibilityProfile::isProfilePack);
        selectedPacks.add(Math.min(profilePackIndex, selectedPacks.size()), profile.packId());
        repository.setSelected(selectedPacks);
        minecraft.options.updateResourcePacks(repository);

        if (showMessage && minecraft.player != null) {
            minecraft.player.sendOverlayMessage(
                    Component.translatable("message.distinctcraft.profile_changed", profile.displayName()));
        }
    }

    public static void selectDefaultProfile(ClientResourceLoadFinishedEvent event) {
        if (!event.isInitial()) {
            return;
        }

        Minecraft minecraft = Minecraft.getInstance();
        PackRepository repository = minecraft.getResourcePackRepository();
        boolean profileSelected = repository.getSelectedPacks().stream()
                .map(Pack::getId)
                .anyMatch(AccessibilityProfile::isProfilePack);

        if (!profileSelected) {
            applyProfile(AccessibilityProfile.CLEAR, false);
        }
    }

    private static AccessibilityProfile fromPackId(String packId) {
        for (AccessibilityProfile profile : AccessibilityProfile.values()) {
            if (profile.packId().equals(packId)) {
                return profile;
            }
        }
        return null;
    }
}
