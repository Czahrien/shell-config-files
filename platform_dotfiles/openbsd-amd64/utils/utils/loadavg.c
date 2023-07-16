#include <stdlib.h>
#include <stdio.h>
#include <time.h>
int main() {
  double ld[3] = {};

  {
    int retval = getloadavg(ld, 3);
    if(retval < 0) {
      perror("getloadavg");
      return -1;
    }
  }

  struct timespec ts;

  {
    int retval = clock_gettime(CLOCK_BOOTTIME, &ts);
    if(retval != 0) {
      perror("clock_gettime");
      return -1;
    }
  }

#define SECONDS_PER_MINUTE (60ll)
#define SECONDS_PER_HOUR (60ll * SECONDS_PER_MINUTE)
#define SECONDS_PER_DAY (SECONDS_PER_HOUR*24ll)

  if(ts.tv_sec > SECONDS_PER_DAY) {
    printf("%lld days %02lld:%02lld:%02lld", 
        ts.tv_sec / SECONDS_PER_DAY,
        ts.tv_sec % SECONDS_PER_DAY / SECONDS_PER_HOUR,
        ts.tv_sec % SECONDS_PER_HOUR,
        ts.tv_sec % SECONDS_PER_MINUTE );
  }
  else if(ts.tv_sec > 3600) {
    printf("%02lld:%02lld:%02lld", 
        ts.tv_sec / SECONDS_PER_HOUR,
        ts.tv_sec % SECONDS_PER_HOUR / SECONDS_PER_MINUTE,
        ts.tv_sec % SECONDS_PER_MINUTE );
  }
  else {
    printf("%02lld:%02lld", 
        ts.tv_sec / SECONDS_PER_MINUTE,
        ts.tv_sec % SECONDS_PER_MINUTE );
  }

  printf(" <%01.02f,%01.2f,%01.2f>\n", ld[0], ld[1], ld[2]);
  return 0;
}
