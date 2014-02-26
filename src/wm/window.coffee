ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
Wnck = imports.gi.Wnck
Main = imports.ui.main
{delay, runGjsScript} = helper

class Window

  constructor: (@wnckWindow) ->
    global.twm.storage.windows = {} unless global.twm.storage.windows?
    global.twm.storage.windows[@getId()] = {} unless global.twm.storage.windows[@getId()]?
    storage = global.twm.storage.windows[@getId()]
    @storage =
      getItem: (key) -> storage[key]
      setItem: (key, value) -> storage[key] = value
      clear: =>
        # note that when use `storage = {}`
        # `storage` is no longer global.twm.storage.windows[@getId()]
        global.twm.storage.windows[@getId()] = {}

  ###
  Get ID (current xid used)
  ###
  getId: ->
    @wnckWindow.get_xid()

  ###
  Return client geometry
  ###
  getGeometry: ->
    [x, y, width, height] = @wnckWindow.get_client_window_geometry()
    {x: x, y: y, width: width, height: height}

  getTargetGeometry: -> @storage.getItem 'geometry'

  ###
  Set target geometry

  @example
    window.setTargetGeometry({x: x, y: y, width: width, height: height});
  ###
  setTargetGeometry: (geometry) -> @storage.setItem 'geometry', geometry

  ###
  Set window as float

  @note all storage related to this window will be cleared
  ###
  setFloat: ->
    @storage.clear()
    monitor = Main.layoutManager.currentMonitor
    width = monitor.width * 2 / 3
    height = monitor.height * 2 / 3
    @wnckWindow.set_geometry 0, (1 << 2) | (1 << 3), 0, 0, width, height
    runGjsScript "set-float", {xid: @wnckWindow.get_xid()}

  ###
  Return true if type of @wnckWindow is WNCK_WINDOW_NORMAL
  ###
  isNormalWindow: ->
    type = @wnckWindow.get_window_type()
    type is Wnck.WindowType.NORMAL

  ###
  remove title bar
  @note The window should be unmaximized before, which is done by setGeometry
  @note this gjs must be run outside, or the window might crash
  ###
  removeDecorations: ->
    if @storage.getItem('decorations') is false
      return false
    @storage.setItem 'decorations', false
    xid = @wnckWindow.get_xid()
    runGjsScript "set-decorations-0", {xid: xid}

  ###
  set geometry hints
  Overide WM_NORMAL_HINTS(WM_SIZE_HINTS)
  allow setting width & height using px (for Gnome Termianl, Emacs)
  @note the gjs must be run outside, or the window might crash
  ###
  setGeometryHints: ->
    if @storage.getItem('geometry-hints') is 'none'
      return false
    @storage.setItem 'geometry-hints', 'none'
    xid = @wnckWindow.get_xid()
    @wnckWindow.unmaximize()
    runGjsScript "set-geometry-hints", {xid: xid}

  ###
  geometry = {x: int, y: int, width: int, height: int}
  ###
  setGeometry: (geometry)->

    @wnckWindow.unmaximize() # unmaximize first, or will fail to set geometry
    {x, y, width, height} = geometry
    target = [x, y, width, height]

    @removeDecorations()
    @setGeometryHints()

    clientGeometry = @wnckWindow.get_client_window_geometry()
    windowGeometry = @wnckWindow.get_geometry()

    newTarget = []
    for index in [0..3]
      offset = target[index] - clientGeometry[index]
      newTarget[index] = offset + windowGeometry[index]
    [x, y, width, height] = newTarget

    WnckWindowMoveResizeMask = 15
    # use the left top corner of the client window as gravity point
    WNCK_WINDOW_GRAVITY_STATIC = 10
    @wnckWindow.set_geometry WNCK_WINDOW_GRAVITY_STATIC, WnckWindowMoveResizeMask, x, y, width, height
