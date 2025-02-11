# Adds mavlink to ROS image
require imx-image-ros.bb

IMAGE_INSTALL:append:imx95-19x19-navq = " \
    mavlink-router \
    remoteidtransmitter \
    "
