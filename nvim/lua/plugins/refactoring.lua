vim.pack.add({ "https://github.com/ThePrimeagen/refactoring.nvim" });

local rf = require("refactoring");

rf.setup({});

vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "Extract" });
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract to file" });

vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract variable" });

vim.keymap.set("n", "<leader>rb", ":Refactor extract_block ", { desc = "Extract block" });
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file ", { desc = "Extract block to file" });

-- these are weird
-- vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var ", { desc = "Inline variable" });
-- vim.keymap.set("n", "<leader>rI", ":Refactor inline_func ", { desc = "Inline function" });
