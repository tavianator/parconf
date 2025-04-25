#!/bin/sh

# Copyright © Tavian Barnes <tavianator@tavianator.com>
# SPDX-License-Identifier: 0BSD

set -eu

VAR="$1"
FLAGS="$2"
shift 2

if "$@" $FLAGS; then
    printf '%s += %s\n' "$VAR" "$FLAGS"
fi
