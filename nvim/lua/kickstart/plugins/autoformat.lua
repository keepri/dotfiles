-- autoformat.lua
--
-- Use your language server to automatically format your code on save.
-- Adds additional commands as well to manage the behavior
return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Switch for controlling whether you want autoformatting.
        --  Use :FormatLspToggle or :FormatNeoToggle to toggle autoformatting on or off
        local lsp_format_is_enabled = false
        local neoformat_is_enabled = false

        vim.api.nvim_create_user_command("FormatLspToggle", function()
            lsp_format_is_enabled = not lsp_format_is_enabled
            print("Setting autoformatting with lsp to: " .. tostring(lsp_format_is_enabled))
        end, {})

        vim.api.nvim_create_user_command("FormatNeoToggle", function()
            neoformat_is_enabled = not neoformat_is_enabled
            print("Setting autoformatting with neoformat to: " .. tostring(neoformat_is_enabled))
        end, {})

        -- Create an augroup that is used for managing our formatting autocmds.
        --      We need one augroup per client to make sure that multiple clients
        --      can attach to the same buffer without interfering with each other.
        local _augroups = {}
        local get_augroup = function(client)
            if not _augroups[client.id] then
                local group_name = "lsp-format-" .. client.name
                local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                _augroups[client.id] = id
            end

            return _augroups[client.id]
        end

        -- Whenever an LSP attaches to a buffer, we will run this function.
        --
        -- See `:help LspAttach` for more information about this autocmd event.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
            -- This is where we attach the autoformatting for reasonable clients
            callback = function(args)
                local client_id = args.data.client_id
                local client = vim.lsp.get_client_by_id(client_id)
                local bufnr = args.buf

                if not lsp_format_is_enabled or not neoformat_is_enabled then
                    return
                end

                -- Only attach to clients that support document formatting
                if not client.server_capabilities.documentFormattingProvider then
                    return
                end

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = get_augroup(client),
                    buffer = bufnr,
                    callback = function()
                        if lsp_format_is_enabled then
                            vim.lsp.buf.format({
                                async = false,
                                filter = function(c)
                                    return c.id == client.id
                                end,
                            })
                        end

                        if neoformat_is_enabled then
                            vim.cmd("silent! Neoformat prettier")
                        end
                    end,
                })
            end,
        })
    end,
}
