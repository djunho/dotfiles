# kanata Corne port

Replicates the layers and ergonomic features of my [ZMK Corne](../../Corne) keymap
on ordinary keyboards, using [kanata](https://github.com/jtroo/kanata) as a
host-side remapper.

The Corne keeps running ZMK in firmware. kanata runs on this machine and only
touches the **laptop's built-in keyboard** and the **external SONiX keyboard** —
never the Corne itself.

## What's ported

| Feature | ZMK source | kanata mechanism |
|---|---|---|
| 4 layers: base / raise / lower / fn | `keymap` | `deflayer` + `layer-while-held` |
| Bilateral homerow mods (opposite-hand only) | `hm_l` / `hm_r` hold-taps | `tap-hold-release-keys` + `require-prior-idle` |
| Symbol layer (`! @ # … { } | ~`) | `raise_layer` | `raise` layer |
| Nav + numpad | `lower_layer` | `lower` layer |
| F-keys | `fn_layer` | `fn` layer (tri-layer: Space+RCtrl) |
| Bracket/paren combos | `combos` | `defchordsv2` |
| € and dead-circumflex via AltGr | `EURO` / `DEAD_CARET` | `AG-5` / `AG-6` |

**Not ported** (firmware/radio-only, meaningless on a host): Bluetooth profile
switching, `studio_unlock`, `sys_reset`, `bootloader` — i.e. the whole ZMK
`adjust_layer`.

## Layer triggers (the one big change from the Corne)

The Corne triggers layers with thumb keys that don't exist on a normal board.
Because the homerow mods already provide every modifier, the bottom-row mod keys
are free to reuse:

- **raise** (symbols) = hold **Space** (tapping Space still types a space)
- **lower** (nav/num) = hold **Right Ctrl**
- **fn** (F-keys) = hold **Space + Right Ctrl**

**Right Alt is deliberately left as AltGr** so `us(altgr-intl)` dead keys keep
working. To change the scheme, edit the `spc` / `lwr` aliases and the bottom row
of each `deflayer` in [`kanata.kbd`](kanata.kbd).

> If your laptop has no physical Right Ctrl, rebind `lower` to another key, or
> the nav/number layer will be unreachable there.

## Quick install (Arch)

```fish
./install.sh
```

Run it as your **normal user** (not with sudo). It is idempotent and will:
install kanata (AUR helper → pacman → cargo), validate `kanata.kbd`, set up
rootless input/uinput permissions, and install + enable a systemd user service.
If it adds you to the `input` group you must log out/in once before the service
can start.

The rest of this README documents what the script does, for doing it by hand.

## Install manually (Arch)

```fish
# from the AUR (binary or build):
paru -S kanata-bin      # or: paru -S kanata
# or via cargo:
cargo install kanata
```

## Permissions (rootless, recommended)

kanata reads from `/dev/input/*` and writes to `/dev/uinput`.

```fish
# 1. join the input group (log out/in afterwards for it to take effect)
sudo usermod -aG input $USER

# 2. allow the input group to use uinput, and load the module at boot
echo 'KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput", RUN+="/usr/bin/setfacl -m g::rw /dev/uinput"' \
  | sudo tee /etc/udev/rules.d/99-uinput-kanata.rules
echo uinput | sudo tee /etc/modules-load.d/uinput.conf
sudo udevadm control --reload-rules && sudo udevadm trigger && sudo udevadm settle
sudo modprobe uinput
```

(If you'd rather not bother, just run kanata with `sudo` — but the rootless
setup is needed for the systemd **user** service.)

### Why the `setfacl` part? (brltty conflict)

If `brltty` is installed (it's in the `input` group by default on Arch), its
`/usr/lib/udev/rules.d/90-brltty-uinput.rules` puts an **ACL** on `/dev/uinput`
*before* our rule runs. Once a file has an ACL, a plain `MODE=0660` only sets the
ACL **mask**, not the owning-group entry — so `getfacl /dev/uinput` shows
`group::---` and `input` members (including kanata) get *Permission denied*. The
trailing `setfacl -m g::rw` repairs the `group::` entry. Verify with:

```fish
getfacl /dev/uinput      # group:: should read rw-, not ---
test -w /dev/uinput && echo writable || echo NOT writable
```

> Alternative: if you don't use a braille display, you can instead neutralize
> brltty's rule with `sudo ln -sf /dev/null /etc/udev/rules.d/90-brltty-uinput.rules`
> and skip the `setfacl` part — but the ACL approach is non-destructive.

## Verify the device paths

The config hardcodes two device symlinks. Confirm they still exist:

```fish
ls -l /dev/input/by-path/platform-i8042-serio-0-event-kbd   # laptop internal
ls -l /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd        # external SONiX
```

If the SONiX has a different name, find it with:

```fish
grep -iE 'Name=|Handlers=' /proc/bus/input/devices
ls /dev/input/by-id/
```

## Run

```fish
# 1. ALWAYS validate first
kanata --check --cfg kanata.kbd

# 2. run in the foreground to watch the log
kanata --cfg kanata.kbd
```

kanata prints every input device it grabs at startup — check the Corne is **not**
in that list.

## Run as a service

The unit references kanata's **standard config location** (`~/.config/kanata/kanata.kbd`)
rather than this repo's path, so it doesn't care where the repo lives. Symlink
the config there, then install the unit:

```fish
# 1. point kanata's standard location at this repo's config
mkdir -p ~/.config/kanata
ln -sfn (pwd)/kanata.kbd ~/.config/kanata/kanata.kbd

# 2. install + enable the unit (uses %E/kanata/kanata.kbd -> the symlink above)
mkdir -p ~/.config/systemd/user
cp kanata.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now kanata.service
journalctl --user -u kanata -f      # follow logs
```

`install.sh` does both the symlink and the unit for you. Because the unit holds
no repo path, **moving the repo never requires regenerating it** — just re-point
the symlink (or re-run `install.sh`).

## Tuning

All timings live in the `defvar` block of `kanata.kbd`:

- **Homerow mods feel sluggish / hard to trigger** → lower `hr-hold` (250 ms).
- **Homerow mods firing during same-hand rolls** → raise `hr-hold`.
- **Brackets misfiring or hard to chord** → adjust `chord-time` (40 ms).
- **Space-hold layer triggering mid-word** → raise `hr-hold`, or switch `raise`
  off Space onto e.g. Left Alt (edit the `spc` alias + the bottom rows).

kanata also has a newer `tap-hold-opposite-hand` action purpose-built for
bilateral homerow mods — worth trying as an upgrade once the basics feel right.

### Prior-idle (emulated now; native in 1.12)

ZMK's `require-prior-idle-ms 150` (treat a tap-hold as a plain tap if you were
just typing) has **no native equivalent in kanata 1.11.0** — the global
`tap-hold-require-prior-idle` option only exists on `main` and ships in **1.12**.

Until then it's **emulated** by the `hrm` `deftemplate` in `kanata.kbd`: a
`switch` checks `(key-timing $idle-recency less-than $idle-ms)` and, if the
previous key was recent, emits the plain letter instead of arming the modifier.

Tuning (in the `defvar` block):

- **Homerow mods fire while typing fast** → raise `idle-ms` (150 → 180/200).
- **Homerow mods NEVER produce a modifier** (always type the letter) → the
  current keypress is being measured; set `idle-recency` to `2`.
- **A deliberate mod needs too long a pause** → lower `idle-ms`.

**When 1.12 lands** you can simplify: delete the `switch`/`key-timing` wrapper in
the `hrm` template (leaving just the `tap-hold-release-keys` line) and add one
line to `defcfg`:

```lisp
tap-hold-require-prior-idle 150
```

then re-validate with `kanata --check --cfg kanata.kbd`. The native option is
simpler and matches the ZMK setup 1:1; the emulation is only needed pre-1.12.
