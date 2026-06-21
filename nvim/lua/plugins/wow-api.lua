vim.pack.add({ "https://github.com/Tyrannican/warcraft-api.nvim" });

require("warcraft-api").setup();

local function enable_wow_api_for_buffer(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
        return;
    end;

    if vim.bo[bufnr].filetype ~= "lua" then
        return;
    end;

    if vim.b[bufnr].warcraft_api_enabled then
        return;
    end;

    local has_lua_ls = vim.lsp.get_clients({ bufnr = bufnr, name = "lua_ls" })[1] ~= nil;
    if not has_lua_ls then
        return;
    end;

    vim.b[bufnr].warcraft_api_enabled = true;
    vim.api.nvim_buf_call(bufnr, function ()
        vim.cmd("WarcraftApi enable");
    end);
end;

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (args)
        vim.schedule(function ()
            enable_wow_api_for_buffer(args.buf);
        end);
    end,
});
