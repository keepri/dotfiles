---@type vim.lsp.Config
return {
    cmd = { "emmet-language-server", "--stdio" },

    filetypes = {
        "html",
        "css",
        "javascriptreact",
        "typescriptreact",
        "go",
        "rust",
        "php",
        "blade",
    },

    root_markers = {
        ".git",
        "composer.json",
        "package.json",
        "Makefile",
        "node_modules",
    },
};
