-- https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M34WQ 0x00000020",
  mode = "3440x1440@144.00101Hz",
  position = "0x0",
  scale = 1,
  bitdepth = 10,
  vrr = 2
})
hl.monitor({
  output = "desc:Dell Inc. DELL P2422HE FVW89M3",
  mode = "preferred",
  position = "-1920x-125",
  scale = 1,
})

hl.monitor({
  output = "desc:Dell Inc. DELL P2422HE 7SSFV34",
  mode = "preferred",
  position = "-1920x-125",
  scale = 1,
})

hl.monitor({
  output = "desc:AU Optronics 0xD9A3",
  mode = "preferred",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

require("config-desktop")
--require("config-laptop")

---------------------------------------------------------------
--begin Consts

MOD           = "SUPER"
terminal      = "kitty"
fileManager   = "nautilus"
menu          = "rofi -combi-modi 'drun,window' -show combi -emoji-mode copy -no-show-match -no-sort -no-persist-history"
gameWorkspace = 9
appW          = "monitor_h*1.389" -- ((monitor_h*0.9)*4.63/3)
appH          = "monitor_h*0.9"

require("hypr-binds")
require("hypr-rules")
require("hypr-plugins")

--end Consts
---------------------------------------------------------------

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal")
  hl.exec_cmd("waybar")
  hl.exec_cmd("swaync")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("swayosd-server")
  hl.exec_cmd("hyprpm reload dynamic-cursors")
  hl.exec_cmd("kdeconnect-cli --refresh")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

---------------------------------------------------------------
--begin Variables

hl.config({
  debug = {
    disable_logs = false,
  },

  general = {
    gaps_in = 2,
    gaps_out = 0,
    border_size = 2,
    col = {
      active_border   = {
        colors = { "rgb(cba6f7)", "rgb(cba6f7)", "rgb(ff6ec7)" },
        angle = 45,
      },
      inactive_border = {
        colors = { "rgba(cba6f74f)", "rgba(cba6f74f)", "rgba(ff6ec74f)" },
        angle = 45,
      },
    },
    layout = "master",
    allow_tearing = true,
  },

  scrolling = {
    direction = "right",
  },

  dwindle = {
    preserve_split = true,
  },

  input = {
    kb_layout    = "br,us",
    kb_variant   = "",
    kb_model     = "",
    -- man xkeyboard-config
    kb_options   = "grp:switch,grp:shift_caps_toggle",
    kb_rules     = "",
    follow_mouse = 2,
    touchpad     = {
      natural_scroll = false,
      scroll_factor  = 0.75,
      -- middle_button_emulation = true,
    },
  },

  gestures = {
    workspace_swipe_distance   = 300,
    workspace_swipe_create_new = false,
    workspace_swipe_forever    = true,
  },

  binds = {
    hide_special_on_workspace_change = true,
  },

  animations = {
    enabled = true,
  },

  decoration = {
    rounding = 0,
    shadow = {
      enabled = false,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
  },

  misc = {
    vrr = 3,
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    on_focus_under_fullscreen = 1,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    middle_click_paste = false,
    render_unfocused_fps = 5,
    animate_manual_resizes = true,
    disable_splash_rendering = true,
    --enable_swallow = true,
    swallow_regex = "^kitty$",
    swallow_exception_regex = "^(wev|.+\\.exe)$",
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

--end Variables
---------------------------------------------------------------

---------------------------------------------------------------
--begin Devices

hl.device({
  -- bluetooth at 3600 dpi
  name = "mm712-hybrid-mouse",
  sensitivity = -1.0,
})

hl.device({
  -- 2.4ghz at 3600 dpi
  name = "cooler-master-cooler-master-mice-dongle-1",
  sensitivity = -1.0,
})

hl.device({
  -- usb at 3600 dpi
  name = "cooler-master-mm712-hybrid-mouse-1",
  sensitivity = -1.0,
})

--end Devices
---------------------------------------------------------------

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
--hl.animation({ leaf = "borderangle", enabled = true, speed = 250, bezier = "linear", loop = true })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "default" })
