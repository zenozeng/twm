ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
spawn = helper.spawn
Window = Extension.imports.api.window.Window
layouts = Extension.imports.layouts.layouts.layouts

config =

  keybindings:
    "<Super>e": -> spawn "emacsclient -c"
    "<Super>c": -> spawn "google-chrome"
    "<Super>l": -> Main.lookingGlass.toggle()
    "<Super>Return": -> spawn "gnome-terminal"
    "<Super>k": -> (new Window()).current().destroy()
    "<Super>r": -> spawn "gnome-shell --replace" # reload gnome
    "<Super>t": -> false

  layouts: layouts.list()

  onWindowChange: -> false

  windowsFilter: (win) -> true
