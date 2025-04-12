return {
    "nvim-tree/nvim-web-devicons",
    priority = 9001,
    config = function ()
        require("nvim-web-devicons").setup({
            default = true,
            strict = true,
            color_icons = true,
            variant = "dark",
        });
    end,
};
