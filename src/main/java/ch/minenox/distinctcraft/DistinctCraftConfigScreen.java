package ch.minenox.distinctcraft;

import java.util.List;
import net.minecraft.client.gui.components.Button;
import net.minecraft.client.gui.components.CycleButton;
import net.minecraft.client.gui.components.StringWidget;
import net.minecraft.client.gui.components.Tooltip;
import net.minecraft.client.gui.screens.Screen;
import net.minecraft.network.chat.CommonComponents;
import net.minecraft.network.chat.Component;
import org.jspecify.annotations.Nullable;

public final class DistinctCraftConfigScreen extends Screen {
    private final @Nullable Screen parent;
    private AccessibilityProfile profile;
    private boolean targetOutline;

    public DistinctCraftConfigScreen(@Nullable Screen parent) {
        super(Component.translatable("screen.distinctcraft.config.title"));
        this.parent = parent;
        this.profile = ProfileManager.selectedProfile();
        this.targetOutline = DistinctCraftConfig.TARGET_OUTLINE.getAsBoolean();
    }

    @Override
    protected void init() {
        super.init();
        int left = this.width / 2 - 100;
        int y = Math.max(38, this.height / 2 - 74);

        this.addRenderableWidget(new StringWidget(left, y - 28, 200, 20, this.title, this.font));

        CycleButton<AccessibilityProfile> profileButton = CycleButton
                .builder(AccessibilityProfile::displayName, this.profile)
                .withValues(List.of(AccessibilityProfile.values()))
                .withTooltip(profile -> Tooltip.create(profile.description()))
                .create(left, y, 200, 20, Component.translatable("config.distinctcraft.profile"),
                        (button, value) -> this.profile = value);
        this.addRenderableWidget(profileButton);

        CycleButton<Boolean> outlineButton = CycleButton
                .onOffBuilder(this.targetOutline)
                .withTooltip(value -> Tooltip.create(Component.translatable("config.distinctcraft.target_outline.tooltip")))
                .create(left, y + 26, 200, 20, Component.translatable("config.distinctcraft.target_outline"),
                        (button, value) -> this.targetOutline = value);
        this.addRenderableWidget(outlineButton);

        this.addRenderableWidget(Button.builder(CommonComponents.GUI_DONE, button -> this.saveAndClose())
                .bounds(left, y + 62, 98, 20)
                .build());
        this.addRenderableWidget(Button.builder(CommonComponents.GUI_CANCEL, button -> this.onClose())
                .bounds(left + 102, y + 62, 98, 20)
                .build());
    }

    private void saveAndClose() {
        DistinctCraftConfig.setTargetOutline(this.targetOutline);
        if (this.profile != ProfileManager.selectedProfile()) {
            ProfileManager.applyProfile(this.profile, true);
        }
        this.onClose();
    }

    @Override
    public void onClose() {
        this.minecraft.setScreenAndShow(this.parent);
    }
}
