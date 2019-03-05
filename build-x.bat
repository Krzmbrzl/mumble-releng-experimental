@echo off

SET MUMDIR=%1
SET QMAKE_CFG=%2
SET QMAKE_CFG=%QMAKE_CFG:"=%

IF [%QSPEC%] == [] (
ECHO Missing QSPEC value
ECHO Run the prepare script first to set up the environment...
EXIT /B 1
)

echo ---
echo Building Mumble in path %MUMDIR%
echo Using QTBIN %QTBIN%
echo %triplet%
echo Qt Makespec %QSPEC%
echo ---

PUSHD "%MUMDIR%"
IF ERRORLEVEL 1 (
echo Target build directory does not exist at %MUMDIR%
EXIT /B 1
)

"%QTBIN%\qmake.exe" ^
  -spec %QSPEC% ^
  -recursive ^
  %QMAKE_CFG% ^
  main.pro
IF ERRORLEVEL 1 (
ECHO Failed on project configuration with qmake
POPD
EXIT /B 1
)

nmake clean
nmake
IF ERRORLEVEL 1 (
ECHO Failed to build
POPD
EXIT /B 1
)

POPD
