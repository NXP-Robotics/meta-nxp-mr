LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8e5974086ac4189f96d6afe4dc36ddbe"

SRC_URI = "gitsm://github.com/julianoes/libmavlike;protocol=https;branch=mavsdk-fork"

PV = "1.0+git"
SRCREV = "80dbd91a0c5d6f0a79f1e8597b820ba075d1cf15"

DEPENDS += "libtinyxml2-mavsdk picosha2-mavsdk"

FILES:${PN}-dev += "${datadir}/mav/cmake/*.cmake"

inherit cmake

EXTRA_OECMAKE = "-DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_SHARED_LIBS=OFF"
