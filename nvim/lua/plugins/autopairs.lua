vim.pack.add({ "https://github.com/windwp/nvim-autopairs" });

local pairs = require("nvim-autopairs");
local is_treesitter_installed = pcall(require, "nvim-treesitter");

pairs.setup({
    check_ts = is_treesitter_installed,
});
