-- autoformat.lua
--
-- Use your language server to automatically format your code on save.
-- Adds additional commands as well to manage the behavior
return {
    "neovim/nvim-lspconfig",
    config = function ()
        -- Switch for controlling whether you want autoformatting.
        --  Use :FormatLspToggle or :FormatNeoToggle to toggle autoformatting on or off
        local lsp_format_is_enabled = false;
        local neoformat_is_enabled = false;

        local function toggle_formatting(formatter)
            if formatter == "lsp" then
                lsp_format_is_enabled = not lsp_format_is_enabled
                print("Setting autoformatting with lsp to: " .. tostring(lsp_format_is_enabled));
            elseif formatter == "neo" then
                neoformat_is_enabled = not neoformat_is_enabled
                print("Setting autoformatting with neoformat to: " .. tostring(neoformat_is_enabled));
            end
            vim.cmd.LspRestart();
        end

        -- Create an augroup that is used for managing our formatting autocmds.
        --      We need one augroup per client to make sure that multiple clients
        --      can attach to the same buffer without interfering with each other.
        local _augroups = {}
        local function get_augroup(client)
            if not _augroups[client.id] then
                local group_name = "lsp-format-" .. client.name
                local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                _augroups[client.id] = id
            end

            return _augroups[client.id];
        end

        vim.api.nvim_create_user_command("FormatLspToggle", function () toggle_formatting("lsp"); end, {})
        vim.api.nvim_create_user_command("FormatNeoToggle", function () toggle_formatting("neo"); end, {})

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
            -- This is where we attach the autoformatting for reasonable clients
            callback = function (args)
                local client_id = args.data.client_id;
                local client = vim.lsp.get_client_by_id(client_id);
                local bufnr = args.buf;

                if not lsp_format_is_enabled and not neoformat_is_enabled then
                    return;
                end

                -- Only attach to clients that support document formatting
                if not client.server_capabilities.documentFormattingProvider then
                    return;
                end

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = get_augroup(client),
                    buffer = bufnr,
                    callback = function ()
                        if lsp_format_is_enabled then
                            vim.cmd.Format();
                        end

                        if neoformat_is_enabled then
                            vim.api.nvim_command("silent! Neoformat prettier");
                        end
                    end,
                })
            end,
        });
    end,
}
