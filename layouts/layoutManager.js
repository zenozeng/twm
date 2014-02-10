// Generated by CoffeeScript 1.6.3
var LayoutManager, Main;

Main = imports.ui.main;

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
  Apply Layout
  */


  LayoutManager.prototype.apply = function(layoutName, windows) {
    var areas, avaliableHeight, avaliableWidth, layout, monitor;
    windows.forEach(function(win) {
      return win.setDecorated(false);
    });
    monitor = Main.layoutManager.primaryMonitor;
    avaliableWidth = monitor.width;
    avaliableHeight = monitor.height - Main.panel.actor.height;
    layout = this.get(layoutName);
    areas = layout(windows.length);
    return windows.forEach(function(win, index) {
      var height, width, x, y, _ref;
      _ref = areas[index], x = _ref.x, y = _ref.y, width = _ref.width, height = _ref.height;
      x = x * avaliableWidth;
      y = y * avaliableHeight;
      width = width * avaliableWidth;
      height = height * avaliableHeight;
      return win.setArea(x, y, width, height);
    });
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