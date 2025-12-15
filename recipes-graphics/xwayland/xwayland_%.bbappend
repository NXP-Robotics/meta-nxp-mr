FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG_CONFARGS:append = "-Dsecure-rpc=false"

# Undo BSP-specific removals so glamor/glx are not stripped
OPENGL_PKGCONFIGS_REMOVE_IMXGPU:imx-nxp-bsp = ""
OPENGL_PKGCONFIGS_REMOVE_IMXGPU:mx8-nxp-bsp = ""

# Explicitly add pkg-configs back for these BSP overrides
OPENGL_PKGCONFIGS:append:imx-nxp-bsp = " glamor glx"
OPENGL_PKGCONFIGS:append:mx8-nxp-bsp = " glx"

INSANE_SKIP:pn-xwayland += "buildpaths"
RDEPENDS:${PN}:remove = " libegl"
