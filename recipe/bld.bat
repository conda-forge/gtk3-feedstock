setlocal EnableExtensions EnableDelayedExpansion
@echo on

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"

set "XDG_DATA_DIRS=%XDG_DATA_DIRS%;%LIBRARY_PREFIX%\share"

:: ensure that the post install script is ignored
set "DESTDIR=%BUILD_PREFIX:~0,3%"

:: meson options
:: (set pkg_config_path so deps in host env can be found)
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  --wrap-mode=nofallback ^
  --buildtype=release ^
  --backend=ninja ^
  -D demos=false ^
  -D examples=false ^
  -D gtk_doc=false ^
  -D installed_tests=false ^
 ^"

:: configure build using meson
meson setup builddir !MESON_OPTIONS!
if errorlevel 1 exit 1

:: print results of build configuration
meson configure builddir
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1

:: create directory for modules so post-link script doesn't fail
set "MODULEDIR=%LIBRARY_LIB%\gtk-3.0\3.0.0"
if not exist "%MODULEDIR%" md "%MODULEDIR%"
if errorlevel 1 exit 1
type nul > "%MODULEDIR%\.keep"
if errorlevel 1 exit 1
