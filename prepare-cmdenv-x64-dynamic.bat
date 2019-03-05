@echo off

SET BASE=%~dp0
SET TRIPLET=x64-windows

call %BASE%prepare-cmdenv-x.bat %TRIPLET%
