return {
    "nvim-treesitter/nvim-treesitter",

    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },

    build = ":TSUpdate",
    event = { "VeryLazy" },
    -- load treesitter early when opening a file from the cmdline
    lazy = vim.fn.argc(-1) == 0,
    init = function (plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treesitter** module to be loaded in time.
        -- Luckily, the only things that those plugins need are the custom queries, which we make available
        -- during startup.
        require("lazy.core.loader").add_to_rtp(plugin);
        require("nvim-treesitter.query_predicates");
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    opts = {
        ensure_installed = {
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
        },
        modules = {},
        sync_install = true,
        ignore_install = {},

        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<M-space>",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            -- swap = {
            --   enable = true,
            --   swap_next = {
            --     ["<leader>a"] = "@parameter.inner",
            --   },
            --   swap_previous = {
            --     ["<leader>A"] = "@parameter.inner",
            --   },
            -- },
        },
    },

    config = function (_, opts)
        vim.defer_fn(function ()
            require("nvim-treesitter.configs").setup(opts);
        end, 0);
    end,
};
