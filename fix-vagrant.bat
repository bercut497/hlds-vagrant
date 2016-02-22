cd %~dp0

del /fs %VAGRANT_HOME%/tmp/*
del /fs %VAGRANT_HOME%/gems/*
del /fs %VAGRANT_HOME%/plugins.json

echo "1.1" %VAGRANT_HOME%/setup_version

exit 0
