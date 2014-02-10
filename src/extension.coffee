ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper

Window = Extension.imports.api.window.Window
keybindings = Extension.imports.api.keybindings

Config = Extension.imports.config.config.Config

init = ->
  helper.log "Hey, this is TWM v41"

  # init global variable for functions to call from outside
  global.twm = {functions: {}};

  # load config
  try
    config = new Config

    # apply keybindings from config

    # hook into window events

  catch e
    helper.log e

enable = ->
  # do sth here
  # bind events here

disable = -> false
  # disconnect
