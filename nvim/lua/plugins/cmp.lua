vim.pack.add({
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/cmp-buffer",
});

local cmp = require("cmp");
local is_lazydev_installed = pcall(require, "lazydev");
local is_treesitter_installed, ts_utils = pcall(require, "nvim-treesitter.ts_utils");
local is_luasnip_installed, luasnip = pcall(require, "luasnip");
local is_autopairs_installed, autopairs_cmp = pcall(require, "nvim-autopairs.completion.cmp");
local sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
};


if is_lazydev_installed then
    table.insert(sources, {
        name = "lazydev",
        -- set group index to 0 to skip loading LuaLS completions
        group_index = 0,
    });
end;

if is_luasnip_installed then
    vim.pack.add({ "https://github.com/saadparwaiz1/cmp_luasnip" });

    table.insert(sources, { name = "luasnip" });
end;

if is_autopairs_installed then
    local on_confirm_done = autopairs_cmp.on_confirm_done();

    cmp.event:on("confirm_done", on_confirm_done);
end;

if is_treesitter_installed and is_autopairs_installed then
    local ts_node_func_parens_disabled = {
        -- ecma
        named_imports = true,
        -- rust
        use_declaration = true,
    };

    local default_handler = autopairs_cmp.filetypes["*"]["("].handler;

    local function handler(char, item, bufnr, rules, commit_character)
        local node_type = ts_utils.get_node_at_cursor():type();

        if ts_node_func_parens_disabled[node_type] then
            if item.data then
                item.data.funcParensDisabled = true;
            else
                char = "";
            end;
        end;

        default_handler(char, item, bufnr, rules, commit_character);
    end;

    autopairs_cmp.filetypes["*"]["("].handler = handler;

    cmp.event:on(
        "confirm_done",
        autopairs_cmp.on_confirm_done({ sh = false })
    );
end;

local mappings = {
    ["<C-n>"] = cmp.mapping(
        function ()
            if cmp.visible() then
                cmp.select_next_item();
            end;
        end,
        { "i", "s" }
    ),
    ["<C-p>"] = cmp.mapping(
        function ()
            if cmp.visible() then
                cmp.select_prev_item();
            end;
        end,
        { "i", "s" }
    ),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
};

if is_luasnip_installed then
    mappings["<Tab>"] = cmp.mapping(
        function (fallback)
            if cmp.visible() then
                cmp.select_next_item();
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump();
            else
                fallback();
            end;
        end,
        { "i", "s" }
    );

    mappings["<S-Tab>"] = cmp.mapping(
        function (fallback)
            if cmp.visible() then
                cmp.select_prev_item();
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1);
            else
                fallback();
            end;
        end,
        { "i", "s" }
    );
end;

cmp.setup({
    snippet = {
        expand = function (args)
            if is_luasnip_installed then
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
