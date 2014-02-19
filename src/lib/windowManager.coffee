Wnck = imports.gi.Wnck

class WindowManager

  constructor: ->
    screen = Wnck.Screen.get_default()

    screen.force_update()
    @activeWindow = screen.get_active_window()
    @activeWorkspace = screen.get_active_workspace()
    @windows = screen.get_windows()

    screen.connect "window-closed", (wnckScreen, wnckWindow) =>
      xid = wnckWindow.get_xid()
      @windows = @windows.filter (wnckWindow) -> wnckWindow.get_xid() isnt xid
      @emit "window-closed", [wnckScreen, wnckWindow]
    screen.connect "window-opened", (wnckScreen, wnckWindow) =>
      @windows.push wnckWindow
      @emit "window-opened", [wnckScreen, wnckWindow]
    screen.connect "active-window-changed", (wnckScreen, wnckWindow) =>
      @activeWindow = wnckWindow
      @emit "active-window-changed", [wnckScreen, wnckWindow]
    screen.connect "active-workspace-changed", (wnckScreen, wnckWorkspace) =>
      @activeWorkspace = wnckWorkspace
      @emit "active-workspace-changed", [wnckScreen, wnckWorkspace]

    @events = {}

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
