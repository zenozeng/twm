Gtk = imports.gi.Gtk;
# Initialize the gtk
Gtk.init(null, 0);

log = (msg) -> throw msg

Wnck = imports.gi.Wnck

screen = Wnck.Screen.get_default()

windows = screen.get_windows()
currentWorkspace = screen.get_active_workspace()

windows = windows.filter (wnckWindow) ->
  # This will also checks if window is not minimized or shaded
  wnckWindow.is_visible_on_workspace(currentWorkspace)



log windows.length

windows[0].set_geometry 0, 15, 0, 0, 683, 768 - 27
windows[1].set_geometry 0, 15, 683, 0, 683, 768 - 27
