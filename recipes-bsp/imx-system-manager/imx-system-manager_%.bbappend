
SRCBRANCH = "imx95-navq-lf-6.12.y"
SRCREV = "d725ccd1a6b74368e1bea0e275eb5debc57934cf"
IMX_SYSTEM_MANAGER_SRC = "git://git@github.com/NXPHoverGames/imx-sm-private.git;protocol=ssh;branch=${SRCBRANCH}"

LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=f2a70813bc08547f509361c08b718861"

do_configure:prepend() {
    # Remove comments from all files in configs to fix the configtool parsing bugs
    for f in ${S}/configs/*.cfg; do
        [ -f "$f" ] && sed -i 's/#.*//' "$f"
    done
}
