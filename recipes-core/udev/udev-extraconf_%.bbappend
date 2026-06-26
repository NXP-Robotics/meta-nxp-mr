# NXP i.MX SOC extra configuration udev rules
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append () {
    # LDP release, we only need install NXP specific blacklist as blacklist-nxp.conf
    rm -rf ${D}${sysconfdir}/*
    if [ -e "${UNPACKDIR}/blacklist.conf" ]; then
        install -d ${D}${sysconfdir}/modprobe.d
        install -m 0644 ${UNPACKDIR}/blacklist.conf ${D}${sysconfdir}/modprobe.d/blacklist-nxp.conf
    fi
}

# wrynose's oe-core split udev-extraconf into -automount/-autonet sub-packages
# and made the main package RDEPEND on them. Since we wipe ${sysconfdir} above
# (LDP: only blacklist-nxp.conf is shipped), those sub-packages are empty and no
# rpm is generated, which breaks image do_rootfs ("nothing provides
# udev-extraconf-automount/-autonet"). Drop the dangling dependency.
RDEPENDS:${PN}:remove = "${PN}-automount ${PN}-autonet"
