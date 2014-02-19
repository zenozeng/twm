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

    # bind on window change events
    onWindowChange = (wnckScreen, wnckWindow) ->
      wnckScreen.force_update()
      currentWorkspace = wnckScreen.get_active_workspace()
      if wnckWindow.is_visible_on_workspace currentWorkspace
        if config.windowsFilter(wnckWindow)
          currentLayout = config.layouts.current()
          if currentLayout? and currentLayout isnt 'float'
            config.layouts.apply currentLayout, config.windowsFilter
      false
    screen = Wnck.Screen.get_default()
    screen.connect "window-opened", onWindowChange
    screen.connect "window-closed", onWindowChange

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
