vim.g.mapleader = " ";

vim.g.netrw_banner = 0;
vim.g.loaded_netrwPlugin = 1;
vim.g.loaded_netrw = 1;

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim";
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system{
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    };
end;
vim.opt.rtp:prepend(lazypath);

require("lazy").setup({
    require("kickstart.plugins.autoformat"),
    require("kickstart.plugins.debug"),
    { import = "custom.plugins" },
}, {});

vim.o.wrap = false;
vim.o.colorcolumn = "80";
vim.o.autoindent = true;
vim.o.smartindent = true;
vim.o.scrolloff = 11;
vim.o.tabstop = 4;
vim.o.softtabstop = 4;
vim.o.shiftwidth = 4;
vim.o.expandtab = true;
vim.o.number = true;
vim.o.guicursor = "a:block";
vim.o.winborder = "none";

vim.o.hlsearch = true;

vim.wo.relativenumber = true;

vim.o.mouse = "a";

vim.o.breakindent = true;

vim.o.undofile = true;

vim.o.ignorecase = true;
vim.o.smartcase = true;

vim.wo.signcolumn = "yes";

vim.o.updatetime = 300;
vim.o.timeoutlen = 300;

vim.o.completeopt = "menuone,noselect";

vim.o.termguicolors = true;

vim.keymap.set("n", "<leader>kv", ":Neotree reveal<CR>", { desc = "Open Neotree." });
-- vim.keymap.set("n", "<leader>kv", vim.cmd.Ex, { desc = "Open NetRw." });
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up centered." });
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down centered." });
vim.keymap.set("n", "n", "nzzzv", { desc = "Center while selecting next search result." });
vim.keymap.set("n", "N", "Nzzzv", { desc = "Center while selecting previous search result." });
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up one line." });   -- down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down one line." }); -- up
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste and keep copy buffer. This is cool!" });
vim.keymap.set("n", "<leader>%", [[$V%]], { desc = "Select ... block?..." });
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard." });
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard." });
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete n number of lines up or down." });
vim.keymap.set({ "n", "v" }, "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace all ocurrences of word in buffer." });

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true });

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move up" });
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move down" });

vim.keymap.set("n", "[d", function () vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() }); end, { desc = "Go to previous diagnostic message" });
vim.keymap.set("n", "]d", function () vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_next() }); end, { desc = "Go to next diagnostic message" });
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" });
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" });

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true });
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function ()
        vim.hl.on_yank();
    end,
    group = highlight_group,
    pattern = "*",
});

local on_attach = function (client, bufnr)
    local function nmap(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc;
        end;

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc });
    end;

    local function neoformat()
        vim.api.nvim_command("silent! Neoformat prettier");
    end;

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame");
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction");
    nmap("<leader>f", neoformat, "[F]ormat code using Neoformat prettier");
    nmap("<leader>lf", vim.cmd.Format, "[F]ormat code using LSP");

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition");
    nmap("gr", require("telescope.builtin").lsp_references, "[D]ocument [S]ymbols");
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation");
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition");
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols");
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols");

    if client.name == "htmx" then
        client.server_capabilities.hoverProvider = false;
    end;

    if client.name == "ts_ls" then
        nmap("K", vim.lsp.buf.hover, "Hover Do[K]umentation");
    end;

    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation");

    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration");
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder");
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder");
    nmap("<leader>wl", function ()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()));
    end, "[W]orkspace [L]ist Folders");

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function (_)
        vim.lsp.buf.format({ async = false });
    end, { desc = "Format current buffer with LSP" });

    vim.diagnostic.config({
        underline = false,
        virtual_text = {
            prefix = "",
            spacing = 2,
        },
        signs = true,
        update_in_insert = false,
    });
end;

local servers = {
    gopls = {},
    rust_analyzer = {},
    emmet_language_server = {
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
    },
    tailwindcss = {
        filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "css",
            "scss",
            "php",
            "blade",
        },
    },
    jsonls = {
        filetypes = {
            "json",
            "jsonc",
        },
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
    },
    ts_ls = {
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },
    },
    html = {
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
        filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "php",
            "blade",
        },
    },
    htmx = {
        filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "php",
            "blade",
        },
    },
    lua_ls = {
        filetypes = {
            "lua",
        },
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                diagnostics = {
                    globals = { "vim" },
                },
                doc = {
                    privateName = { "^_" },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    intelephense = {
        filetypes = {
            "php",
            "blade",
        },
    },
    -- TODO
    -- laravel_ls = {
    --     filetypes = {
    --         "php",
    --         "blade",
    --     },
    --     settings = {
    --         laravel = {
    --             enable = true,
    --             format = {
    --                 enable = true,
    --             },
    --             completion = {
    --                 enable = true,
    --             },
    --             diagnostics = {
    --                 enable = true,
    --             },
    --         },
    --     },
    -- },
};

local server_names = vim.tbl_keys(servers);

require("mason").setup();
require("mason-lspconfig").setup({
    automatic_enable = false,
    ensure_installed = server_names,
});

require("neodev").setup({
    debug = false,
    library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = {
            "nvim-treesitter",
            "plenary.nvim",
            "telescope.nvim",
        },
    },
    setup_jsonls = true,
    lspconfig = true,
    pathStrict = true,
});

-- Add filetype for blade files.
vim.filetype.add({
    pattern = {
        [".*%.blade%.php"] = "blade",
    },
});
-- Make $ part of the keyword for php.
vim.api.nvim_exec2([[ autocmd FileType php set iskeyword+=$ ]], {});

local blade_group = vim.api.nvim_create_augroup("lsp_blade_workaround", { clear = true });
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.blade.php",
    group = blade_group,
    callback = function ()
        vim.bo.filetype = "blade";
    end,
});

-- Additional autocommand to switch back to 'blade' after LSP has attached
vim.api.nvim_create_autocmd("LspAttach", {
    pattern = "*.blade.php",
    callback = function (args)
        vim.schedule(function ()
            for _, client in ipairs(vim.lsp.get_clients()) do
                if client.name == "intelephense" and client.attached_buffers[args.buf] then
                    vim.api.nvim_buf_set_option(args.buf, "filetype", "blade");
                    vim.api.nvim_buf_set_option(args.buf, "syntax", "blade");
                    break;
                end;
            end;
        end);
    end,
});

local capabilities = vim.lsp.protocol.make_client_capabilities();
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities);

local lspconfig = require("lspconfig");
for _, server_name in pairs(server_names) do
    lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
    });
end;

-- -- continue setting up treesitter for blade file types
-- ---@class ParserConfig
-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs();
-- parser_config.blade = {
--     install_info = {
--         url = "https://github.com/EmranMR/tree-sitter-blade",
--         files = { "src/parser.c" },
--         branch = "main",
--     },
--     filetype = "blade",
-- };

-- local function clear_match()
--   if vim.g.current_word_match_id then
--     pcall(vim.fn.matchdelete, vim.g.current_word_match_id)
--     vim.g.current_word_match_id = nil
--   end
-- end
-- local function highlight_word()
--   clear_match()
--   local word = vim.fn.expand("<cword>")
--   if word ~= "" then
--     local pattern = [[\V\<]] .. word .. [[\>]]
--     vim.g.current_word_match_id = vim.fn.matchadd("Search", pattern)
--   end
-- end
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   callback = highlight_word,
-- })
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   callback = clear_match,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function (args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id);
--         if client and client:supports_method("textDocument/completion") then
--             vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true });
--         end;
--     end,
-- });
