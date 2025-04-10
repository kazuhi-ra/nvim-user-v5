---@type LazySpec
return {
	"okuuva/auto-save.nvim",
	event = { "User AstroFile", "InsertEnter" },
	opts = {
		trigger_events = {
			immediate_save = { "BufLeave", "FocusLost" },
			defer_save = {},
		},
	},
}
