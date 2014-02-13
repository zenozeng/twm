# Gnome Shell 的一些 API 整理


```
Main.shellDBusService.Eval
```



## Focus Search

/js/ui/shellDBus.js

- `Main.overview.focusSearch();`

- `gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.FocusSearch`

## Lock

/js/ui/shellDBus.js

`gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/ScreenSaver --method org.gnome.ScreenSaver.Lock`

`xdg-screensaver lock`
