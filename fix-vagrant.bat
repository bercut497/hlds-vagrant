cd %~dp0

del /f /s %VAGRANT_HOME%/tmp/*
del /f /s %VAGRANT_HOME%/gems/*
del /f /s %VAGRANT_HOME%/plugins.json

echo "1.1" %VAGRANT_HOME%/setup_version

pause
exit 0
