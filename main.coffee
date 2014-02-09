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

helper.log 'TWMA V20'

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

    {Window, keybindings} = modules

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

      applyLayout = ->
        wins = (new Window()).getAll()
        wins = wins.filter (win) -> win.wmClass isnt 'Gnome-shell'

        layout = modules.layouts["2-column"]
        areas = layout(wins.length)

        monitor = Main.layoutManager.primaryMonitor

        avaliableWidth = monitor.width
        avaliableHeight = monitor.height

        wins.forEach (win, index) ->
          {x, y, width, height} = areas[index]
          x = x * avaliableWidth
          y = y * avaliableHeight
          width = width * avaliableWidth
          height = height * avaliableHeight
          helper.log {x: x, y: y, width: width, height: height}
          win.setDecorated false
          win.setArea x, y, width, height

      keybindings.add "<Super>t", ->
        applyLayout()
        helper.log "applyLayout"
      keybindings.apply()

# load layouts

# hook into window events

# load user's config file
