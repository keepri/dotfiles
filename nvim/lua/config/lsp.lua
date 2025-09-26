vim.diagnostic.config({
    underline = false,
    virtual_text = {
        prefix = "",
        spacing = 2,
    },
    signs = true,
    update_in_insert = false,
    severity_sort = true,
});

local function enable_lsp_completion(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr });

    local client = nil;
    for _, c in ipairs(clients) do
        local cmp_support = c:supports_method("textDocument/completion", bufnr);

        if cmp_support then
            if client then
                vim.print("Found multiple clients with cmp support: " .. c.name);
                goto continue;
            end;

            client = c;
        end;

        ::continue::
    end;

    if not client then
        return nil;
    end;

    if client.name == "htmx" then
        client.server_capabilities.hoverProvider = false;
    end;

    local is_cmp_installed = pcall(require, "cmp");

    vim.lsp.completion.enable(
        not is_cmp_installed,
        client.id,
        bufnr,
        { autotrigger = true }
    );
end;

local function set_buf_keymaps(bufnr)
    local function map(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc;
        end;

        vim.keymap.set(
            "n",
            keys,
            func,
            {
                buffer = bufnr,
                desc = desc,
            }
        );
    end;

    local telescope_builtin = require("telescope.builtin");

    map("gI", function () telescope_builtin.lsp_implementations({ trim_text = true }); end, "[G]oto [I]mplementation");
    -- map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation");
    map(
        "gd",
        function ()
            telescope_builtin.lsp_definitions({
                jump_type = "never",
                fname_width = 30,
                show_line = true,
                trim_text = true,
            });
        end,
        "[G]oto [D]efinition"
    );
    -- map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition");
    map("gr", function () telescope_builtin.lsp_references({ trim_text = true }); end, "[R]eferences");
    -- map("gr", vim.lsp.buf.references, "[R]eferences");
    map("<leader>ds", telescope_builtin.lsp_document_symbols, "[D]ocument [S]ymbols");
    -- map("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols");
    map("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols");
    -- map("<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols");
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame");
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction");
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration");
    map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition");

    map("K", vim.lsp.buf.hover, "Hover Do[K]umentation");
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation");

    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder");
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder");
    map(
        "<leader>wl",
        function ()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()));
        end,
        "[W]orkspace [L]ist Folders"
    );
end;

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (args)
        vim.defer_fn(
            function ()
                enable_lsp_completion(args.buf);
                set_buf_keymaps(args.buf);
            end,
            69
        );
    end,
});
