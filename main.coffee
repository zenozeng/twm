# todo: function to reload config
{helper} = modules

helper.log 'hey, this is tw/main 7'

monitor = Main.layoutManager.primaryMonitor

##########################################
#
# Load API
#
# Notice that helper.exec is asynchronous
#
##########################################

apis = ["window", "monitor"]
fns = apis.map (util) -> (-> helper.exec "api/#{util}.coffee")
async.parallel fns, helper.log "loaded"


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
