require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.cmp"
require "user.lsp"
require "user.telescope"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.gitsigns"
require "user.nvimtree"
require "user.bufferline"
require "user.fidget"
require "user.lazygit"
require "user.whichkey"

local function load_project_config()
  local local_config = vim.fn.getcwd() .. "/.nvimrc.lua"
  if vim.fn.filereadable(local_config) == 1 then
    dofile(local_config)
  end
end

-- Load the project-specific config on entering the directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = load_project_config,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only restore if no files were passed to nvim (no CLI args)
    if vim.fn.argc() == 0 then
      require("persistence").load()
    end
  end,
})
