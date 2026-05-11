SUMMARY = "Mavlink MAVSDK endpoints"

LICENSE = "LGPL-3.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=54ad3cbe91bebcf6b1823970ff1fb97f"


SRCBRANCH = "master"

SRCREV = "d6a7eeaf43319ce6da19a1973ca40180a4210643"

SRC_URI = "gitsm://github.com/mavlink/mavlink.git;protocol=https;branch=${SRCBRANCH} \
           "

SRC_URI += "file://0001-Pymavlink-as-yocto-dependency.patch"

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

DEPENDS += "python3-pymavlink-native python3-future-native"

RDEPENDS:${PN} += "python3-future"

BBCLASSEXTEND = "native"

EXTRA_OECMAKE += "-DMAVLINK_DIALECT=ardupilotmega"

ERROR_QA:remove = "patch-status"
