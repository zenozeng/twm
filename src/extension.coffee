ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
keybindings = Extension.imports.lib.keybindings
ConfigManager = Extension.imports.config.configManager.ConfigManager
Wnck = imports.gi.Wnck

init = ->

  # init global variable for functions to call from outside
  global.twm = {functions: {}}

  try

    # load config
    config = new ConfigManager

    # apply keybindings from config
    for keybinding, callback of config.keybindings
      keybindings.add keybinding, callback
    keybindings.apply()

    # fire onStartup Hook
    config.onStartup?()

  catch e
    global.log e
    helper.log e

  # `init()` must return false, or enable will nerver be called
  #
  # In gnome-shell/js/ui/extensionSystem.js function initExtension:
  # if (extensionModule.init) {
  #     extensionState = extensionModule.init(extension);
  # }
  # if (!extensionState)
  #     extensionState = extensionModule;
  # extension.stateObj = extensionState;

  false

enable = -> false

disable = -> false
