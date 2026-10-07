-- Servers are installed manually, see README.md for the install commands.
-- The default cmd/root_markers/filetypes come from nvim-lspconfig's lsp/*.lua
-- definitions; everything in lua/user/lsp/settings/<server>.lua is merged on top.
local handlers = require("user.lsp.handlers")

local servers = {
  "lua_ls",
  "ty", -- https://github.com/astral-sh/ty
  "jsonls",
  "clangd",
  "jdtls",
  "rust_analyzer",
  "bashls",
  "gopls",
  "dockerls",
  "docker_compose_language_service",
  "ansiblels",
  "helm_ls",
}

-- Applies to every server, merged under the per-server config.
vim.lsp.config("*", {
  capabilities = handlers.capabilities,
})

for _, server in ipairs(servers) do
  local ok, custom_opts = pcall(require, "user.lsp.settings." .. server)
  if ok then
    vim.lsp.config(server, custom_opts)
  end
end

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      handlers.on_attach(client, args.buf)
    end
  end,
})
