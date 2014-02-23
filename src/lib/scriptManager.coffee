ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()

class ScriptManager

  constructor: ->

    if ScriptManager.instance?
      return ScriptManager.instance
    ScriptManager.instance = this
    return this

  run: (scriptName, args, callback) ->
    scriptId = (new Date()).getTime() + scriptName

  gc: (scriptId) ->
    spawn "sh -c \"ps -ef | grep #{gjsDir} | grep #{timestamp} | awk '{print $2}' | xargs kill -9\""

  
