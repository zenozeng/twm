Main = imports.ui.main
Meta = imports.gi.Meta
ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
spawnSync = helper.spawnSync
spawn = helper.spawn
WindowOverlay = imports.ui.workspace.WindowOverlay

class Window

  ###
  Constructor

  @example Get current window's wmClass
    var wmClass = (new Window()).current().wmClass;

  @example Get current window's meta_window
    var wmClass = (new Window()).current().meta;
  ###
  constructor: (@actor) ->
    if @actor?
      @metaWindow = @actor.get_meta_window()
      @wmClass = @metaWindow.get_wm_class()

  ###
  Get Overlay Object of current Window
  in js/ui/workspace.js
  this._windowOverlays of const Workspace
  ###
  getWindowOverlay: -> false

  ###
  Get current window
  ###
  current: ->
    wins = @getAll().filter (win) -> win.metaWindow.has_focus()
    wins[0]

  ###
  Get all windows which is shown in current workspace

  @example Move every windows in current workspace to (0, 0) and resize to 100*100
    (new Window()).getAll().forEach(function(win){
      win.setArea(0, 0, 100, 100);
    });
  ###
  getAll: ->
    currentWorkspaceIndex = global.screen.get_active_workspace_index()
    windows = global.get_window_actors().filter (actor) ->
      actor.get_workspace() is currentWorkspaceIndex or
      (actor.get_meta_window() and actor.get_meta_window().is_on_all_workspaces())
    windows.map (actor) -> new Window(actor)

  ###
  Set the position and size of the visiable part of window

  @param [Number] x position x (px)
  @param [Number] y position y (px)
  @param [Number] width width (px) (border & shadow should not be included)
  @param [Number] height height (px) (border & shadow should not be included)
  @note (0, 0) was at the left-bottom of the top bar
  ###
  setArea: (x, y, width, height) ->
    helper.log [@wmClass, x, y, width, height]
    y += Main.panel.actor.height
    @metaWindow.unmaximize(Meta.MaximizeFlags.VERTICAL | Meta.MaximizeFlags.HORIZONTAL)
    @actor.set_position x, y
    # WindowOverlay._animateOverlayActor @actor, x, y, width, height
    # @metaWindow.move_resize_frame true, x, y, width, height
    # # do its best convince the width and height of visiable part
    # fix = =>
    #   widthOffset = width - @actor.get_width()
    #   widthFix = width + widthOffset
    #   heightOffset = height - @actor.get_height()
    #   heightFix = height + heightOffset
    #   helper.log [@wmClass, widthFix, heightFix]
    #   @metaWindow.move_resize_frame true, x, y, widthFix, heightFix
    # # twice
    # helper.delay 100, fix
    # helper.delay 200, fix
    # helper.delay 300, fix

  ###
  Activate window

  @TODO Fix this
  ###
  activate: ->
    Main.activateWindow @actor
    this

  ###
  Get XID of window actor (using xwininfo)

  @see https://bitbucket.org/mathematicalcoffee/maximus-gnome-shell-extension/src/712915b37e7ac42d3593f58d97ef00b341d165fb/maximus@mathematical.coffee.gmail.com/extension.js?at=stable#cl-113
  ###
  getXid: ->
    xid = @metaWindow.get_compositor_private()['x-window'].toString('16')
    xids = spawnSync "xwininfo -children -id 0x#{xid}"
    regExp = new RegExp('0x[0-9a-f]{3,}', 'g')
    xid = xids.match(regExp)[1]

  ###
  Get PID of window actor

  @TODO remove this api unless needed
  @see http://stackoverflow.com/questions/5541884/how-to-get-xid-from-pid-and-vice-versa
  ###
  getPid: -> "xprop -id <windowid> _NET_WM_PID"

  ###
  Control whether window should be decorated with a title bar, resize controls, etc.

  @param [Bool] setting Decorate the window when true, undecorate when false
  @see http://mathematicalcoffee.blogspot.com/2012/05/automatically-undecorate-maximised.html
  ###
  setDecorated: (setting) ->
    # will crash when maximized
    @unmaximize()
    xid = @getXid()
    if setting
      hints = "0x2, 0x0, 0x1, 0x0, 0x0"
      # use child's xid
      xids = spawnSync "xwininfo -children -id #{xid}"
      regExp = new RegExp('0x[0-9a-f]{3,}', 'g')
      xid = xids.match(regExp)[1]
    else
      hints = "0x2, 0x0, 0x0, 0x0, 0x0"
    spawnSync 'xprop -id ' + xid + ' -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "' + hints + '"'
    this

  ###
  Maximize
  ###
  maximize: ->
    @metaWindow.maximize(Meta.MaximizeFlags.VERTICAL | Meta.MaximizeFlags.HORIZONTAL)
    this

  ###
  Unmaximize
  ###
  unmaximize: ->
    @metaWindow.unmaximize(Meta.MaximizeFlags.VERTICAL | Meta.MaximizeFlags.HORIZONTAL)
    this

  # ###
  # Emit signal to window

  # @note signals can be found here: https://developer.gnome.org/shell/unstable/ShellWM.html
  # ###
  # signal: (signal) ->
  #   @actor.emit signal
  #   this


  ###
  @TODO Fix this
  ###
  move: (direction) ->
    # window = @actor
    # direction = 'up'

    # # in js/ui/workspace.js
    # # finding through click of button
    # activeWorkspace = global.screen.get_active_workspace();
    # toActivate = activeWorkspace.get_neighbor(direction);
    # WindowOverlay._closeWindow @actor
    # if (activeWorkspace != toActivate)
    #   #This won't have any effect for "always sticky" windows
    #   # (like desktop windows or docks)

    #   this._movingWindow = window;
    #   window.change_workspace(toActivate);

    #   global.display.clear_mouse_mode();
    #   toActivate.activate_with_focus window, global.get_current_time()

  ###
  Close window

  @TODO Fix this
  ###
  close: -> false
