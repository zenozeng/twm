// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, GLib, Window, WindowManager, Wnck;

Wnck = imports.gi.Wnck;

GLib = imports.gi.GLib;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

Window = Extension.imports.wm.window.Window;


/*
About wnck_screen_force_update ()

Synchronously and immediately updates the list of WnckWindow on screen. This bypasses the standard update mechanism, where the list of WnckWindow is updated in the idle loop.

This is usually a bad idea for both performance and correctness reasons (to get things right, you need to write model-view code that tracks changes, not get a static list of open windows). However, this function can be useful for small applications that just do something and then exit.
 */


/*
Window Manager
 */

WindowManager = (function() {
  function WindowManager() {
    if ((WindowManager.instance != null)) {
      return WindowManager.instance;
    }
    WindowManager.instance = this;
    this.screen = Wnck.Screen.get_default();
    this.forceUpdate();
    this.activeWindow = this.screen.get_active_window();
    this.activeWorkspace = this.screen.get_active_workspace();
    this.windows = this.screen.get_windows();
    this.screen.connect("window-closed", (function(_this) {
      return function(wnckScreen, wnckWindow) {
        var xid;
        xid = wnckWindow.get_xid();
        _this.windows = _this.windows.filter(function(wnckWindow) {
          return wnckWindow.get_xid() !== xid;
        });
        return _this.emit("window-closed", [wnckScreen, wnckWindow]);
      };
    })(this));
    this.screen.connect("window-opened", (function(_this) {
      return function(wnckScreen, wnckWindow) {
        _this.windows.push(wnckWindow);
        return _this.emit("window-opened", [wnckScreen, wnckWindow]);
      };
    })(this));
    this.screen.connect("active-window-changed", (function(_this) {
      return function(wnckScreen, prevWnckWindow) {
        _this.activeWindow = _this.screen.get_active_window();
        return _this.emit("active-window-changed", [wnckScreen, prevWnckWindow]);
      };
    })(this));
    this.screen.connect("active-workspace-changed", (function(_this) {
      return function(wnckScreen, prevWnckWorkspace) {
        _this.activeWorkspace = _this.screen.get_active_workspace();
        return _this.emit("active-workspace-changed", [wnckScreen, prevWnckWorkspace]);
      };
    })(this));
    this.storage = {};
    this.events = {};
    this.setGeometryInterval();
    return this;
  }


  /*
  Get all visible windows in current workspace (in all monitors)
   */

  WindowManager.prototype.getVisibleWindows = function() {
    var windows;
    windows = this.windows.filter((function(_this) {
      return function(wnckWindow) {
        return wnckWindow.is_visible_on_workspace(_this.getActiveWorkspace());
      };
    })(this));
    return windows.map(function(wnckWindow) {
      return new Window(wnckWindow);
    });
  };


  /*
  @note Some window (like Emacs) might set wm_normal_hints and size after some seconds, so this function should be called by interval.
  @private
   */

  WindowManager.prototype.setGeometryInterval = function() {
    return GLib.timeout_add(GLib.PRIORITY_DEFAULT, 20, (function(_this) {
      return function() {
        var visibleWindows;
        visibleWindows = _this.getVisibleWindows();
        visibleWindows.forEach(function(window) {
          var geometry, target;
          target = window.getTargetGeometry();
          geometry = window.getGeometry();
          if ((target != null) && target !== geometry) {
            return window.setGeometry(target);
          }
        });
        return true;
      };
    })(this));
  };


  /*
  Return true if the (Window) window should be ignored
   */

  WindowManager.prototype.ignore = function(window) {
    if (!window.isNormalWindow()) {
      return true;
    }
    return false;
  };

  WindowManager.prototype.forceUpdate = function() {
    return this.screen.force_update();
  };


  /*
  Bind event
  
  @param [String] event Event name
  @param [Function] callback callback
   */

  WindowManager.prototype.connect = function(event, callback) {
    if (!this.events[event]) {
      this.events[event] = [];
    }
    return this.events[event].push(callback);
  };


  /*
  Emit event
  
  @param [String] event Event name
  @param [Array] args Args for callback
  @private
   */

  WindowManager.prototype.emit = function(event, args) {
    var callback, callbacks, _i, _len, _results;
    callbacks = this.events[event] || [];
    _results = [];
    for (_i = 0, _len = callbacks.length; _i < _len; _i++) {
      callback = callbacks[_i];
      _results.push(callback.apply(this, args));
    }
    return _results;
  };


  /*
  Get active window (Wnck Window)
  
  @see https://developer.gnome.org/libwnck/stable/WnckWindow.html
   */

  WindowManager.prototype.getActiveWindow = function() {
    return this.activeWindow;
  };


  /*
  Get active workspace (Wnck Workspace)
  
  @see https://developer.gnome.org/libwnck/stable/WnckWorkspace.html
   */

  WindowManager.prototype.getActiveWorkspace = function() {
    return this.activeWorkspace;
  };


  /*
  Get an array of all windows of current screen (Wnck Window)
  
  @see https://developer.gnome.org/libwnck/stable/WnckWindow.html
   */

  WindowManager.prototype.getWindows = function() {
    return this.windows;
  };

  return WindowManager;

})();
