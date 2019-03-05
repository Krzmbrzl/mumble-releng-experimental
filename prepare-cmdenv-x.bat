@echo off

SET TRIPLET=%1
IF [%TRIPLET%] == [] (
  echo ERROR: Missing parameter triplet
  EXIT /B 1
)

SET BASE=%~dp0
SET INST=%BASE%vcpkg\installed\%TRIPLET%
SET DLTOOLS=%BASE%vcpkg\downloads\tools
SET VSVER=2019

IF [%TRIPLET%] == [x64-windows] (
  call "C:\Program Files (x86)\Microsoft Visual Studio\%VSVER%\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
)
IF [%TRIPLET%] == [x64-windows-static] (
  call "C:\Program Files (x86)\Microsoft Visual Studio\%VSVER%\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
)
IF [%TRIPLET%] == [x86-windows] (
  call "C:\Program Files (x86)\Microsoft Visual Studio\%VSVER%\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
)
IF [%TRIPLET%] == [x86-windows-static] (
  call "C:\Program Files (x86)\Microsoft Visual Studio\%VSVER%\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
)

SET QTBIN=%INST%\tools\qt5\
SET QSPEC=%INST%\share\qt5\mkspecs\win32-msvc\
SET PBBIN=%INST%\tools\protobuf
SET BIN=%INST%\bin\

SET PATH=%QTBIN%;%PATH%
SET PATH=%PBBIN%;%PATH%
SET INCLUDE=%INST%\include;%INCLUDE%
SET LIB=%INST%\lib;%LIB%
SET LIB=%INST%\lib\manual-link;%LIB%

REM TODO: cmake? how is this supposed to work with vcpkg?
SET PATH=%DLTOOLS%\cmake-3.14.0-windows\cmake-3.14.0-win32-x86\bin\;%PATH%
SET PATH=%DLTOOLS%\nasm\nasm-2.14.02\;%PATH%
SET PATH=%DLTOOLS%\jom\jom-1.1.3\;%PATH%
SET PATH=%DLTOOLS%\perl\perl\bin\;%PATH%
SET PATH=%DLTOOLS%\python\python2\;%PATH%
SET PATH=%DLTOOLS%\python\python-3.7.3\;%PATH%
