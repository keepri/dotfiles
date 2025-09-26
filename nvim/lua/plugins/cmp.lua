vim.pack.add({
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/cmp-buffer",

    "https://github.com/ray-x/cmp-treesitter",
    "https://github.com/saadparwaiz1/cmp_luasnip",
});

local function make_sources(args)
    local sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    };

    if args.is_lazydev then
        table.insert(sources, {
            name = "lazydev",
            -- set group index to 0 to skip loading LuaLS completions
            group_index = 0,
        });
    end;

    if args.is_luasnip then
        table.insert(sources, { name = "luasnip" });
    end;

    if args.is_cmp_ts then
        table.insert(sources, { name = "treesitter" });
    end;

    return sources;
end;

local function setup_cmp_autopairs(args)
    if args.is_ts_utils and args.is_cmp_autopairs then
        local ts_node_func_parens_disabled = {
            -- ecma
            named_imports = true,
            -- rust
            use_declaration = true,
        };

        local default_handler = args.cmp_autopairs.filetypes["*"]["("].handler;

        local function handler(char, item, bufnr, rules, commit_character)
            local node_type = args.ts_utils.get_node_at_cursor():type();

            if ts_node_func_parens_disabled[node_type] then
                if item.data then
                    item.data.funcParensDisabled = true;
                else
                    char = "";
                end;
            end;

            default_handler(char, item, bufnr, rules, commit_character);
        end;

        args.cmp_autopairs.filetypes["*"]["("].handler = handler;

        args.cmp.event:on(
            "confirm_done",
            args.cmp_autopairs.on_confirm_done({ sh = false })
        );
    elseif args.is_cmp_autopairs then
        local on_confirm_done = args.cmp_autopairs.on_confirm_done();

        args.cmp.event:on("confirm_done", on_confirm_done);
    end;
end;

local function make_mappigs(args)
    local mappings = {
        ["<C-n>"] = args.cmp.mapping(
            function ()
                if args.cmp.visible() then
                    args.cmp.select_next_item();
                end;
            end,
            { "i", "s" }
        ),
        ["<C-p>"] = args.cmp.mapping(
            function ()
                if args.cmp.visible() then
                    args.cmp.select_prev_item();
                end;
            end,
            { "i", "s" }
        ),
        ["<C-d>"] = args.cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = args.cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = args.cmp.mapping.complete({}),
        ["<CR>"] = args.cmp.mapping.confirm({
            behavior = args.cmp.ConfirmBehavior.Replace,
            select = true,
        }),
    };

    if args.is_luasnip then
        mappings["<Tab>"] = args.cmp.mapping(
            function (fallback)
                if args.luasnip.expand_or_locally_jumpable() then
                    args.luasnip.expand_or_jump();
                elseif args.cmp.visible() then
                    args.cmp.select_next_item();
                else
                    fallback();
                end;
            end,
            { "i", "s" }
        );

        mappings["<S-Tab>"] = args.cmp.mapping(
            function (fallback)
                if args.luasnip.locally_jumpable(-1) then
                    args.luasnip.jump(-1);
                elseif args.cmp.visible() then
                    args.cmp.select_prev_item();
                else
                    fallback();
                end;
            end,
            { "i", "s" }
        );
    end;

    return mappings;
end;

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function ()
        local cmp = require("cmp");
        local is_cmp_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp");
        local is_ts_utils, ts_utils = pcall(require, "nvim-treesitter.ts_utils");
        local is_cmp_ts, cmp_ts = pcall(require, "cmp-treesitter");
        local is_lazydev = pcall(require, "lazydev");
        local is_luasnip, luasnip = pcall(require, "luasnip");
        local params = {
            cmp = cmp,
            ts_utils = ts_utils,
            cmp_ts = cmp_ts,
            luasnip = luasnip,
            cmp_autopairs = cmp_autopairs,
            is_ts_utils = is_ts_utils,
            is_cmp_ts = is_cmp_ts,
            is_luasnip = is_luasnip,
            is_cmp_autopairs = is_cmp_autopairs,
            is_lazydev = is_lazydev,
        };
        local mappings = make_mappigs(params);
        local sources = make_sources(params);

        setup_cmp_autopairs(params);

        cmp.setup({
            snippet = {
                expand = function (args)
                    if is_luasnip then
                        luasnip.lsp_expand(args.body);
                    end;
                end,
            },
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            mapping = mappings,
            sources = sources,
        });
    end,
});
