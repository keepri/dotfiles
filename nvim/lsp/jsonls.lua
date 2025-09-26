---@type vim.lsp.Config
return {
    filetypes = {
        "json",
        "jsonc",
    },

    root_markers = { ".git" },

    json = {
        -- Schemas https://www.schemastore.org
        schemas = {
            {
                fileMatch = { "package.json" },
                url = "https://json.schemastore.org/package.json",
            },
            {
                fileMatch = { "tsconfig*.json" },
                url = "https://json.schemastore.org/tsconfig.json",
            },
            {
                fileMatch = {
                    ".prettierrc",
                    ".prettierrc.json",
                    "prettier.config.json",
                },
                url = "https://json.schemastore.org/prettierrc.json",
            },
            {
                fileMatch = { ".eslintrc", ".eslintrc.json" },
                url = "https://json.schemastore.org/eslintrc.json",
            },
        },
    },
};
