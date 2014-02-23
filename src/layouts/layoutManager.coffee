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
  apply: (layoutName, filter, activeWindow = wm.getActiveWindow()) ->

    windows = wm.getWindows()
    currentWorkspace = wm.getActiveWorkspace()

    @layoutOfWorkspace[currentWorkspace.get_name()] = layoutName

    windows = windows.filter (wnckWindow) ->
      # This will also checks if window is not minimized or shaded
      wnckWindow.is_visible_on_workspace(currentWorkspace)

    windows = windows.filter filter if filter?

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
    monitor = Main.layoutManager.primaryMonitor
    avaliableWidth = monitor.width
    avaliableHeight = monitor.height - Main.panel.actor.height

    layout = @get layoutName
    areas = layout windows.length

    updateWindows = =>

      windows.forEach (win, index) ->
        {x, y, width, height} = areas[index]
        x = x * avaliableWidth
        y = y * avaliableHeight
        width = width * avaliableWidth
        height = height * avaliableHeight

        y += 27

        _window = new Window(win)
        geometry = {x: x, y: y, width: width, height: height}
        _window.removeDecorations()
        _window.setGeometryHints()
        _window.setGeometry geometry

    updateWindows()
