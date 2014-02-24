Wnck = imports.gi.Wnck
GLib = imports.gi.GLib

###
About wnck_screen_force_update ()

Synchronously and immediately updates the list of WnckWindow on screen. This bypasses the standard update mechanism, where the list of WnckWindow is updated in the idle loop.

This is usually a bad idea for both performance and correctness reasons (to get things right, you need to write model-view code that tracks changes, not get a static list of open windows). However, this function can be useful for small applications that just do something and then exit.
###

###
Window Manager
###
class WindowManager

  constructor: ->
    # 单例模式
    if(WindowManager.instance?)
      return WindowManager.instance
    WindowManager.instance = this

    global.log "Construct!!!"


    @screen = Wnck.Screen.get_default()
    @forceUpdate()

    @activeWindow = @screen.get_active_window()
    @activeWorkspace = @screen.get_active_workspace()
    @windows = @screen.get_windows()

    @screen.connect "window-closed", (wnckScreen, wnckWindow) =>
      xid = wnckWindow.get_xid()
      @windows = @windows.filter (wnckWindow) -> wnckWindow.get_xid() isnt xid
      @emit "window-closed", [wnckScreen, wnckWindow]
    @screen.connect "window-opened", (wnckScreen, wnckWindow) =>
      @windows.push wnckWindow
      @emit "window-opened", [wnckScreen, wnckWindow]
    @screen.connect "active-window-changed", (wnckScreen, prevWnckWindow) =>
      @activeWindow = @screen.get_active_window()
      @emit "active-window-changed", [wnckScreen, prevWnckWindow]
    @screen.connect "active-workspace-changed", (wnckScreen, prevWnckWorkspace) =>
      @activeWorkspace = @screen.get_active_workspace()
      @emit "active-workspace-changed", [wnckScreen, prevWnckWorkspace]

    @storage = {}
    @events = {}

    return this

  ###
  Get all visible windows in current workspace (in all monitors)
  ###
  getVisibleWindows: ->
    windows = @windows.filter (wnckWindow) =>
      # This will also checks if window is not minimized or shaded
      wnckWindow.is_visible_on_workspace(@currentWorkspace)
    windows.map (wnckWindow) -> new Window(wnckWindow)


  ###
  @private
  ###
  setGeometryInterval: ->
    GLib.timeout_add GLib.PRIORITY_DEFAULT, 20, =>
      visibleWindows = @getVisibleWindows()
      # check Geometry
      visibleWindows.forEach (window) ->
        geometry = window.getTargetGeometry()
      # nerver destory the interval
      true


  ###
  Return true if the (Window) window should be ignored
  ###
  ignore: (window) ->
    return true unless window.isNormalWindow()
    false


  forceUpdate: -> @screen.force_update()

  ###
  Bind event

  @param [String] event Event name
  @param [Function] callback callback
  ###
  connect: (event, callback) ->
    @events[event] = [] unless @events[event]
    @events[event].push callback

  ###
  Emit event

  @param [String] event Event name
  @param [Array] args Args for callback
  @private
  ###
  emit: (event, args) ->
    callbacks = @events[event] or []
    for callback in callbacks
      callback.apply this, args

  ###
  Get active window (Wnck Window)

  @see https://developer.gnome.org/libwnck/stable/WnckWindow.html
  ###
  getActiveWindow: -> @activeWindow

  ###
  Get active workspace (Wnck Workspace)

  @see https://developer.gnome.org/libwnck/stable/WnckWorkspace.html
  ###
  getActiveWorkspace: -> @activeWorkspace

  ###
  Get an array of all windows of current screen (Wnck Window)

  @see https://developer.gnome.org/libwnck/stable/WnckWindow.html
  ###
  getWindows: -> @windows
