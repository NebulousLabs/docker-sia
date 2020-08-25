#!/bin/sh

# Check if `siad` is running
if [ -z "$(pidof siad)" ]; then
  exit 1
fi

exit 0
