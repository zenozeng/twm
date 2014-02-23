// This GJS script will remove all decoration

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;
const GdkX11 = imports.gi.GdkX11;

const delay = function(time, callback) {
  return GLib.timeout_add(GLib.PRIORITY_DEFAULT, time, function() {
    return typeof callback === "function" ? callback() : void 0;
  });
};


const main = function(args) {
    let windows = args.windows;

    Gtk.init(null, 0);

    windows.forEach(function(win) {
        let gdkWindow = GdkX11.X11Window.foreign_new_for_display(Gdk.Display.get_default(), win.xid);
        gdkWindow.hide(); // hide to avoid carsh
        gdkWindow.set_decorations(0);
        gdkWindow.show();
        gdkWindow.move_resize(win.x, win.y, win.width, win.height);
    });
    Gtk.main();
}
