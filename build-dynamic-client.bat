@echo off

IF [%QSPEC%] == [] (
ECHO Missing QSPEC value
ECHO Run the prepare script first to set up the environment...
EXIT /B 1
)

python --version
IF ERRORLEVEL 1 (
ECHO Missing python which we require for
EXIT /B 1
)

SET MUMDIR=mumble-dynamic-client

echo ---
echo Building Mumble in path %MUMDIR%
echo Using QTBIN %QTBIN%
echo %triplet%
echo Qt Makespec %QSPEC%
echo ---

PUSHD "%MUMDIR%"

"%QTBIN%\qmake.exe" ^
  -spec %QSPEC% ^
  -recursive ^
  CONFIG+=no-asio ^
  CONFIG+=no-server ^
  CONFIG+=no-g15 ^
  CONFIG+=no-bonjour ^
  CONFIG+=no-elevation ^
  CONFIG+=no-update ^
  CONFIG+=no-ice ^
  CONFIG+=no-embed-qt-translations ^
  main.pro
IF ERRORLEVEL 1 (
ECHO Failed on project configuration with qmake
POPD
EXIT /B 1
)

nmake
IF ERRORLEVEL 1 (
ECHO Failed to build
POPD
EXIT /B 1
)

POPD
