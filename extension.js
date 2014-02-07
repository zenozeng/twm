const Main = imports.ui.main;
const MessageTray = imports.ui.messageTray;
const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;

var uuid = 'twma@zenozeng.com';

var helper = (function() {
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
        var userExtensionsPath = GLib.build_filenamev([global.userdatadir, 'extensions/'+uuid+'/']);
        if(filename.indexOf('/') !== 0) {
            filename = userExtensionsPath + filename;
        }

        log(filename);

        let loop = GLib.MainLoop.new(null, false);
        let f = Gio.file_new_for_path(filename);
        f.load_contents_async(null, function(f, res) {
            let contents;
            try {
                contents = f.load_contents_finish(res)[1];
            } catch (e) {
                log("*** ERROR: " + e.message);
                loop.quit();
                return;
            }
            callback(contents.toString());
            loop.quit();
        });
        loop.run();
    };
    var exec = function() {
    };
    return {log: log, cat: cat, exec: exec};
})();

var exec = function(file) {
    helper.log(userExtensionsDir);
};


function init() {
    helper.cat('/home/zenozeng/.shadowsockslog', function(data) {
        helper.log(data);
    });
    helper.cat('test.coffee', function(data) {
        helper.log(data);
    });
    // todo: livereload config file
}

function enable() {}

function disable() {}
