{spawnSync} = modules

home = spawnSync "echo $HOME"

###
Compile config/defalut.coffee to ~/.twm.js

@private
###
create: ->
  false

###
Try to load config.
~/.twm.js first, ~/.twm.coffee then.
Create one if none exits

@param [Function] callback the function to be called when done
###
load: (callback) ->
  false
