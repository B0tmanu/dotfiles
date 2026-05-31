local mocha = require("themes.mocha").colors
-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 2,

		col = {
			active_border = {
				colors = { mocha.maroon, mocha.green, },
				angle = 45
			},
			inactive_border = mocha.base,
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = true,

	},

	decoration = {
		rounding = 15,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 20,
			passes = 3,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})



-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
--hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
--hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
--hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
--hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- 1. POISTA tai kommentoi pois aiemmat hl.workspace_rule -riviti,
-- jotta järjestelmän globaalit oletusraot (gaps) pysyvät päällä kaikilla ikkunoilla.

-- 2. Poistetaan raot (margin), reunat ja pyöristys VAIN LibreWolfilta näissä työtiloissa
-- (Käytetään negatiivista marginia -15 korvaamaan puuttuva gaps_out-sääntö, säädä lukua tarvittaessa)
