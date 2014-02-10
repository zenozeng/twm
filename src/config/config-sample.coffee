ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
defalutConfig = Extension.imports.config.defaultConfig.config

onStartup = -> false

# helper.log "This is in config file!"

# Example: Ignore all gimp windows
myWindowsFilter = (win) -> win.wmClass.indexOf 'gimp' is -1


# expose to config
config =
  windowsFilter: myWindowsFilter
