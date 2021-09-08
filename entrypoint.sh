#!/bin/sh

[[ -z $INPUT_URL ]] && exit 1

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

if !([ -z $USERNAME ] || [ -z $PASSWORD ]); then
OPERATION="$OPERATION --username \"$USERNAME\" --password \"$PASSWORD\""
fi

log=$(duck -q -y $OPERATION $INPUT_ARGS)
log="${log//'%'/'%25'}"
log="${log//$'\n'/'%0A'}"
log="${log//$'\r'/'%0D'}"
echo "::set-output name=log::$log"
