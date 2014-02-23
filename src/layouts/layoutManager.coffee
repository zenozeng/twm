Main = imports.ui.main
Wnck = imports.gi.Wnck
ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
WindowManager = Extension.imports.wm.windowManager.WindowManager
Window = Extension.imports.wm.window.Window

wm = new WindowManager

{spawn, spawnSync, delay, runGjsScript} = helper

class LayoutManager

  constructor: ->
    @layouts = {}
    @layoutOfWorkspace = {}

  reapply: (shouldFocus) ->
    currentLayout = @current()
    if currentLayout? and currentLayout isnt 'float'
      @apply currentLayout, shouldFocus

  init: ->
    wm.connect "window-opened", (wnckScreen, wnckWindow) =>
      currentWorkspace = wm.getActiveWorkspace()
      if wnckWindow.is_visible_on_workspace currentWorkspace
        @reapply(wnckWindow)

    wm.connect "window-closed", (wnckScreen, wnckWindow) =>
      currentWorkspace = wm.getActiveWorkspace()
      if wnckWindow.is_visible_on_workspace currentWorkspace
        @reapply()
      null

    # some window may change size when focused
    # so reapply
    wm.connect "active-window-changed", => @reapply()

  # filter fn
  filter: (window) ->
    true

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
  @private
  ###
  layoutKeygen: ->
    monitor = Main.layoutManager.currentMonitor
    primaryMonitor = Main.layoutManager.primaryMonitor
    if monitor is primaryMonitor
      wm.getActiveWorkspace().get_name()
    else
      "Monitor:(#{monitor.x}, #{monitor.y})"

  ###
  Get Layout of current workspace
  ###
  current: ->
    global.log JSON.stringify(@layoutOfWorkspace)
    @layoutOfWorkspace[@layoutKeygen()]

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
  apply: (layoutName, activeWindow = wm.getActiveWindow()) ->

    windows = wm.getWindows()
    currentWorkspace = wm.getActiveWorkspace()

    @layoutOfWorkspace[@layoutKeygen()] = layoutName

    global.layouts = @layoutOfWorkspace

    windows = windows.filter (wnckWindow) ->
      # This will also checks if window is not minimized or shaded
      wnckWindow.is_visible_on_workspace(currentWorkspace)

    monitor = Main.layoutManager.currentMonitor

    # only handle windows in current monitor
    windows = windows.filter (wnckWindow) ->
      clientGeometry = wnckWindow.get_client_window_geometry()
      [x, y, width, height] = clientGeometry
      x = x + width * 0.5
      y = y + height * 0.5
      xMatch = (x >= monitor.x) && (x < (monitor.width + monitor.x))
      yMatch = (y >= monitor.y) && (y < (monitor.height + monitor.y))
      xMatch && yMatch

    windows.forEach (wnckWindow) ->
      global.log wnckWindow.get_name()

    windows = windows.filter (wnckWindow) ->
      _window = new Window(wnckWindow)
      _window.isNormalWindow()

    if layoutName is 'float'
      @float windows, activeWindow
      return null

    xids = windows.map (wnckWindow) -> wnckWindow.get_xid()

    refocus = ->
      if activeWindow?
        activeWindow.activate(helper.getXServerTimestamp())
      else
        false

    # set layout
    primaryMonitor = Main.layoutManager.primaryMonitor
    panelHeight = Main.panel.actor.height

    avaliableWidth = monitor.width
    avaliableHeight = monitor.height

    if monitor is primaryMonitor
      avaliableHeight -= panelHeight

    layout = @get layoutName
    areas = layout windows.length

    updateWindows = =>

      windows.forEach (win, index) ->
        {x, y, width, height} = areas[index]
        x = x * avaliableWidth + monitor.x
        y = y * avaliableHeight + monitor.y

        if monitor is primaryMonitor
          y += panelHeight

        width = width * avaliableWidth
        height = height * avaliableHeight

        _window = new Window(win)
        geometry = {x: x, y: y, width: width, height: height}
        _window.setGeometry geometry, refocus

    updateWindows()
