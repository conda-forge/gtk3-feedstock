setlocal EnableDelayedExpansion
@echo on

:: add include dirs to search path
set "INCLUDE=%INCLUDE%;%LIBRARY_INC%\atk-1.0;%LIBRARY_INC%\pango-1.0"

:: meson options
:: (set pkg_config_path so deps in host env can be found)
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  --pkg-config-path="%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig" ^
  --wrap-mode=nofallback ^
  --buildtype=release ^
  --backend=ninja ^
  -D demos=false ^
  -D examples=false ^
  -D gtk_doc=false ^
  -D installed_tests=false ^
 ^"

:: configure build using meson
%BUILD_PREFIX%\python.exe %BUILD_PREFIX%\Scripts\meson setup builddir !MESON_OPTIONS!
if errorlevel 1 exit 1

:: print results of build configuration
%BUILD_PREFIX%\python.exe %BUILD_PREFIX%\Scripts\meson configure builddir
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1