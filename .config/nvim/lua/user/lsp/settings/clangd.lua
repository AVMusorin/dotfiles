return {
  cmd = {
    'clangd',
    '--background-index=false',
    '--completion-style=detailed',
    '--header-insertion=never',
    '--pch-storage=memory',
    '--clang-tidy=false',         -- Disable slow clang-tidy checks
    '-j=4',                       -- Use only 4 threads instead of all cores
    '--malloc-trim',              -- Reduce memory usage
  },
  filetypes = { 'c', 'cpp' },
  single_file_support = true,
}
