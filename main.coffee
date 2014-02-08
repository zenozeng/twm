# todo: function to reload config

modules.spawn = (cmd) -> GLib.spawn_command_line_async cmd

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
    # reload this extension
    keybindings.add "<Super>r", -> init()

    # for testing
    keybindings.add "<Super>t", ->
      current = (new Window()).current()
      helper.log current.wmClass
      current.setArea(10, 10, 100, 100)

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
