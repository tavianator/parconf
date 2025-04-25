#!/bin/sh

# Copyright © Tavian Barnes <tavianator@tavianator.com>
# SPDX-License-Identifier: 0BSD

set -eu

MACRO=$1
shift

if "$@"; then
    printf '#define %s 1\n' "$MACRO"
else
    printf '#define %s 0\n' "$MACRO"
fi
