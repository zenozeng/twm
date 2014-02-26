ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
spawn = helper.spawn
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
    "<Super>r": -> spawn "gnome-shell --replace" # reload gnome
    "<Super>t": -> layouts.apply "2-column"

  layouts: layouts

  windowsFilter: (wnckWindow) -> true

  workspaceNum: 8

  gjsServerPort: 56780
