SUMMARY = "Create rpmsg endpoints using rpmsg_ctrl device"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ff273e1fd41fa52668171e0817c89724"

SRCBRANCH = "master"

SRCREV = "e31568cba3a94f34b3192f7517a70a513b99b96a"

SRC_URI = "git://git@github.com/NXP-Robotics/rpmsgexport.git;protocol=https;branch=${SRCBRANCH}"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	oe_runmake
	install -d ${D}${bindir}
	install -m 0755 rpmsgexport ${D}${bindir}
}

