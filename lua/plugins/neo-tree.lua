return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = function(_, config)
		config.sources = { "filesystem", "git_status" }

		config.filesystem.window = {
			mappings = {
				["l"] = "child_or_image_preview_or_open",
			},
		}
		config.filesystem.commands = {
			child_or_image_preview_or_open = function(state)
				local node = state.tree:get_node()
				local absolutePath = node.path
				if node.type == "directory" or node:has_children() then
					if not node:is_expanded() then -- if unexpanded, expand
						state.commands.toggle_node(state)
					else -- if expanded and has children, seleect the next child
						require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
					end
				else -- if not a directory just open it
					local function GetFileExtension(url)
						return url:match("^.+(%..+)$")
					end
					local function IsImage(url)
						local extension = GetFileExtension(url)

						if extension == ".bmp" then
							return true
						elseif extension == ".jpg" or extension == ".jpeg" then
							return true
						elseif extension == ".png" then
							return true
						elseif extension == ".gif" then
							return true
						elseif extension == ".icon" then
							return true
						end

						return false
					end

					if IsImage(absolutePath) then
						-- identify
						local identify_command = "identify " .. absolutePath
						local identify_result = vim.fn.systemlist(identify_command)
						local truncated_result = table.concat(identify_result, " "):gsub(" ", "\\n")

						local command = "silent !wezterm cli split-pane --top --percent 98 -- zsh -c 'wezterm imgcat "
							.. absolutePath
							.. '; echo "\\nImage Info: '
							.. truncated_result
							.. "\"; read'"
						vim.api.nvim_command(command)
					else
						state.commands.open(state)
					end
				end
			end,
		}
		config.filesystem.filtered_items = {
			visible = true,
      hide_dotfiles = false,
      hide_gitignored = true,
		}

		config.git_status = {
			window = {
				position = "float",
				mappings = {
					["A"]  = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
					["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
					["d"] = "show_diff", -- own
				}
			},
			commands = {
				show_diff = function (state)
					-- some variables. use any if you want
					local node = state.tree:get_node()
					local is_file = node.type == "file"
					if not is_file then
						return
					end
					
					vim.api.nvim_command('DiffviewOpen')
				end,
			}
		}

		return config
	end,
}
