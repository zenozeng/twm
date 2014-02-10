ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper

Window = Extension.imports.api.window.Window
keybindings = Extension.imports.api.keybindings

Config = Extension.imports.config.Config

init = ->
  # init global variable for functions to call from outside
  global.twm = {functions: {}};
  # init config
  config = new Config
  helper.log "Hey, new Version here"
  false

enable = ->
  # do sth here
  # bind events here

disable = -> false
  # disconnect
