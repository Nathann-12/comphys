@echo off
setlocal ENABLEDELAYEDEXPANSION

REM สคริปต์ Build + Run โปรแกรม comphys.exe
call "%~dp0build.bat" || exit /b 1

pushd %~dp0\..
if not exist out mkdir out
comphys.exe
set ERR=%ERRORLEVEL%
popd

exit /b %ERR%

