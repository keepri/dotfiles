---@type vim.lsp.Config
return {
    cmd = { "typescript-language-server", "--stdio" },

    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },

    root_markers = {
        ".git",
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
        "node_modules",
    },
};
