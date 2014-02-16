Main = imports.ui.main
Wnck = imports.gi.Wnck
ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
Gdk = imports.gi.Gdk

runGjsScript = (scriptName) ->
  fileName = "gjs/#{scriptName}.js"
  file = Extension.dir.get_path().toString() + '/' + fileName
  spawn "gjs #{file}"
  delay 1000, -> # kill the process
    spawn "sh -c \"ps -ef | grep #{fileName} | awk '{print $2}' | xargs kill -9\""

{spawn, spawnSync, delay} = helper

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
  Apply Float Layout

  @private
  ###
  float: (wnckWindows) ->
    global.log 'float!!!!'
    runGjsScript "set-decorations-all"

  ###
  Apply Layout

  @param [String] layoutName Layout Name
  @param [Function] filter Filter function which takes WnckWindow as param and returns false this window should be ignored
  ###
  apply: (layoutName, filter) ->

    screen = Wnck.Screen.get_default()
    windows = screen.get_windows()
    currentWorkspace = screen.get_active_workspace()

    windows = windows.filter (wnckWindow) ->
      # This will also checks if window is not minimized or shaded
      wnckWindow.is_visible_on_workspace(currentWorkspace)

    windows = windows.filter filter if filter?

    if layoutName is 'float'
      @float windows
      return null

    # remove title bar
    # this code must be run outside, or the window might crash
    runGjsScript "set-decorations-0"

    # set geometry hints
    # Overide WM_NORMAL_HINTS(WM_SIZE_HINTS)
    # allow setting width & height using px (for Gnome Termianl, Emacs)
    # this code must be run outside, or the window might crash
    runGjsScript "set-geometry-hints"

    # set layout
    monitor = Main.layoutManager.primaryMonitor
    avaliableWidth = monitor.width
    avaliableHeight = monitor.height - Main.panel.actor.height

    layout = @get layoutName
    areas = layout windows.length

    setGeometry = (wnckWindow, geometry) ->
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

    updateWindows()
    delay 300, updateWindows
    delay 600, updateWindows

  ###
  List all avaliable layouts, returns an array like ["2-column", "3-column"]
  ###
  list: ->
    layouts = []
    for key, value of @layouts
      layouts.push key if value?
    layouts
