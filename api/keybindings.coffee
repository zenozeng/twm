######################################
#
# A dirty Hack for keybinding support
#
# Tested in Gnome Shell 3.8.4
#
######################################

{helper, spawn} = modules

KEYBINDINGS_SCHEMA = 'org.gnome.shell.extensions.twm.keybindings'

maxKeybindings = 256

keybinding = {}

keybinding.add = (keybinding, callback) ->
  if keybinding.length > maxKeybindings
    helper.log "Error: too many keybindings"
  else
    index = keybindings.length - 1
    Main.wm.addKeybinding "custom-#{index}",
      new Gio.Settings({ schema: KEYBINDINGS_SCHEMA }),
      Meta.KeyBindingFlags.NONE,
      Shell.KeyBindingMode.NORMAL |
      Shell.KeyBindingMode.TOPBAR_POPUP,
      callback

    spawn "gsettings set org.gnome.shell.extensions.twma.keybindings custom-#{index} \"#{keybinding}\""

modules.keybinding = keybinding
