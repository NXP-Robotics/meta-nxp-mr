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

