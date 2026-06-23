FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Patch remote_input.c to avoid libinput_device_get_id_bustype() which was
# introduced in libinput 1.26.0 (LIBINPUT_1.26).  We carry libinput 1.25.0
# to match Ubuntu 24.04; this patch replaces the call with BUS_USB fallback.
SRC_URI:append = " file://0001-remote-input-compat-libinput-1.25.patch"
