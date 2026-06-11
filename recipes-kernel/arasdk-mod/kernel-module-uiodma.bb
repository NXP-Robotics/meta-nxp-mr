SUMMARY = "UIO DMA kernel module"
DESCRIPTION = "Builds the uiodma kernel module"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "\
    file://uiodma.c;subdir=${BPN} \
    file://Makefile;subdir=${BPN} \
"

# REQUIRED FOR WALNASCAR
S = "${UNPACKDIR}/${BPN}"

DEPENDS += "virtual/kernel"

# Ensure package architecture follows the machine/kernel ABI
PACKAGE_ARCH = "${MACHINE_ARCH}"

do_install() {
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra
    install -m 0644 ${B}/uiodma.ko \
        ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
}
