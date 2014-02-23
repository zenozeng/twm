#!/usr/bin/gjs

const xlib = imports.gi.xlib;
const ClutterX11 = imports.gi.ClutterX11;

const width = 500;
const height = 300;

let display = ClutterX11.get_default_display();


display = Xlib.display.Display()
root = display.screen().root
windowID = root.get_full_property(display.intern_atom('_NET_ACTIVE_WINDOW'), Xlib.X.AnyPropertyType).value[0]
window = display.create_resource_object('window', windowID)
window.configure(width = WIDTH, height = HEIGHT)
display.sync()