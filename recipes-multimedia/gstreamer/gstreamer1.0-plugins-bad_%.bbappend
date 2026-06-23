ERROR_QA:remove = "buildpaths"

# dash, smoothstreaming, ttml all link libxml2.so.16 (libxml2 2.14.x from whinlatter BSP).
# ubuntu-base RCONFLICTS with OE libxml2 2.14.x (Ubuntu 24.04 provides libxml2 2.9.x via apt).
# Disable these plugins to avoid the RPM dependency conflict at rootfs assembly.
PACKAGECONFIG:remove = "dash smoothstreaming ttml"
