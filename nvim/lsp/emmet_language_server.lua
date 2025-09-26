---@type vim.lsp.Config
return {
    cmd = { "emmet-language-server", "--stdio" },

    filetypes = {
        "html",
        "css",
        "scss",
        "javascriptreact",
        "typescriptreact",
        "go",
        "rust",
        "php",
        "blade",
    },

    root_markers = { ".git" },
};
