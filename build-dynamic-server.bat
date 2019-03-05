@echo off

SET MUMDIR=mumble-dynamic-server
SET QMAKE_CFG= ^
  CONFIG+=no-client ^
  CONFIG+=no-asio ^
  CONFIG+=no-g15 ^
  CONFIG+=no-bonjour ^
  CONFIG+=no-elevation ^
  CONFIG+=no-update ^
  CONFIG+=no-ice ^
  CONFIG+=no-embed-qt-translations

call build-x.bat "%MUMDIR%" "%QMAKE_CFG%"
