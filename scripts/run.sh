#!/bin/sh

socat tcp-listen:9980,reuseaddr,fork tcp:localhost:8000 &

# Use the `cat` utility in order assign a multi-line string to a variable.
SIAD_CMD=$(cat <<-END
./siad \
  --modules $SIA_MODULES \
  --sia-directory $SIA_DATA_DIR \
  --api-addr localhost:8000
END
)

# Create the SIA_DATA_DIR if it doesn't already exist.
mkdir -p $SIA_DATA_DIR

# Output the logs to stdout and stderr.
# See https://stackoverflow.com/a/23550347/363293 for details.
tail -qF "$SIA_DATA_DIR/siad_stdout.log" &
>&2 tail -qF "$SIA_DATA_DIR/siad_errout.log" &

# We are using `exec` to start `siad` in order to ensure that it will be run as
# PID 1. We need that in order to have `siad` receive OS signals (e.g. SIGTERM)
# on container shutdown, so it can exit gracefully and no data corruption can
# occur.
exec $SIAD_CMD "$@" \
  1>"$SIA_DATA_DIR/siad_stdout.log" \
  2>"$SIA_DATA_DIR/siad_errout.log"
