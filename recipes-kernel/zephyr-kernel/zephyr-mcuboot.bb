SUMMARY = "MCUBoot"
DESCRIPTION = "A bootloader called MCUBoot running on zephyr"

PREFERRED_VERSION_zephyr-kernel = "4.3.0"
include recipes-kernel/zephyr-kernel/zephyr-sample.inc

#FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
DEPENDS += "python3-jsonschema-native"

ZEPHYR_SRC_DIR = "${ZEPHYR_BASE}/../bootloader/mcuboot/boot/zephyr"

do_deploy() {
    cp ${D}/firmware/${PN}.bin ${TOPDIR}/tmp/m7_mcuboot_image.bin
}
