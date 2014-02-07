###################################
#
# GJS Window API Wrapper
#
###################################

window = {}

# get windows which is shown in current workspace
window.get = ->
  currentWorkspaceIndex = global.screen.get_active_workspace_index()
  windows = global.get_window_actors().filter (window) ->
    window.get_workspace() is currentWorkspaceIndex or
    (window.get_meta_window() and window.get_meta_window().is_on_all_workspaces())

# 设置四角坐标
# 坐标为相对坐标，从顶栏下面那个点作为 （0,0），然后是不包括阴影的
window.setArea = (window, x, y, width, height) -> true

window.kill = -> true

modules.window = window
