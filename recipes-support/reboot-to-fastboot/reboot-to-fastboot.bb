SUMMARY = "Reboot into U-Boot fastboot mode on i.MX95"
DESCRIPTION = "Installs reboot_to_fastboot helper script to trigger one-shot U-Boot fastboot mode"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://reboot_to_fastboot.sh"

inherit allarch

do_install() {
    install -d ${D}${bindir}
    install -m 755 ${UNPACKDIR}/reboot_to_fastboot.sh ${D}${bindir}/reboot_to_fastboot
}

FILES:${PN} += "${bindir}/reboot_to_fastboot"
