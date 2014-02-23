Main = imports.ui.main
MessageTray = imports.ui.messageTray
GLib = imports.gi.GLib
ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()

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
  # The glib.timeout_add() function sets a function (specified by callback) to
  # be called at regular intervals (specified by interval, with the default
  # priority, glib.PRIORITY_DEFAULT. Additional arguments to pass to callback
  # can be specified after callback. The idle priority may be specified as
  # a keyword-value pair with the keyword "priority".

  # The function is called repeatedly until it returns False, at which point the
  # timeout is automatically destroyed and the function will not be called again.
  # The first call to the function will be at the end of the first interval.
  # Note that timeout functions may be delayed, due to the processing of other
  # event sources. Thus they should not be relied on for precise timing. After
  # each call to the timeout function, the time of the next timeout is
  # recalculated based on the current time and the given interval (it does not
  # try to 'catch up' time lost in delays).
  GLib.timeout_add GLib.PRIORITY_DEFAULT, time, ->
    callback?()
    false # destory the interval

getXServerTimestamp = -> parseInt(GLib.get_monotonic_time()/1000)


runGjsScript = (scriptName, args, callback) ->
  gjsDir = Extension.dir.get_path().toString() + '/gjs/'
  args = JSON.stringify args
  timestamp = (new Date()).getTime()
  gjs = "imports[\"#{scriptName}\"].main(#{args});//#{timestamp}"
  cmd = "gjs -c '#{gjs}' -I #{gjsDir}"
  spawn cmd

  gc = ->
    spawn "sh -c \"ps -ef | grep #{gjsDir} | grep #{timestamp} | awk '{print $2}' | xargs kill -9\""
    callback?()
  delay 1000, gc

