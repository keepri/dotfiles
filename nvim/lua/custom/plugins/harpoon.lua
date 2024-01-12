return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = {
        { "nvim-lua/plenary.nvim" },
    },
    config = function ()
        local harpoon = require("harpoon");
        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
            },
        });

        vim.keymap.set("n", "<leader>a", function () harpoon:list():append(); end, { desc = "[A]ppend Buffer to Harpoon" });
        vim.keymap.set("n", "<C-e>", function () harpoon.ui:toggle_quick_menu(harpoon:list()); end,
            { desc = "Harpoon Buffer List [E]xplore" });
        vim.keymap.set("n", "<leader>h1", function () harpoon:list():select(1); end, { desc = "Harpoon Item [1]" });
        vim.keymap.set("n", "<leader>h2", function () harpoon:list():select(2); end, { desc = "Harpoon Item [2]" });
        vim.keymap.set("n", "<leader>h3", function () harpoon:list():select(3); end, { desc = "Harpoon Item [3]" });
        vim.keymap.set("n", "<leader>h4", function () harpoon:list():select(4); end, { desc = "Harpoon Item [4]" });
        vim.keymap.set("n", "<leader>h5", function () harpoon:list():select(5); end, { desc = "Harpoon Item [5]" });
    end,
};
