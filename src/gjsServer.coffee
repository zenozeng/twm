###
Gjs Daemon Server using Gio.SocketService

@see https://developer.gnome.org/gio/2.38/
###

# imports
Gio = imports.gi.Gio

###########################
#
# Server
#
###########################

# init server
gjsServer = new Gio.SocketService
inetAddress = new Gio.InetAddress.new_from_string('127.0.0.1')
socketAddress = new Gio.SocketAddress inetAddress
gjsServer.add_address socketAddress, 56780

# bind events
gjsServer.connect 'incoming', (socketService, socketConnection) ->

call = (scriptName, argsJSON) -> false

###########################
#
# Scripts
#
###########################

scripts = {}

_getGdkWindow = (xid) -> GdkX11.X11Window.foreign_new_for_display(Gdk.Display.get_default(), xid)

setFloat = (xid) ->
  Gtk.init(null, 0)
  gdkWindow = _getGdkWindow xid
  gdkWindow.hide()
  gdkWindow.set_decorations(0)
  gdkWindow.show()
  Gtk.main();

scripts.setFloat = setFloat

# g_socket_client_connect_to_uri ()
# https://developer.gnome.org/gio/2.38/GSocketClient.html#g-socket-client-connect-to-uri
