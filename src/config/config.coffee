ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
uuid = Extension.uuid
helper = Extension.imports.helper
spawn = helper.spawn
defalutConfig = Extension.imports.config["default-config"].config
fs = Extension.imports.api.fs

class Config

  constructor: ->

    HOME = helper.spawnSync "sh -c 'echo $HOME'"
    PATH = (HOME + '/.twm').replace('\n', '')

    if fs.existsSync PATH + '/twm.js'
      js = fs.readFileSync PATH + '/twm.js'
    else if fs.existsSync PATH + '/twm.coffee'
      filename = PATH + '/twm.coffee'
      js = spawnSync "coffee -p #{filename}"
    else
      @create()

    inject = "var Extension = imports.misc.extensionUtils.extensions[#{uuid}];"
    config = (Function(inject + js + ';return config;'))()

  ###
  Cp config/defalut.js to ~/.twm/twm.js

  @private
  ###
  create: -> false
