ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()

class Layouts

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
  List all avaliable layouts, returns an array like ["2-column", "3-column"]
  ###
  list: ->
    layouts = []
    layouts.push key for key, value of @layouts
    layouts

layouts = new Layouts
layouts.set "2-column", Extension.imports.layouts.2-column.layout
layouts.set "3-column", Extension.imports.layouts.3-column.layout
