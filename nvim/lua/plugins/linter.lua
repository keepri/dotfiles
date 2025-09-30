vim.pack.add({
    "https://github.com/mfussenegger/nvim-lint",
    "https://github.com/rshkarin/mason-nvim-lint",
});

vim.diagnostic.config({
    underline = false,
    -- virtual_lines = true,
    virtual_text = {
        prefix = "",
        spacing = 2,
    },
    signs = true,
    update_in_insert = false,
    severity_sort = true,
});

local is_mason_installed = pcall(require, "mason");
local lint = require("lint");

if is_mason_installed then
    local mason_nvim_lint = require("mason-nvim-lint");

    mason_nvim_lint.setup({
        ensure_installed = {
            "eslint_d",
        },
        automatic_installation = true,
    });
end;

lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
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
