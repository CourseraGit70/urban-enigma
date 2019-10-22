@echo off

set currentdir=%~dp0

powershell.exe -executionpolicy remotesigned -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "%currentdir%\Enable_developer_mode.ps1"