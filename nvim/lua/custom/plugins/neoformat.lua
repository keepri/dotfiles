return {
  'sbdchd/neoformat',
  config = function()
    vim.g.neoformat_try_node_exe = 1
    vim.api.nvim_create_autocmd(
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
          '*.lua',
          '*.cpp',
          '*.h',
          '*.go',
          '*.rs',
        },
      }
    )
  end
}
