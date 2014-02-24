// Generated by CoffeeScript 1.7.1
var Extension, ExtensionUtils, Window, Wnck, delay, helper, runGjsScript;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

Wnck = imports.gi.Wnck;

delay = helper.delay, runGjsScript = helper.runGjsScript;

Window = (function() {
  function Window(wnckWindow) {
    this.wnckWindow = wnckWindow;
    this.wmInstance = {};
    this.targetGeometry = {};
  }


  /*
  Get ID (current xid used)
   */

  Window.prototype.getId = function() {
    return this.wnckWindow.get_xid();
  };

  Window.prototype.getTargetGeometry = function() {
    return this.targetGeometry;
  };

  Window.prototype.setTargetGeometry = function(geometry) {
    return this.targetGeometry = geometry;
  };


  /*
  Wait until @wnckWindow no longer change its size
   */

  Window.prototype.waitUntilReady = function(callback) {
    var fn, last, lastButOne;
    last = null;
    lastButOne = null;
    fn = (function(_this) {
      return function() {
        var current;
        current = JSON.stringify(_this.wnckWindow.get_geometry());
        if (current === last && last === lastButOne) {
          return typeof callback === "function" ? callback() : void 0;
        } else {
          last = lastButOne;
          lastButOne = current;
          return delay(20, fn);
        }
      };
    })(this);
    return fn();
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
  @note this gjs must be run outside, or the window might crash
   */

  Window.prototype.removeDecorations = function() {
    var xid;
    xid = this.wnckWindow.get_xid();
    this.wnckWindow.unmaximize();
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
    xid = this.wnckWindow.get_xid();
    this.wnckWindow.unmaximize();
    return runGjsScript("set-geometry-hints", {
      xid: xid
    });
  };

  Window.prototype.setGeometry = function(geometry, callback, raw) {
    var height, realSetGeometry, target, width, x, y;
    if (raw == null) {
      raw = false;
    }
    this.wnckWindow.unmaximize();
    x = geometry.x, y = geometry.y, width = geometry.width, height = geometry.height;
    target = [x, y, width, height];
    target = target.map(function(arg) {
      return Math.round(arg);
    });
    if (!raw) {
      this.removeDecorations();
      this.setGeometryHints();
    }
    realSetGeometry = function(wnckWindow, geometryArr, maxRetry) {
      var apply, now, test, _realSetGeometry;
      if (maxRetry == null) {
        maxRetry = 50;
      }
      _realSetGeometry = function(geometryArr) {
        var WNCK_WINDOW_GRAVITY_STATIC, WnckWindowMoveResizeMask, clientGeometry, index, newTarget, offset, windowGeometry, _i;
        clientGeometry = wnckWindow.get_client_window_geometry();
        windowGeometry = wnckWindow.get_geometry();
        newTarget = [];
        for (index = _i = 0; _i <= 3; index = ++_i) {
          offset = geometryArr[index] - clientGeometry[index];
          newTarget[index] = offset + windowGeometry[index];
        }
        x = newTarget[0], y = newTarget[1], width = newTarget[2], height = newTarget[3];
        WnckWindowMoveResizeMask = 15;
        WNCK_WINDOW_GRAVITY_STATIC = 10;
        return wnckWindow.set_geometry(WNCK_WINDOW_GRAVITY_STATIC, WnckWindowMoveResizeMask, x, y, width, height);
      };
      test = function(callback) {
        var check;
        check = function() {
          var clientGeometry, windowGeometry;
          clientGeometry = wnckWindow.get_client_window_geometry();
          windowGeometry = wnckWindow.get_geometry();
          return JSON.stringify(geometryArr) === JSON.stringify(clientGeometry);
        };
        if (check()) {
          return delay(50, function() {
            if (check()) {
              return delay(50, function() {
                if (check()) {
                  return typeof callback === "function" ? callback(true) : void 0;
                } else {
                  return typeof callback === "function" ? callback(false) : void 0;
                }
              });
            } else {
              return typeof callback === "function" ? callback(false) : void 0;
            }
          });
        } else {
          return typeof callback === "function" ? callback(false) : void 0;
        }
      };
      now = (new Date()).getTime();
      apply = function() {
        return test(function(hasDone) {
          if (hasDone) {
            return typeof callback === "function" ? callback() : void 0;
          } else {
            _realSetGeometry(geometryArr);
            maxRetry--;
            if (maxRetry > 0) {
              return delay(20, function() {
                return apply();
              });
            } else {
              return null;
            }
          }
        });
      };
      return apply();
    };
    return this.waitUntilReady((function(_this) {
      return function() {
        return realSetGeometry(_this.wnckWindow, target);
      };
    })(this));
  };

  return Window;

})();
