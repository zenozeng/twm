ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
defalutConfig = Extension.imports.config["default-config"].config

onStartup = -> false

# helper.log "This is in config file!"

# expose to config
config = {}
