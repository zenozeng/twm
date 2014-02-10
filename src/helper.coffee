Main = imports.ui.main
MessageTray = imports.ui.messageTray
GLib = imports.gi.GLib

log = (text) ->
  unless typeof text is "string"
    text = JSON.stringify(text)
  source = new MessageTray.SystemNotificationSource()
  Main.messageTray.add(source)
  notification = new MessageTray.Notification(source, text, null)
  notification.setTransient(true)
  source.notify(notification)

spawn = (cmd) -> GLib.spawn_command_line_async(cmd)

spawnSync = (cmd) ->
  result = GLib.spawn_command_line_sync(cmd)
  if(result[0])
     result[1].toString()
  else
     log(result)

delay = (time, callback) ->
  GLib.timeout_add GLib.PRIORITY_DEFAULT, time, -> callback?()
