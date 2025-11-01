vim.pack.add({ "https://github.com/mbbill/undotree" });

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function ()
        vim.keymap.set(
            "n",
            "<leader>u",
            vim.cmd.UndotreeToggle,
            { desc = "Toggle Undotree" }
        );
    end,
});

vim.g.undotree_WindowLayout = 2;
