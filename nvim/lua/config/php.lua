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
