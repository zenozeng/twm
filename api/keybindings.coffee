######################################
#
# A dirty Hack for Keybinding support
#
# Tested in Gnome Shell 3.8.4 (Debian Sid)
#
# Usage:
# keybinds.add "<Super>o", -> helper.log "hello!"
#
######################################

{helper, spawn} = modules

keybindings = {}

commands = {}
fnIndex = 0;

keybindings.add = (keybinding, callback) ->
  fnIndex++
  fn = "fn#{fnIndex}"
  global.twm.functions[fn] = callback
  cmd = "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'global.twm.functions[\\\"#{fn}\\\"]()'"
  commands[keybinding] = cmd

  # keybindings.apply()

# write to dconf using gsettings
keybindings.apply = ->
  # object 2 array for conivence
  cmds = []
  for keybinding, cmd of commands
    cmds.push [cmd, keybinding]
  helper.log JSON.stringify(cmds)
  # set custom keybindings
  customs = [0...cmds.length].map (index) -> "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{index}/"
  spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings '#{JSON.stringify customs}'"
  # set commands
  for i in [0...cmds.length]
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[i]} binding '#{cmds[i][1]}'"
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[i]} command \"#{cmds[i][0]}\""
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[i]} name 'twm:#{i}'"

global.twm.apply = keybindings.apply

modules.keybindings = keybindings
