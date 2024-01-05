return {
  'sbdchd/neoformat',
  config = function()
    vim.g.neoformat_try_node_exe = 1
    local id = vim.api.nvim_create_autocmd(
      { 'BufWritePost' },
      {
        command = 'silent! Neoformat',
        pattern = {
          '*.cjs',
          '*.mjs',
          '*.js',
          '*.jsx',
          '*.ts',
          '*.tsx',
          '*.json',
          '*.md',
          '*.lua',
          '*.cpp',
          '*.h',
          '*.go',
          '*.rs',
        },
      }
    )
    vim.api.nvim_create_user_command(
      'NeoformatDisableFormatOnSave',
      function()
        vim.api.nvim_del_autocmd(id)
      end,
      {}
    )
  end
}
