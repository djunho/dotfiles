#!/usr/bin/env bash
#
# install.sh — install + configure kanata for the Corne port on Arch Linux.
#
# Steps (all idempotent — safe to re-run):
#   1. install kanata (AUR helper -> pacman -> cargo, whichever is available)
#   2. validate the config with `kanata --check`
#   3. grant rootless input/uinput permissions (input group + udev rule + module)
#   4. install & enable a systemd --user service pointing at kanata.kbd
#
# Run as your NORMAL user (NOT with sudo); it calls sudo only where needed.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="$SCRIPT_DIR/kanata.kbd"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
UNIT="$UNIT_DIR/kanata.service"
UDEV_RULE="/etc/udev/rules.d/99-uinput-kanata.rules"
MODLOAD="/etc/modules-load.d/uinput.conf"
# kanata's standard auto-discovery location; we symlink the repo config here so
# the service references a stable path independent of where this repo lives.
STD_CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kanata"
STD_CFG="$STD_CFG_DIR/kanata.kbd"

# ---- pretty logging ---------------------------------------------------------
info() { printf '\033[1;34m::\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m ✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m !\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m ✗ %s\033[0m\n' "$*" >&2; exit 1; }

# ---- 0. sanity checks -------------------------------------------------------
[[ $EUID -ne 0 ]]           || die "Run as your normal user, not root/sudo — it will sudo itself when needed."
command -v sudo >/dev/null  || die "sudo is required but not found."
[[ -f "$CFG" ]]             || die "Config not found next to this script: $CFG"

# cargo installs land here; make sure they're visible this session
export PATH="$HOME/.cargo/bin:$PATH"

# ---- 1. install kanata ------------------------------------------------------
install_kanata() {
    if command -v kanata >/dev/null; then
        ok "kanata already installed ($(command -v kanata))"
        return
    fi

    info "kanata not found — installing…"
    if command -v yay >/dev/null; then
        yay -S --needed --noconfirm kanata-bin
    elif command -v paru >/dev/null; then
        paru -S --needed --noconfirm kanata-bin
    elif command -v pacman >/dev/null && pacman -Si kanata >/dev/null 2>&1; then
        sudo pacman -S --needed --noconfirm kanata
    elif command -v cargo >/dev/null; then
        warn "No AUR helper / repo package found — building from source with cargo (slow)…"
        cargo install kanata
    else
        die "Could not install kanata. Install an AUR helper (paru/yay) or rustup, then re-run."
    fi

    command -v kanata >/dev/null || die "kanata install reported success but the binary isn't on PATH."
    ok "Installed kanata ($(command -v kanata))"
}
install_kanata
KANATA_BIN="$(command -v kanata)"

# ---- 2. validate the config -------------------------------------------------
info "Validating $CFG …"
if "$KANATA_BIN" --check --cfg "$CFG"; then
    ok "Config is valid."
else
    die "Config failed validation — fix kanata.kbd before continuing (nothing else was changed)."
fi

# ---- 3. rootless permissions ------------------------------------------------
# 3a. input group membership (needed to read /dev/input and write /dev/uinput)
if id -nG "$USER" | grep -qw input; then
    ok "User '$USER' is already in the 'input' group."
else
    info "Adding '$USER' to the 'input' group…"
    sudo usermod -aG input "$USER"
    warn "Group change takes effect after you LOG OUT and back in (or reboot)."
    RELOGIN_NEEDED=1
fi

# 3b. ensure setfacl exists (needed by the udev rule below; also used by brltty)
if ! command -v setfacl >/dev/null; then
    info "Installing 'acl' (provides setfacl)…"
    sudo pacman -S --needed --noconfirm acl
fi

# 3c. udev rule so the input group may use /dev/uinput.
# The trailing setfacl restores the owning-group ('input') permission on the
# group:: ACL entry. It is required because brltty's 90-brltty-uinput.rules adds
# an ACL to /dev/uinput first; once an ACL exists, plain MODE=0660 only sets the
# ACL *mask*, leaving group:: as '---' so 'input' members (incl. kanata) get
# nothing. This rule runs at 99 (after brltty's 90), so the setfacl wins.
read -r -d '' UDEV_CONTENT <<'EOF' || true
KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput", RUN+="/usr/bin/setfacl -m g::rw /dev/uinput"
EOF
if [[ -f "$UDEV_RULE" ]] && [[ "$(cat "$UDEV_RULE")" == "$UDEV_CONTENT" ]]; then
    ok "udev rule already in place ($UDEV_RULE)."
else
    info "Writing udev rule $UDEV_RULE…"
    printf '%s\n' "$UDEV_CONTENT" | sudo tee "$UDEV_RULE" >/dev/null
    sudo udevadm control --reload-rules && sudo udevadm trigger && sudo udevadm settle
    ok "udev rule installed and reloaded."
fi

# 3d. load the uinput module now and on every boot
if [[ -f "$MODLOAD" ]] && grep -qx uinput "$MODLOAD"; then
    ok "uinput configured to load at boot."
else
    info "Configuring uinput to load at boot ($MODLOAD)…"
    echo uinput | sudo tee "$MODLOAD" >/dev/null
fi
if lsmod | grep -qw '^uinput'; then
    ok "uinput module is loaded."
else
    info "Loading uinput module now…"
    sudo modprobe uinput && ok "uinput loaded."
fi

# ---- 3e. sanity-check the configured devices exist --------------------------
info "Checking the keyboards referenced in kanata.kbd…"
# pull the linux-dev paths straight out of the config (colon-separated)
DEV_LINE="$(grep -E '^\s*linux-dev\s' "$CFG" | head -n1 | sed -E 's/^\s*linux-dev\s+//')"
IFS=':' read -ra DEVS <<<"$DEV_LINE"
for dev in "${DEVS[@]}"; do
    if [[ -e "$dev" ]]; then
        ok "found  $dev"
    else
        warn "missing $dev  (unplugged? that's fine — linux-continue-if-no-devs-found is set)"
    fi
done

# ---- 4. symlink config to kanata's standard location ------------------------
# Lets both the service and a bare `kanata` find the config regardless of where
# this repo lives. The symlink target is the only place that knows the repo path.
info "Linking config into kanata's standard location…"
mkdir -p "$STD_CFG_DIR"
ln -sfn "$CFG" "$STD_CFG"
ok "Linked $STD_CFG -> $CFG"

# ---- 5. systemd --user service ---------------------------------------------
# ExecStart references the standard location via the %E (config dir) specifier,
# so the unit contains NO repo path and never needs regenerating after a move.
info "Installing systemd --user service…"
mkdir -p "$UNIT_DIR"
cat > "$UNIT" <<EOF
[Unit]
Description=kanata keyboard remapper (Corne port)
Documentation=https://github.com/jtroo/kanata

[Service]
ExecStart=$KANATA_BIN --cfg %E/kanata/kanata.kbd
Restart=on-failure
RestartSec=2

[Install]
WantedBy=default.target
EOF
ok "Wrote $UNIT"

systemctl --user daemon-reload
systemctl --user enable kanata.service >/dev/null
ok "Service enabled (will start on login)."

if [[ "${RELOGIN_NEEDED:-0}" == "1" ]]; then
    warn "Not starting now: you were just added to 'input'. Re-login or reboot, then:"
    warn "    systemctl --user start kanata.service"
else
    # clear any prior failed/rate-limited state from earlier attempts
    systemctl --user reset-failed kanata.service 2>/dev/null || true
    if systemctl --user restart kanata.service; then
        sleep 1
        if systemctl --user is-active --quiet kanata.service; then
            ok "Service started and running."
        else
            warn "Service started but isn't active — check:  journalctl --user -u kanata -e"
        fi
    else
        warn "Could not start the service. Check logs:  journalctl --user -u kanata -e"
    fi
fi

echo
ok "Done."
echo "  Status:  systemctl --user status kanata.service"
echo "  Logs:    journalctl --user -u kanata -f"
echo "  Confirm the Corne is NOT in kanata's grabbed-device list in those logs."
