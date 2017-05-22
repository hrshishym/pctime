@echo off
cd /d %~dp0

powershell -ExecutionPolicy RemoteSigned -File pctime.ps1
