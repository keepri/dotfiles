return {
    -- Git related plugins
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",

    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",

    {
        "slint-ui/vim-slint",
        config = function ()
            require("lspconfig").slint_lsp.setup({});
        end,
    },

    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neodev.nvim",
        },
    },

    {
        "mfussenegger/nvim-lint",
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
                    lint.try_lint();
                end,
            });

            vim.keymap.set("n", "<leader>ll", lint.try_lint, { desc = "Lint" });
        end,
    },

    {
        -- Set lualine as statusline
        "nvim-lualine/lualine.nvim",
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                config = function ()
                    require("nvim-web-devicons").setup({
                        default = true,
                        strict = true,
                    });
                end,
            },
        },
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = true,
                theme = "catppuccin",
                component_separators = "|",
                section_separators = "",
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        -- See `:help ibl`
        main = "ibl",
        opts = {},
    },

    -- 'gc' to comment visual regions/lines
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
};
