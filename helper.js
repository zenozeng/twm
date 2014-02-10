const Main = imports.ui.main;
const MessageTray = imports.ui.messageTray;
const GLib = imports.gi.GLib;
const ExtensionUtils = imports.misc.extensionUtils;
const Extension = ExtensionUtils.getCurrentExtension();

var log = function(text) {
    if(typeof text !== "string") {
        text = JSON.stringify(text);
    }
    let source = new MessageTray.SystemNotificationSource();
    Main.messageTray.add(source);
    let notification = new MessageTray.Notification(source, text, null);
    notification.setTransient(true);
    source.notify(notification);
};

var spawn = function(cmd) {
    GLib.spawn_command_line_async(cmd);
};

var spawnSync = function(cmd) {
    try {
        var result = GLib.spawn_command_line_sync(cmd);
        if(result[0])
          return result[1].toString();
        else
          log(result);
          return null
    } catch(e) {
        log(e);
    }
};