// Generated by CoffeeScript 1.7.1

/*
A dirty Hack for Keybinding API

Use dconf-editor for debug
 */
var Extension, ExtensionUtils, add, apply, commands, fnIndex, helper, spawn;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

spawn = helper.spawn;

commands = {};

fnIndex = 0;


/*
Add a keybinding

@example Assign <Super>+G to lunch google-chrome
  var keybindings = modules.keybindings;
  var spawn = modules.spawn;
  var callback = function() {
    spawn("google-chrome");
  };
  keybindings.add("<Super>c", callback);

@param [String] keybinding the keybinding string
@param [Function] callback the function to be called when keydown
 */

add = function(keybinding, callback) {
  var cmd, fn;
  fnIndex++;
  fn = "fn" + fnIndex;
  global.twm.functions[fn] = function() {
    var e;
    try {
      return typeof callback === "function" ? callback() : void 0;
    } catch (_error) {
      e = _error;
      return helper.log(e.toString());
    }
  };
  cmd = "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'global.twm.functions[\\\"" + fn + "\\\"]()'";
  return commands[keybinding] = cmd;
};


/*
Apply keybindings, should be called after all keybindings was added.
Config are written using gsettings.

@private
 */

apply = function() {
  var cmd, cmds, customs, i, keybinding, _i, _j, _ref, _ref1, _results, _results1;
  cmds = [];
  for (keybinding in commands) {
    cmd = commands[keybinding];
    cmds.push([cmd, keybinding]);
  }
  cmds.unshift(["", ""]);
  customs = (function() {
    _results = [];
    for (var _i = 0, _ref = cmds.length; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
    return _results;
  }).apply(this).map(function(index) {
    return "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom" + index + "/";
  });
  spawn("gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings '" + (JSON.stringify(customs)) + "'");
  _results1 = [];
  for (i = _j = 0, _ref1 = cmds.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
    spawn("gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:" + customs[i] + " binding '" + cmds[i][1] + "'");
    spawn("gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:" + customs[i] + " command \"" + cmds[i][0] + "\"");
    _results1.push(spawn("gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:" + customs[i] + " name 'twm:" + i + "'"));
  }
  return _results1;
};
