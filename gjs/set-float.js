// This GJS script will reset decoration to all
// And will auto activate the last active window

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;
const GdkX11 = imports.gi.GdkX11;

const main = function(args) {
    let xid = args.xid;

    Gtk.init(null, 0);

    let gdkWindow = GdkX11.X11Window.foreign_new_for_display(Gdk.Display.get_default(), xid);

    const GDK_DECOR_ALL = 1 << 0;
    const GDK_DECOR_BORDER = 1 << 1;
    const GDK_DECOR_RESIZEH = 1 << 2;
    const GDK_DECOR_TITLE = 1 << 3;
    const GDK_DECOR_MENU = 1 << 4;
    const GDK_DECOR_MINIMIZE = 1 << 5;
    const GDK_DECOR_MAXIMIZE = 1 << 6;

    // reset decorations
    let GdkWMDecoration = GDK_DECOR_MENU;
    gdkWindow.unmaximize();
    gdkWindow.hide(); // otherwise gnome-shell will freeze
    gdkWindow.set_decorations(GDK_DECOR_ALL);
    gdkWindow.show();

    Gtk.main();
}
