ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
Window = Extension.imports.api.window.Window
keybindings = Extension.imports.api.keybindings
Config = Extension.imports.config.config.Config
Wnck = imports.gi.Wnck

init = ->

  # init global variable for functions to call from outside
  global.twm = {functions: {}}

  try

    # load config
    config = new Config

    # apply keybindings from config
    for keybinding, callback of config.keybindings
      keybindings.add keybinding, callback
    keybindings.apply()

    # fire onStartup Hook
    config.onStartup?()

    # onWindowChange = ->

    #   Wnck = imports.gi.Wnck
    #   screen = Wnck.Screen.get_default()
    #   windows = screen.get_windows()
    #   helper.log windows.length
    #   # workspace = screen.get_active_workspace()
    #   # helper.log workspace.toString()
    #   # helper.log "p2"
    #   # helper.log workspace.get_name().toString()

    #   windows = windows.filter (WnckWindow) ->
    #     # Like wnck_window_is_on_workspace(),
    #     # but also checks that the window is
    #     # in a visible state (i.e. not minimized or shaded).
    #     WnckWindow.is_visible_on_workspace(workspace)

    #   global.t1 = windows

    #   # TODO: fix this
    #   # Get Windows & apply blacklist
    #   # wins = (new Window()).getAll()
    #   # wins = wins.filter (win) -> win.wmClass isnt 'Gnome-shell'
    #   # wins = wins.filter (win) -> config.windowsFilter win

    #   config.layouts.apply "2-column", windows

    # # for test
    # helper.delay 3000, ->
    #   onWindowChange()

    # hook into window events

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
