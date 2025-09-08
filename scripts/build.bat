@echo off
setlocal ENABLEDELAYEDEXPANSION

REM สคริปต์คอมไพล์ Fortran 77 แบบง่าย (gfortran legacy)
pushd %~dp0\..
if not exist out mkdir out

set FFLAGS=-std=legacy -ffixed-line-length-132
gfortran %FFLAGS% src\comphys.f -o comphys.exe
if errorlevel 1 (
  echo [BUILD] Failed.
  popd
  exit /b 1
)
echo [BUILD] Succeeded: comphys.exe
popd
exit /b 0

