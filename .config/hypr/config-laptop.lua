hl.env("GTK_THEME", "catppuccin-mocha-mauve-standard+default:dark")

hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock --grace 5"), { locked = true })

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/bin/lidclosed.sh"), { locked = true })

hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd([[hyprctl keyword monitor "e-DP-1, enable" & hyprctl reload]]),
    { locked = true })

hl.window_rule({ match = { class = "^kitty$" }, size = { 1750, 580 } })
