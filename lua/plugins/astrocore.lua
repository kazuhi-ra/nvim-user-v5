-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true,                              -- enable autopairs at start
      cmp = true,                                    -- enable completion at start
      diagnostics_mode = 3,                          -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true,                           -- highlight URLs at start
      notifications = true,                          -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = {              -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true,     -- sets vim.opt.number
        spell = false,     -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false,      -- sets vim.opt.wrap
        foldcolumn = "0",
        laststatus = 0,
        fillchars = { eob = " ", diff = "▓" },
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        ["<leader>b"] = { name = "Buffers" },

        -- https://twitter.com/thinca/status/1200791599510245376
        ["p"] = "]p",
        ["P"] = "]P",

        ["|"] = {
          function()
            vim.cmd.vsplit()
            require("smart-splits").move_cursor_left()
            require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
            require("smart-splits").move_cursor_right()
          end,
          desc = "Vertical Split",
        },

        -- 12行だけスクロール
        ["<C-d>"] = "5<C-e>",
        ["<C-u>"] = "5<C-y>",

        -- 矢印キーをよく使うやつに割り当て
        ["<Up>"] = {
          function()
            local astro = require("astrocore")
            local worktree = astro.file_worktree()
            local flags = worktree
                and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir)
                or ""
            astro.toggle_term_cmd({ cmd = "lazygit " .. flags, direction = "float" })
          end,
          desc = "ToggleTerm lazygit",
        },

        -- ref: https://github.com/nvim-telescope/telescope.nvim/issues/605
        ["<Down>"] = {
          function()
            local opts = {}
            opts.previewer = require("telescope.previewers").new_termopen_previewer({
              get_command = function(entry)
                return {
                  "git",
                  "-c",
                  "core.pager=delta",
                  "-c",
                  "delta.side-by-side=true",
                  "show",
                  entry.value .. "^!",
                  "--",
                  entry.current_file,
                }
              end,
            })
            require("telescope.builtin").git_bcommits(opts)
          end,
          desc = "Git commits (current file)",
        },
        ["<Left>"] = {
          function()
            require("telescope.builtin").find_files({ hidden = true })
          end,
        },
        ["<Right>"] = {
          function()
            require("telescope.builtin").live_grep({
              additional_args = function()
                return { "--hidden" }
              end,
            })
          end,
          desc = "Find words in all files",
        },

        ["<S-Up>"] = {
          function()
            require("astrocore").toggle_term_cmd("lazydocker")
          end,
          desc = "ToggleTerm lazydocker",
        },

        ["<S-Down>"] = {
          function()
            require("gitsigns").blame_line({ full = true })
          end,
          desc = "View full Git blame",
        },

        -- 行頭・行末移動
        -- https://twitter.com/yuki_ycino/status/1336527468434317317
        ["<S-h>"] = {
          "(getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^')",
          expr = true,
          remap = false,
          desc = "Next buffer",
        },
        ["<S-l>"] = "$",

        ["<Tab>"] = {
          function()
            require("astrocore.buffer").nav(vim.v.count1)
          end,
          desc = "Next buffer",
        },
        ["<S-Tab>"] = {
          function()
            require("astrocore.buffer").nav(-vim.v.count1)
          end,
          desc = "Previous buffer",
        },
        ["<C-w>"] = {
          -- tab2以降にいるときはtabを閉じる
          function()
            local current_tab = vim.fn.tabpagenr()
            if current_tab == 1 then
              require("astrocore.buffer").close()
            else
              vim.cmd("tabclose")
            end
          end,
          desc = "Close buffer or tab",
        },
      },
      i = {
        ["<C-b>"] = "<Left>",
        ["<C-f>"] = "<Right>",
        ["<C-p>"] = "<Up>",
        ["<C-n>"] = "<Down>",
      },
      t = {
        ["<C-h>"] = "<C-h>",
        ["<C-c>"] = "<C-c>",
        ["<C-l>"] = "<C-l>",
      },
    },
  },
}
