# In mesa-only (single-driver) mode on imxmali, mesa.inc installs a Panthor
# module-autoload snippet (${nonarch_libdir}/modules-load.d/panthor.conf) and a
# mali_kbase blacklist (${sysconfdir}/modprobe.d/mesa-panthor.conf) so Panthor wins
# the GPU instead of the Mali DDK. mesa.inc packages both into the bare ${PN}
# ("mesa") package, but the image never installs that package: it pulls
# mesa-megadriver and the lib*-mesa subpackages instead (mesa-megadriver RPROVIDES
# mesa). The blacklist and autoload were therefore built but never reached the
# rootfs, so mali_kbase kept grabbing the GPU and Panthor never bound. PACKAGES uses
# "=+" to order mesa-megadriver ahead of ${PN}, so claiming the two files in
# mesa-megadriver routes them into the package that is actually installed. Scoped to
# imxmali; in dual-driver mode mesa.inc does not install the files, so this is inert.
FILES:mesa-megadriver:append:imxmali = " ${sysconfdir}/modprobe.d/mesa-panthor.conf ${nonarch_libdir}/modules-load.d/panthor.conf"

# The Yocto sysroot's libxcb/xcb-proto is 1.17, so Mesa builds its DRI3 1.4
# explicit-sync WSI path and the Vulkan ICD (libvulkan_panfrost.so / PanVK)
# references xcb_present_pixmap_synced + xcb_dri3_import_syncobj_checked. This image
# runs on the Ubuntu/noble rootfs whose runtime libxcb is 1.15 and lacks those
# symbols, so the ICD fails to load and vkCreateInstance reports "Found no drivers"
# (vkcube: "failed to find the VK_KHR_surface extension"). The patch forces
# with_dri3_explicit_sync=false so those symbols are compiled out, matching the
# noble libxcb ABI (the same way the kisak-mesa PPA builds Mesa against noble's
# libxcb instead of shipping a newer one).
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://0001-disable-dri3-explicit-sync-for-noble-libxcb.patch"
