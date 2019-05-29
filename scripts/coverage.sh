#!/bin/bash

set -e

mix compile
mix coveralls.html
echo "Coverage report has been generated!"
open ./cover/excoveralls.html
