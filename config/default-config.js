// Generated by CoffeeScript 1.6.3
var Extension, ExtensionUtils, Window, config, helper, layouts, spawn;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

spawn = helper.spawn;

Window = Extension.imports.api.window.Window;

layouts = Extension.imports.layouts.layouts.layouts;

config = {
  keybindings: {
    "<Super>e": function() {
      return spawn("emacsclient -c");
    },
    "<Super>c": function() {
      return spawn("google-chrome");
    },
    "<Super>l": function() {
      return Main.lookingGlass.toggle();
    },
    "<Super>Return": function() {
      return spawn("gnome-terminal");
    },
    "<Super>k": function() {
      return (new Window()).current().destroy();
    },
    "<Super>r": function() {
      return spawn("gnome-shell --replace");
    },
    "<Super>t": function() {
      return false;
    }
  },
  layouts: layouts.list(),
  onWindowChange: function() {
    return false;
  },
  windowsFilter: function(win) {
    return true;
  }
};
