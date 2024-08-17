return {
    "folke/which-key.nvim",

    config = function ()
        local wk = require("which-key");

        wk.add({
            { "<leader>", desc = "VISUAL <leader>", mode = "v" },

            { "<leader>c", group = "[C]ode" },
            { "<leader>d", group = "[D]ocument" },
            { "<leader>g", group = "[G]it" },
            { "<leader>h", group = "Git [H]unk" },
            { "<leader>k", group = "[K]IPRI" },
            { "<leader>l", group = "[L]int" },
            { "<leader>r", group = "[R]ename" },
            { "<leader>s", group = "[S]earch" },
            { "<leader>t", group = "[T]oggle" },
            { "<leader>w", group = "[W]orkspace" },

            { "<leader>c_", hidden = true },
            { "<leader>d_", hidden = true },
            { "<leader>g_", hidden = true },
            { "<leader>h_", hidden = true },
            { "<leader>k_", hidden = true },
            { "<leader>l_", hidden = true },
            { "<leader>r_", hidden = true },
            { "<leader>s_", hidden = true },
            { "<leader>t_", hidden = true },
            { "<leader>w_", hidden = true },
        });
    end,
};
