@echo off

SET BASE=%~dp0
SET TRIPLET=x64-windows-static

call %BASE%prepare-cmdenv-x.bat %TRIPLET%
