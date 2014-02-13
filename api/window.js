// Generated by CoffeeScript 1.6.3
var Extension, ExtensionUtils, Main, Meta, Window, WindowOverlay, helper, shellwm, spawn, spawnSync, wm;

Main = imports.ui.main;

Meta = imports.gi.Meta;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

helper = Extension.imports.helper;

spawnSync = helper.spawnSync;

spawn = helper.spawn;

WindowOverlay = imports.ui.workspace.WindowOverlay;

shellwm = global.window_manager;

wm = imports.ui.main.wm;

Window = (function() {
  /*
  Constructor
  
  @example Get current window's wmClass
    var wmClass = (new Window()).current().wmClass;
  
  @example Get current window's meta_window
    var wmClass = (new Window()).current().meta;
  */

  function Window(actor) {
    this.actor = actor;
    if (this.actor != null) {
      this.metaWindow = this.actor.get_meta_window();
      this.wmClass = this.metaWindow.get_wm_class();
    }
  }

  /*
  Get Overlay Object of current Window
  in js/ui/workspace.js
  this._windowOverlays of const Workspace
  */


  Window.prototype.getWindowOverlay = function() {
    return false;
  };

  /*
  Get current window
  */


  Window.prototype.current = function() {
    var wins;
    wins = this.getAll().filter(function(win) {
      return win.metaWindow.has_focus();
    });
    return wins[0];
  };

  /*
  Get all windows which is shown in current workspace
  
  @example Move every windows in current workspace to (0, 0) and resize to 100*100
    (new Window()).getAll().forEach(function(win){
      win.setArea(0, 0, 100, 100);
    });
  */


  Window.prototype.getAll = function() {
    var currentWorkspaceIndex, windows;
    currentWorkspaceIndex = global.screen.get_active_workspace_index();
    windows = global.get_window_actors().filter(function(actor) {
      return actor.get_workspace() === currentWorkspaceIndex || (actor.get_meta_window() && actor.get_meta_window().is_on_all_workspaces());
    });
    return windows.map(function(actor) {
      return new Window(actor);
    });
  };

  /*
  Set the position and size of the visiable part of window
  
  @param [Number] x position x (px)
  @param [Number] y position y (px)
  @param [Number] width width (px) (border & shadow should not be included)
  @param [Number] height height (px) (border & shadow should not be included)
  @note (0, 0) was at the left-bottom of the top bar
  @see https://bugzilla.gnome.org/show_bug.cgi?id=651899
  */


  Window.prototype.setArea = function(x, y, width, height) {
    var clientRect, outerRect, user_op;
    y += Main.panel.actor.height;
    this.metaWindow.unmaximize(Meta.MaximizeFlags.VERTICAL | Meta.MaximizeFlags.HORIZONTAL);
    user_op = false;
    clientRect = this.metaWindow.get_rect();
    outerRect = this.metaWindow.get_outer_rect();
    this.metaWindow.resize(user_op, width + outerRect.width - clientRect.width, height + outerRect.height - clientRect.height);
    return this.metaWindow.move_frame(user_op, x, y);
  };

  /*
  Activate window
  
  @TODO Fix this
  */


  Window.prototype.activate = function() {
    Main.activateWindow(this.actor);
    return this;
  };

  /*
  Get XID of window actor (using xwininfo)
  
  @see https://bitbucket.org/mathematicalcoffee/maximus-gnome-shell-extension/src/712915b37e7ac42d3593f58d97ef00b341d165fb/maximus@mathematical.coffee.gmail.com/extension.js?at=stable#cl-113
  */


  Window.prototype.getXid = function() {
    var regExp, xid, xids;
    xid = this.metaWindow.get_compositor_private()['x-window'].toString('16');
    xids = spawnSync("xwininfo -children -id 0x" + xid);
    regExp = new RegExp('0x[0-9a-f]{3,}', 'g');
    return xid = xids.match(regExp)[1];
  };

  /*
  Get PID of window actor
  
  @TODO remove this api unless needed
  @see http://stackoverflow.com/questions/5541884/how-to-get-xid-from-pid-and-vice-versa
  */


  Window.prototype.getPid = function() {
    return "xprop -id <windowid> _NET_WM_PID";
  };

  /*
  Control whether window should be decorated with a title bar, resize controls, etc.
  
  @param [Bool] setting Decorate the window when true, undecorate when false
  @see http://mathematicalcoffee.blogspot.com/2012/05/automatically-undecorate-maximised.html
  */


  Window.prototype.setDecorated = function(setting) {
    var hints, regExp, xid, xids;
    this.unmaximize();
    xid = this.getXid();
    if (setting) {
      hints = "0x2, 0x0, 0x1, 0x0, 0x0";
      xids = spawnSync("xwininfo -children -id " + xid);
      regExp = new RegExp('0x[0-9a-f]{3,}', 'g');
      xid = xids.match(regExp)[1];
    } else {
      hints = "0x2, 0x0, 0x0, 0x0, 0x0";
    }
    spawnSync('xprop -id ' + xid + ' -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "' + hints + '"');
    return this;
  };

  /*
  Maximize
  */


  Window.prototype.maximize = function() {
    this.metaWindow.maximize(Meta.MaximizeFlags.VERTICAL | Meta.MaximizeFlags.HORIZONTAL);
    return this;
  };

  /*
  Unmaximize
  */


  Window.prototype.unmaximize = function() {
    this.metaWindow.unmaximize(Meta.MaximizeFlags.VERTICAL | Meta.MaximizeFlags.HORIZONTAL);
    return this;
  };

  /*
  @TODO Fix this
  */


  Window.prototype.move = function(direction) {};

  /*
  Close window
  
  @see js/ui/windowManager.js function:_destoryWindow
  */


  Window.prototype.close = function() {
    helper.log("np1");
    wm._destroyWindow(shellwm, this.actor);
    return helper.log("np2");
  };

  return Window;

})();
