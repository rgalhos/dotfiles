local workspace = hl.dsp.workspace
local window = hl.dsp.window
local exec = hl.dsp.exec_cmd

local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

local function runOnce(program)
    return "pgrep " .. program .. " || uwsm app -- " .. program
end

local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

function closeSpecial()
    local current = hl.get_active_special_workspace()
    if current ~= nil then
        local name = current.name:sub(("special:"):len() + 1)
        hl.dispatch(workspace.toggle_special(name))
    end
end

---------------------------------------------------------------
--begin Binds

hl.bind(MOD .. " + CTRL + Escape", closeSpecial)
hl.bind(MOD .. " + CTRL + 1", workspace.toggle_special("1whatsapp"))
hl.bind(MOD .. " + CTRL + 2", workspace.toggle_special("2discord"))
hl.bind(MOD .. " + CTRL + 3", workspace.toggle_special("3spotify"))

-- Misc binds
hl.bind("CONTROL + ALT + T", exec(terminal))
hl.bind("ALT + F4", window.close())
hl.bind(MOD .. " + M", hl.dsp.exit())
hl.bind(MOD .. " + T", exec(fileManager))
hl.bind(MOD .. " + F", window.float())
hl.bind(MOD .. " + C", window.center())
hl.bind(MOD .. " + P", window.pin())
hl.bind("ALT + space", exec(menu))
hl.bind(MOD .. " + V", exec("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(MOD .. " + Page_Up", window.fullscreen({ mode = "maximized" }))
hl.bind(MOD .. " + F11", window.fullscreen_state({ internal = 3, client = 3 }))

hl.bind(MOD .. " + left", function()
    hl.dispatch(hl.dsp.focus({ direction = "l" }))
    hl.dispatch(window.bring_to_top())
end)
hl.bind(MOD .. " + right", function()
    hl.dispatch(hl.dsp.focus({ direction = "r" }))
    hl.dispatch(window.bring_to_top())
end)
hl.bind(MOD .. " + up", function()
    hl.dispatch(window.cycle_next({ next = false }))
    hl.dispatch(window.bring_to_top())
end)
hl.bind(MOD .. " + down", function()
    hl.dispatch(window.cycle_next())
    hl.dispatch(window.bring_to_top())
end)

hl.bind(MOD .. " + ALT + left", window.swap({ direction = "l" }))
hl.bind(MOD .. " + ALT + left", window.move({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + ALT + right", window.swap({ direction = "r" }))
hl.bind(MOD .. " + ALT + right", window.move({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + ALT + up", window.swap({ direction = "u" }))
hl.bind(MOD .. " + ALT + up", window.move({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind(MOD .. " + ALT + down", window.swap({ direction = "d" }))
hl.bind(MOD .. " + ALT + down", window.move({ x = 0, y = 100, relative = true }), { repeating = true })

hl.bind(MOD .. " + CTRL + right", window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + CTRL + left", window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + CTRL + up", window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(MOD .. " + CTRL + down", window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- Switch workspaces with MOD + [0-9]
hl.bind(MOD .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(MOD .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(MOD .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(MOD .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(MOD .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(MOD .. " + Q", hl.dsp.focus({ workspace = 6 }))
hl.bind(MOD .. " + W", hl.dsp.focus({ workspace = 7 }))
hl.bind(MOD .. " + E", hl.dsp.focus({ workspace = 8 }))
hl.bind(MOD .. " + R", hl.dsp.focus({ workspace = 9 }))
hl.bind(MOD .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with MOD + SHIFT + [0-9]
hl.bind(MOD .. " + SHIFT + 1", window.move({ workspace = 1, follow = true }))
hl.bind(MOD .. " + SHIFT + 2", window.move({ workspace = 2, follow = true }))
hl.bind(MOD .. " + SHIFT + 3", window.move({ workspace = 3, follow = true }))
hl.bind(MOD .. " + SHIFT + 4", window.move({ workspace = 4, follow = true }))
hl.bind(MOD .. " + SHIFT + 5", window.move({ workspace = 5, follow = true }))
hl.bind(MOD .. " + SHIFT + Q", window.move({ workspace = 6, follow = true }))
hl.bind(MOD .. " + SHIFT + W", window.move({ workspace = 7, follow = true }))
hl.bind(MOD .. " + SHIFT + E", window.move({ workspace = 8, follow = true }))
hl.bind(MOD .. " + SHIFT + R", window.move({ workspace = 9, follow = true }))
hl.bind(MOD .. " + SHIFT + 0", window.move({ workspace = 10, follow = true }))
hl.bind(MOD .. " + CTRL + SHIFT + 1", window.move({ workspace = 1, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + 2", window.move({ workspace = 2, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + 3", window.move({ workspace = 3, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + 4", window.move({ workspace = 4, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + 5", window.move({ workspace = 5, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + Q", window.move({ workspace = 6, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + W", window.move({ workspace = 7, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + E", window.move({ workspace = 8, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + R", window.move({ workspace = 9, follow = false }))
hl.bind(MOD .. " + CTRL + SHIFT + 0", window.move({ workspace = 10, follow = false }))
hl.bind(MOD .. " + ALT + TAB", workspace.move({ monitor = "+1" }))

-- Scratchpad workspaces
hl.bind(MOD .. " + A", workspace.toggle_special("magicA"))
hl.bind(MOD .. " + SHIFT + A", window.move({ workspace = "special:magicA", follow = true }))
hl.bind(MOD .. " + S", workspace.toggle_special("magicS"))
hl.bind(MOD .. " + SHIFT + S", window.move({ workspace = "special:magicS", follow = true }))
hl.bind(MOD .. " + D", workspace.toggle_special("magicD"))
hl.bind(MOD .. " + SHIFT + D", window.move({ workspace = "special:magicD", follow = true }))

-- Scroll through existing workspaces
hl.bind(MOD .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MOD .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(MOD .. " + ALT + Q", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(MOD .. " + ALT + E", hl.dsp.focus({ workspace = "e+1" }))

-- Move/resize windows with MOD + LMB/RMB and dragging
hl.bind(MOD .. " + mouse:272", window.drag(), { mouse = true })
hl.bind(MOD .. " + mouse:273", window.resize(), { mouse = true })
hl.bind("mouse:275", window.drag(), { mouse = true })
hl.bind("mouse:276", window.resize(), { mouse = true })

-- Zoom
hl.bind(MOD .. " + EQUAL", function() zoom(0.25) end, { repeating = true })
hl.bind(MOD .. " + MINUS", function() zoom(-0.25) end, { repeating = true })

-- Monitor control
hl.bind(MOD .. " + KP_Multiply", exec("ddcutil setvcp 0x60 0x11"), { locked = true })                -- HDMI-1
hl.bind(MOD .. " + KP_Subtract", exec("ddcutil setvcp 0x60 0x0f"), { locked = true })                -- DP-1
hl.bind(MOD .. " + KP_Add", exec("ddcutil setvcp 0x60 0x10"), { locked = true })                     -- USB-C / KVM
hl.bind(MOD .. " + CTRL + KP_Enter", exec("sleep 1 && hyprctl dispatch dpms on"), { locked = true }) -- Force the monitor to turn on because M34WQ built-in KVM is weird

hl.bind(MOD .. " + KP_Home", function()
    hl.dispatch(exec("hyprctl hyprsunset temperature -500"))
    hl.dispatch(exec(
        [[swayosd-client --custom-icon weather-clear-night --custom-message "$(hyprctl hyprsunset temperature)K"]]))
end, { locked = true })
hl.bind(MOD .. " + KP_Up", exec("hyprctl hyprsunset identity"), { locked = true })
hl.bind(MOD .. " + KP_Prior", function()
    hl.dispatch(exec("hyprctl hyprsunset temperature +500"))
    hl.dispatch(exec(
        [[swayosd-client --custom-icon weather-clear-night --custom-message "$(hyprctl hyprsunset temperature)K"]]))
end, { locked = true })
hl.bind(MOD .. " + KP_Left", exec("hyprshade on eink"), { locked = true })
hl.bind(MOD .. " + KP_Right", exec("hyprshade off"), { locked = true })

-- Changing volume and unmuting audio plays a sound (ocean sound pack comes with plasma 6);
hl.bind(MOD .. " + XF86AudioRaiseVolume", function()
    hl.dispatch(exec("wpctl set-mute @DEFAULT_SINK@ 0"))
    hl.dispatch(exec("wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+"))
    hl.dispatch(exec("swayosd-client --output-volume +0"))
    hl.dispatch(exec("pw-cat --volume 0.6 -p /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
end, { locked = true, repeating = true })

hl.bind("CTRL + XF86AudioRaiseVolume", exec("playerctl -p spotify volume .05+"),
    { locked = true, repeating = true })
hl.bind("CTRL + XF86AudioLowerVolume", exec("playerctl -p spotify volume .05-"),
    { locked = true, repeating = true })

hl.bind("XF86AudioRaiseVolume", function()
    hl.dispatch(exec("wpctl set-mute @DEFAULT_SINK@ 0"))
    hl.dispatch(exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"))
    hl.dispatch(exec("swayosd-client --output-volume +0"))
    hl.dispatch(exec("pw-cat --volume 0.6 -p /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
end, { locked = true, repeating = true })

hl.bind("XF86AudioLowerVolume", function()
    hl.dispatch(exec("wpctl set-mute @DEFAULT_SINK@ 0"))
    -- hl.dispatch(exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
    hl.dispatch(exec("swayosd-client --output-volume -5"))
    hl.dispatch(exec("pw-cat --volume 0.6 -p /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
end, { locked = true, repeating = true })

-- hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMute", function()
    hl.dispatch(exec("swayosd-client --output-volume mute-toggle"))
    hl.dispatch(exec("pw-cat --volume 0.6 -p /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
end, { locked = true })

hl.bind(MOD .. " + CTRL + apostrophe", exec("swayosd-client --playerctl=play-pause --player spotify"),
    { locked = true })
hl.bind(MOD .. " + apostrophe", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

hl.bind("XF86AudioMicMute", function()
    hl.dispatch(exec("wpctl set-mute @DEFAULT_SOURCE@ toggle"))
    hl.dispatch(exec("swayosd-client --input-volume +0"))
end, { locked = true })

hl.bind(MOD .. " + period", function()
    hl.dispatch(exec("wpctl set-mute @DEFAULT_SOURCE@ toggle"))
    hl.dispatch(exec("swayosd-client --input-volume +0"))
end, { locked = true })

-- PrtSc lets you select a region, SHIFT+PrtSc prints the active window, MOD+PrtSc prints the whole screeen
hl.bind("Print", exec([[
    grim -g "$(slurp -d)" - | tee "/tmp/print_$(date +%%s).png" | wl-copy
]]))

hl.bind("SHIFT + Print",
    function()
        local x, y, w, h
        x, y = hl.get_active_window().at.x, hl.get_active_window().at.y
        w, h = hl.get_active_window().size.x, hl.get_active_window().size.y
        local pos = ("%d,%d %dx%d"):format(x, y, w, h)
        hl.dispatch(exec(([[
            grim -g "%s" - | tee "/tmp/print_$(date +%%s).png" | wl-copy
        ]]):format(pos)))
    end)

hl.bind(MOD .. " + Print", exec([[grim - | tee "/tmp/print_$(date +%s).png" | wl-copy]]))

-- Global binds
hl.bind("XF86Calculator", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "M", window = "class:^vesktop$" }))
hl.bind("SHIFT + ALT + S",
    hl.dsp.send_shortcut({ mods = "SHIFT + ALT", key = "S", window = "class:^com.obsproject.Studio$" }))

--end Binds
---------------------------------------------------------------