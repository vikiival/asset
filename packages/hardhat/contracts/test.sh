#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 2
fi

echo "Testing $1"

docker run -v $(pwd):/tmp mythril/myth analyze /tmp/$0

