vim.keymap.set(
    "i",
    "<C-l>",
    "<C-y>",
    { noremap = true, silent = true }
);

vim.keymap.set(
    "n",
    "<leader>kv",
    ":Neotree reveal<CR>",
    { desc = "Open Neotree." }
);

-- vim.keymap.set(
--     "n",
--     "<leader>kv",
--     vim.cmd.Ex,
--     { desc = "Open NetRw." }
-- );

vim.keymap.set(
    "n",
    "<C-u>",
    "<C-u>zz",
    { desc = "Page up centered." }
);

vim.keymap.set(
    "n",
    "<C-d>",
    "<C-d>zz",
    { desc = "Page down centered." }
);

vim.keymap.set(
    "n",
    "n",
    "nzzzv",
    { desc = "Center while selecting next search result." }
);

vim.keymap.set(
    "n",
    "N",
    "Nzzzv",
    { desc = "Center while selecting previous search result." }
);

vim.keymap.set(
    "v",
    "K",
    ":m '<-2<CR>gv=gv",
    { desc = "Move selection up one line." }
);

vim.keymap.set(
    "v",
    "J",
    ":m '>+1<CR>gv=gv",
    { desc = "Move selection down one line." }
);

vim.keymap.set(
    "x",
    "<leader>p",
    [["_dP]],
    { desc = "Paste and keep copy buffer. This is cool!" }
);

vim.keymap.set(
    "n",
    "<leader>%",
    [[$V%]],
    { desc = "Select ... block?..." }
);

vim.keymap.set(
    "n",
    "<leader>Y",
    [["+Y]],
    { desc = "Copy line to system clipboard." }
);

vim.keymap.set(
    { "n", "v" },
    "<leader>y",
    [["+y]], { desc = "Copy to system clipboard." }
);

vim.keymap.set(
    { "n", "v" },
    "<leader>d",
    [["_d]], { desc = "Delete n number of lines up or down." }
);

vim.keymap.set(
    { "n", "v" },
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace all ocurrences of word in buffer." }
);

vim.keymap.set(
    { "n", "v" },
    "<Space>",
    "<Nop>",
    { silent = true }
);

vim.keymap.set(
    "n",
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true, desc = "Move up" }
);

vim.keymap.set(
    "n",
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true, desc = "Move down" }
);

vim.keymap.set(
    "n",
    "[d",
    function ()
        local prev_diagnostic = vim.diagnostic.get_prev();
        vim.diagnostic.jump({ diagnostic = prev_diagnostic });
    end,
    { desc = "Go to previous diagnostic message" }
);
vim.keymap.set(
    "n",
    "]d",
    function ()
        local next_diagnostic = vim.diagnostic.get_next();
        vim.diagnostic.jump({ diagnostic = next_diagnostic });
    end,
    { desc = "Go to next diagnostic message" }
);

vim.keymap.set(
    "n",
    "<leader>e",
    vim.diagnostic.open_float,
    { desc = "Open floating diagnostic message" }
);

vim.keymap.set(
    "n",
    "<leader>q",
    vim.diagnostic.setloclist,
    { desc = "Open diagnostics list" }
);
