vim.pack.add({ "https://github.com/sbdchd/neoformat" });

vim.g.neoformat_try_node_exe = 1;

-- Switch for controlling whether you want autoformatting.
--  Use :FormatLspToggle or :FormatNeoToggle to toggle autoformatting on or off
local lsp_format_is_enabled = false;
local neoformat_is_enabled = false;

local function toggle_formatting(formatter)
    if formatter == "lsp" then
        lsp_format_is_enabled = not lsp_format_is_enabled;
        print("Setting autoformatting with lsp to: " .. tostring(lsp_format_is_enabled));
    elseif formatter == "neo" then
        neoformat_is_enabled = not neoformat_is_enabled;
        print("Setting autoformatting with neoformat to: " .. tostring(neoformat_is_enabled));
    end;
    vim.cmd.LspRestart();
end;

local function lsp_format()
    vim.lsp.buf.format({ async = false });
    vim.print("Formatted with LSP");
end;

local function neoformat()
    vim.cmd("Neoformat prettier");
    vim.print("Formatted with Neoformat prettier");
end;

local function format()
    local ok, _ = pcall(neoformat);

    if not ok then
        ok = pcall(lsp_format);
    end;

    if not ok then
        vim.print("No formatter available");
    end;
end;

local _augroups = {};
local function get_augroup(client)
    if not _augroups[client.id] then
        local group_name = "lsp-format-" .. client.name;
        local id = vim.api.nvim_create_augroup(group_name, { clear = true });
        _augroups[client.id] = id;
    end;

    return _augroups[client.id];
end;

vim.api.nvim_create_user_command(
    "FormatLspToggle",
    function ()
        toggle_formatting("lsp");
    end,
    {}
);

vim.api.nvim_create_user_command(
    "FormatNeoToggle",
    function ()
        toggle_formatting("neo");
    end,
    {}
);

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
    callback = function (args)
        local client_id = args.data.client_id;
        local client = vim.lsp.get_client_by_id(client_id);
        local bufnr = args.buf;

        vim.keymap.set("n", "<leader>f", format, {
            buffer = bufnr,
            desc = "[F]ormat code using Neoformat or LSP",
        });

        vim.keymap.set("n", "<leader>lf", lsp_format, {
            buffer = bufnr,
            desc = "[F]ormat code using LSP",
        });

        if
            (not lsp_format_is_enabled and not neoformat_is_enabled)
            or not client
            or not client.server_capabilities.documentFormattingProvider
        then
            return;
        end;

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function ()
                if lsp_format_is_enabled then
                    lsp_format();
                end;

                if neoformat_is_enabled then
                    neoformat();
                end;
            end,
        });
    end,

});
