SUMMARY = "Auto In Vehicle Networking SJA1110 Linux Driver"
DESCRIPTION = "${SUMMARY}"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI = "git://git@github.com/NXP-Robotics/autoivnsw_sja1110_linux.git;protocol=https;branch=master"
SRC_URI += "file://Makefile"

SRCREV = "${AUTOREV}"

RPROVIDES_${PN} += "kernel-module-sja1110"

do_configure:prepend() {
    cp ${UNPACKDIR}/Makefile ${S}
}
