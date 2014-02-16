const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;
const GdkX11 = imports.gi.GdkX11;

const main = function(args) {
    let xids = args.xids;

    Gtk.init(null, 0);

    let gdkWindows = xids.map(function(xid) {
        return GdkX11.X11Window.foreign_new_for_display(Gdk.Display.get_default(), xid);
    });
    let geometry = new Gdk.Geometry({});
    gdkWindows.forEach(function(gdkWindow) {
        gdkWindow.set_geometry_hints(geometry, 1 << 5)
    });
    Gtk.main();
}
