return {
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "tpope/vim-sleuth",

    {
        "slint-ui/vim-slint",
        config = function ()
            require("lspconfig").slint_lsp.setup({});
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            { "j-hui/fidget.nvim", opts = {} },

            "folke/neodev.nvim",
        },
    },

    {
        "mfussenegger/nvim-lint",
        dependencies = {
            "rshkarin/mason-nvim-lint",
        },
        config = function ()
            local lint = require("lint");

            lint.linters_by_ft = {
                javascript = { "eslint" },
                javascriptreact = { "eslint" },

                typescript = { "eslint" },
                typescriptreact = { "eslint" },
            };

            vim.api.nvim_create_autocmd({
                "BufWinEnter",
                "BufWritePost",
                -- "TextChangedI", -- IDK about this one yet
            }, {
                callback = function ()
                    lint.try_lint(nil, { ignore_errors = true });
                end,
            });

            vim.keymap.set("n", "<leader>ll", lint.try_lint, { desc = "Lint" });
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            ---@type ibl.config.indent
            indent = {
                char = "▏",
                tab_char = "▏",
                highlight = "IndentBlanklineChar",
            },

            ---@type ibl.config.scope
            scope = {
                char = "▎",
                show_start = true,
                show_end = false,
            },
        },
    },

    { "numToStr/Comment.nvim", opts = {} },

    {
        "sbdchd/neoformat",
        config = function ()
            vim.g.neoformat_try_node_exe = 1;
        end,
    },

    {
        "mbbill/undotree",
        config = function ()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" });
        end,
    },

    {
        "hedyhli/outline.nvim",
        config = function ()
            vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" });

            require("outline").setup({});
        end,
    },
};
