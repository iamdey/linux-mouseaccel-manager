# Configure / disable mouseaccel

Install a script to disable mouseaccel. This script supports multi-entry devices (like some razer
mouses). It adds the installed script to the gnome autostart.

## Dependencies

- xinput
- [optional] gnome
- libnotify-bin

## Usage

```
./configure.sh install <search term>
```

_(see `./configure.sh status` for connected devices)_

Then launch `~/bin/disable_mouse_accel.sh` each time you login.
