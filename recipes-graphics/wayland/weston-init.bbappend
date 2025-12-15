

# Append to the do_install task to tweak weston.ini after it's installed into ${D}
do_install:append() {
    WESTON_INI="${D}${sysconfdir}/xdg/weston/weston.ini"

    if [ -f "${WESTON_INI}" ]; then
        # Flip use-g2d to false if currently set to true
        sed -i 's/\buse-g2d=true\b/use-g2d=false/' "${WESTON_INI}"
    fi
}
