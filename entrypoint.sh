#!/bin/bash

set -e

source /opt/ros/humble/setup.bash

echo "Provided arguments: $@"

if [ -z "$1" ]; then
  exec bash
else
  exec "$@"
fi