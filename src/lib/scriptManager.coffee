ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()

class ScriptManager

  constructor: ->

    # 单例模式
    if ScriptManager.instance?
      return ScriptManager.instance
    ScriptManager.instance = this

    # Connect to Gjs Server
    # Create one if not exists

    @runningScripts = {}
    return this

  call: (scriptName, args, callback) ->
    scriptId = scriptName + JSON.stringify(args)
    unless @runningScripts[scriptId]
      @runningScripts[scriptId] = {uuid: uuid, callback: callback}
      uuid = (new Date()).getTime() + scriptName

  gc: (scriptId) ->
    {uuid, callback} = @runningScripts[scriptId]
    @runningScripts[scriptId] = false
    spawn "sh -c \"ps -ef | grep #{gjsDir} | grep #{uuid} | awk '{print $2}' | xargs kill -9\""
    callback?()
