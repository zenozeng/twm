// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, LayoutManager, Main, Window, WindowManager, Wnck, delay, helper, runGjsScript, spawn, spawnSync, wm;

Main = imports.ui.main;

Wnck = imports.gi.Wnck;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

WindowManager = Extension.imports.wm.windowManager.WindowManager;

Window = Extension.imports.wm.window.Window;

wm = new WindowManager;

spawn = helper.spawn, spawnSync = helper.spawnSync, delay = helper.delay, runGjsScript = helper.runGjsScript;

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
    return this.layoutOfWorkspace[wm.getActiveWorkspace().get_name()];
  };


  /*
  Apply Float Layout
  
  @private
   */

  LayoutManager.prototype.float = function(wnckWindows, activeWindow) {
    var activeWindowXid, height, monitor, width, xids;
    activeWindowXid = activeWindow != null ? activeWindow.get_xid() : null;
    monitor = Main.layoutManager.primaryMonitor;
    width = monitor.width * 2 / 3;
    height = monitor.height * 2 / 3;
    wnckWindows.forEach(function(wnckWindow) {
      return wnckWindow.set_geometry(0, (1 << 2) | (1 << 3), 0, 0, width, height);
    });
    xids = wnckWindows.map(function(wnckWindow) {
      return wnckWindow.get_xid();
    });
    return runGjsScript("set-float", {
      xids: xids,
      activeWindowXid: activeWindowXid
    });
  };


  /*
  Apply Layout
  
  @param [String] layoutName Layout Name
  @param [Function] filter Filter function which takes WnckWindow as param and returns false this window should be ignored
   */

  LayoutManager.prototype.apply = function(layoutName, filter, activeWindow) {
    var areas, avaliableHeight, avaliableWidth, currentWorkspace, layout, monitor, refocus, updateWindows, windows, xids;
    if (activeWindow == null) {
      activeWindow = wm.getActiveWindow();
    }
    windows = wm.getWindows();
    currentWorkspace = wm.getActiveWorkspace();
    this.layoutOfWorkspace[currentWorkspace.get_name()] = layoutName;
    windows = windows.filter(function(wnckWindow) {
      return wnckWindow.is_visible_on_workspace(currentWorkspace);
    });
    if (filter != null) {
      windows = windows.filter(filter);
    }
    if (layoutName === 'float') {
      this.float(windows, activeWindow);
      return null;
    }
    xids = windows.map(function(wnckWindow) {
      return wnckWindow.get_xid();
    });
    refocus = function() {
      if (activeWindow != null) {
        return activeWindow.activate(helper.getXServerTimestamp());
      } else {
        return false;
      }
    };
    monitor = Main.layoutManager.primaryMonitor;
    avaliableWidth = monitor.width;
    avaliableHeight = monitor.height - Main.panel.actor.height;
    layout = this.get(layoutName);
    areas = layout(windows.length);
    updateWindows = (function(_this) {
      return function() {
        return windows.forEach(function(win, index) {
          var geometry, height, width, x, y, _ref, _window;
          _ref = areas[index], x = _ref.x, y = _ref.y, width = _ref.width, height = _ref.height;
          x = x * avaliableWidth;
          y = y * avaliableHeight;
          width = width * avaliableWidth;
          height = height * avaliableHeight;
          y += 27;
          _window = new Window(win);
          geometry = {
            x: x,
            y: y,
            width: width,
            height: height
          };
          _window.removeDecorations();
          _window.setGeometryHints();
          return _window.setGeometry(geometry);
        });
      };
    })(this);
    return updateWindows();
  };

  return LayoutManager;

})();
