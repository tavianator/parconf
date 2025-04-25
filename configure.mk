# Copyright © Tavian Barnes <tavianator@tavianator.com>
# SPDX-License-Identifier: 0BSD

# The default goal generates both outputs, and merges the logs together
config: Makefile config.h
	cat Makefile.log config.h.log >$@.log
	rm Makefile.log config.h.log

.PHONY: config

# Default values, if unspecified
CC ?= cc
CPPFLAGS ?= -D_GNU_SOURCE
CFLAGS ?= -g
LDFLAGS ?=

# Export these through the environment to avoid stripping backslashes
export _CC=${CC}
export _CPPFLAGS=${CPPFLAGS}
export _CFLAGS=${CFLAGS}
export _LDFLAGS=${LDFLAGS}

FLAGS := \
    deps.mk \
    Wall.mk \
    pthread.mk \
    bind-now.mk

Makefile: ${FLAGS}
	printf 'CC := %s\n' "$$_CC" >$@
	printf 'CPPFLAGS := %s\n' "$$_CPPFLAGS" >>$@
	printf 'CFLAGS := %s\n' "$$_CFLAGS" >>$@
	printf 'LDFLAGS := %s\n' "$$_LDFLAGS" >>$@
	cat ${FLAGS} >>$@
	cat ${FLAGS:%=%.log} >$@.log
	rm ${FLAGS} ${FLAGS:%=%.log}
	cat main.mk >>$@

.PHONY: Makefile

ALL_FLAGS = ${CPPFLAGS} ${CFLAGS} ${LDFLAGS}

# Run the compiler with the given flags, sending
#
# - stdout to foo.mk (e.g. CFLAGS += -flag)
# - stderr to foo.mk.log (e.g. error: unrecognized command-line option ‘-flag’)
# - the compiled binary to foo.mk.out
#   - but then we delete it immediately
TRY_CC = ${CC} ${ALL_FLAGS} empty.c -o $@.out >$@ 2>$@.log && rm -f $@.out $@.d

deps.mk:
	./flags.sh CPPFLAGS "-MP -MD" ${TRY_CC}
Wall.mk:
	./flags.sh CFLAGS -Wall ${TRY_CC}
pthread.mk:
	./flags.sh CFLAGS -pthread ${TRY_CC}
bind-now.mk:
	./flags.sh LDFLAGS -Wl,-z,now ${TRY_CC}

.PHONY: ${FLAGS}

# Use a recursive make to pick up our auto-detected *FLAGS from above
config.h: Makefile
	+${MAKE} -f header.mk $@

.PHONY: config.h
