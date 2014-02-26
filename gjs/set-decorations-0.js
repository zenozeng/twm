// This GJS script will remove all decoration

// You should unmaximize all windows before call this script
// otherwise the windows might crash
// They are not included by default because this might change active status of windows

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;
const GdkX11 = imports.gi.GdkX11;

const main = function(args) {
    let xid = args.xid;

    Gtk.init(null, 0);

    let gdkWindow = GdkX11.X11Window.foreign_new_for_display(Gdk.Display.get_default(), xid);
    gdkWindow.set_decorations(0);
    Gtk.main();
}