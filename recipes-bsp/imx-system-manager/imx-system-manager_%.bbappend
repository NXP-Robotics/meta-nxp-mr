
SRCBRANCH = "imx95-navq-lf-6.12.y"
IMX_SYSTEM_MANAGER_SRC = "git://git@github.com/NXP-Robotics/imx-sm.git;protocol=https;branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=f2a70813bc08547f509361c08b718861"

PACKAGECONFIG = "${SYSTEM_MANAGER_MONITOR_MODE}"

do_configure:prepend() {
    # Remove comments from all files in configs to fix the configtool parsing bugs
    for f in ${S}/configs/*.cfg; do
        [ -f "$f" ] && sed -i 's/#.*//' "$f"
    done
}
