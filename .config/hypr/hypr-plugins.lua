---------------------------------------------------------------
--begin Variables

--if not hl.plugin.hyprglass then
--    hl.plugin.load(os.getenv("HOME") .. "/Projects/hyprglass/hyprglass.so")
--end

--if not hl.plugin.dynamic_cursors then
--    hl.plugin.load(os.getenv("HOME") .. "/Projects/hypr-dynamic-cursors/dynamic-cursors.so")
--end

if hl.plugin.dynamic_cursors then
    hl.config({
        plugin = {
            dynamic_cursors = {
                enabled = true,
                mode = "tilt",
                shake = {
                    enabled = false,
                }
            }
        }
    })
end

if hl.plugin.hyprglass then
    local hg = hl.plugin.hyprglass

    hg.config({
        layers = { enabled = 1 },
        tint_color = 0x11111bff,
        default_preset = "glass",
    })

    hg.layer("rofi")
    -- hg.layer("waybar")
    hg.layer("swayosd")
    hg.layer("swaync-notification-window")
    hg.layer("swaync-control-center")

    -- hg.layer("waybar", { preset = "contrasted", mask_threshold = 0.5 })
end

--end Devices
---------------------------------------------------------------
