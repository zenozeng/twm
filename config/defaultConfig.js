// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, LayoutManager, config, helper, layouts, spawn;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

spawn = helper.spawn;

LayoutManager = Extension.imports.layouts.layoutManager.LayoutManager;

layouts = new LayoutManager;

layouts.set("2-column", Extension.imports.layouts["2-column"].layout);

layouts.set("3-column", Extension.imports.layouts["3-column"].layout);

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
    "<Super>r": function() {
      return spawn("gnome-shell --replace");
    },
    "<Super>t": function() {
      return layouts.apply("2-column");
    }
  },
  layouts: layouts,
  windowsFilter: function(wnckWindow) {
    return true;
  },
  workspaceNum: 8
};
