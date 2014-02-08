# TWM

Current, only Gnome Shell 3.8 was supported. I have not tested in Gnome Shell 3.10 yet.

## Doc

I am using Coffee Script & using [codo](https://github.com/coffeedoc/codo) as documentation generator.
Docs can be found in api/doc

## Keybindings

Keybindings Config are based on gsettings & gdbus, and it will overwrite your custom shortcuts in Gnome Settings.  Backup them first!

## Config File

Coffee Script is supported by default, CoffeeScript Compiler v1.7.1 was included.

## License

GPL v3

## Ref

https://wiki.gnome.org/Projects/GnomeShell/Extensions

https://wiki.gnome.org/Projects/GnomeShell/LookingGlass

https://mail.gnome.org/archives/commits-list/2013-February/msg00140.html

http://sander.github.io/tmp/gsdoc/documentation.html

Source Code can be viewed in /usr/share/gnome-shell/js/ui

`grep set_ * | grep actor`


### Keybinding

- http://www.mibus.org/2013/02/15/making-gnome-shell-plugins-save-their-config/

- https://git.gnome.org/browse/mutter/tree/src/core/keybindings.c

### GIO

- https://developer.gnome.org/gio/unstable/

- https://git.gnome.org/browse/gjs/tree/examples/gio-cat.js

- http://blog.fpmurphy.com/2011/05/hack-to-fix-gnome-shell-stylesheet-problems.html
