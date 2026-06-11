# flit_core 3.12 does not support the license-files field in [project].
# Remove the multi-line license-files section so the build backend accepts
# the metadata without error.
do_compile:prepend() {
    sed -i '/^license-files = \[/,/^\]/d' ${S}/pyproject.toml
}
