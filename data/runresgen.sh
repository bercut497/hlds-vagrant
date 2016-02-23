#!/bin/bash
cd "$( dirname ""$0"" )"
CDIR="$(pwd)"

BIN="${CDIR}/resgen"
MODDIR="$( dirname ""${CDIR}"" )"

# begn checks
if [ ! -f "${BIN}" ] ; then
	echo " binary file ""${BIN}"" not found. exit"
	exit 1
fi

if [ ! -d "${MODDIR}/maps" ] ; then
	echo " maps directory ""${MODDIR}/maps"" not found. exit"
	exit 1
fi
echo "start: ${BIN} -e \"${MODDIR}\" -d \"${MODDIR}/maps\" -mvnsl"
${BIN} -e "${MODDIR}" -d "${MODDIR}/maps" -mvnsl
[ $? -eq 0 ] && ( echo -e '\n\n === \n ALL ok...' ) || exit $?
