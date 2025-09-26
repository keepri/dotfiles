vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" });

require("luasnip.loaders.from_vscode").lazy_load();

local luasnip = require("luasnip");

luasnip.config.setup({});

luasnip.filetype_extend("javascript", { "jsdoc" });
luasnip.filetype_extend("javascriptreact", { "jsdoc" });
luasnip.filetype_extend("typescript", { "tsdoc" });
luasnip.filetype_extend("typescriptreact", { "tsdoc" });
