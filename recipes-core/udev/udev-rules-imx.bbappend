# Update 10-imx.rules 
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://99-rpmsg.rules \
	file://99-gpio.rules \
	file://99-spi.rules \
	"

do_install:append () {
    install -D -m 0644 ${S}/*.rules \
                       ${D}${sysconfdir}/udev/rules.d
}

