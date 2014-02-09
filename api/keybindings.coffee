###
A dirty Hack for Keybinding API

Use dconf-editor for debug
###

{helper, spawn} = modules

keybindings = {}
commands = {}
fnIndex = 0;

###
Add a keybinding

@example Assign <Super>+G to lunch google-chrome
  var keybindings = modules.keybindings;
  var spawn = modules.spawn;
  var callback = function() {
    spawn("google-chrome");
  };
  keybindings.add("<Super>c", callback);

@param [String] keybinding the keybinding string
@param [Function] callback the function to be called when keydown
###
keybindings.add = (keybinding, callback) ->
  fnIndex++
  fn = "fn#{fnIndex}"
  global.twm.functions[fn] = ->
    try
      callback?()
    catch e
      helper.log e
  cmd = "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'global.twm.functions[\\\"#{fn}\\\"]()'"
  commands[keybinding] = cmd

###
Apply keybindings, should be called after all keybindings was added.
Config are written using gsettings.

@private
###
keybindings.apply = ->

  # object 2 array for conivence
  cmds = []
  for keybinding, cmd of commands
    cmds.push [cmd, keybinding]

  # seems that the first keybinding will nerver become effective
  # so add a fake keybinding as workround
  cmds.unshift ["", ""]

  # set custom keybindings
  customs = [0...cmds.length].map (index) -> "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{index}/"
  spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings '#{JSON.stringify customs}'"
  # set commands
  for i in [0...cmds.length]
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[i]} binding '#{cmds[i][1]}'"
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[i]} command \"#{cmds[i][0]}\""
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[i]} name 'twm:#{i}'"

# exposed to moudles
modules.keybindings = keybindings
