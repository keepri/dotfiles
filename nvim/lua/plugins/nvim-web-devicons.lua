vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" });

local icons = require("nvim-web-devicons");

icons.setup({
    default = true,
    strict = true,
    color_icons = true,
    variant = "dark",
});
