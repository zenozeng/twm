Main = imports.ui.main

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
  ###
  apply: (layoutName, windows) ->

    # remove title bar
    windows.forEach (win) -> win.setDecorated false

    monitor = Main.layoutManager.primaryMonitor
    avaliableWidth = monitor.width
    avaliableHeight = monitor.height - Main.panel.actor.height

    layout = @get layoutName
    areas = layout windows.length

    windows.forEach (win, index) ->
      {x, y, width, height} = areas[index]
      x = x * avaliableWidth
      y = y * avaliableHeight
      width = width * avaliableWidth
      height = height * avaliableHeight
      # helper.log {x: x, y: y, width: width, height: height}
      win.setArea x, y, width, height


  ###
  List all avaliable layouts, returns an array like ["2-column", "3-column"]
  ###
  list: ->
    layouts = []
    for key, value of @layouts
      layouts.push key if value?
    layouts
