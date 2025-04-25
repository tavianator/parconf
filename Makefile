CC := cc
CPPFLAGS := -D_GNU_SOURCE
CFLAGS := -g
LDFLAGS := 
CPPFLAGS += -MP -MD
CFLAGS += -Wall
CFLAGS += -pthread
LDFLAGS += -Wl,-z,now
# Copyright © Tavian Barnes <tavianator@tavianator.com>
# SPDX-License-Identifier: 0BSD

OBJS := main.o

app: ${OBJS}
	${CC} ${CFLAGS} ${LDFLAGS} ${OBJS} -o $@

${OBJS}:
	${CC} ${CPPFLAGS} ${CFLAGS} -c ${@:.o=.c} -o $@

-include ${OBJS:.o=.d}

clean:
	rm -f app ${OBJS}

.PHONY: clean
