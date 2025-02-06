SUMMARY = "RemoteIDtransmitter"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://README.md;md5=ff65426c72468afec489f9abea202565"


SRCBRANCH = "main"

SRCREV = "3d02abe7d420037ba11fa1d04b17e07d52686d9d"

SRC_URI = "gitsm://github.com/ARK-Electronics/RemoteIDTransmitter.git;protocol=https;branch=${SRCBRANCH} \
           "

S = "${WORKDIR}/git"


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