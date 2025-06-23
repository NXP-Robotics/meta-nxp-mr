# Update 10-imx.rules 
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://99-rpmsg.rules \
             file://98-neutron.rules "

do_install:append () {
    install -D -m 0644 ${S}/99-rpmsg.rules \
                       ${D}${sysconfdir}/udev/rules.d/99-rpmsg.rules
    install -D -m 0644 ${S}/98-neutron.rules \
                       ${D}${sysconfdir}/udev/rules.d/98-neutron.rules
}

