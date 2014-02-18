// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, GLib, Gdk, LayoutManager, Main, Wnck, delay, helper, runGjsScript, spawn, spawnSync;

Main = imports.ui.main;

Wnck = imports.gi.Wnck;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

Gdk = imports.gi.Gdk;

GLib = imports.gi.GLib;

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

spawn = helper.spawn, spawnSync = helper.spawnSync, delay = helper.delay;

LayoutManager = (function() {
  function LayoutManager() {
    this.layouts = {};
    this.layoutOfWorkspace = {};
  }


  /*
  Get Layout Func
  
  @param [String] layoutName Layout Name
   */

  LayoutManager.prototype.get = function(layoutName) {
    return this.layouts[layoutName];
  };


  /*
  Set Layout Func
  
  @param [String] layoutName Layout Name
  @param [Function] layoutFunc Layout Function
   */

  LayoutManager.prototype.set = function(layoutName, layoutFunc) {
    return this.layouts[layoutName] = layoutFunc;
  };


  /*
  Unset Layout
  
  @param [String] layoutName Layout Name
   */

  LayoutManager.prototype.unset = function(layoutName) {
    return this.layouts[layoutName] = null;
  };


  /*
  List all avaliable layouts, returns an array like ["2-column", "3-column"]
   */

  LayoutManager.prototype.list = function() {
    var key, layouts, value, _ref;
    layouts = ["float"];
    _ref = this.layouts;
    for (key in _ref) {
      value = _ref[key];
      if (value != null) {
        layouts.push(key);
      }
    }
    return layouts;
  };


  /*
  Get Layout of current workspace
   */

  LayoutManager.prototype.current = function() {
    var currentWorkspace, screen, windows;
    screen = Wnck.Screen.get_default();
    screen.force_update();
    windows = screen.get_windows();
    currentWorkspace = screen.get_active_workspace();
    return this.layoutOfWorkspace[currentWorkspace.get_name()];
  };


  /*
  Apply Float Layout
  
  @private
   */

  LayoutManager.prototype.float = function(wnckWindows) {
    var activeWindow, xids;
    activeWindow = wnckWindows.filter(function(win) {
      return win.is_active();
    });
    activeWindow = activeWindow[0];
    xids = wnckWindows.map(function(wnckWindow) {
      return wnckWindow.get_xid();
    });
    runGjsScript("set-decorations-all", {
      xids: xids
    });
    helper.log(activeWindow.get_xid());
    if (activeWindow != null) {
      return activeWindow.activate(helper.getXServerTimestamp());
    }
  };


  /*
  Apply Layout
  
  @param [String] layoutName Layout Name
  @param [Function] filter Filter function which takes WnckWindow as param and returns false this window should be ignored
   */

  LayoutManager.prototype.apply = function(layoutName, filter) {
    var areas, avaliableHeight, avaliableWidth, currentWorkspace, layout, monitor, screen, setGeometry, updateWindows, windows, xids;
    screen = Wnck.Screen.get_default();
    screen.force_update();
    windows = screen.get_windows();
    currentWorkspace = screen.get_active_workspace();
    this.layoutOfWorkspace[currentWorkspace.get_name()] = layoutName;
    windows = windows.filter(function(wnckWindow) {
      return wnckWindow.is_visible_on_workspace(currentWorkspace);
    });
    if (filter != null) {
      windows = windows.filter(filter);
    }
    if (layoutName === 'float') {
      this.float(windows);
      return null;
    }
    xids = windows.map(function(wnckWindow) {
      return wnckWindow.get_xid();
    });
    runGjsScript("set-decorations-0", {
      xids: xids
    });
    runGjsScript("set-geometry-hints", {
      xids: xids
    });
    monitor = Main.layoutManager.primaryMonitor;
    avaliableWidth = monitor.width;
    avaliableHeight = monitor.height - Main.panel.actor.height;
    layout = this.get(layoutName);
    areas = layout(windows.length);
    setGeometry = function(wnckWindow, geometry) {
      var height, width, x, y;
      wnckWindow.activate(helper.getXServerTimestamp());
      wnckWindow.unmaximize();
      geometry = geometry.map(function(elem) {
        return Math.round(elem);
      });
      x = geometry[0], y = geometry[1], width = geometry[2], height = geometry[3];
      return wnckWindow.set_geometry(0, 15, x, y, width, height);
    };
    updateWindows = function() {
      var activeWindow;
      activeWindow = windows.filter(function(win) {
        return win.is_active();
      });
      activeWindow = activeWindow[0];
      windows.forEach(function(win, index) {
        var clientWindowGeometry, height, heightOffset, target, width, widthOffset, windowGeometry, x, y, _ref;
        _ref = areas[index], x = _ref.x, y = _ref.y, width = _ref.width, height = _ref.height;
        x = x * avaliableWidth;
        y = y * avaliableHeight;
        width = width * avaliableWidth;
        height = height * avaliableHeight;
        clientWindowGeometry = win.get_client_window_geometry();
        windowGeometry = win.get_geometry();
        widthOffset = windowGeometry[2] - clientWindowGeometry[2];
        heightOffset = windowGeometry[3] - clientWindowGeometry[3];
        y -= 3;
        target = [x, y, width + widthOffset, height + heightOffset];
        return setGeometry(win, target);
      });
      if (activeWindow != null) {
        return activeWindow.activate(helper.getXServerTimestamp());
      }
    };
    updateWindows();
    delay(300, updateWindows);
    return delay(600, updateWindows);
  };

  return LayoutManager;

})();
