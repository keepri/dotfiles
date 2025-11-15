vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
});

local servers = {
    "gopls",
    "rust_analyzer",
    "emmet_language_server",
    "tailwindcss",
    "jsonls",
    "ts_ls",
    "html",
    "htmx",
    "lua_ls",
    "intelephense",
    "docker_language_server",
    "docker_compose_language_service",
    "clangd",
    -- TODO
    -- "laravel_ls",
};
local mason = require("mason");
local mason_lspconfig = require("mason-lspconfig");

mason.setup({});
mason_lspconfig.setup({
    automatic_enable = true,
    ensure_installed = servers,
});

local is_cmp_lsp_installed, cmp_lsp = pcall(require, "cmp_nvim_lsp");
local capabilities = vim.lsp.protocol.make_client_capabilities();

if is_cmp_lsp_installed then
    capabilities = cmp_lsp.default_capabilities(capabilities);
end;

for _, server in ipairs(servers) do
    vim.lsp.config(server, {
        capabilities = capabilities,
    });
end;
