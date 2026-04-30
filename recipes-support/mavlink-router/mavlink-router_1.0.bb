SUMMARY = "Route Mavlink packets between endpoints"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=93888867ace35ffec2c845ea90b2e16b"


DEPENDS = "systemd"

SRCBRANCH = "master"

SRCREV = "c20337bbc61abda21463e7482172d58b654e66b6"

SRC_URI = "gitsm://github.com/mavlink-router/mavlink-router.git;protocol=https;branch=${SRCBRANCH} \
           file://main.conf \
           "

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} = "mavlink-router.service"

do_install:append() {
    install -d ${D}${sysconfdir}/mavlink-router
    install -m 755 ${UNPACKDIR}/main.conf ${D}${sysconfdir}/mavlink-router/main.conf
    SERVICE_FILE="${D}${systemd_system_unitdir}/mavlink-router.service"

    if [ -f "$SERVICE_FILE" ]; then
        sed -i '/^\[Unit\]/a ConditionPathExists=/dev/ttyproxy' "$SERVICE_FILE"
    fi
}

inherit meson pkgconfig systemd