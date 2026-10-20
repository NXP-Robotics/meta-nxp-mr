
SRCBRANCH = "imx95-navq-lf-6.18.y-26Q2"
IMX_SYSTEM_MANAGER_SRC = "git://git@github.com/NXP-Robotics/imx-sm.git;protocol=https;branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=f2a70813bc08547f509361c08b718861"

# Debug console transport for the SM.
#
#   uart - stock behavior, console on the debug LPUART
#   rtt  - console (banner, printf, and the debug monitor) is carried over
#          an attached SWD debug probe, leaving the debug LPUART free for
#          another owner. Best effort, never blocks the SM.
#
# Host side: "JLinkRTTClient" or "pyocd rtt -t mimx95_cm33_mx25um".
#
# Use SYSTEM_MANAGER_MONITOR_MODE = "1" with rtt. Mode 2 ("press key to
# enter monitor") misses the keypress while the system is asleep, as the
# probe cannot act as a wake source.
SYSTEM_MANAGER_CONSOLE ?= "uart"

EXTRA_OEMAKE += "CONSOLE=${SYSTEM_MANAGER_CONSOLE}"

do_configure:prepend() {
    # Remove comments from all files in configs to fix the configtool parsing bugs
    for f in ${S}/configs/*.cfg; do
        [ -f "$f" ] && sed -i 's/#.*//' "$f"
    done
}
