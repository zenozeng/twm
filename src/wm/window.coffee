ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
{delay, runGjsScript} = helper

class Window

  constructor: (@wnckWindow) ->

  # remove title bar
  # this code must be run outside, or the window might crash
  removeDecorations: () ->
    xid = @wnckWindow.get_xid()
    runGjsScript "set-decorations-0", {xid: xid}

  # set geometry hints
  # Overide WM_NORMAL_HINTS(WM_SIZE_HINTS)
  # allow setting width & height using px (for Gnome Termianl, Emacs)
  # this code must be run outside, or the window might crash
  setGeometryHints: () ->
    xid = @wnckWindow.get_xid()
    runGjsScript "set-geometry-hints", {xid: xid}

  setGeometry: (geometry)->

    # preprocess
    @wnckWindow.unmaximize() # unmaximize first, or will fail to set geometry
    {x, y, width, height} = geometry
    target = [x, y, width, height]
    target = target.map (arg) -> Math.round arg

    realSetGeometry = (wnckWindow, geometryArr, maxRetry = 50) ->

      _realSetGeometry = (geometryArr) ->

        clientGeometry = wnckWindow.get_client_window_geometry()
        windowGeometry = wnckWindow.get_geometry()

        newTarget = []
        for index in [0..3]
          offset = geometryArr[index] - clientGeometry[index]
          newTarget[index] = offset + windowGeometry[index]
        [x, y, width, height] = newTarget

        WnckWindowMoveResizeMask = 15
        # use the left top corner of the client window as gravity point
        WNCK_WINDOW_GRAVITY_STATIC = 10
        wnckWindow.set_geometry WNCK_WINDOW_GRAVITY_STATIC, WnckWindowMoveResizeMask, x, y, width, height

      # callback will be called with an bool arg indicate whether geometry is matched
      test = (callback) ->

        # return true if geometry matched
        check = ->
          clientGeometry = wnckWindow.get_client_window_geometry()
          windowGeometry = wnckWindow.get_geometry()
          JSON.stringify(geometryArr) is JSON.stringify(clientGeometry)

        if check()
          # recheck needed
          delay 50, ->
            if check()
              delay 50, ->
                if check()
                  callback?(true)
                else
                  callback?(false)
            else
              callback?(false)
        else
          callback?(false)

      now = (new Date()).getTime()

      apply = ->
        time = ((new Date()).getTime() - now)
        global.log time

        test (hasDone) ->
          if hasDone
            null
          else
            _realSetGeometry geometryArr
            maxRetry--
            if maxRetry > 0
              delay 20, -> apply()
            else
              null
      apply()

    realSetGeometry @wnckWindow, target
