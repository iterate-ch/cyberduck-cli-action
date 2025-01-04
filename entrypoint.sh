#!/usr/bin/env bash

case $INPUT_MODE in
	raw) ;;
	list) OPERATION="--list $INPUT_URL";;
	longlist) OPERATION="--longlist $INPUT_URL";;
	upload)
OPERATION="--upload $INPUT_URL";
[[ ! -z $INPUT_PATH ]] && OPERATION="$OPERATION \"$INPUT_PATH\"";
;;
	download)
OPERATION="--download $INPUT_URL";
[[ ! -z $INPUT_PATH ]] && OPERATION="$OPERATION \"$INPUT_PATH\"";
;;
    delete) OPERATION="--delete $INPUT_URL";;
    purge) OPERATION="--purge $INPUT_URL";;
	*) exit 1;;
esac

if !([ -z $USERNAME ]); then
OPERATION="$OPERATION --username \"$USERNAME\""
fi
if !([ -z $PASSWORD ]); then
OPERATION="$OPERATION --password \"$PASSWORD\""
fi
if !([ -z $IDENTITY ]); then
OPERATION="$OPERATION --identity \"$IDENTITY\""
fi

log=$(duck -q -y $OPERATION $INPUT_ARGS)
exitcode=$?

log="${log//'%'/'%25'}"
log="${log//$'\n'/'%0A'}"
log="${log//$'\r'/'%0D'}"
echo "::set-output name=log::$log"

exit $exitcode;