Meta = imports.gi.Meta

class Window

  ###
  Constructor

  @example Get current window's wmClass
    var wmClass = (new Window()).current().wmClass;

  @example Get current window's meta_window
    var wmClass = (new Window()).current().meta;
  ###
  constructor: (@window) ->
    if @window?
      @meta = @window.get_meta_window()
      @wmClass = @meta.get_wm_class()
    this

  ###
  Get current window
  ###
  current: ->
    wins = @getAll().filter (win) -> win.window.get_meta_window().has_focus()
    wins[0]

  ###
  Get all windows which is shown in current workspace

  @example Move every windows in current workspace to (0, 0) and resize to 100*100
    (new Window()).getAll().forEach(function(win){
      win.setArea(0, 0, 100, 100);
    });
  ###
  getAll: ->
    currentWorkspaceIndex = global.screen.get_active_workspace_index()
    windows = global.get_window_actors().filter (window) ->
      window.get_workspace() is currentWorkspaceIndex or
      (window.get_meta_window() and window.get_meta_window().is_on_all_workspaces())
    windows.map (win) -> new Window(win)

  ###
  Set the position and size of the window

  @param [Number] x position x (px)
  @param [Number] y position y (px)
  @param [Number] width width (px) (border & shadow should not be included)
  @param [Number] height height (px) (border & shadow should not be included)
  @note (0, 0) was at the left-bottom of the top bar
  ###
  setArea: (x, y, width, height) ->
    y += Main.panel.actor.height
    @window.get_meta_window().unmaximize(Meta.MaximizeFlags.VERTICAL | Meta.MaximizeFlags.HORIZONTAL)
    @window.get_meta_window().move_resize_frame true, x, y, width, height
    this

  ###
  Activate window
  ###
  activate: ->
    Main.activateWindow @window
    this

  ###
  Destory window
  ###
  destory: -> @window.destory()

modules.Window = Window
