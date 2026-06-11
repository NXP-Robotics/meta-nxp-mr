SUMMARY = "RemoteIDtransmitter"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7096806b67525ff0c38b2b02532e31f7"


SRCBRANCH = "main"

SRCREV = "871cd481bf2b64f1221ff0c11f689b809371afc3"

SRC_URI = "gitsm://github.com/ARK-Electronics/RemoteIDTransmitter.git;protocol=https;branch=${SRCBRANCH} \
           "

DEPENDS = " \
    mavsdk \
    bluez5 \
    "

inherit cmake pkgconfig systemd

EXTRA_OECMAKE += "-DBUILD_TESTING=OFF "

do_configure[network] = "1"

do_install:append() {
    install -d ${D}/usr/bin/
    install -p -m 755 ${WORKDIR}/build/rid-transmitter ${D}/usr/bin
}

pkg_postinst:${PN} () {
	setcap cap_net_raw,cap_net_admin+eip "$D/usr/bin/rid-transmitter"
}


TARGET_CFLAGS += "-Wno-stringop-truncation"
