FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
 file://0001-qemu-Reinstated-syscall-emulation-through-libc-9.patch \
 file://0002-qemu-native-fix-setgroups-libc-syscall.patch \
 file://0003-qemu-native-fix-statx-libc-syscall.patch \
 file://0004-qemu-native-fix-fchmodat2-libc-syscall.patch \
"

ERROR_QA:remove = "patch-status patch-fuzz"

# Enable LTO for ~10-20% TCG speedup; qemu-native is built once and cached.
EXTRA_OEMESON:append = " -Db_lto=true"

# Use 'max' CPU model so qemu-aarch64 can use all available host instructions
# (helps apt-get decompression and crypto operations in Ubuntu chroot builds).
QEMU_EXTRAOPTIONS_aarch64 = " -cpu max"
