// Generated by CoffeeScript 1.6.3
var Config, Extension, ExtensionUtils, Window, disable, enable, helper, init, keybindings;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

Window = Extension.imports.api.window.Window;

keybindings = Extension.imports.api.keybindings;

Config = Extension.imports.config.config.Config;

init = function() {
  var callback, config, e, keybinding, onWindowChange, _ref;
  global.twm = {
    functions: {}
  };
  try {
    config = new Config;
    _ref = config.keybindings;
    for (keybinding in _ref) {
      callback = _ref[keybinding];
      keybindings.add(keybinding, callback);
    }
    keybindings.apply();
    if (typeof config.onStartup === "function") {
      config.onStartup();
    }
    onWindowChange = function() {
      var wins;
      wins = (new Window()).getAll();
      wins = wins.filter(function(win) {
        return win.wmClass !== 'Gnome-shell';
      });
      wins = wins.filter(function(win) {
        return config.windowsFilter(win);
      });
      return config.layouts.apply("2-column", wins);
    };
    onWindowChange();
  } catch (_error) {
    e = _error;
    global.log(e);
    helper.log(e);
  }
  return false;
};

enable = function() {
  return false;
};

disable = function() {
  return false;
};
