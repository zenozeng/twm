// Generated by CoffeeScript 1.6.3
var Extension, ExtensionUtils, existsSync, readFileSync, spawnSync;

ExtensionUtils = imports.misc.extensionUtils;

Extension = ExtensionUtils.getCurrentExtension();

spawnSync = Extension.imports.helper.spawnSync;

/*
Read File Contents

@param [String] filename Absolute path of the file
*/


readFileSync = function(filename) {
  return spawnSync("cat " + filename);
};

/*
Test whether file exists

@param [String] path Absolute path of the file
*/


existsSync = function(path) {
  var exists, result;
  result = spawnSync("sh -c \"[ -f " + path + " ] && echo 'Found' || echo 'Not found'\"");
  return exists = result.replace('\n', '') === 'Found';
};
