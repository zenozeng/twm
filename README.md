# TWM

Current, only Gnome Shell 3.8 was supported. I have not tested in Gnome Shell 3.10 yet.

这个插件不是那么得符合 Gnome 的 Coding Style，颇有些黑科技的味道，但是我只是希望暴露到 user 上的东西
可以更好更容易的去使用就好了。也许这支插件不会上 Gnome 官方的插件中心。

顺便吐个槽：Gnome Shell 的文档非常少，很多 API 都找不到，不得不去读 Gnome Shell 的一些js源代码。
经常没找到方便的API，甚至有时候不得不用 unstable 的私有API。

## Meta Window API

源代码：

in `https://github.com/GNOME/mutter`

see `src/meta/window.h`, `src/core/window.c`

文档：

https://developer.gnome.org/meta/unstable/MetaWindow.html

奇怪的是，当 focus 在当前 window 时， `meta_window_move_resize_frame` 就无效了。
像 Emacs 这种以 usehint 作为尺寸单位的，一般难以用 px 作为单位来调整，比如原先给了 683px 刚好排不下一个字符的宽度，于是就少了10多px，给684px，刚好多一个字符，多了10多px。Gnome Shell 半屏最大化的时候是给两边这接注入空白，类似padding的感觉来实现使之宽度稳定在一个确定的尺寸上的。

[14.1.7 Setting and Reading the WM_NORMAL_HINTS Property](http://tronche.com/gui/x/xlib/ICC/client-to-window-manager/wm-normal-hints.html)

这是我的 Emacs，用 xprop 读到的。

```
WM_NORMAL_HINTS(WM_SIZE_HINTS):
		program specified minimum size: 36 by 38
		program specified resize increment: 9 by 19
		program specified base size: 27 by 19
		window gravity: NorthWest
```

这是我的 Chrome，

```
WM_NORMAL_HINTS(WM_SIZE_HINTS):
		program specified minimum size: 387 by 90
		window gravity: NorthWest
```

扩号里头应该是类型。


用 `xprop -f WM_SIZE_HINTS 32i` 可以读到
`WM_NORMAL_HINTS(WM_SIZE_HINTS) = 848, 0, 0, 1, 0, 36, 38, 12691600, 0, 9, 19, 12874720, 0, 33206688, 0, 27, 19, 1`，
猜测为上下界，参数（可能）见下

```
#define USPosition	(1L << 0)	/* user specified x, y */
#define USSize		(1L << 1)	/* user specified width, height */
#define PPosition	(1L << 2)	/* program specified position */
#define PSize		(1L << 3)	/* program specified size */
#define PMinSize	(1L << 4)	/* program specified minimum size */
#define PMaxSize	(1L << 5)	/* program specified maximum size */
#define PResizeInc	(1L << 6)	/* program specified resize increments */
#define PAspect		(1L << 7)	/* program specified min and max aspect ratios */
#define PBaseSize	(1L << 8)
#define PWinGravity	(1L << 9)
#define PAllHints	(PPosition|PSize|PMinSize|PMaxSize|PResizeInc|PAspect)
```

其中第10和第11为 program specified resize increment。

## 换用 libwnck

比起直接用 Window Actor 大概有以下好处：

- API 文档更全

- API 稳定

- 靠谱的获取 XID 方式: `wnckWindow.get_xid()`

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

这是我一些肤浅的阅读笔记。如有错误之处，还望指正。

### Lang.Class

GJS 里头写 Class 的方式，此时 this 的行为和js默认不一样，而是按照正常的预期样子。

### workspace

overview -> workspaceThumbnail -> workspaceView -> workspace

最终 workspace 里的 _closeWindow 指的是删除 clone 的 Actor
应该注意的是 _onWindowAdded 的行为

### Keybinding

windowManager.js 里头有个 `setCustomKeybindingHandler`
指向了 `Meta.keybindings_set_custom_handler(name, handler)`

这一部分应该是C写的，然后封装成 gi 对象来操作的样子，
这里有文档：
https://developer.gnome.org/meta/unstable/meta-MetaKeybinding.html
然后源代码在 mutter/src/core/keybindings.c

几个函数值得注意一下：

- `meta_display_add_keybinding`
- `meta_display_remove_keybinding`
- `meta_display_get_keybinding_action`

注意一点，Meta.display 在 Gnome Shell 中是 bind 到了 global.display 中的，
所以 GJS 中相应的函数名为 `global.display.get_keybinding_action`

在 C 源代码里可以读到：
```
  if (binding)
    {
      MetaKeyGrab *grab = g_hash_table_lookup (external_grabs, binding->name);
      if (grab)
        return grab->action;
      else
        return (guint) meta_prefs_get_keybinding_action (binding->name);
    }
  else
    {
      return META_KEYBINDING_ACTION_NONE;
    }
```

`meta_prefs_get_keybinding_action` 对应 GJS 里头的 `Meta.prefs_get_keybinding_action`

比如 `Meta.prefs_get_keybinding_action('maximize')` 就会读取绑在 `<Super>+Up` 上的 action，
返回的是个 guint。

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
