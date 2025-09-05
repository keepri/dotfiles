return {
    {
        "tpope/vim-fugitive",
        config = function ()
            vim.keymap.set("n", "<leader>gh", ":0Gclog<CR>", {
                noremap = true,
                silent = true,
                desc = "Git full file history",
            });
            vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>", {
                noremap = true,
                silent = true,
                desc = "Git diff vertical split",
            });
        end,
    },

    "tpope/vim-rhubarb",
    "tpope/vim-sleuth",
};
