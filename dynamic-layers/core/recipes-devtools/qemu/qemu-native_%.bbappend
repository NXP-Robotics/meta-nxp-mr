FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
 file://0001-qemu-Reinstated-syscall-emulation-through-libc-9.patch \
 file://0002-qemu-native-fix-setgroups-libc-syscall.patch \
 file://0003-qemu-native-fix-statx-libc-syscall.patch \
"

ERROR_QA:remove = "patch-status patch-fuzz"
