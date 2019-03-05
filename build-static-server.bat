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

SET MUMDIR=mumble

echo ---
echo Building Mumble in path %MUMDIR%
echo Using QTBIN %QTBIN%
echo %triplet%
echo Qt Makespec %MKSPEC%
echo ---

pushd "%MUMDIR%"

echo Configuring project with qmake...
"%QTBIN%\qmake.exe" ^
  -spec %QSPEC% ^
  -recursive ^
  CONFIG+=static ^
  CONFIG+=no-asio ^
  CONFIG+=no-client ^
  CONFIG+=no-g15 ^
  CONFIG+=no-bonjour ^
  CONFIG+=no-elevation ^
  CONFIG+=no-update ^
  CONFIG+=no-ice ^
  CONFIG+=no-embed-qt-translations ^
  main.pro
IF ERRORLEVEL 1 (
ECHO Failed to build
POPD
EXIT /B 1
)

echo Staring build...
nmake
IF ERRORLEVEL 1 (
ECHO Failed to build
POPD
EXIT /B 1
)

popd
