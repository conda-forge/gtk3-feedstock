:: When cross-compiling, or installing for a different platform, the commands
:: can't be executed. So we catch errors and print a message instead of failing.
"%PREFIX%\Library\bin\glib-compile-schemas.exe" "%PREFIX%\Library\share\glib-2.0\schemas" 2>> "%PREFIX%\.messages.txt"
if errorlevel 1 goto ProcessError
"%PREFIX%\Library\bin\gtk-update-icon-cache.exe" -f -t -q "%PREFIX%\Library\share\icons\hicolor" 2>> "%PREFIX%\.messages.txt"
if errorlevel 1 goto ProcessError
"%PREFIX%\Library\bin\gtk-query-immodules-3.0.exe" --update-cache 2>> "%PREFIX%\.messages.txt"
if errorlevel 1 goto ProcessError

exit /b 0

:ProcessError
(
echo ERROR: Failed to complete gtk3's post-link script.
echo To fix this, activate the environment and run:
echo     glib-compile-schemas "%PREFIX%\Library\share\glib-2.0\schemas"
echo     gtk-update-icon-cache -f -t "%PREFIX%\Library\share\icons\hicolor"
echo     gtk-query-immodules-3.0 --update-cache
) >> "%PREFIX%\.messages.txt"
