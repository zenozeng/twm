const Main = imports.ui.main;
const MessageTray = imports.ui.messageTray;
const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;
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

var cat = function(filename, callback) {

    // relative path support
    var userExtensionsPath = Extension.dir.get_path('.') + '/';
    if(filename.indexOf('/') !== 0) {
        filename = userExtensionsPath + filename;
    }

    let loop = GLib.MainLoop.new(null, false);
    let f = Gio.file_new_for_path(filename);
    f.load_contents_async(null, function(f, res) {
        let contents;
        try {
            contents = f.load_contents_finish(res)[1];
        } catch (e) {
            log("ERROR: "+ filename + ": " + e.message);
            loop.quit();
            return;
        }
        callback(contents.toString());
        loop.quit();
    });
    loop.run();
};

var exec = function(file, callback) {
    cat(file, function(content) {
        try {
            if(file.split('.').pop() === 'coffee') {
                content = CoffeeScript.compile(content);
            }
            // fix window.attachEvent for Coffee Compiler
            var window = {};
            window.attachEvent = function() {};
            // do not use (Function(content))() directly
            // or the variables may not be exposed.
            eval("(function() {"+content+"})()");
        } catch(e) {
            log("Error in "+file+": "+e);
        }
        if(callback) {
            callback();
        }
    });
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