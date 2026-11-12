SUMMARY = "eProsima Micro XRCE-DDS Agent"
DESCRIPTION = "Bridges the PX4 uxrce_dds_client on the M7 to DDS / ROS 2 on \
Linux over the RPMsg tty /dev/ttyros. Built with the upstream superbuild, \
which fetches and builds Fast CDR, foonathan_memory, Fast DDS and spdlog \
during do_compile and installs them next to the agent."
HOMEPAGE = "https://github.com/eProsima/Micro-XRCE-DDS-Agent"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRC_URI = "git://github.com/eProsima/Micro-XRCE-DDS-Agent.git;protocol=https;nobranch=1;tag=v${PV} \
           file://micro-xrce-dds-agent.service \
           file://micro-xrce-dds-agent.default \
           file://99-micro-xrce-dds-agent.rules \
           "
SRCREV = "73622810d984349b80bbac0ef55fc0b694d62222"

# Fast DDS links OpenSSL (TLS transport) when it finds it. Without the target
# openssl in the sysroot it picks up the x86 one from the native sysroot and
# the link fails. At runtime the Ubuntu libssl3 is used (DISTRO_NEVER_WRITE_PACKAGE).
DEPENDS = "openssl"

inherit cmake

# The superbuild re-runs CMake in ${B} for the agent itself while the outer
# build is still running there. That works with Makefiles (the upstream way),
# not with a nested Ninja in the same directory.
OECMAKE_GENERATOR = "Unix Makefiles"

# The dependencies are installed to ${B}/temp_install and found from there.
# The OE toolchain file only searches below the sysroot, so add it as a root.
OECMAKE_EXTRA_ROOT_PATH = "${B}/temp_install"

EXTRA_OECMAKE += " \
    -DCMAKE_BUILD_TYPE=Release \
    -DUAGENT_BUILD_TESTS=OFF \
    -DUAGENT_P2P_PROFILE=OFF \
"

# The superbuild clones its dependencies from GitHub at build time.
do_configure[network] = "1"
do_compile[network] = "1"

do_install:append() {
    # The superbuild also installs the headers, CMake/pkg-config files and
    # static libs of the bundled dependencies. Only the agent binary and the
    # shared libs (agent, Fast DDS, Fast CDR) are needed on the target.
    rm -rf ${D}${includedir} \
           ${D}${libdir}/cmake \
           ${D}${libdir}/pkgconfig \
           ${D}${libdir}/foonathan_memory \
           ${D}${datadir}/*/cmake \
           ${D}${bindir}/nodesize_dbg
    rm -f ${D}${libdir}/*.a

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/micro-xrce-dds-agent.service ${D}${systemd_system_unitdir}/

    install -d ${D}${sysconfdir}/default
    install -m 0644 ${UNPACKDIR}/micro-xrce-dds-agent.default ${D}${sysconfdir}/default/micro-xrce-dds-agent

    install -d ${D}${nonarch_base_libdir}/udev/rules.d
    install -m 0644 ${UNPACKDIR}/99-micro-xrce-dds-agent.rules ${D}${nonarch_base_libdir}/udev/rules.d/
}

# Fast DDS XSDs and the licenses of the agent and the bundled dependencies.
FILES:${PN} += " \
    ${datadir} \
    ${systemd_system_unitdir}/micro-xrce-dds-agent.service \
    ${nonarch_base_libdir}/udev/rules.d/99-micro-xrce-dds-agent.rules \
"
CONFFILES:${PN} = "${sysconfdir}/default/micro-xrce-dds-agent"

COMPATIBLE_MACHINE = "(imx95-navqdesktop|imx95)"
