FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Enable DDR spread spectrum (SSC) in the OEI timing files
SRC_URI += "file://0001-enable-spread-spectrum.patch"
