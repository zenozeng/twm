const Main = imports.ui.main;
const MessageTray = imports.ui.messageTray;
const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;

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
    return {log: log, cat: cat};
})();

var eval = function(file) {

};


function init() {
    helper.log('hello world!!!');
    helper.cat('/home/zenozeng/.shadowsockslog');
}

function enable() {}

function disable() {}
