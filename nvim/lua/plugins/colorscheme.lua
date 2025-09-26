vim.pack.add({
    "https://github.com/catppuccin/nvim",
    "https://github.com/rose-pine/neovim",
});

local theme = "rose-pine";

if theme == "catppuccin" then
    local catppuccin = require("catppuccin");

    catppuccin.setup({
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
    });
end;

if theme == "rose-pine" then
    local rose_pine = require("rose-pine");

    rose_pine.setup({
        -- auto, main, moon, or dawn
        variant = "main",
        -- main, moon, or dawn
        dark_variant = "main",
        dim_inactive_windows = true,
        extend_background_behind_borders = true,
        styles = {
            bold = true,
            italic = false,
            transparency = false,
        },
    });
end;

vim.cmd.colorscheme(theme);

vim.api.nvim_set_hl(0, "Normal", { bg = "none" });
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" });
