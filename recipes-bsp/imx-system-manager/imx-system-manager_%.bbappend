
SRCBRANCH = "imx95-navq-lf-6.12.y"
SRCREV = "59f0a4c587b9dd843a963e0bd7e00a89636382a6"
IMX_SYSTEM_MANAGER_SRC = "git://git@github.com/NXPHoverGames/imx-sm-private.git;protocol=ssh;branch=${SRCBRANCH}"

LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=f2a70813bc08547f509361c08b718861"

do_configure:prepend() {
    # Remove comments from all files in configs to fix the configtool parsing bugs
    for f in ${S}/configs/*.cfg; do
        [ -f "$f" ] && sed -i 's/#.*//' "$f"
    done
}
