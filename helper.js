// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, GLib, Main, MessageTray, delay, getXServerTimestamp, log, runGjsScript, spawn, spawnSync;

Main = imports.ui.main;

MessageTray = imports.ui.messageTray;

GLib = imports.gi.GLib;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

log = function(text) {
  var notification, source;
  if (typeof text !== "string") {
    text = JSON.stringify(text);
  }
  source = new MessageTray.SystemNotificationSource();
  Main.messageTray.add(source);
  notification = new MessageTray.Notification(source, text, null);
  notification.setTransient(true);
  return source.notify(notification);
};

spawn = function(cmd) {
  return GLib.spawn_command_line_async(cmd);
};

spawnSync = function(cmd) {
  var result;
  result = GLib.spawn_command_line_sync(cmd);
  if (result[0]) {
    return result[1].toString();
  } else {
    return log(result);
  }
};

delay = function(time, callback) {
  return GLib.timeout_add(GLib.PRIORITY_DEFAULT, time, function() {
    if (typeof callback === "function") {
      callback();
    }
    return false;
  });
};

getXServerTimestamp = function() {
  return parseInt(GLib.get_monotonic_time() / 1000);
};

runGjsScript = function(scriptName, args, callback) {
  var cmd, gc, gjs, gjsDir, timestamp;
  gjsDir = Extension.dir.get_path().toString() + '/gjs/';
  args = JSON.stringify(args);
  timestamp = (new Date()).getTime();
  gjs = "imports[\"" + scriptName + "\"].main(" + args + ");//" + timestamp;
  cmd = "gjs -c '" + gjs + "' -I " + gjsDir;
  spawn(cmd);
  gc = function() {
    spawn("sh -c \"ps -ef | grep " + gjsDir + " | grep " + timestamp + " | awk '{print $2}' | xargs kill -9\"");
    return typeof callback === "function" ? callback() : void 0;
  };
  return delay(1000, gc);
};
