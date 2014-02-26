// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, Main, Window, Wnck, delay, helper, runGjsScript;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

Wnck = imports.gi.Wnck;

Main = imports.ui.main;

delay = helper.delay, runGjsScript = helper.runGjsScript;

Window = (function() {
  function Window(wnckWindow) {
    var storage;
    this.wnckWindow = wnckWindow;
    if (global.twm.storage.windows == null) {
      global.twm.storage.windows = {};
    }
    if (global.twm.storage.windows[this.getId()] == null) {
      global.twm.storage.windows[this.getId()] = {};
    }
    storage = global.twm.storage.windows[this.getId()];
    this.storage = {
      getItem: function(key) {
        return storage[key];
      },
      setItem: function(key, value) {
        return storage[key] = value;
      },
      clear: (function(_this) {
        return function() {
          return global.twm.storage.windows[_this.getId()] = {};
        };
      })(this)
    };
  }


  /*
  Get ID (current xid used)
   */

  Window.prototype.getId = function() {
    return this.wnckWindow.get_xid();
  };


  /*
  Return client geometry
   */

  Window.prototype.getGeometry = function() {
    var height, width, x, y, _ref;
    _ref = this.wnckWindow.get_client_window_geometry(), x = _ref[0], y = _ref[1], width = _ref[2], height = _ref[3];
    return {
      x: x,
      y: y,
      width: width,
      height: height
    };
  };

  Window.prototype.getTargetGeometry = function() {
    return this.storage.getItem('geometry');
  };


  /*
  Set target geometry
  
  @example
    window.setTargetGeometry({x: x, y: y, width: width, height: height});
   */

  Window.prototype.setTargetGeometry = function(geometry) {
    return this.storage.setItem('geometry', geometry);
  };


  /*
  Set window as float
  
  @note all storage related to this window will be cleared
   */

  Window.prototype.setFloat = function() {
    var height, monitor, width;
    this.storage.clear();
    monitor = Main.layoutManager.currentMonitor;
    width = monitor.width * 2 / 3;
    height = monitor.height * 2 / 3;
    this.wnckWindow.set_geometry(0, (1 << 2) | (1 << 3), 0, 0, width, height);
    return runGjsScript("set-float", {
      xid: this.wnckWindow.get_xid()
    });
  };


  /*
  Return true if type of @wnckWindow is WNCK_WINDOW_NORMAL
   */

  Window.prototype.isNormalWindow = function() {
    var type;
    type = this.wnckWindow.get_window_type();
    return type === Wnck.WindowType.NORMAL;
  };


  /*
  remove title bar
  @note The window should be unmaximized before, which is done by setGeometry
  @note this gjs must be run outside, or the window might crash
   */

  Window.prototype.removeDecorations = function() {
    var xid;
    if (this.storage.getItem('decorations') === false) {
      return false;
    }
    this.storage.setItem('decorations', false);
    xid = this.wnckWindow.get_xid();
    return runGjsScript("set-decorations-0", {
      xid: xid
    });
  };


  /*
  set geometry hints
  Overide WM_NORMAL_HINTS(WM_SIZE_HINTS)
  allow setting width & height using px (for Gnome Termianl, Emacs)
  @note the gjs must be run outside, or the window might crash
   */

  Window.prototype.setGeometryHints = function() {
    var xid;
    if (this.storage.getItem('geometry-hints') === 'none') {
      return false;
    }
    this.storage.setItem('geometry-hints', 'none');
    xid = this.wnckWindow.get_xid();
    this.wnckWindow.unmaximize();
    return runGjsScript("set-geometry-hints", {
      xid: xid
    });
  };


  /*
  geometry = {x: int, y: int, width: int, height: int}
   */

  Window.prototype.setGeometry = function(geometry) {
    var WNCK_WINDOW_GRAVITY_STATIC, WnckWindowMoveResizeMask, clientGeometry, height, index, newTarget, offset, target, width, windowGeometry, x, y, _i;
    this.wnckWindow.unmaximize();
    x = geometry.x, y = geometry.y, width = geometry.width, height = geometry.height;
    target = [x, y, width, height];
    this.removeDecorations();
    this.setGeometryHints();
    clientGeometry = this.wnckWindow.get_client_window_geometry();
    windowGeometry = this.wnckWindow.get_geometry();
    newTarget = [];
    for (index = _i = 0; _i <= 3; index = ++_i) {
      offset = target[index] - clientGeometry[index];
      newTarget[index] = offset + windowGeometry[index];
    }
    x = newTarget[0], y = newTarget[1], width = newTarget[2], height = newTarget[3];
    WnckWindowMoveResizeMask = 15;
    WNCK_WINDOW_GRAVITY_STATIC = 10;
    return this.wnckWindow.set_geometry(WNCK_WINDOW_GRAVITY_STATIC, WnckWindowMoveResizeMask, x, y, width, height);
  };

  return Window;

})();
