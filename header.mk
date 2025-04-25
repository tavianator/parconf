# Copyright © Tavian Barnes <tavianator@tavianator.com>
# SPDX-License-Identifier: 0BSD

# Get the final *FLAGS values from the Makefile
include Makefile

# We first generate a lot of small headers, before merging them into one big one
HEADERS := \
    have_statx.h \
    have_st_birthtim.h \
    have_st_birthtimespec.h \
    have___st_birthtim.h

config.h: ${HEADERS}
	printf '#ifndef CONFIG_H\n' >$@
	printf '#define CONFIG_H\n' >>$@
	cat ${HEADERS} >>$@
	printf '#endif\n' >>$@
	cat ${HEADERS:%=%.log} >$@.log
	rm ${HEADERS} ${HEADERS:%=%.log}

.PHONY: config.h

# Strip .h and capitalize the macro name
MACRO = $$(printf '%s' ${@:.h=} | tr 'a-z' 'A-Z')

ALL_FLAGS = ${CPPFLAGS} ${CFLAGS} ${LDFLAGS}

${HEADERS}:
	./define.sh ${MACRO} ${CC} ${ALL_FLAGS} ${@:.h=.c} -o $@.out >$@ 2>$@.log
	rm -f $@.out $@.d

.PHONY: ${HEADERS}
