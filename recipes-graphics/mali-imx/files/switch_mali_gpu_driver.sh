#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root. Please use sudo:"
    echo "   sudo $0"
    exit 1
fi

MODPROBE_DIR="/etc/modprobe.d"
LDCONF_DIR="/etc/ld.so.conf.d"
LDCONF_FILE="$LDCONF_DIR/mali-imx.conf"
VULKAN_DIR="/etc/vulkan"
VULKAN_BACKUP="/etc/vulkan-mali-imx"

function blacklist_module() {
    local module=$1
    echo "blacklist $module" > "$MODPROBE_DIR/blacklist-$module.conf"
    echo "✅ Blacklisted $module"
}

function unblacklist_module() {
    local module=$1
    rm -f "$MODPROBE_DIR/blacklist-$module.conf"
    echo "✅ Unblacklisted $module"
}

function add_ldconfig_path() {
    echo "/usr/lib/mali-imx" > "$LDCONF_FILE"
    ldconfig
    echo "✅ Added /usr/lib/mali-imx to ldconfig"
}

function remove_ldconfig_path() {
    rm -f "$LDCONF_FILE"
    ldconfig
    echo "✅ Removed /usr/lib/mali-imx from ldconfig"
}

function switch_vulkan_to_backup() {
    if [ -d "$VULKAN_DIR" ]; then
        mv "$VULKAN_DIR" "$VULKAN_BACKUP"
        echo "✅ Renamed /etc/vulkan to /etc/vulkan-mali-imx"
    fi
}

function restore_vulkan_from_backup() {
    if [ -d "$VULKAN_BACKUP" ]; then
        mv "$VULKAN_BACKUP" "$VULKAN_DIR"
        echo "✅ Restored /etc/vulkan-mali-imx to /etc/vulkan"
    fi
}

link_gbm() {
  local target="/usr/lib/libgbm.so"
  local source="$1"

  # Remove existing file or symlink
  if [[ -e "$target" || -L "$target" ]]; then
    echo "Removing existing $target..."
    sudo rm -f "$target" || { echo "ERROR: Failed to remove $target"; return 1; }
  fi

  # Create symlink  # Create symlink
  echo "Linking $target -> $source"
  sudo ln -s "$source" "$target" || { echo "ERROR: Failed to create symlink"; return 1; }
}

echo "🔧 Choose GPU driver to enable:"
select choice in "mali_kbase" "panthor" "Exit"; do
    case $choice in
        mali_kbase)
            blacklist_module panthor
            unblacklist_module mali_kbase
            link_gbm /usr/lib/mali-imx/libgbm.so.1.0.0
            add_ldconfig_path
            restore_vulkan_from_backup
            break
            ;;
        panthor)
            blacklist_module mali_kbase
            unblacklist_module panthor
            link_gbm /usr/lib/aarch64-linux-gnu/libgbm.so.1.0.0
            remove_ldconfig_path
            switch_vulkan_to_backup
            break
            ;;
        Exit)
            echo "👋 Exiting."
            exit 0
            ;;
        *)
            echo "⚠️ Invalid option. Try again."
            ;;
    esac
done

echo "✅ Done. You may need to reboot or reload modules for changes to take effect."
