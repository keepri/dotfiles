vim.pack.add{ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } };

local ts = require("nvim-treesitter");
local parsers = {
    "bash",
    "blade",
    "c",
    "cpp",
    "diff",
    "html",
    "go",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "make",
    "printf",
    "python",
    "query",
    "regex",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "php",
    "php_only",
    "phpdoc",
};

ts.install(parsers);

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return; end;
    vim.treesitter.start(buf, language);

    -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()";
    -- vim.wo.foldmethod = "expr";

    local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil;
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"; end;
end;

local available_parsers = ts.get_available();
vim.api.nvim_create_autocmd("FileType", {
    callback = function (args)
        local buf, filetype = args.buf, args.match;

        local language = vim.treesitter.language.get_lang(filetype);
        if not language then return; end;

        local installed_parsers = ts.get_installed("parsers");

        if vim.tbl_contains(installed_parsers, language) then
            -- Enable the parser if it is already installed
            treesitter_try_attach(buf, language);
        elseif vim.tbl_contains(available_parsers, language) then
            -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
            ts.install(language):await(function () treesitter_try_attach(buf, language); end);
        else
            -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language);
        end;
    end,
});

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function ()
        vim.cmd("TSUpdate");
    end,
});
