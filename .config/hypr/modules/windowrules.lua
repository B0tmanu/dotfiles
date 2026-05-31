--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
  name = "discord",
  match = {
    class = "discord"
  },
   workspace = "6 silent",
})

hl.window_rule({
  name = "steam",
  match = {
    class = "steam"
  },
   float = true,
})

hl.window_rule({
  name = "localsend",
  match = {
    class = "localsend"
  },
   float = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

hl.layer_rule({
	name = "notification-animations",
	match = { namespace = "swaync-control-center" },
	animation = "slide top"

})

hl.layer_rule({
	name = "rofi-animations",
	match = { namespace = "rofi" },
	animation = "popin"

})

hl.window_rule({
    name = "steam-apps-ws3",
    match = {
        class = "^steam_app_.*$",
    },
	workspace = "special:magic"
})

hl.window_rule({
    name = "gamescope-ws3",
    match = {
        class = "^gamescope$",
    },
	workspace = "special:magic"
})

hl.window_rule({
    name = "alacritty",
    match = {
        class = "Alacritty",
    },
	float = true,
	size = {230, 560},
})

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", default = true, persistent = true })
