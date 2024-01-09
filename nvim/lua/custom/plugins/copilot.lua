return {
  "github/copilot.vim",
  config = function()
    -- vim.api.nvim_set_keymap("i", "<C-J>", "copilot#Accept("<CR>")", { silent = true, expr = true })
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_filetypes = {
      ["*"] = false,
      ["javascript"] = true,
      ["javascriptreact"] = true,
      ["typescript"] = true,
      ["typescriptreact"] = true,
      ["html"] = true,
      ["css"] = true,
      ["lua"] = true,
      ["rust"] = true,
      ["c"] = true,
      ["cpp"] = true,
      ["go"] = true,
      ["bash"] = true,
    }
  end
}
