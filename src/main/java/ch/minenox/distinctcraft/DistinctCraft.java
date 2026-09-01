package ch.minenox.distinctcraft;

import java.util.List;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.Identifier;
import net.minecraft.server.packs.PackType;
import net.minecraft.server.packs.repository.Pack;
import net.minecraft.server.packs.repository.PackSource;
import net.neoforged.api.distmarker.Dist;
import net.neoforged.bus.api.IEventBus;
import net.neoforged.fml.ModContainer;
import net.neoforged.fml.common.Mod;
import net.neoforged.fml.config.ModConfig;
import net.neoforged.neoforge.client.gui.IConfigScreenFactory;
import net.neoforged.neoforge.common.NeoForge;
import net.neoforged.neoforge.event.AddPackFindersEvent;

@Mod(value = DistinctCraft.MOD_ID, dist = Dist.CLIENT)
public final class DistinctCraft {
    public static final String MOD_ID = "distinctcraft";
    private static final List<String> PROFILES = AccessibilityProfile.names();

    public DistinctCraft(IEventBus modEventBus, ModContainer modContainer) {
        modEventBus.addListener(DistinctCraft::addProfilePacks);
        modEventBus.addListener(DistinctCraftKeyMappings::register);
        modContainer.registerConfig(ModConfig.Type.CLIENT, DistinctCraftConfig.SPEC);
        modContainer.registerExtensionPoint(
                IConfigScreenFactory.class,
                (container, parent) -> new DistinctCraftConfigScreen(parent));

        NeoForge.EVENT_BUS.addListener(ProfileManager::selectDefaultProfile);
        NeoForge.EVENT_BUS.addListener(DistinctCraftClientEvents::onClientTick);
        NeoForge.EVENT_BUS.addListener(DistinctCraftClientEvents::onBlockOutline);
    }

    private static void addProfilePacks(AddPackFindersEvent event) {
        for (String profile : PROFILES) {
            addProfilePack(event, profile);
        }
    }

    private static void addProfilePack(AddPackFindersEvent event, String profile) {
        event.addPackFinders(
                Identifier.fromNamespaceAndPath(MOD_ID, "resourcepacks/" + profile),
                PackType.CLIENT_RESOURCES,
                Component.translatable("pack.distinctcraft.profile." + profile + ".name"),
                PackSource.BUILT_IN,
                false,
                Pack.Position.TOP);
    }

}
