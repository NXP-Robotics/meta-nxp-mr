SUMMARY = "Mavlink MAVSDK endpoints"

LICENSE = "LGPL-3.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=54ad3cbe91bebcf6b1823970ff1fb97f"


SRCBRANCH = "master"

SRCREV = "f1d42e2774cae767a1c0651b0f95e3286c587257"

SRC_URI = "gitsm://github.com/mavlink/mavlink.git;protocol=https;branch=${SRCBRANCH} \
           "

S = "${WORKDIR}/git"

DEPENDS = " \
    libxslt-native \
    libxml2-native \
    python3-lxml-native \
    python3-pip-native \
	 "

inherit cmake pkgconfig python3native

do_configure[network] = "1"
do_compile[network] = "1"

BBCLASSEXTEND = "native"