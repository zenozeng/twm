# TWM

Current, only Gnome Shell 3.8 was supported. I have not tested in Gnome Shell 3.10 yet.

这个插件不是那么得符合 Gnome 的 Coding Style，颇有些黑科技的味道，但是我只是希望暴露到 user 上的东西
可以更好更容易的去使用就好了。也许这支插件不会上 Gnome 官方的插件中心。

顺便吐个槽：Gnome Shell 的文档非常少，很多 API 都找不到，不得不去读 Gnome Shell 的一些js源代码。
经常没找到方便的API，甚至有时候不得不用 unstable 的私有API。

## Doc

I am using Coffee Script & using [codo](https://github.com/coffeedoc/codo) as documentation generator.
Docs can be found in api/doc

## Keybindings

Keybindings Config are based on gsettings & gdbus, and it will overwrite your custom shortcuts in Gnome Settings.  Backup them first!

## Config File

Coffee Script is supported by default, CoffeeScript Compiler v1.7.1 was included.

## License

GPL v3

## Gnome-shell 源代码阅读笔记

如有错误之处，还望指正。

### Lang.Class

GJS 里头写 Class 的方式，此时 this 的行为和js默认不一样，而是按照正常的预期样子。

### workspace

overview -> workspaceThumbnail -> workspaceView -> workspace

最终 workspace 里的 _closeWindow 指的是删除 clone 的 Actor
应该注意的是 _onWindowAdded 的行为

## Ref

### Hint

LookingGlass 的调试结果有下划线的是可点击的，是可以查看明细的。左边的取色状工具可以取得窗口的具体信息。

#### Log Everything

`nohup gnome-shell --replace > log &`

### Hide title bar

- http://askubuntu.com/questions/131159/hide-window-title-in-gnome-shell-using-mutter-gdk-wnck-or-gtk

- https://developer.gnome.org/gdk3/stable/gdk3-Windows.html

- [Re: gdk.window set_decorations works in python not javascript bindings (v3.0)](https://mail.gnome.org/archives/gnome-shell-list/2012-May/msg00023.html)

- http://askubuntu.com/questions/293195/how-can-i-turn-off-window-titlebars-window-decorations-in-gnome-shell-mutter

- https://developer.gnome.org/gtk3/3.8/GtkWindow.html

- http://mathematicalcoffee.blogspot.com/2012/05/automatically-undecorate-maximised.html

### Startup

- https://wiki.gnome.org/Projects/GnomeShell/Extensions

- https://wiki.gnome.org/Projects/GnomeShell/LookingGlass

- https://mail.gnome.org/archives/commits-list/2013-February/msg00140.html

### UI

Source Code can be viewed in /usr/share/gnome-shell/js/ui

`grep set_ * | grep actor`

- http://sander.github.io/tmp/gsdoc/documentation.html

- https://wiki.gnome.org/Projects/GnomeShell/Extensions/StepByStepTutorial#knowingClutter-someExamples-signals

### Keybinding

- http://www.mibus.org/2013/02/15/making-gnome-shell-plugins-save-their-config/

- https://git.gnome.org/browse/mutter/tree/src/core/keybindings.c

### GIO

- https://developer.gnome.org/gio/unstable/

- https://git.gnome.org/browse/gjs/tree/examples/gio-cat.js

- http://blog.fpmurphy.com/2011/05/hack-to-fix-gnome-shell-stylesheet-problems.html
