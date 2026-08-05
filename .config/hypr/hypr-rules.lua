---------------------------------------------------------------
--begin Window Rules

hl.layer_rule({ match = { namespace = "^rofi$" }, blur = true, xray = true, no_screen_share = true })

hl.window_rule({ match = { class = "^.*$", xwayland = false }, center = true })
hl.window_rule({ match = { class = "^.*$" }, persistent_size = true })

hl.window_rule({ match = { class = "^vlc$" }, float = true })

hl.window_rule({ match = { class = "^kitty$" }, float = true })

hl.window_rule({
    match = { class = "^org\\.gnome\\.SystemMonitor$" },
    float = true,
    size = { 1165, 870 },
})

hl.window_rule({
    match = { class = "^org\\.gnome\\.Nautilus$" },
    float = true,
    size = { 1310, 960 },
    opacity = "0.92",
    xray = true,
})

hl.window_rule({
    match = { class = "^org\\.gnome\\.FileRoller$" },
    float = true,
    size = { 1165, 870 },
})

hl.window_rule({
    match = { class = "^org\\.pulseaudio\\.pavucontrol$" },
    float = true,
    size = { 750, 900 },
})

hl.window_rule({
    match = { class = "^org\\.kde\\.bluedevilwizard$" },
    float = true,
    size = { 450, 500 },
})

hl.window_rule({
    match = { class = "^blueman-manager$" },
    float = true,
    size = { 530, 550 },
})

hl.window_rule({
    match = { title = "^Picture[- ]in[- ]Picture$" },
    float = true,
    pin = true,
    no_initial_focus = true,
    border_size = 0,
    no_blur = true,
    move = { "monitor_w-window_w", "monitor_h-window_h" },
})

hl.window_rule({
    match = { class = "^virt-manager$" },
    float = true,
    size = { 1000, 700 },
})

hl.window_rule({
    match = { class = "^org\\.nomacs\\.ImageLounge$" },
    float = true,
    size = { 1000, 1000 },
})

hl.window_rule({
    match = { class = "^[Xx]dg-desktop-portal-gtk$" },
    float = true,
    size = { 950, 750 },
    no_shadow = true,
    no_blur = true,
    border_size = 0,
})

hl.window_rule({
    match = { class = "^FFPWA-01KJYX9FQT62HTN1VWBRW8P81H$" },
    workspace = "special:1whatsapp silent",
    border_color = "rgb(25d366)",
    float = true,
    no_screen_share = true,
    size = { appW, appH },
})

hl.window_rule({
    match = { class = "^vesktop$" },
    workspace = "special:2discord silent",
    border_color = "rgb(5865f2)",
    float = true,
    size = { appW, appH },
})

hl.window_rule({
    match = { class = "^[Ss]potify$" },
    workspace = "special:3spotify silent",
    border_color = "rgb(1db954)",
    float = true,
    size = { appW, appH },
})

hl.window_rule({
    match = { class = "^looking-glass-client$" },
    workspace = "5 silent",
    idle_inhibit = "always",
    fullscreen = true,
})

--end Window Rules
---------------------------------------------------------------

---------------------------------------------------------------
--begin Rules for steam games

hl.window_rule({ match = { xdg_tag = "^proton-game$" }, content = "game" })
hl.window_rule({ match = { class = "^steam_app_.*$" }, content = "game" })
hl.window_rule({ match = { class = "^gamescope$" }, content = "game" })
hl.window_rule({ match = { class = "^tf_linux64$" }, content = "game" })
hl.window_rule({ match = { class = "^cs2$" }, content = "game" })

hl.window_rule({
    match = { class = "^(steam_app_.*|gamescope|tf_linux64|cs2)$" },
    workspace = gameWorkspace .. " silent",
    suppress_event = "maximize",
    idle_inhibit = "focus",
    immediate = true,
})
hl.window_rule({
    match = { xdg_tag = "^proton-game$" },
    workspace = gameWorkspace .. " silent",
    suppress_event = "maximize",
    idle_inhibit = "focus",
    immediate = true,
})

hl.window_rule({ match = { class = "^steam$" }, float = true, border_color = "rgb(66c0f4)" })
hl.window_rule({ match = { class = "^steam$", title = "^([Ss]team)$" }, size = { appW, appH }, workspace = "8 silent" })
hl.window_rule({ match = { class = "^steam$", title = "^Sign in to Steam$" }, workspace = "8 silent" })
hl.window_rule({ match = { class = "^steam$", title = "^Launching.+$" }, workspace = "8 silent" })
hl.window_rule({ match = { class = "^steam$", title = "^Special Offers.+$" }, workspace = "8 silent" })
hl.window_rule({ match = { class = "^steam$", title = "^Friends List$" }, workspace = "8 silent" })
hl.window_rule({ match = { class = "^$", title = "^Steam$" }, workspace = "8 silent" })

--end Rules for steam games
---------------------------------------------------------------

---------------------------------------------------------------
--begin Rules for workspaces

hl.workspace_rule({
    workspace = "special:3spotify",
    on_created_empty = "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland",
})

--end Rules for workspaces
---------------------------------------------------------------
