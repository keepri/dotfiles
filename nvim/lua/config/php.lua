vim.filetype.add({
    pattern = {
        [".*%.blade%.php"] = "blade",
    },
});

-- Make $ part of the keyword for php.
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "php",
        "blade",
    },
    callback = function ()
        vim.opt_local.iskeyword:append("$");
    end,
});

vim.api.nvim_create_autocmd("LspAttach", {
    pattern = "*.blade.php",
    callback = function (args)
        vim.schedule(function ()
            for _, client in ipairs(vim.lsp.get_clients()) do
                local is_intelephense = client.name == "intelephense";
                local is_client_attached = client.attached_buffers[args.buf] ~= nil;

                if is_intelephense and is_client_attached then
                    vim.api.nvim_set_option_value("syntax", "blade", { buf = args.buf });
                    break;
                end;
            end;
        end);
    end,
});
