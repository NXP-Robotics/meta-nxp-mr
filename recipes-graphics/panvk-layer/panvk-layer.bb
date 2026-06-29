SUMMARY = "Layered PanVK Vulkan driver selector (kisak Mesa over Yocto Mesa)"
DESCRIPTION = "Installs a boot-time + apt-hook selector that points the active \
PanVK Vulkan ICD at the kisak (Ubuntu multiarch) Mesa driver when it is \
installed, and transparently falls back to the Yocto /usr/lib PanVK otherwise. \
Distro-shipped panfrost ICD manifests are neutralised so the Mali-G310 is \
enumerated only once."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://select-panvk.sh \
    file://panvk-layer.service \
    file://99panvk-layer \
"

S = "${UNPACKDIR}"

inherit systemd allarch

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/select-panvk.sh ${D}${sbindir}/select-panvk.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/panvk-layer.service ${D}${systemd_system_unitdir}/panvk-layer.service

    install -d ${D}${sysconfdir}/apt/apt.conf.d
    install -m 0644 ${UNPACKDIR}/99panvk-layer ${D}${sysconfdir}/apt/apt.conf.d/99panvk-layer
}

FILES:${PN} += " \
    ${sbindir}/select-panvk.sh \
    ${systemd_system_unitdir}/panvk-layer.service \
    ${sysconfdir}/apt/apt.conf.d/99panvk-layer \
"

SYSTEMD_SERVICE:${PN} = "panvk-layer.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
