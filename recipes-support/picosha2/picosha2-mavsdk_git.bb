LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=277ac5bc231af240c801ade17211246a"

FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI = "git://github.com/julianoes/PicoSHA2;protocol=https;branch=cmake-install-support"

PV = "1.0+git"
SRCREV = "1bf940d8a03bb752604fbb366d47b97b50b9e6ce"

S = "${WORKDIR}/git"

inherit cmake

EXTRA_OECMAKE = ""
