# adaptivedemux2 links libxml2.so.16 (libxml2 2.14.x ABI from whinlatter BSP).
# ubuntu-base RCONFLICTS with OE libxml2 because Ubuntu 24.04 provides it via apt
# (Ubuntu 24.04 ships libxml2 2.9.x with soname libxml2.so.2, not .so.16).
# Disable adaptivedemux2 entirely so libxml2 is not linked at all.
PACKAGECONFIG[adaptivedemux2] = "-Dadaptivedemux2=enabled,-Dadaptivedemux2=disabled,libxml2"
PACKAGECONFIG:remove = "adaptivedemux2"
