local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

-- TODO: register all custom mappings
--       I don't like the way to place all mapping in this module, because it's not
--       clear to find them here, I recon the best place for mapping is keymaps.lua, so
--       whick-key should register mappings there 
--
--       Also, there are mappings in other plugins
--
--       Do these plugins be loaded in right order? Means since that depends on which-key should which-key
--       be loaded at first?
which_key.setup {}
