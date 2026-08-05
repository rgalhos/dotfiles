---------------------------------------------------------------
--begin Variables

hl.plugin.load(os.getenv("HOME") .. "/Projects/hyprglass/hyprglass.so")
hl.plugin.load(os.getenv("HOME") .. "/Projects/hypr-dynamic-cursors/dynamic-cursors.so")

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

--end Devices
---------------------------------------------------------------
