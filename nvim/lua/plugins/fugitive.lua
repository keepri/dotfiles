vim.pack.add({
    "https://github.com/tpope/vim-fugitive",
    -- dependencies
    "https://github.com/tpope/vim-rhubarb",
    "https://github.com/tpope/vim-sleuth",
});

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function ()
        vim.keymap.set(
            "n",
            "<leader>gh",
            ":0Gclog<CR>",
            {
                noremap = true,
                silent = true,
                desc = "Git full file history",
            }
        );

        vim.keymap.set(
            "n",
            "<leader>gd",
            ":Gvdiffsplit<CR>",
            {
                noremap = true,
                silent = true,
                desc = "Git diff vertical split",
            }
        );
    end,
});
