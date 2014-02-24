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
    @layoutOfWorkspace[@layoutKeygen()]

  ###
  Apply Float Layout

  @private
  ###
  float: (wnckWindows) ->
    # get current active window
    # activeWindowXid = if activeWindow? then activeWindow.get_xid() else null

    windows = wnckWindows.map (wnckWindow) -> new Window(wnckWindow)
    windows.forEach (window) -> window.setFloat()


  ###
  Apply Layout

  @param [String] layoutName Layout Name
  ###
  apply: (layoutName) ->

    windows = wm.getWindows()
    currentWorkspace = wm.getActiveWorkspace()

    @layoutOfWorkspace[@layoutKeygen()] = layoutName

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

    windows = windows.filter (wnckWindow) ->
      _window = new Window(wnckWindow)
      _window.isNormalWindow()

    if layoutName is 'float'
      @float windows
      return null

    # set layout
    primaryMonitor = Main.layoutManager.primaryMonitor
    panelHeight = Main.panel.actor.height

    avaliableWidth = monitor.width
    avaliableHeight = monitor.height

    if monitor is primaryMonitor
      avaliableHeight -= panelHeight

    layout = @get layoutName
    areas = layout windows.length

    updateWindows = ->

      windows.forEach (win, index) ->

        {x, y, width, height} = areas[index]

        x = x * avaliableWidth + monitor.x
        y = y * avaliableHeight + monitor.y

        if monitor is primaryMonitor
          y += panelHeight

        width = width * avaliableWidth
        height = height * avaliableHeight

        [x, y, width, height] = [x, y, width, height].map (elem) -> Math.round(elem)

        _window = new Window(win)
        _window.setTargetGeometry {x: x, y: y, width: width, height: height}

    updateWindows()
