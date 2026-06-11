SUMMARY = "MCUBoot"
DESCRIPTION = "A bootloader called MCUBoot running on zephyr"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PREFERRED_VERSION_zephyr-kernel = "4.3.0"
inherit zephyr-sample

#FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
DEPENDS += "python3-jsonschema-native"

ZEPHYR_SRC_DIR = "${ZEPHYR_BASE}/../bootloader/mcuboot/boot/zephyr"

do_deploy() {
    cp ${D}/firmware/${PN}.bin ${TOPDIR}/tmp/m7_mcuboot_image.bin
}
