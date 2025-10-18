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

local configs = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
};

local function has_eslint_config(cwd)
    local config_exists = false;

    for _, name in ipairs(configs) do
        local config_path = cwd .. "/" .. name;
        config_exists = vim.fn.filereadable(config_path) == 1;

        if config_exists then
            break;
        end;
    end;

    return config_exists;
end;

local function try_lint()
    local cwd = vim.fn.getcwd();
    local eslint_configured = has_eslint_config(cwd);

    if not eslint_configured then
        return;
    end;

    lint.try_lint(nil, {});
end;

vim.api.nvim_create_autocmd({
    "BufWinEnter",
    "BufWritePost",
    "TextChanged",
}, {
    callback = try_lint,
});

vim.keymap.set("n", "<leader>ll", try_lint, { desc = "Lint" });
