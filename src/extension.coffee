ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
keybindings = Extension.imports.lib.keybindings
ConfigManager = Extension.imports.config.configManager.ConfigManager
WindowManager = Extension.imports.lib.windowManager.WindowManager
Wnck = imports.gi.Wnck

init = ->

  # init global variable for functions to call from outside
  global.twm = {functions: {}}

  try

    # load config
    config = new ConfigManager

    # set up workspace
    helper.spawn "gsettings set org.gnome.shell.overrides dynamic-workspaces false"
    helper.spawn "gsettings set org.gnome.desktop.wm.preferences num-workspaces #{config.workspaceNum}"


    # apply keybindings from config
    for keybinding, callback of config.keybindings
      keybindings.add keybinding, callback
    keybindings.apply()

    # bind on window change events
    wm = new WindowManager
    onWindowChange = (wnckWindow, activeWindow) ->
      currentWorkspace = wm.getActiveWorkspace()
      if wnckWindow.is_visible_on_workspace currentWorkspace
        if config.windowsFilter(wnckWindow)
          currentLayout = config.layouts.current()
          if currentLayout? and currentLayout isnt 'float'
            config.layouts.apply currentLayout, config.windowsFilter, activeWindow
      false
    wm.connect "window-opened", (wnckScreen, wnckWindow) ->
      onWindowChange wnckWindow, wnckWindow
    wm.connect "window-closed", (wnckScreen, wnckWindow) ->
      onWindowChange wnckWindow, null

    # fire onStartup Hook
    config.onStartup?()

    global.t0 = -> config.layouts.apply "3-column"

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
