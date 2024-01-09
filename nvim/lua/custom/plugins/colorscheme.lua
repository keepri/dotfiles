local theme = "rose-pine"
local function set_colorscheme(colorscheme)
  vim.cmd.colorscheme(colorscheme)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  {
    "catppuccin/nvim",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        term_colors = true,
        show_end_of_buffer = false,
        no_bold = true,
        no_italic = true,
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.25,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = true,
          harpoon = true,
          mason = true,
          which_key = true,
        },
      })

      set_colorscheme(theme)
    end
  },

  {
    "rose-pine/neovim",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main",      -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = true,
        extend_background_behind_borders = true,
        styles = {
          bold = false,
          italic = false,
          transparency = true,
        },
      })

      set_colorscheme(theme)
    end
  }
}
