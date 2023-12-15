@echo off
:: todo: rename this file to release.bat

::----------------::
:: VERSION NUMBER ::
::----------------::
:: write out old version number
FOR /F %%i IN (version.txt) DO set old_version=%%i
echo [90mOld version is :: [0m%old_version%
:: get version number
echo [90mNew version number? (v{major}.{minor}.{patch})[0m
:: set version number
:: todo: only ask weather the change is major/minor/patch and auto increment the version number
:: todo: change version.txt to .version
TYPE CON > version.txt
:: read new version number
FOR /F %%i IN (version.txt) DO set new_version=%%i
echo [90mNew version is :: [0m%new_version%
:: set dart file to new version
echo const String version = '%new_version%'; > lib\version.dart

:: todo: merge into main, and add version tag
:: todo: instead of merge use pull requiest merge?

::-----------::
:: APP BUILD ::
::-----------::
:: set to not web compile
copy .\lib\download_tab_not_web.dart .\lib\download_tab.dart > NUL 2> NUL
:: compile windows
call flutter build windows
@if NOT %ERRORLEVEL% == 0 (
    echo.
    echo [1m[41m WINDOWS BUILD FAILED [0m
    echo.
    goto end
)
:: compile android
call flutter build apk
@if NOT %ERRORLEVEL% == 0 (
    echo.
    echo [1m[41m ANDROID BUILD FAILED [0m
    echo.
    goto end
)
echo [90m

:: zip exe
tar -acf qu2s_win.zip -C .\build\windows\runner\Release\ *
:: fixme: delete everything in download folder
:: copy exe and apk
move .\qu2s_win.zip web\download\qu2s_%new_version%_win.zip
move .\build\app\outputs\flutter-apk\app-release.apk web\download\qu2s_%new_version%_android.apk

::-----------::
:: WEB BUILD ::
::-----------::
:: set to web compile
copy .\lib\download_tab_web.dart .\lib\download_tab.dart > NUL 2> NUL
:: compile web
echo [0m
call flutter build web
@if NOT %ERRORLEVEL% == 0 (
    echo.
    echo [1m[41m WEB BUILD FAILED [0m
    echo.
    goto end
)
echo [90m

::---------::
:: PUBLISH ::
::---------::
pushd .\build\web
:: (re)set the ftp login details
git config git-ftp.url "ftp://ftp.qu2s.com:21/"
git config git-ftp.user "u577410265.hemlock7145"
git config git-ftp.password "m78KWsa75agEvNTgzsDzyA2XevsG8JLxrA8g8F6T"
:: add all files
git add *
:: commit here as new version
git commit * -m "%new_version%"
:: push to webserver
git ftp push

popd

:: set to not web compile
copy .\lib\download_tab_not_web.dart .\lib\download_tab.dart > NUL 2> NUL

echo.
echo [1m[42m PUBLISH COMPLETE [100m %new_version% [0m
echo.

:end

:: todo: set version in pubspec.yaml
:: todo: show version in downloaded file e.g. qu2s_v0.1.1_windows.zip
