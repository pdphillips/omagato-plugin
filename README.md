# Omagato plugin

Omarchy shell bar widget and menu for [Omagato](https://github.com/pdphillips/omagato). This repo is `manifest.json` and QML only. It talks to the daemon on `$XDG_RUNTIME_DIR/omagato.sock` and does not open HID.

Colors come from the shell theme (`Commons.Color`, `Commons.Style`), not fixed hex values.

## Compatibility

Omarchy 4.0.6 and Quickshell 0.3.2 (revision `2b4501a282689792b62e94f3fb30d8f512324fe6`, the build Omarchy ships). That stack uses Qt 6.12, whose `QtQuick` module has its own `Color` type, so theme colors are read as `Commons.Color`.

## Install

Build the app first so `omagato-gui` and `omagato-daemon` are on `PATH`. See the [app README](https://github.com/pdphillips/omagato) (`cargo build --release`, systemd user service, udev).

```bash
omarchy plugin add https://github.com/pdphillips/omagato-plugin --enable
```

A local checkout works the same way:

```bash
omarchy plugin add /path/to/omagato-plugin --enable
```

Validate before adding:

```bash
omarchy plugin validate .
```

The bar shows whether the daemon is up. The menu can mute output, mute the mic, bump brightness, change page, open the Omagato window, and reconnect.
