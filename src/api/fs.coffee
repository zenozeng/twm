ExtensionUtils = imports.misc.extensionUtils
Extension = ExtensionUtils.getCurrentExtension()
spawnSync = Extension.imports.helper.spawnSync

###
Read File Contents

@param [String] filename Absolute path of the file
###
readFileSync = (filename) -> spawnSync "cat #{filename}"

###
Test whether file exists

@param [String] path Absolute path of the file
###
existsSync = (path) ->
  result = spawnSync "[ -f #{path} ] && echo 'Found' || echo 'Not found'"
  exists = result is 'Found'
