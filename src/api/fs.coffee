ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
spawnSync = Extension.imports.helper.spawnSync

fs = {}

###
Read File Contents

@param [String] filename Absolute path of the file
###
fs.readFileSync = (filename) -> spawnSync "cat #{filename}"

###
Test whether file exists

@param [String] path Absolute path of the file
###
fs.existsSync = (path) ->
  result = spawnSync "[ -f #{path} ] && echo 'Found' || echo 'Not found'"
  exists = result is 'Found'
