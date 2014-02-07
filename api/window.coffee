###################################
#
# GJS Window API Wrapper
#
###################################

class Window

  constructor: (@window) -> this

  # get all windows which is shown in current workspace
  getAll: ->
    currentWorkspaceIndex = global.screen.get_active_workspace_index()
    windows = global.get_window_actors().filter (window) ->
      window.get_workspace() is currentWorkspaceIndex or
      (window.get_meta_window() and window.get_meta_window().is_on_all_workspaces())
    windows.map (win) -> new Window(win)

  # 设置四角坐标
  # 坐标为相对坐标，从顶栏下面那个点作为 （0,0），然后是不包括阴影以及border的
  setArea: (x, y, width, height) ->
    y += Main.panel.actor.height
    @window.set_position x, y

  kill: -> true

modules.Window = Window
