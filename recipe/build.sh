#! /bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux
# Prior to conda-forge, Copyright 2014-2019 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

set -ex

# necessary to ensure the gobject-introspection-1.0 pkg-config file gets found
# meson needs this to determine where the g-ir-scanner script is located
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig

export XDG_DATA_DIRS=${XDG_DATA_DIRS}:$PREFIX/share

if [[ "$target_platform" == "osx-arm64" && "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
    # get meson to find pkg-config when cross compiling
    export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config
fi

meson_config_args=(
    -D gtk_doc=false
    -D demos=false
    -D examples=false
    -D installed_tests=false
    -D wayland_backend=false
)


# ensure that the post install script is ignored
export DESTDIR="/"

meson setup builddir \
    ${MESON_ARGS} \
    "${meson_config_args[@]}" \
    --buildtype=release \
    --prefix=$PREFIX \
    -Dlibdir=lib \
    --wrap-mode=nofallback
ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}

cd $PREFIX
find . '(' -name '*.la' -o -name '*.a' ')' -delete
rm -rf $(echo "
share/applications
share/gtk-doc
share/man
bin/gtk3-demo*
bin/gtk3-icon-browser
bin/gtk3-widget-factory
")
