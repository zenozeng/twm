// This GJS script will reset decoration to all

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;
const GdkX11 = imports.gi.GdkX11;

const main = function(args) {
    let xids = args.xids;

    Gtk.init(null, 0);

    const gdkWindows = xids.map(function(xid) {
        return GdkX11.X11Window.foreign_new_for_display(Gdk.Display.get_default(), xid);
    });

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
}
