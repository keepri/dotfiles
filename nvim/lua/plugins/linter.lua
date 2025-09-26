vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" });

local is_mason_installed = pcall(require, "mason");
local lint = require("lint");

if is_mason_installed then
    vim.pack.add({ "https://github.com/rshkarin/mason-nvim-lint" });

    local mason_nvim_lint = require("mason-nvim-lint");

    mason_nvim_lint.setup({
        -- ensure_installed = { "eslint" },
        -- automatic_installation = true,
    });
end;

lint.linters_by_ft = {
    -- javascript = { "eslint" },
    -- javascriptreact = { "eslint" },

    -- typescript = { "eslint" },
    -- typescriptreact = { "eslint" },
};

vim.api.nvim_create_autocmd({
    "BufWinEnter",
    "BufWritePost",
    -- "TextChangedI", -- IDK about this one yet
}, {
    callback = function ()
        lint.try_lint(nil, {
            -- ignore_errors = true,
        });
    end,
});

vim.keymap.set("n", "<leader>ll", lint.try_lint, { desc = "Lint" });
