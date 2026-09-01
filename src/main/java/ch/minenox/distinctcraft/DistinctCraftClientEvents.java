package ch.minenox.distinctcraft;

import com.mojang.blaze3d.vertex.PoseStack;
import net.minecraft.client.Minecraft;
import net.minecraft.client.renderer.rendertype.RenderTypes;
import net.minecraft.core.BlockPos;
import net.minecraft.network.chat.Component;
import net.minecraft.util.ARGB;
import net.minecraft.world.phys.Vec3;
import net.neoforged.neoforge.client.event.ClientTickEvent;
import net.neoforged.neoforge.client.event.ExtractBlockOutlineRenderStateEvent;

public final class DistinctCraftClientEvents {
    private static final int OUTLINE_DARK = ARGB.color(255, 0, 0, 0);
    private static final int OUTLINE_BRIGHT = ARGB.color(255, 255, 224, 64);

    private DistinctCraftClientEvents() {
    }

    public static void onClientTick(ClientTickEvent.Post event) {
        Minecraft minecraft = Minecraft.getInstance();

        while (DistinctCraftKeyMappings.OPEN_SETTINGS.consumeClick()) {
            minecraft.setScreenAndShow(new DistinctCraftConfigScreen(null));
        }
        while (DistinctCraftKeyMappings.CYCLE_PROFILE.consumeClick()) {
            ProfileManager.applyProfile(ProfileManager.selectedProfile().next(), true);
        }
        while (DistinctCraftKeyMappings.TOGGLE_HIGHLIGHT.consumeClick()) {
            boolean enabled = !DistinctCraftConfig.TARGET_OUTLINE.getAsBoolean();
            DistinctCraftConfig.setTargetOutline(enabled);
            if (minecraft.player != null) {
                minecraft.player.sendOverlayMessage(
                        Component.translatable(enabled
                                ? "message.distinctcraft.highlight_enabled"
                                : "message.distinctcraft.highlight_disabled"));
            }
        }
    }

    public static void onBlockOutline(ExtractBlockOutlineRenderStateEvent event) {
        if (!DistinctCraftConfig.TARGET_OUTLINE.getAsBoolean()) {
            return;
        }

        event.addCustomRenderer((renderState, submitNodeCollector, poseStack, levelRenderState) -> {
            Vec3 cameraPosition = levelRenderState.cameraRenderState.pos;
            BlockPos pos = renderState.pos();
            poseStack.pushPose();
            try {
                poseStack.translate(
                        pos.getX() - cameraPosition.x,
                        pos.getY() - cameraPosition.y,
                        pos.getZ() - cameraPosition.z);
                submitNodeCollector.submitShapeOutline(
                        poseStack,
                        renderState.shape(),
                        RenderTypes.secondaryBlockOutline(),
                        OUTLINE_DARK,
                        5.0F,
                        renderState.isTranslucent());
                submitNodeCollector.submitShapeOutline(
                        poseStack,
                        renderState.shape(),
                        RenderTypes.lines(),
                        OUTLINE_BRIGHT,
                        2.0F,
                        renderState.isTranslucent());
            } finally {
                poseStack.popPose();
            }
            return true;
        });
    }

}
