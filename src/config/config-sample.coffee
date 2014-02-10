ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
helper = Extension.imports.helper
# defalutConfig = Extension.imports.config.defalut.config

onStartup = -> false

myKeybindings = []

# myLayouts = defalutConfig.layouts.concat ["3-column"]
myLayouts = []

helper.log "helper!"

# expose to config
config =
  onStartup: onStartup
  layouts: myLayouts
  keybindings: myKeybindings
