---@type LazySpec
return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },

	opts = function()
		local actions = require("telescope.actions")
		local get_icon = require("astroui").get_icon
		return {
			defaults = {
				git_worktrees = vim.g.git_worktrees,
				prompt_prefix = string.format("%s ", get_icon("Search")),
				selection_caret = string.format("%s ", get_icon("Selected")),
				path_display = { "truncate" },
				sorting_strategy = "ascending",
				file_ignore_patterns = {
					".git",
					"node_modules",
					"build",
					"dist",
					"package-lock.json",
					"yarn.lock",
					"log",
				},
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.60,
					},
					vertical = {
						mirror = false,
					},
					width = { padding = 4 },
					height = 0.94,
					preview_cutoff = 120,
				},

				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
					n = { ["q"] = actions.close },
				},
			},
		}
	end,
}
