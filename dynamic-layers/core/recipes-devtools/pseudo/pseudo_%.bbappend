FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# Add support for extra syscalls and better chroot to support apt-get
# use inside pseudo for target rootfs setups
# Patches rebased onto pseudo 1.9.5 (0bad855) for wrynose.
# Note: 0003-proper-compile-of-f-stat-v-fs-wrappers dropped (headers already upstream).
#       0001-Enabled-utimensat now wrapfuncs.in only (makewrappers array support already upstream).
#       0001-configure-Prune-PIE-flags dropped (already upstream in 1.9.2).
#       0015-faccessat manually rebased (new file + context changed).
#       wrynose (1.9.2 -> 1.9.5): 0017-realpath rebased (context changed);
#       0014/0020 refreshed to apply without fuzz.
SRC_URI += " \
    file://0001-pseudo-Enabled-utimensat-ftimens-wrapfuncs.in-only-a.patch \
    file://0002-pseudo-The-stat-v-fs-functions-were-not-wrapped-prop.patch \
    file://0003-pseudo-Added-support-function-for-fnmatch.patch \
    file://0004-Moved-chroot-path-check-into-subfunction.patch \
    file://0005-pseudo-Filename-translation-for-exec-path-handling.patch \
    file://0006-pseudo-path-search-was-not-shell-compliant.patch \
    file://0007-pseudo-Oops.-Forgot-to-add-variable-cleanup.patch \
    file://0008-pseudo-Unified-and-added-debug-messages-for-exec_pat.patch \
    file://0009-pseudo-Clean-up-executable-check.patch \
    file://0010-pseudo-Implemented-means-to-force-chroot-usage.patch \
    file://0011-pseudo-Change-the-usage-of-pseudo_exec_path.patch \
    file://0012-seudo-Now-handles-chroot-scripts-and-executables.patch \
    file://0013-pseudo-Treat-chroot-exceptions-properly-for-std-path.patch \
    file://0014-pseudo-pseudo_root_path-didn-t-work-properly-for.patch \
    file://0015-pseudo-Fixing-an-incorrect-prior-patch-port.patch \
    file://0016-pseudo-Diagnostic-cleanup-for-utimensat.patch \
    file://0017-pseudo-realpath-wrapper-did-not-do-chroot-translatio.patch \
    file://0018-pseudo-did-not-treat-softlinks-correctly-in-chroot.patch \
    file://0019-pseudo-Added-missing-support-for-faccessat-manually-.patch \
    file://0020-pseudo-Critical-chroot-readlink-fix.patch \
    file://0021-pseudo-Added-dup3-support.patch \
    file://0022-pseudo-Fix-fxstatat-calls-for-non-fs-file-handles.patch \
    file://0023-pseudo-fix-posix_spawn-pseudo_exec_path-arity-and-pa.patch \
"

ERROR_QA:remove = "patch-status"
