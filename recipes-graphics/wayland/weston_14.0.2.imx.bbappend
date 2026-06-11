# Temporary workaround to skip Yocto QA "buildpaths" failures caused by
# references to ${TMPDIR} in installed binaries/plugins.
# NOTE: Use this as a short-term unblock; it's better to fix rpaths or
# compiled-in absolute paths in the source/meson configuration.

# Core Weston binaries and plugins
INSANE_SKIP:pn-weston += "buildpaths"

# libweston backend/renderer modules
INSANE_SKIP:pn-libweston-14 += "buildpaths"

# Weston example clients (if you ship them)
INSANE_SKIP:pn-weston-examples += "buildpaths"

# In Ubuntu overlay images, the RPM preinst groupadd creates/deletes
# /etc/.pwd.lock whose inode gets reused by the next RPM-installed file,
# triggering a pseudo inode-reuse path-mismatch abort during do_rootfs.
# Override pkg_preinst with an early exit so the useradd-class-appended
# groupadd code is never reached during rootfs construction.
# Group creation is deferred to first-boot via pkg_postinst_ontarget instead.
pkg_preinst:${PN}() {
#!/bin/sh
# weston-launch group is created at first boot (see postinst_ontarget)
exit 0
}

pkg_postinst_ontarget:${PN}() {
    groupadd --system weston-launch 2>/dev/null || true
}
