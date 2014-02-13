ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
spawn = helper.spawn
Window = Extension.imports.api.window.Window
LayoutManager = Extension.imports.layouts.layoutManager.LayoutManager

layouts = new LayoutManager
layouts.set "2-column", Extension.imports.layouts["2-column"].layout
layouts.set "3-column", Extension.imports.layouts["3-column"].layout

config =

  keybindings:
    "<Super>e": -> spawn "emacsclient -c"
    "<Super>c": -> spawn "google-chrome"
    "<Super>l": -> Main.lookingGlass.toggle()
    "<Super>Return": -> spawn "gnome-terminal"
    "<Super>k": -> (new Window()).current().close()
    "<Super>r": -> spawn "gnome-shell --replace" # reload gnome
    "<Super>t": -> layouts.apply "2-column"

  layouts: layouts

  onWindowChange: -> false

  windowsFilter: (win) -> true
