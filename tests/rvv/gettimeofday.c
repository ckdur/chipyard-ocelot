/* Version of sbrk for no operating system.  */
#include <sys/time.h>

int _gettimeofday (struct timeval *tp, void *tzp) {
  return 0;  // TODO: Implement
}

