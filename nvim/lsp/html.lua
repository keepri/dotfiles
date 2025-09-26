---@type vim.lsp.Config
return {
    filetypes = {
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "php",
        "blade",
    },

    init_options = {
        provideFormatter = true,
        configurationSection = {
            "html",
            "css",
            "javascript",
        },
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
    },
};
