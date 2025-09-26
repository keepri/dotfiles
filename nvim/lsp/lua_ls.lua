---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },

    filetypes = { "lua" },

    root_markers = {
        { ".luarc.json", ".luarc.jsonc" },
        ".git",
    },

    -- Specific settings to send to the server. The schema for this is
    -- defined by the server. For example the schema for lua-language-server
    -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
    -- settings = {
    --     Lua = {
    --         runtime = {
    --             version = "LuaJIT",
    --         },
    --         workspace = {
    --             library = vim.api.nvim_get_runtime_file("", true),
    --             checkThirdParty = false,
    --         },
    --         diagnostics = {
    --             globals = { "vim" },
    --         },
    --         doc = {
    --             privateName = { "^_" },
    --         },
    --         telemetry = {
    --             enable = false,
    --         },
    --     },
    -- },
};
