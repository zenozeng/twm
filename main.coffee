GLib = imports.gi.GLib

# todo: function to reload config

modules.spawn = (cmd) -> GLib.spawn_command_line_async cmd
modules.spawnSync = (cmd) ->
  try
    result = GLib.spawn_command_line_sync cmd
    if result[0]
      result[1].toString()
    else
      helper.log result
  catch e
    helper.log e
{helper, spawn} = modules

helper.log 'TWMA V22'

monitor = Main.layoutManager.primaryMonitor

##########################################
#
# Load API
#
# Notice that helper.exec is asynchronous
#
##########################################


helper.exec "api/window.coffee", ->
  helper.exec "api/keybindings.coffee", ->

    {Window, keybindings, spawn} = modules

    keybindings.add "<Super>e", -> spawn "emacsclient -c"
    keybindings.add "<Super>c", -> spawn "google-chrome"
    keybindings.add "<Super>l", -> Main.lookingGlass.toggle()
    keybindings.add "<Super>Return", -> spawn "gnome-terminal"
    keybindings.add "<Super>k", -> (new Window()).current().destroy()
    keybindings.add "<Super>r", -> init() # reload this extension

    # for testing
    keybindings.add "<Super>t", ->
      current = (new Window()).current()
      helper.log "Done"

    # load layouts
    modules.layouts = {}
    helper.exec "layouts/2-column.coffee", ->

    # TODO: Support blacklist in Config File
    blackList = (win) -> win.wmClass isnt 'Gnome-shell'

    applyLayout = ->
        wins = (new Window()).getAll()
        wins = wins.filter (win) -> blackList win

        # remove title bar
        wins.forEach (win) -> win.setDecorated false

        delay = (time, callback) ->
          GLib.timeout_add GLib.PRIORITY_DEFAULT, time, ->
            callback?()

        # a delay to make sure window are already setDecorated(false)
        delayTime = 100

        delay delayTime, ->

          layout = modules.layouts["2-column"]
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

      keybindings.add "<Super>t", ->
        applyLayout()
        helper.log "applyLayout"
      keybindings.apply()

# load layouts

# hook into window events

# load user's config file
