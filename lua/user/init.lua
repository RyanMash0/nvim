-------------------------------------------------------------------------------
-- User Configs                                                              --
-------------------------------------------------------------------------------
--- 	Add your configuration overrides in this directory, but note that
--- altering this file directly may cause issues with git.
--- 	Custom config files outside of the scope of keymaps and options should be
--- set in a file with the following path: /lua/user/custom.lua. You can either
--- write all configs in this custom.lua file, or you can use the custom.lua
--- file to link in other files of your choosing.
--- 	Also note that you can set your own leader key in a file with the path:
--- /lua/user/leader.lua. This leader.lua file will be the first file loaded on
--- start up, while all other configs defined in this directory will be loaded
--- last so that configuration overrides are possible.

pcall(require, 'user.keymaps')
pcall(require, 'user.options')
pcall(require, 'user.custom')
