vim.pack.add({ "https://github.com/lukas-reineke/indent-blankline.nvim" });

local indent = require("ibl");

indent.setup({
    indent = {
        char = "▏",
        tab_char = "▏",
    },

    scope = {
        char = "▎",
        show_start = true,
        show_end = false,
    },
});
