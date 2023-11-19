@echo off

::----------------::
:: VERSION NUMBER ::
::----------------::
@REM :: write out old version number
@REM FOR /F %%i IN (version.txt) DO set old_version=%%i
@REM echo [90mOld version is :: [0m%old_version%
@REM :: get version number
@REM echo [90mNew version number? (v{major}.{minor}.{patch}::{development})[0m
@REM :: set version number
@REM TYPE CON > version.txt
@REM :: read new version number
@REM FOR /F %%i IN (version.txt) DO set new_version=%%i
@REM echo [90mNew version is :: [0m%new_version%
@REM :: set dart file to proper version
@REM echo const String version = '%new_version%'; > lib\version.dart

::-----------::
:: APP BUILD ::
::-----------::
@REM :: set to not web compile
@REM copy .\lib\download_page_not_web.dart .\lib\download_page.dart > NUL 2> NUL
@REM :: compile windows
@REM call flutter build windows
@REM :: compile android
@REM call flutter build apk

@REM :: zip exe and apk
@REM tar -acf qu2s_win.zip -C .\build\windows\runner\Release\ *
@REM tar -acf qu2s_android.zip -C .\build\app\outputs\flutter-apk\ app-release.apk
@REM :: copy exe and apk
@REM move .\qu2s_win.zip web\download\qu2s_win.zip
@REM move .\qu2s_android.zip web\download\qu2s_android.zip

::-----------::
:: WEB BUILD ::
::-----------::
@REM :: set to web compile
@REM copy .\lib\download_page_web.dart .\lib\download_page.dart > NUL 2> NUL
@REM :: compile web
@REM flutter build web

::---------::
:: PUBLISH ::
::---------::
:: publish to webserver
:: git ftp

git config git-ftp.url "ftp://qu2s.com:21/public_html"
git config git-ftp.user "hemlock7145"
git config git-ftp.password "o^Rs%&cr6NQZC@L8mr&gjZ692"
