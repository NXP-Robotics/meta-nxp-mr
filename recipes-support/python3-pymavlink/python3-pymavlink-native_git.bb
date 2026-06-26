SUMMARY = "Python MAVLink code"
HOMEPAGE = "https://github.com/ArduPilot/pymavlink/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=6ea13ec5f0f3dd35ac5b53afdc3ed9ff \
                    file://COPYING;md5=6ea13ec5f0f3dd35ac5b53afdc3ed9ff \
                    file://generator/javascript/local_modules/jspack/LICENSE;md5=312dd5360f685408b04fb52e84940c4a \
                    file://generator/javascript/local_modules/long/LICENSE;md5=d273d63619c9aeaf15cdaf76422c4f87"

SRC_URI = "gitsm://github.com/mavlink/mavlink.git;protocol=https;branch=master"

inherit setuptools3 native

PV = "1.0+git"
SRCREV = "b401fe0238b9647f8ea18d58d9e968b79b347916"

S = "${UNPACKDIR}/${BP}/pymavlink"

DEPENDS += "python3-fastcrc-native python3-cython-native python3-native"
RDEPENDS:${PN} += "python3-fastcrc python3-lxml python3-core python3-native"

ERROR_QA:remove = "patch-status"
