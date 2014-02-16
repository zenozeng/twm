const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;

Gtk.init(null, 0);
const gdkScreen = Gdk.Screen.get_default();
const gdkWindows = gdkScreen.get_window_stack();
const geometry = new Gdk.Geometry({});
gdkWindows.forEach(function(gdkWindow) {
    gdkWindow.set_geometry_hints(geometry, 1 << 5)
});
Gtk.main();
