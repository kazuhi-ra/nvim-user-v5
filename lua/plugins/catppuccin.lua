---@type LazySpec
return {
  "catppuccin/nvim",
  opts = function(_, opts)
    opts.color_overrides = {
      mocha = {
        base = "#000000",
        mantle = "#101010",
        crust = "#66a6a6",
      },
    }
    opts.dim_inactive = {
      enabled = true
    }
    opts.custom_highlights = function(C)
      return {
        NeoTreeNormal = { bg = C.base },
        CursorLine = {
          bg = "#11225c",
        },
      }
    end

    return opts
  end
}
