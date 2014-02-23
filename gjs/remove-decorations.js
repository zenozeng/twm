#!/usr/bin/gjs

// This GJS script will remove all decoration

// ./remove-decorations.js '{"xid": "0x1800144"}'

// You should unmaximize all windows before call this script
// otherwise the windows might crash
// They are not included by default because this might change active status of windows

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GLib = imports.gi.GLib;
const GdkX11 = imports.gi.GdkX11;
const console = {
    log: function(msg) {
        throw new Error(msg);
    }
}

const ARGS = JSON.parse(ARGV);

let xid = parseInt(ARGS.xid);


Gtk.init(null, 0);

let gdkWindow = GdkX11.X11Window.foreign_new_for_display(Gdk.Display.get_default(), xid);
gdkWindow.hide(); // hide to avoid carsh
// This might cause last_focus_time greater than comparison timestamp
gdkWindow.set_decorations(0);
gdkWindow.show();
Gtk.main();
