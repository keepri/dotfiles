return {
  -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  config = function()
    -- document existing key chains
    require("which-key").register {
      ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
      ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
      ["<leader>u"] = { name = "[U]ndotree", _ = "which_key_ignore" },
      ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
      ["<leader>a"] = { name = "[A]ppend Buffer To Harpoon List", _ = "which_key_ignore" },
      ["<leader>h1"] = { name = "[H]ppend List Item 1", _ = "which_key_ignore" },
      ["<leader>h2"] = { name = "[H]ppend List Item 2", _ = "which_key_ignore" },
      ["<leader>h3"] = { name = "[H]ppend List Item 3", _ = "which_key_ignore" },
      ["<leader>h4"] = { name = "[H]ppend List Item 4", _ = "which_key_ignore" },
      ["<leader>h5"] = { name = "[H]ppend List Item 5", _ = "which_key_ignore" },
    }

    -- register which-key VISUAL mode
    -- required for visual <leader>hs (hunk stage) to work
    require("which-key").register({
      ["<leader>"] = { "VISUAL <leader>" },
      ["<leader>h"] = { "Git [H]unk" },
    }, { mode = "v" })
  end
}
