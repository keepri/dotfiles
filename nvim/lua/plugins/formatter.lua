vim.pack.add({ "https://github.com/stevearc/conform.nvim" });

local conform = require("conform");
local is_auto_format = false;

conform.setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" },
        php = { "pint" },
        blade = { "pint" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    -- format_on_save = {
    --     lsp_format = "fallback",
    --     timeout_ms = 500,
    -- },
    format_after_save = function ()
        if not is_auto_format then
            return nil;
        end;

        return { lsp_format = "fallback" };
    end,
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    notify_no_formatters = true,
});


local function toggle_auto_format()
    is_auto_format = not is_auto_format;
    print("Setting autoformatting to: " .. tostring(is_auto_format));
end;

vim.api.nvim_create_user_command("FormatOnSave", toggle_auto_format, {});

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
    callback = function (args)
        local bufnr = args.buf;

        local function format()
            conform.format({ async = false });
        end;

        vim.keymap.set("n", "<leader>f", format, {
            buffer = bufnr,
            desc = "[F]ormat code",
        });

        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {
            buffer = bufnr,
            desc = "[F]ormat code with [L]SP",
        });
    end,
});
