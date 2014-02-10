ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
spawn = helper.spawn
Window = Extension.imports.api.window.Window
layouts = Extension.imports.layouts.layouts

defalutConfig =

  keybindings:
    "<Super>e": -> spawn "emacsclient -c"
    "<Super>c": -> spawn "google-chrome"
    "<Super>l": -> Main.lookingGlass.toggle()
    "<Super>Return": -> spawn "gnome-terminal"
    "<Super>k": -> (new Window()).current().destroy()
    "<Super>r": -> init() # reload this extension

  layouts: layouts.list()

  onWindowChange: -> false

class Config

  constructor: ->

    HOME = helper.spawnSync "sh -c 'echo $HOME'"
    PATH = (HOME + '/.twm').replace('\n', '')
    helper.log PATH
    imports.searchPath.push PATH

    config = imports.twm.config

    helper.log config

  ###
  Cp config/defalut.js to ~/.twm/twm.js

  @private
  ###
  create: -> false
