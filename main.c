// Copyright © Tavian Barnes <tavianator@tavianator.com>
// SPDX-License-Identifier: 0BSD

#include "config.h"
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <time.h>

int main(int argc, char *argv[]) {
	for (int i = 1; i < argc; ++i) {
#if HAVE_STATX
		struct statx stx;
		if (statx(AT_FDCWD, argv[i], 0, STATX_BTIME, &stx) != 0) {
			perror(argv[i]);
			continue;
		}
		if (!(stx.stx_mask & STATX_BTIME)) {
			fprintf(stderr, "%s: No birth time available\n", argv[i]);
			continue;
		}
		time_t t = stx.stx_btime.tv_sec;
#else
		struct stat st;
		if (stat(argv[i], &st) != 0) {
			perror(argv[i]);
			continue;
		}
#  if HAVE_ST_BIRTHTIM
		time_t t = st.st_birthtim.tv_sec;
#  elif HAVE_ST_BIRTHTIMESPEC
		time_t t = st.st_birthtimespec.tv_sec;
#  elif HAVE___ST_BIRTHTIM
		time_t t = st.__st_birthtim.tv_sec;
#  else
#    error "No birth times available on this platform"
#  endif
#endif

		struct tm *tm = localtime(&t);
		if (!tm) {
			perror("localtime()");
			continue;
		}

		char buf[64];
		if (strftime(buf, sizeof(buf), "%c", tm) == 0) {
			perror("strftime()");
			continue;
		}

		printf("%s\t%s\n", buf, argv[i]);
	}

	return 0;
}
