#!/usr/bin/env bash

# Make sure that `pidof` is available
if [[ -z $(which pidof) ]]; then
  exit 1
fi

# Check if `socat` is running
if [[ -z $(pidof socat) ]]; then
  exit 1
fi

exit 0
