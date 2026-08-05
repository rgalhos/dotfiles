hl.env("GTK_THEME", "catppuccin-mocha-mauve-standard+default:dark")

hl.on("hyprland.start", function()
  hl.exec_cmd("steam")
end)

hl.bind("SUPER + L", hl.dsp.exec_cmd("ddcutil setvcp 0xD6 0x05"), { locked = true })

hl.window_rule({ match = { class = "^kitty$" }, size = {2250, 580} })
