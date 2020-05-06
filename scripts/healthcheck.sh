#!/bin/sh

# Check if `socat` is running
if [ -z "$(pidof socat)" ]; then
  exit 1
fi

exit 0
