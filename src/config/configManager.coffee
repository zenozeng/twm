ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
uuid = Extension.uuid
helper = Extension.imports.helper
{spawn, spawnSync} = helper
defalutConfig = Extension.imports.config.defaultConfig.config
fs = Extension.imports.api.fs
ShellJS = imports.gi.ShellJS

class ConfigManager

  constructor: ->

    HOME = helper.spawnSync "sh -c 'echo $HOME'"
    PATH = (HOME + '/.twm').replace('\n', '')

    @installImporter PATH

    Config = global.twm.Config
    try
      config = Config.imports.twm.config
    catch e
      helper.log "ConfigManager: #{e}"
      config = null

    config = {} unless config?

    for key, value of defalutConfig
      unless config[key]?
        config[key] = value

    return config

  ###
  Add imports for config

  @private
  ###
  installImporter: (configPath) ->
    global.twm.importsTargetObject = {}
    ShellJS.add_extension_importer('global.twm.importsTargetObject', 'imports', configPath);
    global.twm.Extension = {imports: Extension.imports}
    global.twm.Config = {imports: global.twm.importsTargetObject.imports}
