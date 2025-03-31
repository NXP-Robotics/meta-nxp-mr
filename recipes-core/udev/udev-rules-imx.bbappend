# Update 10-imx.rules 
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://99-rpmsg.rules"

do_install:append () {
    install -D -m 0644 ${WORKDIR}/99-rpmsg.rules \
                       ${D}${sysconfdir}/udev/rules.d/99-rpmsg.rules
}

