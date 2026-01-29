SUMMARY = "Setup apt packages on startup from Ubuntu start rootfs"
LICENSE = "MIT"
PR = "r0"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://apt-setup-firstboot.service"

DEPENDS = "apt-native gnupg-native"

UBUNTU_PACKAGE_NAME = "libopengl0 openssh-server libwrap0 \
                       openssh-sftp-server openssh-client libfido2-1 libcbor0.10 \
                       "
UBUNTU_ARCH = "arm64"
UBUNTU_RELEASE = "noble"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

WORKDIR_DOWNLOAD = "${WORKDIR}/downloads"

inherit systemd

do_install() {
    rm -rf ${WORKDIR_DOWNLOAD}
    mkdir -p ${WORKDIR_DOWNLOAD}
    export DEBIAN_FRONTEND=noninteractive
    APT_DIR="${WORKDIR}/apt"
    mkdir -p ${APT_DIR}/etc/apt
    mkdir -p ${APT_DIR}/var/lib/apt/lists/partial
    mkdir -p ${APT_DIR}/var/cache/apt/archives/partial
    mkdir -p ${APT_DIR}/var/lib/dpkg
    touch ${APT_DIR}/var/lib/dpkg/status
    echo "deb [trusted=yes] http://ports.ubuntu.com/ubuntu-ports/ ${UBUNTU_RELEASE} main universe" > ${APT_DIR}/etc/apt/sources.list
    echo "deb [trusted=yes] http://ports.ubuntu.com/ubuntu-ports/ ${UBUNTU_RELEASE}-security main universe" >> ${APT_DIR}/etc/apt/sources.list
    echo "deb [trusted=yes] http://ports.ubuntu.com/ubuntu-ports/ ${UBUNTU_RELEASE}-updates main universe" >> ${APT_DIR}/etc/apt/sources.list

    /usr/bin/apt -o Dir::Etc::sourcelist=${APT_DIR}/etc/apt/sources.list \
        -o Dir::Etc::sourceparts=- \
        -o Dir::State=${APT_DIR}/var/lib/apt \
        -o Dir::Cache=${APT_DIR}/var/cache/apt \
        -o Dir::State::status=${APT_DIR}/var/lib/dpkg/status \
        -o Debug::NoLocking=true \
        -o APT::Architecture=${UBUNTU_ARCH} \
        -o APT::Architectures="${UBUNTU_ARCH}" \
        update

    cd ${WORKDIR_DOWNLOAD}

    /usr/bin/apt -o Dir::Etc::sourcelist=${APT_DIR}/etc/apt/sources.list \
        -o Dir::Etc::sourceparts=- \
        -o Dir::State=${APT_DIR}/var/lib/apt \
        -o Dir::Cache=${APT_DIR}/var/cache/apt \
        -o Dir::State::status=${APT_DIR}/var/lib/dpkg/status \
        -o Debug::NoLocking=true \
        -o APT::Architecture=${UBUNTU_ARCH} \
        -o APT::Architectures="${UBUNTU_ARCH}" \
        -d download ${UBUNTU_PACKAGE_NAME}

    install -d ${D}/etc/apt-setup
    install -m 644 ${WORKDIR_DOWNLOAD}/* ${D}/etc/apt-setup

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/apt-setup-firstboot.service ${D}${systemd_system_unitdir}/apt-setup-firstboot.service
}

SYSTEMD_SERVICE:${PN} = "apt-setup-firstboot.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[network] = "1"
