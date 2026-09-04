#!/usr/bin/env bash

case $INPUT_MODE in
	raw) ;;
	list) OPERATION="--list $INPUT_URL";;
	longlist) OPERATION="--longlist $INPUT_URL";;
	upload)
OPERATION="--upload $INPUT_URL";
[[ ! -z $INPUT_PATH ]] && OPERATION="$OPERATION $INPUT_PATH";
;;
	download)
OPERATION="--download $INPUT_URL";
[[ ! -z $INPUT_PATH ]] && OPERATION="$OPERATION $INPUT_PATH";
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

# Run duck, streaming combined stdout/stderr to the console while capturing it
# for the `log` output. Without the tee the output is swallowed into the step
# output and a failure shows up with an empty log.
 if [[ -n "${USERNAME:-}" ]]; then
   echo "::add-mask::$USERNAME"
 fi
 if [[ -n "${PASSWORD:-}" ]]; then
   echo "::add-mask::$PASSWORD"
 fi
log=$(duck -q -y $OPERATION $INPUT_ARGS 2>&1 | tee /dev/stderr)
exitcode=${PIPESTATUS[0]}

echo 'log<<EOF' >> $GITHUB_OUTPUT
echo "$log" >> $GITHUB_OUTPUT
echo 'EOF' >> $GITHUB_OUTPUT

exit $exitcode;
