SUMMARY = "Create rpmsg endpoints using rpmsg_ctrl device"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ff273e1fd41fa52668171e0817c89724"

SRCBRANCH = "master"

SRCREV = "d06645c390d37ed2b2c37cfe8575b765c92d461f"

SRC_URI = "git://git@github.com/NXPHoverGames/rpmsgexport.git;protocol=ssh;branch=${SRCBRANCH}"

S = "${WORKDIR}/git"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	oe_runmake
	install -d ${D}${bindir}
	install -m 0755 rpmsgexport ${D}${bindir}
}

