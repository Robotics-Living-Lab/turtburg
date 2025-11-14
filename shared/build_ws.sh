#!/bin/bash

export MAKEFLAGS="-j1"
export CMAKE_BUILD_PARALLEL_LEVEL=1

colcon build --executor sequential --parallel-workers 1 --cmake-args -DCMAKE_BUILD_TYPE=MinSizeRel
