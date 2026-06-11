SUMMARY = "Mavlink MAVSDK libevenets"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../../LICENSE.md;md5=92eb10e2bbc58e0d704de5f23dd755ef"


SRCBRANCH = "main"

SRCREV = "7c1720749dfe555ec2e71d5f9f753e6ac1244e1c"

SRC_URI = "gitsm://github.com/mavlink/libevents.git;protocol=https;branch=${SRCBRANCH} \
           "

S = "${UNPACKDIR}/git/libs/cpp"

DEPENDS = " \
    libxslt-native \
    libxml2-native \
    python3-lxml-native \
    python3-pip-native \
	 "

inherit cmake pkgconfig

EXTRA_OECMAKE += "-DENABLE_TESTING=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON"

do_configure[network] = "1"
do_compile[network] = "1"

BBCLASSEXTEND = "native"