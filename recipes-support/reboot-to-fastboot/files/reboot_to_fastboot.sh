#!/bin/sh
set -e

echo "[INFO] ===== Fastboot Reboot Script ====="

# --- Check root ---
if [ "$(id -u)" != "0" ]; then
    echo "[ERROR] This script must be run as root!"
    exit 1
fi

echo "[INFO] Running as root ✅"

# --- USB warning ---
echo "[WARNING]"
echo "--------------------------------------------------"
echo "Make sure the USB OTG/Device cable is ALREADY"
echo "connected to the host PC BEFORE reboot."
echo "--------------------------------------------------"

ROOT_DEV=$(findmnt -n -o SOURCE /)
BASE_DEV=$(lsblk -no PKNAME "$ROOT_DEV" 2>/dev/null || true)

[ -z "$BASE_DEV" ] && BASE_DEV=$(basename "$ROOT_DEV")
BASE_DEV="/dev/$BASE_DEV"

case "$BASE_DEV" in
    /dev/mmcblk*)
        ;;
    *)
        echo "[ERROR] Unsupported root device ($BASE_DEV)"
        exit 1
        ;;
esac

cat > /etc/fw_env.config <<EOF
$BASE_DEV 0x700000 0x4000
EOF

if ! fw_printenv > /dev/null 2>&1; then
    echo "[ERROR] Cannot access U-Boot environment!"
    echo "[HINT] Run 'saveenv' once in U-Boot"
    exit 1
fi

OLD_BOOTCMD=$(fw_printenv -n bootcmd)

fw_setenv bootcmd "setenv bootcmd '${OLD_BOOTCMD}'; saveenv; fastboot usb 0"

echo "[INFO] Rebooting into fastboot..."
sleep 3
reboot
