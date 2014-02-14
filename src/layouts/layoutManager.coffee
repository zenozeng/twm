Main = imports.ui.main
Wnck = imports.gi.Wnck
ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
GdkX11 = imports.gi.GdkX11
Gdk = imports.gi.Gdk

{spawnSync} = helper

class LayoutManager

  constructor: -> @layouts = {}

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
  Apply Layout

  @param [String] layoutName Layout Name
  @param [Function] filter Filter function which takes WnckWindow as param and returns false this window should be ignored
  ###
  apply: (layoutName, filter) ->

    global.log layoutName

    screen = Wnck.Screen.get_default()
    windows = screen.get_windows()
    currentWorkspace = screen.get_active_workspace()

    windows = windows.filter (wnckWindow) ->
      # This will also checks if window is not minimized or shaded
      wnckWindow.is_visible_on_workspace(currentWorkspace)

    windows = windows.filter filter if filter?

    global.xwins = []

    # remove title bar
    # @see http://mathematicalcoffee.blogspot.com/2012/05/automatically-undecorate-maximised.html
    windows.forEach (wnckWindow) ->
      xid = wnckWindow.get_xid()
      spawnSync 'xprop -id ' + xid + ' -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"'

    # set geometry hints
    # Overide WM_NORMAL_HINTS(WM_SIZE_HINTS)
    # allow setting width & height using px (for Gnome Termianl, Emacs)
    gdkScreen = Gdk.Screen.get_default()
    gdkWindows = gdkScreen.get_window_stack()
    gdkWindows.forEach (gdkWindow) ->
      geometry = new Gdk.Geometry({})
      gdkWindow.set_geometry_hints(geometry, 1 << 5)

    # set layout

    monitor = Main.layoutManager.primaryMonitor
    avaliableWidth = monitor.width
    avaliableHeight = monitor.height - Main.panel.actor.height

    layout = @get layoutName
    areas = layout windows.length

    setGeometry = (wnckWindow, geometry) ->
      global.log geometry
      wnckWindow.unmaximize() # unmaximize first, or will fail to set geometry
      geometry = geometry.map (elem) -> parseInt elem
      [x, y, width, height] = geometry
      wnckWindow.set_geometry 0, 15, x, y, width, height

    windows.forEach (win, index) ->
      {x, y, width, height} = areas[index]
      x = x * avaliableWidth
      y = y * avaliableHeight
      width = width * avaliableWidth
      height = height * avaliableHeight

      clientWindowGeometry = win.get_client_window_geometry()
      windowGeometry = win.get_geometry()

      heightOffset = windowGeometry[3] - clientWindowGeometry[3]

      y -= 3 # border-radius of panel
      height += 3

      # workround for emacs
      # if win.get_class_instance_name() is 'emacs'
      #   width += 3
      #   height += 3
      #   x -= 1

      target = [x, y, width, height + heightOffset]
      setGeometry win, target

      # fix
      # actual = win.get_client_window_geometry()
      # helper.log ["actual", actual]
      # newTarget = [0, 0, 0, 0]
      # newTarget = newTarget.map (elem, index) ->
      #   offset = parseInt(target[index]) - parseInt(actual[index])
      #   offset + target
      # setGeometry win, newTarget

  ###
  List all avaliable layouts, returns an array like ["2-column", "3-column"]
  ###
  list: ->
    layouts = []
    for key, value of @layouts
      layouts.push key if value?
    layouts
