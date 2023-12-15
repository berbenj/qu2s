@echo off

::----------------::
:: VERSION NUMBER ::
::----------------::
:: write out old version number
FOR /F %%i IN (version.txt) DO set old_version=%%i
echo [90mOld version is :: [0m%old_version%
:: get version number
echo [90mNew version number? (v{major}.{minor}.{patch}::{development})[0m
:: set version number
:: todo: dont ask new version number, only automatically increment it 
:: todo: change version.txt to .version
TYPE CON > version.txt
:: read new version number
FOR /F %%i IN (version.txt) DO set new_version=%%i
echo [90mNew version is :: [0m%new_version%
:: set dart file to proper version
echo const String version = '%new_version%'; > lib\version.dart

:: todo: commit all with message
:: todo: add tag with version to the most recent commit

echo .
echo [1m[42m COMMIT COMPLETE [100m %new_version% [0m
echo .

:: fixme: add error handling
:: echo [1m[4m[41m WINDOWS BUILD FAILED [0m
