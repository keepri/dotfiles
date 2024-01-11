return {
    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        },
        config = function ()
            -- [[ Configure nvim-cmp ]]
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip").filetype_extend("javascript", { "jsdoc" })
            require("luasnip").filetype_extend("javascriptreact", { "jsdoc" })
            require("luasnip").filetype_extend("typescript", { "tsdoc" })
            require("luasnip").filetype_extend("typescriptreact", { "tsdoc" })

            luasnip.config.setup({})

            cmp.setup{
                snippet = {
                    expand = function (args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    -- ['<Tab>'] = cmp.mapping(function(fallback)
                    --   if cmp.visible() then
                    --     cmp.select_next_item()
                    --   elseif luasnip.expand_or_locally_jumpable() then
                    --     luasnip.expand_or_jump()
                    --   else
                    --     fallback()
                    --   end
                    -- end, { 'i', 's' }),
                    -- ['<S-Tab>'] = cmp.mapping(function(fallback)
                    --   if cmp.visible() then
                    --     cmp.select_prev_item()
                    --   elseif luasnip.locally_jumpable(-1) then
                    --     luasnip.jump(-1)
                    --   else
                    --     fallback()
                    --   end
                    -- end, { 'i', 's' }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            }
        end,
    },

    {
        "windwp/nvim-autopairs",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function ()
            require("nvim-autopairs").setup({})
            -- If you want to automatically add `(` after selecting a function or method
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
}
