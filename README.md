# Omagato plugin

Omarchy shell bar widget and menu for [Omagato](https://github.com/pdphillips/omagato). This repo is `manifest.json` and QML only. It talks to the daemon on `$XDG_RUNTIME_DIR/omagato.sock` and does not open HID.

Colors come from the shell theme (`Color`, `Style`), not fixed hex values.

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
