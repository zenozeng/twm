Main = imports.ui.main
Wnck = imports.gi.Wnck
ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
Gdk = imports.gi.Gdk
GLib = imports.gi.GLib
WindowManager = Extension.imports.lib.windowManager.WindowManager

wm = new WindowManager

runGjsScript = (scriptName, args, callback) ->
  gjsDir = Extension.dir.get_path().toString() + '/gjs/'
  args = JSON.stringify args
  timestamp = (new Date()).getTime()
  gjs = "imports[\"#{scriptName}\"].main(#{args});//#{timestamp}"
  cmd = "gjs -c '#{gjs}' -I #{gjsDir}"
  spawn cmd

  gc = ->
    spawn "sh -c \"ps -ef | grep #{gjsDir} | grep #{timestamp} | awk '{print $2}' | xargs kill -9\""
    callback?()
  delay 1000, gc

{spawn, spawnSync, delay} = helper

class LayoutManager

  constructor: ->
    @layouts = {}
    @layoutOfWorkspace = {}

  ###
  Get Layout Func

  @param [String] layoutName Layout Name
  ###
  get: (layoutName) -> @layouts[layoutName]

  ###
  Set Layout Func

  @param [String] layoutName Layout Name
  @param [Function] layoutFunc Layout Function
  ###
  set: (layoutName, layoutFunc) -> @layouts[layoutName] = layoutFunc


  ###
  Unset Layout

  @param [String] layoutName Layout Name
  ###
  unset: (layoutName) -> @layouts[layoutName] = null


  ###
  List all avaliable layouts, returns an array like ["2-column", "3-column"]
  ###
  list: ->
    layouts = ["float"]
    for key, value of @layouts
      layouts.push key if value?
    layouts

  ###
  Get Layout of current workspace
  ###
  current: -> @layoutOfWorkspace[wm.getActiveWorkspace().get_name()]

  ###
  Apply Float Layout

  @private
  ###
  float: (wnckWindows, activeWindow) ->
    # get current active window
    activeWindowXid = if activeWindow? then activeWindow.get_xid() else null
    # reset width and height
    monitor = Main.layoutManager.primaryMonitor
    width = monitor.width * 2 / 3
    height = monitor.height * 2 / 3
    wnckWindows.forEach (wnckWindow) -> wnckWindow.set_geometry 0, (1 << 2) | (1 << 3), 0, 0, width, height
    # apply
    xids = wnckWindows.map (wnckWindow) -> wnckWindow.get_xid()
    runGjsScript "set-float", {xids: xids, activeWindowXid: activeWindowXid}

  ###
  Apply Layout

  @param [String] layoutName Layout Name
  @param [Function] filter Filter function which takes WnckWindow as param and returns false this window should be ignored
  ###
  apply: (layoutName, filter) ->

    screen = Wnck.Screen.get_default()
    screen.force_update()
    windows = screen.get_windows()
    currentWorkspace = screen.get_active_workspace()
    activeWindow = screen.get_active_window()

    @layoutOfWorkspace[currentWorkspace.get_name()] = layoutName

    windows = windows.filter (wnckWindow) ->
      # This will also checks if window is not minimized or shaded
      wnckWindow.is_visible_on_workspace(currentWorkspace)

    windows = windows.filter filter if filter?

    if layoutName is 'float'
      @float windows, activeWindow
      return null

    xids = windows.map (wnckWindow) -> wnckWindow.get_xid()

    # remove title bar
    # this code must be run outside, or the window might crash
    windows.forEach (wnckWindow) -> wnckWindow.unmaximize() # unmaximize to avoid carsh
    runGjsScript "set-decorations-0", {xids: xids}

    # set geometry hints
    # Overide WM_NORMAL_HINTS(WM_SIZE_HINTS)
    # allow setting width & height using px (for Gnome Termianl, Emacs)
    # this code must be run outside, or the window might crash
    runGjsScript "set-geometry-hints", {xids: xids}

    # get current active window
    refocus = ->
      if activeWindow?
        activeWindow.activate(helper.getXServerTimestamp())
      else
        false

    # set layout
    monitor = Main.layoutManager.primaryMonitor
    avaliableWidth = monitor.width
    avaliableHeight = monitor.height - Main.panel.actor.height

    layout = @get layoutName
    areas = layout windows.length

    setGeometry = (wnckWindow, geometry) ->
      wnckWindow.activate(helper.getXServerTimestamp()) # avoid last_focus_time (9747565) is greater than comparison timestamp message
      wnckWindow.unmaximize() # unmaximize first, or will fail to set geometry
      geometry = geometry.map (elem) -> Math.round elem
      [x, y, width, height] = geometry
      wnckWindow.set_geometry 0, 15, x, y, width, height

    updateWindows = ->

      windows.forEach (win, index) ->
        {x, y, width, height} = areas[index]
        x = x * avaliableWidth
        y = y * avaliableHeight
        width = width * avaliableWidth
        height = height * avaliableHeight

        clientWindowGeometry = win.get_client_window_geometry()
        windowGeometry = win.get_geometry()
        widthOffset = windowGeometry[2] - clientWindowGeometry[2]
        heightOffset = windowGeometry[3] - clientWindowGeometry[3]

        y -= 3 # border-radius of panel

        target = [x, y, width + widthOffset, height + heightOffset]
        setGeometry win, target

      refocus()

    updateWindows()
    delay 300, updateWindows
    delay 600, updateWindows
