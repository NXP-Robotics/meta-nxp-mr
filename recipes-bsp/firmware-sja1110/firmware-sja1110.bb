SUMMARY = "SJA1110 firmware for NavQ95"
DESCRIPTION = "${SUMMARY}"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

SRC_URI = "file://sja1110_uc.bin"

S = "${WORKDIR}/sources-unpack"

FILES:${PN} = "${nonarch_base_libdir}/firmware/sja1110_uc.bin"

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware
    cp ${UNPACKDIR}/sja1110_uc.bin ${D}${nonarch_base_libdir}/firmware
}
