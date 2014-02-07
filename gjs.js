(function() {

    const St = imports.gi.St;

    var monitor = Main.layoutManager.primaryMonitor;
    var width = monitor.width;
    var height = monitor.height;

    var TWM = (function() {
        var windowActors = {
            get: function() {
                // windows shown in current workspace
                var workspaceIndex = global.screen.get_active_workspace_index();
                return global.get_window_actors().filter(function(windowActor){
                    return windowActor.get_workspace() == workspaceIndex ||
                    (windowActor.get_meta_window() && windowActor.get_meta_window().is_on_all_workspaces());
                });
            },
            setArea: function(x, y, width, height) {
                // 设置四角坐标
                // 坐标为相对坐标，从顶栏下面那个点作为 （0,0），然后是不包括阴影的
            },
            // 关闭
            kill: function() {
            }
        }
        return {windowActors: windowActors};
    })();

    TWM.windowActors.get().forEach(function(windowActor) {
        // get borderWidth
        // see /usr/share/gnome-shell/js/ui/boxpointer.js
        // this.actor = new St.Bin({ x_fill: true,
        //                           y_fill: true });
        // let themeNode = this.actor.get_theme_node();
        // let borderWidth = themeNode.get_length('-arrow-border-width');
        windowActor.set_position(0, 100); // 绝对坐标，注意顶栏
        // windowActor.set_area(100, 100, 300, 300);
        windowActor.set_size(width, height);
        // 锚点
        // windowActor.move_anchor_point(0, 0);
    });
})()
