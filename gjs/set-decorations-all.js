// This GJS script will reset decoration to all

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;

Gtk.init(null, 0);
const gdkScreen = Gdk.Screen.get_default();
const gdkWindows = gdkScreen.get_window_stack();

throw(new Error(gdkWindows.length));

const GDK_DECOR_ALL = 1 << 0;
const GDK_DECOR_BORDER = 1 << 1;
const GDK_DECOR_RESIZEH = 1 << 2;
const GDK_DECOR_TITLE = 1 << 3;
const GDK_DECOR_MENU = 1 << 4;
const GDK_DECOR_MINIMIZE = 1 << 5;
const GDK_DECOR_MAXIMIZE = 1 << 6;

gdkWindows.forEach(function(gdkWindow) {
    let GdkWMDecoration = GDK_DECOR_MENU;
    gdkWindow.unmaximize();
    gdkWindow.set_decorations(GDK_DECOR_ALL);
    // reset window status so there won't be strange thing on the corner
    gdkWindow.maximize();
    let timestamp = parseInt((new Date()).getTime()/1000);
    gdkWindow.focus(timestamp);
    // GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, function() {
    //     gdkWindow.unmaximize();
    // });
});
Gtk.main();
