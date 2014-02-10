ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
Window = Extension.imports.api.window.Window
keybindings = Extension.imports.api.keybindings
Config = Extension.imports.config.config.Config
layouts = Extension.imports.layouts.layouts.layouts

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

    applyLayout = ->

      # Get Windows & apply blacklist
      wins = (new Window()).getAll()
      wins = wins.filter (win) -> win.wmClass isnt 'Gnome-shell'
      wins = wins.filter (win) -> config.windowsFilter win

      # remove title bar
      wins.forEach (win) -> win.setDecorated false

      delay = (time, callback) ->
        GLib.timeout_add GLib.PRIORITY_DEFAULT, time, ->
          callback?()

      # a delay to make sure window are already setDecorated(false)
      delayTime = 100

      delay delayTime, ->

        layout = layouts.get("2-column")
        areas = layout(wins.length)

        monitor = Main.layoutManager.primaryMonitor

        avaliableWidth = monitor.width
        avaliableHeight = monitor.height - Main.panel.actor.height

        wins.forEach (win, index) ->
          {x, y, width, height} = areas[index]
          x = x * avaliableWidth
          y = y * avaliableHeight
          width = width * avaliableWidth
          height = height * avaliableHeight
          # helper.log {x: x, y: y, width: width, height: height}
          win.setArea x, y, width, height

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
