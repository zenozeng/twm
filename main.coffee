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
    # reload this extension
    keybindings.add "<Super>r", -> init()

    getLayout = (num) ->
      false


    global.setLayout = ->
      wins = (new Window()).getAll()
      wins = wins.filter (win) -> win.wmClass isnt 'Gnome-shell'
      monitor = Main.layoutManager.primaryMonitor
      avaliable =
        width: monitor.width
        height: monitor.height - Main.panel.actor.height

      helper.log avaliable
      helper.log wins.length
      global.t1 = wins
      if wins.length is 1
        wins[0].setArea 0, 0, avaliable.width, avaliable.height
      if wins.length is 2
        wins[0].setArea 0, 0, avaliable.width/2, avaliable.height
        wins[1].setArea avaliable.width * 0.5, 0, avaliable.width * 0.5, avaliable.height

    # for testing
    keybindings.add "<Super>t", ->
      current = (new Window()).current()
      current.setDecorated(true)
      # global.cw = current
      helper.log "cap"

    # for testing
    keybindings.add "<Super>q", ->
      current = (new Window()).current()
      current.setDecorated(false)
      # global.cw = current
      helper.log "cap"

    keybindings.apply()

    # (new Window()).getAll().forEach (win) ->
    #   win.setArea 0, 0, 100, 100


# API.window.get().forEach(window) ->
#   window.set_position(0, 100);

  # TWM.windowActors.get().forEach(function(windowActor) {
  #     // get borderWidth
  #     // see /usr/share/gnome-shell/js/ui/boxpointer.js
  #     // this.actor = new St.Bin({ x_fill: true,
  #     //                           y_fill: true });
  #     // let themeNode = this.actor.get_theme_node();
  #     // let borderWidth = themeNode.get_length('-arrow-border-width');
  #     windowActor.set_position(0, 100); // 绝对坐标，注意顶栏
  #     // windowActor.set_area(100, 100, 300, 300);
  #     windowActor.set_size(width, height);
  #     // 锚点
  #     // windowActor.move_anchor_point(0, 0);
  # });


# load layouts

# hook into window events

# load user's config file
