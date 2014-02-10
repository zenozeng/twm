ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
Window = Extension.imports.api.window.Window
keybindings = Extension.imports.api.keybindings
Config = Extension.imports.config.config.Config

init = ->
  helper.log "Hey, this is TWM v42"

  # init global variable for functions to call from outside
  global.twm = {functions: {}};

  # load config
  try

    config = new Config

    # apply keybindings from config

    # hook into window events

  catch e
    helper.log e

  # init() must return false, or enable will nerver be called
  # in gnome-shell/js/ui/extensionSystem.js function initExtension
  #
  # if (extensionModule.init) {
  #     extensionState = extensionModule.init(extension);
  # }

  # if (!extensionState)
  #     extensionState = extensionModule;
  # extension.stateObj = extensionState;

  false

enable = -> false

disable = -> false
