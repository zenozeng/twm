// This GJS script will remove all decoration

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;

Gtk.init(null, 0);
const gdkScreen = Gdk.Screen.get_default();
const gdkWindows = gdkScreen.get_window_stack();

const GDK_DECOR_ALL = 1 << 0;
const GDK_DECOR_BORDER = 1 << 1;
const GDK_DECOR_RESIZEH = 1 << 2;
const GDK_DECOR_TITLE = 1 << 3;
const GDK_DECOR_MENU = 1 << 4;
const GDK_DECOR_MINIMIZE = 1 << 5;
const GDK_DECOR_MAXIMIZE = 1 << 6;

gdkWindows.forEach(function(gdkWindow) {
    let GdkWMDecoration = GDK_DECOR_MENU;
    gdkWindow.unmaximize(); // will carsh without this
    gdkWindow.set_decorations(0);
});
Gtk.main();
