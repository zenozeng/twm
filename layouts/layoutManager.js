// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, Gdk, LayoutManager, Main, Wnck, delay, helper, runGjsScript, spawn, spawnSync;

Main = imports.ui.main;

Wnck = imports.gi.Wnck;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

Gdk = imports.gi.Gdk;

runGjsScript = function(scriptName) {
  var file, fileName;
  fileName = "gjs/" + scriptName + ".js";
  file = Extension.dir.get_path().toString() + '/' + fileName;
  spawn("gjs " + file);
  return delay(1000, function() {
    return spawn("sh -c \"ps -ef | grep " + fileName + " | awk '{print $2}' | xargs kill -9\"");
  });
};

spawn = helper.spawn, spawnSync = helper.spawnSync, delay = helper.delay;

LayoutManager = (function() {
  function LayoutManager() {
    this.layouts = {};
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
  Apply Float Layout
  
  @private
   */

  LayoutManager.prototype.float = function(wnckWindows) {
    global.log('float!!!!');
    return runGjsScript("set-decorations-all");
  };


  /*
  Apply Layout
  
  @param [String] layoutName Layout Name
  @param [Function] filter Filter function which takes WnckWindow as param and returns false this window should be ignored
   */

  LayoutManager.prototype.apply = function(layoutName, filter) {
    var areas, avaliableHeight, avaliableWidth, currentWorkspace, layout, monitor, screen, setGeometry, updateWindows, windows;
    screen = Wnck.Screen.get_default();
    windows = screen.get_windows();
    currentWorkspace = screen.get_active_workspace();
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
    runGjsScript("set-decorations-0");
    runGjsScript("set-geometry-hints");
    monitor = Main.layoutManager.primaryMonitor;
    avaliableWidth = monitor.width;
    avaliableHeight = monitor.height - Main.panel.actor.height;
    layout = this.get(layoutName);
    areas = layout(windows.length);
    setGeometry = function(wnckWindow, geometry) {
      var height, width, x, y;
      wnckWindow.unmaximize();
      geometry = geometry.map(function(elem) {
        return Math.round(elem);
      });
      x = geometry[0], y = geometry[1], width = geometry[2], height = geometry[3];
      return wnckWindow.set_geometry(0, 15, x, y, width, height);
    };
    updateWindows = function() {
      return windows.forEach(function(win, index) {
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
    };
    updateWindows();
    delay(300, updateWindows);
    return delay(600, updateWindows);
  };


  /*
  List all avaliable layouts, returns an array like ["2-column", "3-column"]
   */

  LayoutManager.prototype.list = function() {
    var key, layouts, value, _ref;
    layouts = [];
    _ref = this.layouts;
    for (key in _ref) {
      value = _ref[key];
      if (value != null) {
        layouts.push(key);
      }
    }
    return layouts;
  };

  return LayoutManager;

})();
