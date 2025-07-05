local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local handlers = require("user.lsp.handlers")
local lspconfig = require("lspconfig")

local servers = {
  "lua_ls",
  "pyright",
  "jsonls",
  "clangd",
  "jdtls",
  "rust_analyzer",
  "bashls",
  "gopls",
  "dockerls",
  "docker_compose_language_service",
}

local settings = {
  ui = {
    border = "none",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  ensure_installed = servers,
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)

for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }

  local ok, custom_opts = pcall(require, "user.lsp.settings." .. server)
  if ok then
    opts = vim.tbl_deep_extend("force", opts, custom_opts)
  end

  lspconfig[server].setup(opts)
end
