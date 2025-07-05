local status_ok, lazy_git = pcall(require, "lazy")
if not status_ok then
    return
end

lazy_git.setup {
  config = function()
            require("telescope").load_extension("lazygit")
  end,
}
