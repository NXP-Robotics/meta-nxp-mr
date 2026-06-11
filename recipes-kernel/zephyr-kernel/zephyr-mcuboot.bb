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
    # Installed filename includes ZEPHYR_IMAGE_BASE_NAME suffix (machine + timestamp),
    # so use a glob to find the first .bin for ${PN}.
    local fw
    fw=$(ls ${D}/firmware/${PN}*.bin 2>/dev/null | head -1)
    if [ -n "$fw" ]; then
        mkdir -p ${TOPDIR}/tmp
        cp "$fw" ${TOPDIR}/tmp/m7_mcuboot_image.bin
    else
        bbfatal "zephyr-mcuboot: no .bin found in ${D}/firmware/"
    fi
}
