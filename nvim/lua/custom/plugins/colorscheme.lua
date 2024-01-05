return {
  {
    'catppuccin/nvim',
    priority = 1000,
    name = 'catppuccin',
    config = function()
      vim.cmd.colorscheme 'catppuccin'
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

      require('catppuccin').setup {
        flavour = 'mocha',
        transparent_background = true,
        term_colors = true,
        show_end_of_buffer = false,
        no_bold = true,
        no_italic = true,
        dim_inactive = {
          enabled = true,
          shade = 'dark',
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
      }
    end
  }
}
