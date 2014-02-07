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

commands = []
fnIndex = 0;

keybindings.add = (keybinding, callback) ->
  fnIndex++
  fn = "fn#{fnIndex}"
  global.twm.functions[fn] = callback
  cmd = "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'global.twm.functions[\\\"#{fn}\\\"]()'"
  commands.push [cmd, keybinding]

  # keybindings.apply()

# write to dconf using gsettings
keybindings.apply = ->
  helper.log JSON.stringify(commands)
  customs = [1..commands.length].map (nth) -> "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{nth}/"
  spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings '#{JSON.stringify customs}'"
  for nth in [0...commands.length]
    # set to add and reset to force enable
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[nth]} binding '#{commands[nth][1]}'"
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[nth]} command \"#{commands[nth][0]}\""
    spawn "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:#{customs[nth]} name 'twm-#{nth}'"

global.twm.apply = keybindings.apply

modules.keybindings = keybindings
