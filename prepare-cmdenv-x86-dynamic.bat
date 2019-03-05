@echo off

SET BASE=%~dp0
SET TRIPLET=x86-windows

call %BASE%prepare-cmdenv-x.bat %TRIPLET%
